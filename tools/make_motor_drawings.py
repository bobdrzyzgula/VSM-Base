#!/usr/bin/env python3
"""Construction drawings and outline circuits for the companion paper on
motor construction ("Inside the Motor"). Written by Claude at Robert
Drzyzgula's direction.

Usage: tools/make_motor_drawings.py   (run from the repository root)
Writes SVGs to docs/images/motors/.

These are schematic drawings, true in arrangement but not to scale.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import (Circle, Wedge, Rectangle, Polygon, FancyArrowPatch,
                                Arc, FancyBboxPatch)
import numpy as np

OUT = "docs/images/motors"
os.makedirs(OUT, exist_ok=True)

INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
STEEL, STEEL_D = "#c9ccd1", "#9aa0a7"
COPPER, COPPER_D = "#d08a4a", "#a5622a"
CARBON = "#3b3f45"
NCOL, SCOL = "#b5532a", "#1f5fa8"
FLUX = "#1f5fa8"
PH = {"A": "#b5532a", "B": "#3c8a4e", "C": "#1f5fa8"}
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9,
                     "svg.fonttype": "none"})


def canvas(w, h):
    fig, ax = plt.subplots(figsize=(w, h))
    ax.set_aspect("equal")
    ax.axis("off")
    return fig, ax


def save(fig, name):
    fig.savefig(os.path.join(OUT, name), format="svg", bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.join(OUT, name))


def label(ax, xy, text, xytext, ha="left", va="center"):
    ax.annotate(text, xy, xytext=xytext, ha=ha, va=va, color=INK, fontsize=8.5,
                arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.7, shrinkA=0, shrinkB=1))


def dot(ax, x, y, r, out=True, col=COPPER_D):
    """A conductor seen end-on: dot = current toward you, cross = away."""
    ax.add_patch(Circle((x, y), r, fc="white", ec=col, lw=0.9, zorder=6))
    if out:
        ax.add_patch(Circle((x, y), r * 0.3, fc=col, ec="none", zorder=7))
    else:
        d = r * 0.55
        ax.plot([x - d, x + d], [y - d, y + d], color=col, lw=0.9, zorder=7)
        ax.plot([x - d, x + d], [y + d, y - d], color=col, lw=0.9, zorder=7)


def armature(ax, cx, cy, r, slots=12, cond=True, flip_axis="y"):
    """Laminated armature with slots; conductors marked by side of the brush axis."""
    ax.add_patch(Circle((cx, cy), r, fc=STEEL, ec=STEEL_D, lw=1, zorder=3))
    for k in range(slots):
        a = 2 * np.pi * (k + 0.5) / slots
        sx, sy = cx + 0.8 * r * np.cos(a), cy + 0.8 * r * np.sin(a)
        ax.add_patch(Circle((sx, sy), 0.13 * r, fc="white", ec=STEEL_D, lw=0.6, zorder=4))
        if cond:
            # current flows one way on one side of the brush axis, back on the other
            # brushes on the vertical axis ("x" flux): current reverses left to right
            side = np.cos(a) if flip_axis == "x" else np.sin(a)
            dot(ax, sx, sy, 0.09 * r, out=side > 0)
    ax.add_patch(Circle((cx, cy), 0.18 * r, fc="#e8e9eb", ec=STEEL_D, lw=0.8, zorder=5))
    ax.add_patch(Circle((cx, cy), 0.08 * r, fc=MUTED, ec="none", zorder=6))


# ------------------------------------------------------------------ universal motor
def universal_end_view(ax, cx=0, cy=0):
    R_out, R_in = 3.2, 2.6          # stator yoke
    ra = 1.42                       # armature
    shoe_r = 1.55                   # pole face
    neck_h = 0.45                   # half-height of the pole's neck
    ax.add_patch(Wedge((cx, cy), R_out, 0, 360, width=R_out - R_in, fc=STEEL, ec=STEEL_D, lw=1, zorder=2))
    for sgn in (-1, 1):
        # the pole: a neck from the yoke inward, ending in a curved shoe
        ax.add_patch(Rectangle((cx + (1.9 if sgn > 0 else -R_in - 0.02), cy - neck_h),
                               R_in - 1.9 + 0.02, 2 * neck_h, fc=STEEL, ec=STEEL_D, lw=1, zorder=2))
        a0, a1 = (-50, 50) if sgn > 0 else (130, 230)
        ax.add_patch(Wedge((cx, cy), 1.95, a0, a1, width=1.95 - shoe_r, fc=STEEL, ec=STEEL_D, lw=1, zorder=2))
        # the field coil wound round the neck, cut through: a bundle above and below
        for up in (1, -1):
            x0 = cx + (1.98 if sgn > 0 else -R_in + 0.04)
            ax.add_patch(Rectangle((x0, cy + (neck_h if up > 0 else -neck_h - 0.55)), R_in - 2.02, 0.55,
                                   fc=COPPER, ec=COPPER_D, lw=0.8, zorder=3))
            dot(ax, x0 + (R_in - 2.02) / 2, cy + up * (neck_h + 0.275), 0.14, out=(up * sgn > 0), col=INK)
    armature(ax, cx, cy, ra, slots=12, cond=True, flip_axis="x")
    # flux: across through the poles and armature, back round both halves of the yoke
    for dy in (-0.35, 0.35):
        ax.add_patch(FancyArrowPatch((cx - 2.1, cy + dy), (cx + 2.1, cy + dy), arrowstyle="-|>",
                                     mutation_scale=9, color=FLUX, lw=1.1, zorder=8, alpha=0.85))
    for up in (1, -1):
        ax.add_patch(Arc((cx, cy), 2 * 2.9, 2 * 2.9, theta1=12 if up > 0 else 192,
                         theta2=168 if up > 0 else 348, color=FLUX, lw=1.1, ls=(0, (4, 3)), zorder=8))
    # where the brushes bear (on the commutator, which is behind this section)
    for up in (1, -1):
        ax.add_patch(Rectangle((cx - 0.17, cy + up * 1.5 - (0.45 if up < 0 else 0)), 0.34, 0.45,
                               fc=CARBON, ec=INK, lw=0.6, zorder=9))
    label(ax, (cx + 2.75, cy + 1.6), "laminated stator\n(field iron)", (cx + 3.7, cy + 2.7))
    label(ax, (cx + 2.3, cy + 0.75), "field coil", (cx + 3.7, cy + 1.3))
    label(ax, (cx + 1.75, cy - 0.6), "pole shoe", (cx + 3.7, cy - 0.15))
    label(ax, (cx + 1.0, cy - 0.65), "armature conductors\nin slots", (cx + 3.7, cy - 1.3))
    label(ax, (cx + 0.1, cy - 1.8), "brush (on the\ncommutator, behind)", (cx + 3.7, cy - 2.5))
    label(ax, (cx - 1.3, cy + 0.35), "flux", (cx - 3.9, cy + 2.7), ha="right")
    ax.text(cx, cy - 3.75, "End view, through the armature", ha="center", color=INK, fontsize=9.5, weight="bold")


def universal_side_view(ax, cx=0, cy=0):
    # shaft
    ax.add_patch(Rectangle((cx - 5.2, cy - 0.12), 10.6, 0.24, fc="#e8e9eb", ec=MUTED, lw=0.8, zorder=1))
    # bearings
    for x in (-4.0, 3.9):
        ax.add_patch(Rectangle((cx + x - 0.25, cy - 0.45), 0.5, 0.9, fc="white", ec=MUTED, lw=0.9, zorder=2,
                               hatch="////"))
    # armature stack
    ax.add_patch(Rectangle((cx - 1.9, cy - 1.1), 3.0, 2.2, fc=STEEL, ec=STEEL_D, lw=1, zorder=3))
    for x in np.linspace(cx - 1.75, cx + 0.95, 10):
        ax.plot([x, x], [cy - 1.1, cy + 1.1], color=STEEL_D, lw=0.4, zorder=4)
    # armature winding end turns
    for x0 in (cx - 2.3, cx + 1.1):
        ax.add_patch(FancyBboxPatch((x0, cy - 0.95), 0.4, 1.9, boxstyle="round,pad=0.02,rounding_size=0.18",
                                    fc=COPPER, ec=COPPER_D, lw=0.8, zorder=3))
    # stator (field) around the armature, in section
    for up in (1, -1):
        ax.add_patch(Rectangle((cx - 2.5, cy + up * 1.25 - (1.0 if up < 0 else 0)), 4.2, 1.0,
                               fc=STEEL, ec=STEEL_D, lw=1, zorder=2))
    # field coil end turns, at each end of the field iron
    for up in (1, -1):
        for x0 in (cx - 2.85, cx + 1.7):
            ax.add_patch(Rectangle((x0, cy + up * 1.35 - (0.8 if up < 0 else 0)), 0.38, 0.8,
                                   fc=COPPER, ec=COPPER_D, lw=0.8, zorder=3))
    # commutator
    ax.add_patch(Rectangle((cx + 1.9, cy - 0.55), 1.1, 1.1, fc=COPPER, ec=COPPER_D, lw=0.9, zorder=3))
    for y in np.linspace(cy - 0.45, cy + 0.45, 6):
        ax.plot([cx + 1.9, cx + 3.0], [y, y], color=COPPER_D, lw=0.5, zorder=4)
    # risers: armature leads to commutator
    for y in (0.45, -0.45):
        ax.plot([cx + 1.5, cx + 1.9], [cy + y * 1.4, cy + y], color=COPPER_D, lw=0.8, zorder=3)
    # brushes + springs + caps
    for up in (1, -1):
        y0 = cy + up * 0.55
        ax.add_patch(Rectangle((cx + 2.2, y0 if up > 0 else y0 - 0.7), 0.5, 0.7, fc=CARBON, ec=INK, lw=0.6, zorder=5))
        ys = np.linspace(y0 + up * 0.7, y0 + up * 1.5, 9)
        xs = cx + 2.45 + 0.15 * np.where(np.arange(9) % 2, 1, -1)
        ax.plot(xs, ys, color=MUTED, lw=0.9, zorder=5)
        ax.add_patch(Rectangle((cx + 2.1, y0 + up * 1.5 - (0.25 if up < 0 else 0)), 0.7, 0.25, fc=INK, ec=INK, zorder=5))
    # fan and pulley
    ax.add_patch(Polygon([[cx - 3.2, cy - 1.2], [cx - 2.9, cy - 1.2], [cx - 2.9, cy + 1.2], [cx - 3.2, cy + 1.2]],
                         fc=GRID, ec=MUTED, lw=0.8, zorder=2))
    ax.add_patch(Polygon([[cx + 4.6, cy - 0.55], [cx + 5.3, cy - 0.35], [cx + 5.3, cy + 0.35], [cx + 4.6, cy + 0.55]],
                         fc="#e8e9eb", ec=MUTED, lw=0.9, zorder=2))
    label(ax, (cx - 0.4, cy + 0.6), "armature (laminated, wound)", (cx - 6.3, cy + 2.35))
    label(ax, (cx - 1.0, cy + 1.75), "field iron and coils", (cx - 6.3, cy + 3.05))
    label(ax, (cx + 2.6, cy - 0.3), "commutator", (cx + 4.2, cy - 2.2))
    label(ax, (cx + 2.7, cy + 0.9), "carbon brush", (cx + 3.7, cy + 2.2))
    label(ax, (cx + 2.6, cy + 1.75), "spring and cap", (cx + 3.7, cy + 3.0))
    label(ax, (cx - 3.05, cy - 1.0), "fan", (cx - 4.2, cy - 2.2), ha="right")
    label(ax, (cx + 4.95, cy - 0.4), "pulley", (cx + 5.6, cy - 1.4))
    label(ax, (cx - 4.0, cy - 0.4), "bearing", (cx - 4.6, cy - 1.5), ha="right")
    ax.text(cx, cy - 3.55, "Side view, in section", ha="center", color=INK, fontsize=9.5, weight="bold")


fig, ax = canvas(7.0, 3.9)
universal_end_view(ax)
ax.set_xlim(-6.0, 7.6); ax.set_ylim(-4.0, 3.5)
save(fig, "universal-end-view.svg")
fig, ax = canvas(7.0, 3.9)
universal_side_view(ax)
ax.set_xlim(-6.5, 7.0); ax.set_ylim(-4.0, 3.5)
save(fig, "universal-side-view.svg")


# ------------------------------------------------------------------ circuit symbols
def resistor(ax, x0, y0, x1, y1, n=6, amp=0.13, col=INK):
    xs = np.linspace(x0, x1, 2 * n + 1)
    ys = np.full_like(xs, y0)
    ys[1:-1:2] += amp
    ys[2:-1:2] -= amp
    ax.plot(xs, ys, color=col, lw=1.1)


def inductor(ax, x0, x1, y, n=4, col=INK):
    w = (x1 - x0) / n
    for k in range(n):
        ax.add_patch(Arc((x0 + w * (k + 0.5), y), w, w * 1.2, theta1=0, theta2=180, color=col, lw=1.1))


def source(ax, x, y, r, txt):
    ax.add_patch(Circle((x, y), r, fc="white", ec=INK, lw=1.1, zorder=3))
    ax.text(x, y, txt, ha="center", va="center", fontsize=8.5, color=INK, zorder=4)


def wire(ax, pts, col=INK, lw=1.1):
    pts = np.array(pts)
    ax.plot(pts[:, 0], pts[:, 1], color=col, lw=lw, solid_capstyle="round")


def node(ax, x, y):
    ax.add_patch(Circle((x, y), 0.06, fc=INK, ec=INK, zorder=5))


# ------------------------------------------------------------------ universal wiring and model
fig, ax = canvas(9.2, 3.8)
y = 2.0
# line
ax.text(-0.3, y, "L", ha="right", va="center", fontsize=9, color=INK, weight="bold")
wire(ax, [[-0.2, y], [0.4, y]])
inductor(ax, 0.4, 2.0, y, col=COPPER_D)
ax.text(1.2, y + 0.55, "field coil 1", ha="center", color=COPPER_D, fontsize=8.5)
wire(ax, [[2.0, y], [2.6, y]])
ax.add_patch(Rectangle((2.6, y - 0.15), 0.3, 0.3, fc=CARBON, ec=INK, zorder=4))
ax.add_patch(Circle((3.5, y), 0.55, fc=STEEL, ec=STEEL_D, lw=1.1, zorder=3))
ax.text(3.5, y, "A", ha="center", va="center", color=INK, fontsize=9, weight="bold", zorder=4)
ax.add_patch(Rectangle((4.1, y - 0.15), 0.3, 0.3, fc=CARBON, ec=INK, zorder=4))
ax.text(3.5, y + 0.85, "armature, between\nthe two brushes", ha="center", color=INK, fontsize=8.5)
wire(ax, [[4.4, y], [5.0, y]])
inductor(ax, 5.0, 6.6, y, col=COPPER_D)
ax.text(5.8, y + 0.55, "field coil 2", ha="center", color=COPPER_D, fontsize=8.5)
wire(ax, [[6.6, y], [7.2, y]])
ax.text(7.3, y, "N", ha="left", va="center", fontsize=9, color=INK, weight="bold")
ax.text(3.5, y - 0.75, "One current through everything: the field's flux is set by the same i that the armature carries.",
        ha="center", fontsize=8.5, color=MUTED)
# lumped model below
y2 = 0.2
wire(ax, [[-0.2, y2], [0.3, y2]])
resistor(ax, 0.3, y2, 1.5, y2)
ax.text(0.9, y2 + 0.4, "R", ha="center", color=INK, fontsize=9)
ax.text(0.9, y2 - 0.55, "copper of both\nwindings, brushes", ha="center", color=MUTED, fontsize=8)
wire(ax, [[1.5, y2], [2.7, y2]])
inductor(ax, 2.7, 4.3, y2)
ax.text(3.5, y2 + 0.55, "L", ha="center", color=INK, fontsize=9)
ax.text(3.5, y2 - 0.55, "mostly the field\ncoils (iron-cored)", ha="center", color=MUTED, fontsize=8)
wire(ax, [[4.3, y2], [5.3, y2]])
source(ax, 5.75, y2, 0.45, "e")
ax.text(5.75, y2 - 0.8, "back-EMF\ne = K·ω·i", ha="center", color=MUTED, fontsize=8)
wire(ax, [[6.2, y2], [7.2, y2]])
ax.text(7.3, y2 + 0.05, "v = R·i + L·di/dt + K·ω·i,     torque = K·i²", ha="left", va="center", color=INK, fontsize=9)
ax.set_xlim(-0.8, 12.3); ax.set_ylim(-0.9, 3.5)
save(fig, "universal-wiring.svg")


# ------------------------------------------------------------------ PM brushed DC end view + model
fig, axes = plt.subplots(1, 2, figsize=(9.6, 3.9), gridspec_kw={"width_ratios": [1, 1.25]})
ax = axes[0]; ax.set_aspect("equal"); ax.axis("off")
ax.add_patch(Wedge((0, 0), 2.6, 0, 360, width=0.3, fc=STEEL_D, ec=MUTED, lw=1))
for sgn, col, t in ((-1, NCOL, "N"), (1, SCOL, "S")):
    a0 = 180 - 55 if sgn < 0 else -55
    ax.add_patch(Wedge((0, 0), 2.3, a0, a0 + 110, width=0.65, fc=col, ec=INK, lw=0.6, alpha=0.85))
    ax.text(sgn * 1.97, 0, t, ha="center", va="center", color="white", fontsize=11, weight="bold")
armature(ax, 0, 0, 1.5, slots=12, cond=True, flip_axis="x")
for dy in (-0.4, 0.4):
    ax.add_patch(FancyArrowPatch((-1.6, dy), (1.6, dy), arrowstyle="-|>", mutation_scale=9,
                                 color=FLUX, lw=1.1, zorder=8, alpha=0.85))
label(ax, (2.45, 1.0), "steel can\n(return path)", (3.0, 2.3))
label(ax, (1.75, -1.0), "ceramic or\nneodymium magnet", (3.0, -1.9))
ax.text(0, -3.2, "Brushed permanent-magnet DC motor", ha="center", color=INK, fontsize=9.5, weight="bold")
ax.set_xlim(-3.0, 5.4); ax.set_ylim(-3.5, 2.9)
ax = axes[1]; ax.set_aspect("equal"); ax.axis("off")
y2 = 1.0
wire(ax, [[0, y2], [0.4, y2]])
resistor(ax, 0.4, y2, 1.6, y2)
ax.text(1.0, y2 + 0.4, "R", ha="center", color=INK)
wire(ax, [[1.6, y2], [2.0, y2]])
inductor(ax, 2.0, 3.4, y2)
ax.text(2.7, y2 + 0.55, "L (small)", ha="center", color=INK)
wire(ax, [[3.4, y2], [4.1, y2]])
source(ax, 4.55, y2, 0.45, "e")
wire(ax, [[5.0, y2], [5.6, y2]])
ax.text(2.8, y2 - 1.1, "v = R·i + L·di/dt + Kₑ·ω\ntorque = Kₜ·i,   Kₜ = Kₑ in SI units\n\nThe flux is fixed by the magnets, so the back-EMF\n"
        "depends on speed alone, and torque on current alone.", ha="center", va="top", color=INK, fontsize=8.5)
ax.set_xlim(-0.3, 6.0); ax.set_ylim(-2.6, 2.0)
save(fig, "pmdc-construction.svg")


# ------------------------------------------------------------------ BLDC: inrunner end view, bridge
fig, axes = plt.subplots(1, 2, figsize=(10.0, 4.4), gridspec_kw={"width_ratios": [1, 1.15]})
ax = axes[0]; ax.set_aspect("equal"); ax.axis("off")
ax.add_patch(Wedge((0, 0), 2.7, 0, 360, width=0.45, fc=STEEL, ec=STEEL_D, lw=1))
order = ["A", "C", "B", "A", "C", "B"]   # six teeth, three phases, each wound on two opposite teeth
for k in range(6):
    a = np.radians(90 + 60 * k)
    ca, sa = np.cos(a), np.sin(a)
    tooth = Polygon([[1.35 * ca - 0.28 * sa, 1.35 * sa + 0.28 * ca], [2.3 * ca - 0.28 * sa, 2.3 * sa + 0.28 * ca],
                     [2.3 * ca + 0.28 * sa, 2.3 * sa - 0.28 * ca], [1.35 * ca + 0.28 * sa, 1.35 * sa - 0.28 * ca]],
                    fc=STEEL, ec=STEEL_D, lw=0.8)
    ax.add_patch(tooth)
    ax.add_patch(Wedge((0, 0), 1.38, 90 + 60 * k - 20, 90 + 60 * k + 20, width=0.12, fc=STEEL, ec=STEEL_D, lw=0.8))
    ph = order[k]
    for sd in (-1, 1):
        cx, cy = 1.85 * ca + sd * 0.42 * (-sa), 1.85 * sa + sd * 0.42 * ca
        ax.add_patch(Rectangle((cx - 0.13, cy - 0.13), 0.26, 0.26, angle=0, fc=PH[ph], ec="white", lw=0.5, alpha=0.9))
    ax.text(2.95 * ca, 2.95 * sa, ph, ha="center", va="center", color=PH[ph], fontsize=10, weight="bold")
# rotor: 4 magnet poles
for k in range(4):
    col = NCOL if k % 2 == 0 else SCOL
    ax.add_patch(Wedge((0, 0), 1.18, 45 + 90 * k - 42, 45 + 90 * k + 42, width=0.32, fc=col, ec=INK, lw=0.5, alpha=0.85))
    a = np.radians(45 + 90 * k)
    ax.text(1.02 * np.cos(a), 1.02 * np.sin(a), "N" if k % 2 == 0 else "S", ha="center", va="center",
            color="white", fontsize=8, weight="bold")
ax.add_patch(Circle((0, 0), 0.86, fc=STEEL, ec=STEEL_D, lw=0.8))
ax.add_patch(Circle((0, 0), 0.18, fc=MUTED, ec="none"))
# hall sensors: three, 60 mechanical degrees apart for a 4-pole rotor (120 electrical)
for k, h in enumerate(("H1", "H2", "H3")):
    a = np.radians(-60 - 60 * k)
    ax.add_patch(Rectangle((1.28 * np.cos(a) - 0.09, 1.28 * np.sin(a) - 0.09), 0.18, 0.18, fc=INK, ec="none", zorder=6))
label(ax, (1.28 * np.cos(np.radians(-120)), 1.28 * np.sin(np.radians(-120))), "Hall sensors", (-1.2, -3.2), ha="center")
label(ax, (0.8, 0.8), "magnet rotor", (3.4, 2.4))
label(ax, (2.55, 0.9), "wound stator", (3.4, 1.4))
ax.text(0, 3.55, "Brushless (inrunner): coils fixed, magnets turn", ha="center", color=INK, fontsize=9.5, weight="bold")
ax.set_xlim(-3.4, 5.0); ax.set_ylim(-3.6, 3.9)

ax = axes[1]; ax.set_aspect("equal"); ax.axis("off")
# three half-bridges between + and -, star windings
xs = [0.8, 2.3, 3.8]
top, bot = 3.3, -0.3
wire(ax, [[0.3, top], [4.3, top]]); wire(ax, [[0.3, bot], [4.3, bot]])
ax.text(0.15, top, "+24 V", ha="right", va="center", fontsize=8.5, color=INK)
ax.text(0.15, bot, "0 V", ha="right", va="center", fontsize=8.5, color=INK)
for x, ph in zip(xs, "ABC"):
    for yc in (2.55, 0.45):
        ax.add_patch(Rectangle((x - 0.28, yc - 0.32), 0.56, 0.64, fc="white", ec=INK, lw=1))
        ax.text(x, yc, "Q", ha="center", va="center", fontsize=8, color=INK)
    wire(ax, [[x, top], [x, 2.87]]); wire(ax, [[x, 2.23], [x, 0.77]]); wire(ax, [[x, 0.13], [x, bot]])
for k, (x, ph) in enumerate(zip(xs, "ABC")):
    yy = 2.0 - 0.5 * k                 # A, B, C leave their legs at different heights
    node(ax, x, yy)
    x_at = x
    for xc in [xx for xx in xs if xx > x]:
        wire(ax, [[x_at, yy], [xc - 0.13, yy]], col=PH[ph])
        ax.add_patch(Arc((xc, yy), 0.26, 0.26, theta1=0, theta2=180, color=PH[ph], lw=1.1))
        x_at = xc + 0.13
    wire(ax, [[x_at, yy], [5.0, yy]], col=PH[ph])
for k, ph in enumerate("ABC"):
    y0 = 2.0 - 0.5 * k
    inductor(ax, 5.0, 6.2, y0, n=3, col=PH[ph])
    wire(ax, [[6.2, y0], [6.6, 1.5]], col=PH[ph])
node(ax, 6.6, 1.5)
ax.text(6.75, 1.5, "star\npoint", ha="left", va="center", fontsize=8, color=MUTED)
ax.text(3.5, -1.2, "Six switches; at each step one high-side and one low-side\nswitch conduct, chosen from the Hall sensors (or the encoder).",
        ha="center", va="top", fontsize=8.5, color=INK)
ax.text(3.5, 3.85, "The drive: a three-phase bridge", ha="center", color=INK, fontsize=9.5, weight="bold")
ax.set_xlim(-0.9, 7.6); ax.set_ylim(-2.3, 4.2)
save(fig, "bldc-construction.svg")


# ------------------------------------------------------------------ drive circuits in outline
fig, axes = plt.subplots(1, 3, figsize=(10.5, 3.2))
for ax in axes:
    ax.set_aspect("equal"); ax.axis("off")
# (a) triac in series with a universal motor, on the line
ax = axes[0]
wire(ax, [[0, 3], [3.2, 3]]); wire(ax, [[0, 0], [3.2, 0]])
ax.text(-0.1, 3, "L", ha="right", va="center", weight="bold"); ax.text(-0.1, 0, "N", ha="right", va="center", weight="bold")
ax.add_patch(Circle((3.2, 1.5), 0.6, fc=STEEL, ec=STEEL_D, lw=1.1))
ax.text(3.2, 1.5, "M", ha="center", va="center", weight="bold")
wire(ax, [[3.2, 3], [3.2, 2.1]]); wire(ax, [[3.2, 0.9], [3.2, 0]])
ax.add_patch(Polygon([[1.0, 3.25], [1.0, 2.75], [1.45, 3.0]], fc="white", ec=INK, lw=1, zorder=3))
ax.add_patch(Polygon([[1.9, 3.25], [1.9, 2.75], [1.45, 3.0]], fc="white", ec=INK, lw=1, zorder=3))
wire(ax, [[1.6, 2.8], [1.9, 2.3]]); ax.text(1.95, 2.15, "gate", fontsize=8, color=MUTED)
ax.text(1.6, -0.9, "Triac: switched AC,\nmains in the motor and the switch", ha="center", va="top", fontsize=8.5)
ax.set_xlim(-0.6, 4.2); ax.set_ylim(-2.0, 3.6)
# (b) low-side MOSFET + freewheel diode for a PM motor
ax = axes[1]
wire(ax, [[0.5, 3], [3.0, 3]]); wire(ax, [[0.5, 0], [3.0, 0]])
ax.text(0.4, 3, "+24 V", ha="right", va="center", fontsize=8.5); ax.text(0.4, 0, "0 V", ha="right", va="center", fontsize=8.5)
ax.add_patch(Circle((2.0, 2.2), 0.5, fc=STEEL, ec=STEEL_D, lw=1.1)); ax.text(2.0, 2.2, "M", ha="center", va="center", weight="bold")
wire(ax, [[2.0, 3], [2.0, 2.7]]); wire(ax, [[2.0, 1.7], [2.0, 1.25]])
ax.add_patch(Rectangle((1.75, 0.55), 0.5, 0.7, fc="white", ec=INK)); ax.text(2.0, 0.9, "Q", ha="center", va="center", fontsize=8)
wire(ax, [[2.0, 0.55], [2.0, 0]]); wire(ax, [[1.2, 0.9], [1.75, 0.9]]); ax.text(1.15, 0.9, "PWM", ha="right", va="center", fontsize=8, color=MUTED)
wire(ax, [[2.0, 1.45], [3.0, 1.45], [3.0, 1.8]]); wire(ax, [[3.0, 2.4], [3.0, 3]])
ax.add_patch(Polygon([[2.75, 1.8], [3.25, 1.8], [3.0, 2.3]], fc="white", ec=INK, lw=1)); wire(ax, [[2.75, 2.35], [3.25, 2.35]])
ax.text(3.35, 2.05, "freewheel\ndiode", fontsize=8, color=MUTED, va="center")
ax.text(2.0, -0.9, "Chopper: one switch, one diode;\nlow voltage, one direction", ha="center", va="top", fontsize=8.5)
ax.set_xlim(-0.6, 4.6); ax.set_ylim(-2.0, 3.6)
# (c) H-bridge
ax = axes[2]
wire(ax, [[0.5, 3], [3.5, 3]]); wire(ax, [[0.5, 0], [3.5, 0]])
ax.text(0.4, 3, "+24 V", ha="right", va="center", fontsize=8.5); ax.text(0.4, 0, "0 V", ha="right", va="center", fontsize=8.5)
for x in (1.0, 3.0):
    for yc in (2.3, 0.7):
        ax.add_patch(Rectangle((x - 0.25, yc - 0.3), 0.5, 0.6, fc="white", ec=INK)); ax.text(x, yc, "Q", ha="center", va="center", fontsize=8)
    wire(ax, [[x, 3], [x, 2.6]]); wire(ax, [[x, 2.0], [x, 1.0]]); wire(ax, [[x, 0.4], [x, 0]])
    node(ax, x, 1.5)
ax.add_patch(Circle((2.0, 1.5), 0.45, fc=STEEL, ec=STEEL_D, lw=1.1)); ax.text(2.0, 1.5, "M", ha="center", va="center", weight="bold")
wire(ax, [[1.0, 1.5], [1.55, 1.5]]); wire(ax, [[2.45, 1.5], [3.0, 1.5]])
ax.text(2.0, -0.9, "H-bridge: four switches;\nforward, reverse, and braking", ha="center", va="top", fontsize=8.5)
ax.set_xlim(-0.9, 4.2); ax.set_ylim(-2.0, 3.6)
save(fig, "drive-circuits.svg")
