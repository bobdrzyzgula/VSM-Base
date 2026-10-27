#!/usr/bin/env python3
"""Generate docs/guide/90-parameters.md from the Customizer comments in the
model, so the parameter reference always matches the code.

Usage: tools/extract_params.py scad/vsm_base.scad > docs/guide/90-parameters.md

The model follows the OpenSCAD Customizer conventions:
  /* [Section name] */        starts a section ([Hidden] ends the list)
  // Description              one or more comment lines before a parameter
  name = value; // [a, b, c]  optional list of allowed values after it
"""
import re
import sys

SECTION = re.compile(r"^/\*\s*\[(.+?)\]\s*\*/")
ASSIGN = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?);\s*(?://\s*\[(.*)\])?\s*$")


NUMBER = r"-?(\d+\.?\d*|\.\d+)(e-?\d+)?"


def customizer_visible(value):
    """True if OpenSCAD's Customizer can show this default: a number, string,
    boolean, or a vector of one to four numbers."""
    v = value.strip()
    if re.fullmatch(NUMBER, v) or v in ("true", "false"):
        return True
    if re.fullmatch(r'"[^"]*"', v):
        return True
    m = re.fullmatch(r"\[(.*)\]", v)
    if m:
        items = [x.strip() for x in m.group(1).split(",") if x.strip()]
        return 1 <= len(items) <= 4 and all(re.fullmatch(NUMBER, x) for x in items)
    return False


def md_escape(text):
    return text.replace("|", "\\|")


def main(path):
    sections = []          # [(name, [(param, default, choices, description)])]
    comment = []
    pending = None         # multi-line assignment being collected
    with open(path, encoding="utf-8") as f:
        for raw in f:
            line = raw.rstrip("\n")
            stripped = line.strip()
            m = SECTION.match(stripped)
            if m:
                if m.group(1) == "Hidden":
                    break
                sections.append((m.group(1), []))
                comment = []
                continue
            if not sections:
                continue
            if pending is not None:
                pending[1] += " " + stripped
                if stripped.endswith(";"):
                    name, value = pending
                    sections[-1][1].append((name, value.rstrip(";").strip(), "",
                                            " ".join(comment)))
                    pending, comment = None, []
                continue
            if stripped.startswith("//"):
                comment.append(stripped[2:].strip())
                continue
            m = ASSIGN.match(stripped)
            if m:
                sections[-1][1].append((m.group(1), m.group(2).strip(),
                                        (m.group(3) or "").strip(),
                                        " ".join(comment)))
                comment = []
                continue
            m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$", stripped)
            if m and not stripped.endswith(";"):
                pending = [m.group(1), m.group(2)]
                continue
            if stripped == "":
                comment = []

    total = sum(len(ps) for _, ps in sections)
    shown = sum(1 for _, ps in sections for p in ps if customizer_visible(p[1]))
    out = ["# Parameter reference", "",
           "This chapter is generated from the comments in `scad/vsm_base.scad` "
           "by `tools/extract_params.py`. Do not edit it by hand; change the "
           "comment in the model and rebuild.", "",
           f"There are {total} parameters; {shown} of them appear in the "
           "Customizer. The rest are lists the Customizer cannot show, and are "
           "marked *edit in the file*.", ""]
    whole = []
    for name, params in sections:
        if not params:
            continue
        out += [f"## {name}", "", "| Parameter | Default | Description |",
                "|---------|----|---------------|"]   # column proportions (pandoc reads the dashes)
        for p, default, choices, desc in params:
            d = md_escape(desc)
            rng = re.fullmatch(r"\s*(-?[\d.]+)\s*:\s*(-?[\d.]+)\s*:\s*(-?[\d.]+)\s*", choices or "")
            if rng:
                d += f" *Range {rng.group(1)} to {rng.group(3)}, step {rng.group(2)}.*"
            elif choices:
                d += f" *Choices: {md_escape(choices)}.*"
            elif re.fullmatch(r"-?\d+", default):
                whole.append(p)
            if not customizer_visible(default):
                d += " *Edit in the file; not shown in the Customizer.*"
            out.append(f"| `{p}` | `{md_escape(default)}` | {d} |")
        out.append("")
    sys.stdout.write("\n".join(out))
    if whole:
        sys.stderr.write("Whole-number settings with no range (the Customizer steps them by 1): "
                         + ", ".join(whole) + "\n")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "scad/vsm_base.scad")
