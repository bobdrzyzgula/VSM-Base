#!/usr/bin/env python3
"""Configuration test matrix for scad/vsm_base.scad.

A check to run after significant changes to the model. It runs OpenSCAD over
combinations of the main options and compares what it finds with a committed
baseline (tools/test_matrix_baseline.json), so that a new failed assert, a
new warning, a render that breaks or a part whose solid count changes stands
out from what was already known.

Two levels:

  quick  Every combination of machine x compartment x mount x hinge x split
         x extensions (192 runs; an attached bay is storage only), evaluated only (an .echo export, a few
         seconds each): failed asserts, OpenSCAD errors and warnings, and the
         model's own WARNING lines.
  full   quick, plus a full CGAL render of the printable parts for a smaller
         set (each machine x compartment x hinge, the attached bays, the
         extensions and lids, the printed hinges, the test parts): render
         failures, empty results, "may not be a valid 2-manifold", and the
         solid count (CGAL's "Volumes", less one for the outside).

Usage:
  tools/test_matrix.py [--level quick|full] [-j N] [--filter TEXT]
                       [--update-baseline]

Writes build/test-matrix.md (a report) and build/test-matrix.json, and exits
1 if anything is new or changed against the baseline, 0 otherwise. After a
change whose new warnings are expected, review the report, then rerun with
--update-baseline (at the same level) and commit the baseline.

What it does not check: whether a part prints, fits or holds; and moving
parts (hinges, lids, the knee mechanism) through their travel, for
collisions. Sweeping those, for example by rendering the hinge at a series
of tilt angles and intersecting it with the base, is left as an exercise.
Passing means only that the model generates what it generated before.
"""

import argparse
import concurrent.futures as cf
import itertools
import json
import os
import re
import subprocess
import sys
import tempfile
import time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL = os.path.join(ROOT, "scad", "vsm_base.scad")
BASELINE = os.path.join(ROOT, "tools", "test_matrix_baseline.json")
BUILD = os.path.join(ROOT, "build")

MACHINES = ["Singer 99K", "Kenmore 158-14001"]
COMPARTMENTS = ["none", "storage", "outlet", "knee", "controller"]
MOUNTS = ["built-in", "attached"]
HINGES = ["lollipop", "printed", "barrel", "none"]


