#!/usr/bin/env python3
"""A printed target sheet to go under the foot-locating rig, full size.
Written by Claude at Robert Drzyzgula's direction.

Usage (from the repository root):
    tools/make_foot_rig_sheet.py ["Kenmore 158-14001 (as Custom)"] [out.pdf]
The first argument names a parameter set in scad/vsm_base.json (default:
the Kenmore). OpenSCAD reads the rig's dimensions from the model itself, so
the sheet always matches the rig printed from the same profile.

The sheet is drawn in the model's bed coordinates (the bed's front-left
corner at the origin, X along the bed, Y toward the back) and printed at
exactly 1:1. On it:
  - a millimeter grid over the bed's footprint in light blue, heavier every
    5 and 10 mm, so inked black feet stand out from it (and can be separated
    from it by color in a photograph);
  - coordinates every 10 mm along all four sides, and every 50 mm inside;
  - the rig's walls, its floor rim and floor bars, its six marking holes
    (crosshairs) and its eight screw holes, to set the rig on the sheet;
  - four corner markers at known positions, for squaring up a photograph;
  - scale bars in mm and inches, to check the print came out at 100%.
"""
import json
import os
import re
import subprocess
import sys
import tempfile

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAD = os.path.join(ROOT, "scad", "vsm_base.scad")
PRESETS = os.path.join(ROOT, "scad", "vsm_base.json")

preset = sys.argv[1] if len(sys.argv) > 1 else "Kenmore 158-14001 (as Custom)"
name = preset.replace(" (as Custom)", "")
out = sys.argv[2] if len(sys.argv) > 2 else f"foot-rig-sheet-{re.sub(r'[^A-Za-z0-9.-]+', '-', name)}.pdf"


def rig_dims():
    probe = (f'include <{SCAD}>\n'
             'echo(RIG = [rig_L, rig_W, rig_c, rig_wall, rig_rim, rig_mark_in, rig_mark_d,'
             ' rig_bar_in, rig_bar_w, rig_screw_d, rig_height], SCREWS = rig_screws, MARKS = rig_marks,'
             ' CS = has_cord_slot ? [cord_slot[0], cs_w] : [0, 0]);\n')
    with tempfile.TemporaryDirectory() as d:
        p = os.path.join(d, "probe.scad")
        e = os.path.join(d, "probe.echo")
        open(p, "w").write(probe)
        subprocess.run(["openscad", "-p", PRESETS, "-P", preset, "-D", 'part="none"', "-D", "report=false",
                        "-o", e, p], check=True, capture_output=True)
        txt = open(e).read()
    m = re.search(r"RIG = \[(.*?)\], SCREWS = (\[.*?\]\]), MARKS = (\[.*?\]\]), CS = \[(.*?)\]", txt)
    rig = [float(v) for v in m.group(1).split(",")]
    screws = json.loads(m.group(2))
    marks = json.loads(m.group(3))
    cs = [float(v) for v in m.group(4).split(",")]
    return rig, screws, marks, cs


(L, W, c, wall, rim, mark_in, mark_d, bar_in, bar_w, screw_d, height), screws, marks, cs = rig_dims()

# Page, in bed coordinates (mm)
MX, MTOP, MBOT = 60.0, 45.0, 105.0
x0, x1 = -MX, L + MX
y0, y1 = -MBOT, W + MTOP
pw, ph = x1 - x0, y1 - y0

BLUE1, BLUE5, BLUE10 = "#bfe0f5", "#7fc0ea", "#2f8fd0"
LABEL = "#1f6fae"
RIG = "#c2185b"
INK = "#000000"
GREY = "#555555"

fig = plt.figure(figsize=(pw / 25.4, ph / 25.4))
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(x0, x1)
ax.set_ylim(y0, y1)
ax.set_aspect("equal")
ax.axis("off")
PT = 72 / 25.4      # points per mm

# --- grid over the inside of the rig (the bed plus its clearance)
gx0, gx1, gy0, gy1 = -c, L + c, -c, W + c
for i in range(int(gx0) - 1, int(gx1) + 2):
    if gx0 <= i <= gx1:
        col, lw = (BLUE10, 0.7) if i % 10 == 0 else (BLUE5, 0.4) if i % 5 == 0 else (BLUE1, 0.25)
        ax.plot([i, i], [gy0, gy1], color=col, lw=lw, zorder=1)
for j in range(int(gy0) - 1, int(gy1) + 2):
    if gy0 <= j <= gy1:
        col, lw = (BLUE10, 0.7) if j % 10 == 0 else (BLUE5, 0.4) if j % 5 == 0 else (BLUE1, 0.25)
        ax.plot([gx0, gx1], [j, j], color=col, lw=lw, zorder=1)
