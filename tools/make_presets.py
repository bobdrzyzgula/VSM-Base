#!/usr/bin/env python3
"""Build the Customizer presets file (scad/vsm_base.json) from the machine
profiles: one parameter set per profile, "<profile> (as Custom)", with
machine = "Custom" and every Custom machine setting filled in from that
profile, ready to tweak.

Usage: tools/make_presets.py [scad/vsm_base.scad]   (needs openscad)
Written by Claude (Anthropic) for the VSM Base project.
"""
import json, os, re, subprocess, sys, tempfile

scad = sys.argv[1] if len(sys.argv) > 1 else "scad/vsm_base.scad"
src = open(scad).read()
m = re.search(r'^machine\s*=\s*"[^"]*";\s*//\s*\[([^\]]*)\]', src, re.M)
names = [n.strip() for n in m.group(1).split(",") if n.strip() != "Custom"]

sets = {}
for name in names:
    with tempfile.NamedTemporaryFile(suffix=".echo", delete=False) as f:
        out = f.name
    subprocess.run(["openscad", "-o", out, "-D", 'part="none"', "-D", "report=true",
                    "-D", 'machine="%s"' % name, scad],
                   check=True, stderr=subprocess.DEVNULL)
    text = open(out).read()
    os.unlink(out)
    full = re.search(r'Machine: (.*) profile\.', text)
    if not full:
        sys.exit("profile %r not found" % name)
    vals = {"machine": "Custom"}
    for k, v in re.findall(r'ECHO: "  (custom_\w+) = (.*);"', text):
        v = v.replace('\\"', '"')
        vals[k] = v[1:-1] if v.startswith('"') and v.endswith('"') else v
    for i in range(1, 7):                    # unused relief slots
        if vals.get("custom_relief_%d_edge" % i) == "none":
            vals["custom_relief_%d" % i] = "[0, 0, 0]"
    sets["%s (as Custom)" % full.group(1)] = vals

dst = os.path.splitext(scad)[0] + ".json"
# keep any sets saved in the Customizer that aren't ours
if os.path.exists(dst):
    old = json.load(open(dst)).get("parameterSets", {})
    for k, v in old.items():
        if not k.endswith(" (as Custom)"):
            sets[k] = v
json.dump({"parameterSets": sets, "fileFormatVersion": "1"},
          open(dst, "w"), indent=4)
print("wrote %s: %s" % (dst, ", ".join(sets)))