def scad_value(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return str(v)
    return '"%s"' % v


def quick_cases():
    for m, c, mt, h, s, x in itertools.product(
            MACHINES, COMPARTMENTS, MOUNTS, HINGES, [True, False], [True, False]):
        # the model asserts that an attached bay is storage only, for now
        if mt == "attached" and c != "storage":
            continue
        yield {"machine": m, "compartment_option": c, "compartment_mount": mt,
               "hinge_type": h, "split": s,
               "back_ext": x, "left_ext": x, "corner_ext": x, "part": "base"}


def full_cases():
    for m in MACHINES:
        for c, h in itertools.product(COMPARTMENTS, HINGES):
            yield {"machine": m, "compartment_option": c, "hinge_type": h,
                   "part": "base"}
        yield {"machine": m, "compartment_option": "storage",
               "compartment_mount": "attached", "part": "right_bay"}
        for p in ["back_ext", "left_ext", "corner_ext", "back_lid", "left_lid",
                  "corner_lid", "base_lid", "ext_pegs", "test_parts"]:
            yield {"machine": m, "part": p}
        yield {"machine": m, "hinge_type": "printed", "part": "printed_hinges"}


def case_key(kind, d):
    return kind + ": " + ", ".join("%s=%s" % (k, d[k]) for k in sorted(d))


NUM = re.compile(r"-?\d+(\.\d+)?(e-?\d+)?")


def problems(text):
    """Error and warning lines, from OpenSCAD's stderr or the model's echo."""
    out = []
    for line in text.splitlines():
        line = line.strip()
        if not line:
            continue
        if line.startswith("ECHO:"):
            if "WARNING" in line or "ERROR" in line:
                out.append(line[5:].strip().strip('"'))
        elif re.match(r"(WARNING|ERROR|TRACE)", line) or "Assertion" in line:
            # drop file positions, which move with every edit
            out.append(re.sub(r"in file [^,]*, line \d+", "", line).strip())
    return out


def run(kind, d, tmp):
    args = ["openscad"]
    for k, v in d.items():
        args += ["-D", "%s=%s" % (k, scad_value(v))]
    out = os.path.join(tmp, "%d.%s" % (abs(hash(case_key(kind, d))),
                                       "echo" if kind == "quick" else "stl"))
    t0 = time.time()
    try:
        p = subprocess.run(args + ["-o", out, MODEL], capture_output=True,
                           text=True, timeout=1800)
        err, rc = p.stderr, p.returncode
    except subprocess.TimeoutExpired:
        err, rc = "ERROR: timed out after 30 minutes", -1
    res = {"seconds": round(time.time() - t0, 1), "rc": rc}
    text = err
    if kind == "quick" and os.path.exists(out):
        text = open(out).read() + "\n" + err
    res["problems"] = sorted(set(problems(text)))
    if kind == "full":
        m = re.search(r"Volumes:\s*(\d+)", err)
        res["solids"] = int(m.group(1)) - 1 if m else None
        res["empty"] = "top level object is empty" in err
        res["nonmanifold"] = "2-manifold" in err
    if os.path.exists(out):
        os.remove(out)
    return res


def summarize(r):
    bad = []
    if r["rc"] != 0:
        bad.append("exit %d" % r["rc"])
    if r.get("empty"):
        bad.append("empty")
    if r.get("nonmanifold"):
        bad.append("not manifold")
    if any(p.startswith("ERROR") or "Assertion" in p for p in r["problems"]):
        bad.append("error")
    return bad


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--level", choices=["quick", "full"], default="quick")
    ap.add_argument("-j", type=int, default=os.cpu_count() or 1)
    ap.add_argument("--filter", default="", help="run only cases whose key contains this")
    ap.add_argument("--update-baseline", action="store_true")
    a = ap.parse_args()

    cases = [("quick", d) for d in quick_cases()]
    if a.level == "full":
        cases += [("full", d) for d in full_cases()]
    cases = [(k, d) for k, d in cases if a.filter in case_key(k, d)]

    results = {}
    t0 = time.time()
    with tempfile.TemporaryDirectory() as tmp, cf.ThreadPoolExecutor(a.j) as ex:
        futs = {ex.submit(run, k, d, tmp): case_key(k, d) for k, d in cases}
        for i, f in enumerate(cf.as_completed(futs), 1):
            key = futs[f]
            results[key] = f.result()
            bad = summarize(results[key])
            print("[%d/%d] %s%s" % (i, len(cases), key,
                                    "  ** " + ", ".join(bad) if bad else ""),
                  file=sys.stderr, flush=True)
    elapsed = time.time() - t0

    base = {}
    if os.path.exists(BASELINE):
        base = json.load(open(BASELINE))

    # Compare with the baseline
    changes = []
    for key in sorted(results):
        r, b = results[key], base.get(key)
        if b is None:
            if base and (summarize(r) or r["problems"]):
                changes.append((key, "new case with problems", summarize(r) + r["problems"]))
            continue
        new = [p for p in r["problems"] if p not in b["problems"]]
        gone = [p for p in b["problems"] if p not in r["problems"]]
        if new:
            changes.append((key, "new", new))
        if gone:
            changes.append((key, "resolved", gone))
        if summarize(r) != summarize(b):
            changes.append((key, "status", ["was: %s" % (", ".join(summarize(b)) or "ok"),
                                            "now: %s" % (", ".join(summarize(r)) or "ok")]))
        if r.get("solids") != b.get("solids"):
            changes.append((key, "solids", ["was %s, now %s" % (b.get("solids"), r.get("solids"))]))
    regress = [c for c in changes if c[1] != "resolved"]

    os.makedirs(BUILD, exist_ok=True)
    json.dump(results, open(os.path.join(BUILD, "test-matrix.json"), "w"),
              indent=1, sort_keys=True)

    # Report
    L = ["# Configuration test matrix", "",
         "Level %s, %d runs, %.0f minutes, against %s." % (
             a.level, len(results), elapsed / 60,
             "the baseline" if base else "no baseline"), "",
         "This shows only that the model generates what it generated before; "
         "it says nothing about printing, fit or strength.", ""]
    if base:
        L += ["## Changes from the baseline", ""]
        if not changes:
            L += ["None.", ""]
        for key, what, lines in changes:
            L.append("- **%s** (%s)" % (key, what))
            L += ["  - %s" % x for x in lines]
        L.append("")
    failing = {k: r for k, r in results.items() if summarize(r)}
    L += ["## Failed or broken renders", ""]
    L += ["- **%s**: %s" % (k, ", ".join(summarize(r))) for k, r in sorted(failing.items())] or ["None."]
    L += ["", "## Warnings, and the cases that give them", ""]
    byp = {}
    for k, r in results.items():
        for p in r["problems"]:
            byp.setdefault(p, []).append(k)
    for p in sorted(byp, key=lambda p: -len(byp[p])):
        L.append("- %s (%d case%s)" % (p, len(byp[p]), "" if len(byp[p]) == 1 else "s"))
    if not byp:
        L.append("None.")
    if a.level == "full":
        L += ["", "## Renders", "", "| Case | Solids | Seconds |", "|---|---|---|"]
        for k in sorted(results):
            if k.startswith("full"):
                r = results[k]
                L.append("| %s | %s | %s |" % (k[6:], r.get("solids"), r["seconds"]))
    open(os.path.join(BUILD, "test-matrix.md"), "w").write("\n".join(L) + "\n")

    if a.update_baseline:
        merged = dict(base)
        merged.update(results)
        json.dump({k: {kk: v for kk, v in r.items() if kk != "seconds"}
                   for k, r in merged.items()},
                  open(BASELINE, "w"), indent=1, sort_keys=True)
        print("baseline updated: %s" % BASELINE, file=sys.stderr)
        return 0

    print("%d runs, %d failed, %d change(s) from the baseline; report in build/test-matrix.md"
          % (len(results), len(failing), len(regress)), file=sys.stderr)
    return 1 if regress or (failing and not base) else 0


if __name__ == "__main__":
    sys.exit(main())