# the bed's own outline, slightly heavier
ax.add_patch(Rectangle((0, 0), L, W, fill=False, ec=LABEL, lw=1.0, zorder=2))

# coordinates inside, every 50 mm, set just above-right of the intersection
for xi in range(0, int(L) + 1, 50):
    for yj in range(0, int(W) + 1, 50):
        if 0 < xi < L and 0 < yj < W:
            ax.text(xi + 0.8, yj + 0.8, f"{xi},{yj}", fontsize=5.5, color=LABEL, ha="left", va="bottom", zorder=3)
            ax.plot(xi, yj, marker="+", ms=5, mew=0.6, color=LABEL, zorder=3)

# --- the rig, as it stands on the sheet
ox0, ox1, oy0, oy1 = -c - wall, L + c + wall, -c - wall, W + c + wall
ax.add_patch(Rectangle((ox0, oy0), ox1 - ox0, oy1 - oy0, fill=False, ec=RIG, lw=1.2, zorder=4))
ax.add_patch(Rectangle((-c, -c), L + 2 * c, W + 2 * c, fill=False, ec=RIG, lw=0.6, zorder=4))
# the floor rim's inner edge (the rim covers the sheet outside it)
ri = rim - c
ax.add_patch(Rectangle((ri, ri), L - 2 * ri, W - 2 * ri, fill=False, ec=RIG, lw=0.5, ls=(0, (4, 3)), zorder=4))
# floor bars: no foot can print where they lie
for bx in ([bar_in, L - bar_in] if bar_in > 0 else []):
    ax.add_patch(Rectangle((bx - bar_w / 2, -c), bar_w, W + 2 * c, fc="none", ec=RIG, lw=0.6, hatch="////", zorder=4))
    ax.text(bx, W / 2, "floor bar", rotation=90, fontsize=6, color=RIG, ha="center", va="center", zorder=5,
            bbox=dict(fc="white", ec="none", pad=0.6))
# marking holes: crosshairs to sight through the rig's 1.6 mm holes
for mx, my in marks:
    ax.add_patch(Circle((mx, my), mark_d / 2, fill=False, ec=RIG, lw=0.4, zorder=6))
    ax.add_patch(Circle((mx, my), 3.0, fill=False, ec=RIG, lw=0.4, zorder=6))
    ax.plot([mx - 5, mx + 5], [my, my], color=RIG, lw=0.3, zorder=6)
    ax.plot([mx, mx], [my - 5, my + 5], color=RIG, lw=0.3, zorder=6)
# screw holes through the floor rim
for sx, sy in screws:
    ax.add_patch(Circle((sx, sy), screw_d / 2, fill=False, ec=RIG, lw=0.6, zorder=6))
    ax.plot(sx, sy, marker=".", ms=1.5, color=RIG, zorder=6)
# cord notch at the back wall, if the profile has a cord slot
if cs[1] > 0:
    ax.add_patch(Rectangle((cs[0] - cs[1] / 2, W + c), cs[1], wall, fc=RIG, ec="none", alpha=0.35, zorder=4))
    ax.text(cs[0], oy1 + 1.5, "cord notch", fontsize=5.5, color=RIG, ha="center", va="bottom")

# --- coordinates along all four sides, outside the walls, every 10 mm
for xi in range(0, int(L) + 1, 10):
    big = xi % 50 == 0
    for yy, va in ((oy0 - 2.0, "top"), (oy1 + 2.0, "bottom")):
        ax.plot([xi, xi], [oy0 - (1.6 if big else 1.0), oy0] if va == "top" else [oy1, oy1 + (1.6 if big else 1.0)],
                color=LABEL, lw=0.5)
        ax.text(xi, yy - (0.3 if va == "top" else -0.3) + (-1.2 if va == "top" else 1.2) * 0,
                str(xi), fontsize=6.5 if big else 5, color=LABEL, ha="center", va=va,
                weight="bold" if big else "normal")
for yj in range(0, int(W) + 1, 10):
    big = yj % 50 == 0
    ax.plot([ox0 - (1.6 if big else 1.0), ox0], [yj, yj], color=LABEL, lw=0.5)
    ax.plot([ox1, ox1 + (1.6 if big else 1.0)], [yj, yj], color=LABEL, lw=0.5)
    ax.text(ox0 - 2.2, yj, str(yj), fontsize=6.5 if big else 5, color=LABEL, ha="right", va="center",
            weight="bold" if big else "normal")
    ax.text(ox1 + 2.2, yj, str(yj), fontsize=6.5 if big else 5, color=LABEL, ha="left", va="center",
            weight="bold" if big else "normal")
