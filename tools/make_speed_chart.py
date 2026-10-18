#!/usr/bin/env python3
"""Draw the speed-versus-load chart for the motor-control paper as SVG.

Usage: tools/make_speed_chart.py   (run from the repository root)
Writes docs/images/diagrams/speed-vs-load.svg.

The curves come from the paper's series-motor model,
    omega(T) = V / sqrt(K T) - R / K,
with K = 1 and R = 0.1, all three set to the same slow speed (0.2) at the
nominal load T = 1:
  - feedback (KBIC, MCU + tachometer) holds that speed;
  - reduced voltage (variac, open-loop triac): V chosen so omega(1) = 0.2;
  - series resistance (rheostat, carbon pile): full line V = 1, with a
    series resistance Rs chosen so omega(1) = 0.2.
Illustrative, not measured.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

K, R, W0 = 1.0, 0.1, 0.2
V_red = (W0 + R / K) * np.sqrt(K)            # reduced-voltage source
V_line = 1.0
Rs = K * (V_line / np.sqrt(K) - W0) - R      # series resistance pedal

T = np.linspace(0.5, 3.0, 400)
fb = np.full_like(T, W0)
red = np.maximum(V_red / np.sqrt(K * T) - R / K, 0)
ser = np.maximum(V_line / np.sqrt(K * T) - (R + Rs) / K, 0)
T_stall = (V_line / ((R + Rs) / K)) ** 2 / K

ACCENT = "#1f5fa8"
GRAY1 = "#7d8288"     # series resistance (darker neutral)
GRAY2 = "#b4b8bd"     # reduced voltage (lighter neutral)
INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"

plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 10,
                     "svg.fonttype": "none"})
fig, ax = plt.subplots(figsize=(7.2, 3.9), dpi=100)
for s in ("top", "right"):
    ax.spines[s].set_visible(False)
for s in ("left", "bottom"):
    ax.spines[s].set_color(MUTED)
ax.tick_params(colors=MUTED, length=3)
ax.grid(axis="y", color=GRID, linewidth=0.8)
ax.set_axisbelow(True)

ax.plot(T, red, color=GRAY2, linewidth=2, solid_capstyle="round")
ax.plot(T, ser, color=GRAY1, linewidth=2, solid_capstyle="round")
ax.plot(T, fb, color=ACCENT, linewidth=2.2, solid_capstyle="round")
ax.axvline(1.0, color=MUTED, linewidth=0.8, linestyle=(0, (3, 3)))
ax.annotate("nominal load, common set point", (1.0, 0.63), xytext=(5, 0),
            textcoords="offset points", color=MUTED, fontsize=8.5, va="center")
ax.plot([T_stall], [0], "o", color=GRAY1, markersize=5)
ax.annotate(f"stalls at about {T_stall:.1f}×", (T_stall, 0), xytext=(6, 7),
            textcoords="offset points", color=INK, fontsize=8.5)

# direct labels at the right end: [y, name, detail, color, name offset, detail offset] (points)
for y, name, sub, c, o1, o2 in [
        (W0, "Speed feedback", "KBIC, MCU + tachometer", ACCENT, 4, -3),
        (red[-1], "Reduced voltage", "variac, open-loop triac", GRAY2, 4, -3),
        (0.0, "Series resistance", "rheostat, carbon pile", GRAY1, -3, -15)]:
    ax.annotate(name, (3.0, y), xytext=(14, o1), textcoords="offset points", color=INK,
                fontsize=9, fontweight="bold", va="bottom" if o1 > 0 else "top", annotation_clip=False)
    ax.annotate(sub, (3.0, y), xytext=(14, o2), textcoords="offset points", color=MUTED,
                fontsize=8.5, va="bottom" if o2 > 0 else "top", annotation_clip=False)
    ax.plot([3.0], [y], "o", color=c, markersize=4)

ax.set_xlim(0.5, 3.0)
ax.set_ylim(-0.02, 0.66)
ax.set_xticks([0.5, 1, 1.5, 2, 2.5, 3])
ax.set_xticklabels(["0.5×", "1×", "1.5×", "2×", "2.5×", "3×"])
ax.set_xlabel("Load torque (× nominal)", color=MUTED)
ax.set_ylabel("Speed (relative)", color=MUTED)
ax.set_title("At a crawl, a 1.6× load stalls a series-resistance pedal; feedback holds speed",
             loc="left", fontsize=10.5, color=INK, pad=10)
fig.subplots_adjust(left=0.09, right=0.72, top=0.88, bottom=0.14)

os.makedirs("docs/images/diagrams", exist_ok=True)
fig.savefig("docs/images/diagrams/speed-vs-load.svg", facecolor="white")
print(f"V_red={V_red:.3f} Rs={Rs:.3f} stall={T_stall:.3f}x reduced@2x={V_red/np.sqrt(2)-R:.3f}")
