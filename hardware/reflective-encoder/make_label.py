#!/usr/bin/env python3
"""The striped label for the reflective hand-wheel encoder, and a test card,
printed full size. Written by Claude at Robert Drzyzgula's direction.

Usage (defaults: the Singer 99K's measured annulus, 48 cycles):
    make_label.py [--id 45] [--od 65] [--cycles 48] [--radius R] [-o label.pdf]

One letter-size page, to print at 100% ("actual size", no scaling):
  - two labels (one to use, one spare): an annulus 1 mm inside the measured
    one on each side, with `cycles` black and white stripe pairs, radial so
    each stripe is half the pitch at every radius. A thin gray circle at
    each edge is the cutting line; a dotted circle marks the radius the
    sensors read at.
  - a test card: straight gratings at the pitch the track would have at the
    sensors' radius for 36, 48, 60, 72 and 96 cycles, plus solid white and
    black patches. Slide a sensor along each at the gap you mean to use and
    watch its output: the finest grating that still swings well between the
    white and black levels is the most cycles that sensor can resolve.
  - scale bars in mm and inches, to check the print is 1:1.

Print it with a laser printer, on matte white polyester (or vinyl) label
stock, removable adhesive: toner is carbon black, which absorbs infrared,
where many inkjet blacks look nearly white to an infrared sensor. Test an
inkjet print on the test card before trusting it.
"""
import argparse
import math

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Wedge, Circle, Rectangle

ap = argparse.ArgumentParser()
ap.add_argument("--id", type=float, default=45.0, help="annulus inside diameter, mm (measured)")
ap.add_argument("--od", type=float, default=65.0, help="annulus outside diameter, mm (measured)")
ap.add_argument("--cycles", type=int, default=48, help="black-and-white stripe pairs a turn")
ap.add_argument("--radius", type=float, default=0, help="the sensors' radius, mm (default: mid-annulus)")
ap.add_argument("-o", "--out", default="", help="output PDF")
a = ap.parse_args()

lid, lod = a.id + 1, a.od - 1           # the label: 0.5 mm inside the annulus each side
rs = a.radius if a.radius > 0 else (a.id + a.od) / 4
out = a.out or f"encoder-label-{a.cycles}.pdf"

W, H = 215.9, 279.4                      # letter, mm
fig = plt.figure(figsize=(W / 25.4, H / 25.4))
ax = fig.add_axes([0, 0, 1, 1])
ax.set_xlim(0, W)
ax.set_ylim(0, H)
ax.set_aspect("equal")
ax.axis("off")
K = "#000000"
G = "#999999"


def label(cx, cy):
    step = 360 / a.cycles
    for j in range(a.cycles):
        ax.add_patch(Wedge((cx, cy), lod / 2, j * step, j * step + step / 2,
                           width=(lod - lid) / 2, facecolor=K, edgecolor="none"))
    for d in (lod, lid):
        ax.add_patch(Circle((cx, cy), d / 2, fill=False, edgecolor=G, linewidth=0.3))
    ax.add_patch(Circle((cx, cy), rs, fill=False, edgecolor=G, linewidth=0.3, linestyle=(0, (1, 3))))
    ax.plot([cx - 3, cx + 3], [cy, cy], color=G, linewidth=0.3)
    ax.plot([cx, cx], [cy - 3, cy + 3], color=G, linewidth=0.3)


top = H - 20 - lod / 2
label(W / 2 - lod / 2 - 10, top)
label(W / 2 + lod / 2 + 10, top)
counts = 4 * a.cycles
ax.text(W / 2, top - lod / 2 - 8,
        f"{a.cycles} cycles, {counts} counts a turn ({360 / counts:.3g}° each); "
        f"label {lid:g}–{lod:g} mm, sensors at r = {rs:g} mm, "
        f"pitch {2 * math.pi * rs / a.cycles:.2f} mm there",
        ha="center", va="center", fontsize=8)

# Test card
y = top - lod / 2 - 22
ax.text(15, y + 4, "Test card: gratings at the sensors' radius (slide a sensor along each)",
        fontsize=8, va="bottom")
L, h = 80, 9
for n in (36, 48, 60, 72, 96):
    y -= h + 5
    p = 2 * math.pi * rs / n
    ax.add_patch(Rectangle((15, y), L, h, fill=False, edgecolor=G, linewidth=0.3))
    x = 15
    while x + p / 2 <= 15 + L + 1e-6:
        ax.add_patch(Rectangle((x, y), p / 2, h, facecolor=K, edgecolor="none"))
        x += p
    ax.text(15 + L + 4, y + h / 2, f"{n} cycles: pitch {p:.2f} mm, stripes {p / 2:.2f} mm",
            fontsize=7, va="center")
y -= h + 5
ax.add_patch(Rectangle((15, y), 25, h, fill=False, edgecolor=G, linewidth=0.3))
ax.text(42, y + h / 2, "white level", fontsize=7, va="center")
ax.add_patch(Rectangle((70, y), 25, h, facecolor=K, edgecolor="none"))
ax.text(97, y + h / 2, "black level", fontsize=7, va="center")

# Scale bars
y -= 18
ax.plot([15, 115], [y, y], color=K, linewidth=0.5)
for i in range(11):
    ax.plot([15 + 10 * i] * 2, [y, y + (3 if i % 5 == 0 else 1.5)], color=K, linewidth=0.5)
ax.text(120, y, "100 mm", fontsize=7, va="center")
y -= 10
ax.plot([15, 15 + 101.6], [y, y], color=K, linewidth=0.5)
for i in range(5):
    ax.plot([15 + 25.4 * i] * 2, [y, y + 3], color=K, linewidth=0.5)
ax.text(121.6, y, "4 in", fontsize=7, va="center")
ax.text(15, 10, "Print at 100% (actual size). Laser toner on matte white polyester label stock.",
        fontsize=7)
fig.savefig(out)
print(out)