ax.text(L / 2, oy0 - 9, "FRONT (operator's side)   X, mm along the bed  →", fontsize=9, color=GREY,
        ha="center", va="top", weight="bold")
ax.text(L / 2, oy1 + 8, "BACK", fontsize=9, color=GREY, ha="center", va="bottom", weight="bold")
ax.text(ox0 - 16, W / 2, "LEFT (needle end)   Y, mm  →", fontsize=9, color=GREY, ha="center", va="center",
        rotation=90, weight="bold")
ax.text(ox1 + 16, W / 2, "RIGHT (handwheel end)", fontsize=9, color=GREY, ha="center", va="center",
        rotation=270, weight="bold")


# --- corner markers, at known positions, each different, for squaring a photo
def marker(cx, cy, k):
    s = 14.0
    ax.add_patch(Rectangle((cx - s / 2, cy - s / 2), s, s, fc=INK, ec="none", zorder=7))
    ax.add_patch(Rectangle((cx - s / 2 + 2.5, cy - s / 2 + 2.5), s - 5, s - 5, fc="white", ec="none", zorder=8))
    # k dots in the white square: 1 front-left, 2 front-right, 3 back-right, 4 back-left
    pos = [(0, 0), (-1.8, -1.8), (1.8, 1.8), (1.8, -1.8), (-1.8, 1.8)]
    pick = {1: [0], 2: [1, 2], 3: [0, 1, 2], 4: [1, 2, 3, 4]}[k]
    for p in pick:
        ax.add_patch(Circle((cx + pos[p][0], cy + pos[p][1]), 1.0, fc=INK, ec="none", zorder=9))
    ax.plot([cx - 9, cx + 9], [cy, cy], color=INK, lw=0.3, zorder=9)
    ax.plot([cx, cx], [cy - 9, cy + 9], color=INK, lw=0.3, zorder=9)
    ax.text(cx, cy - s / 2 - 1.2, f"M{k} ({cx:g}, {cy:g})", fontsize=5.5, color=GREY, ha="center", va="top")


mk = [(-40, -40), (L + 40, -40), (L + 40, W + 30), (-40, W + 30)]
for k, (cx, cy) in enumerate(mk, start=1):
    marker(cx, cy, k)

# --- scale bars and the title block, below the front
sy = -62.0
ax.plot([0, 200], [sy, sy], color=INK, lw=1.0)
for t in range(0, 201, 10):
    ax.plot([t, t], [sy, sy + (3 if t % 50 == 0 else 1.5)], color=INK, lw=0.6)
ax.text(100, sy - 1.5, "200.0 mm: check with a rule or calipers. If it is not 200.0 mm, the sheet was scaled; "
        "reprint at 100% (actual size), with borderless expansion off.", fontsize=6, color=INK, ha="center", va="top")
iy = sy - 14
ax.plot([0, 203.2], [iy, iy], color=INK, lw=1.0)
for t in range(0, 9):
    ax.plot([t * 25.4, t * 25.4], [iy, iy + (3 if t % 4 == 0 else 1.5)], color=INK, lw=0.6)
ax.text(101.6, iy - 1.5, "8 inches", fontsize=6, color=INK, ha="center", va="top")

tx = 230
lines = [
    f"VSM Base foot-locating rig target: {name}",
    f"Bed {L:g} × {W:g} mm; rig walls {c:g} mm off the bed, {wall:g} mm thick; floor rim {rim:g} mm; "
    f"floor bars {bar_in:g} mm in from each end.",
    "Coordinates are the model's bed coordinates: origin at the bed's front-left corner, X along the bed, Y toward the back.",
    "1. Tape the sheet flat on the board. 2. Set the rig on its outline; sight down each marking hole onto its crosshair.",
    "3. Screw the rig down through the circles. 4. Ink the feet, lower the machine into the rig, lift it straight out.",
    "5. Remove the rig and photograph the sheet square-on, all four corner markers in view, or read the feet off the grid.",
    "Drawn by Claude at Robert Drzyzgula's direction, from tools/make_foot_rig_sheet.py in the VSM Base repository.",
]
for i, t in enumerate(lines):
    ax.text(tx, sy + 2 - i * 5.2, t, fontsize=7.5 if i == 0 else 5.8, color=INK if i == 0 else GREY,
            ha="left", va="top", weight="bold" if i == 0 else "normal")

fig.savefig(out, format="pdf")
print(f"wrote {out}: {pw:.1f} x {ph:.1f} mm ({pw / 25.4:.2f} x {ph / 25.4:.2f} in)")
