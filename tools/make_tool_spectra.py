#!/usr/bin/env python3
"""Measured sound spectra of two cordless tools, for the companion paper on
motor construction ("Inside the Motor", section 5). Written by Claude at
Robert Drzyzgula's direction.

Usage: tools/make_tool_spectra.py   (run from the repository root)
Reads the phone screenshots in docs/images/motors/measured/ and writes
docs/images/motors/tool-spectra.svg.

The screenshots are Robert Drzyzgula's, from the iPhone app Audio Tools
(FFT view, iPhone microphone, 48 kHz, 16 bit), October 2026: a DeWalt
DCD780 drill driver and a DeWalt DCF885 impact driver (both brushed) in a quiet room, each with the
room alone, the trigger just past the start, and the trigger fully in. The
trace is read back off each screenshot (the top edge of the blue line in
each pixel column), and the axes are calibrated from the chart's own
gridlines: one per octave, 1 kHz at x = 660, 105.4 px per octave; 10 dB per
20.3 px, 80 dB at y = 371.5. Accurate to a few percent in frequency and
about 1 dB in level, which is all the app's chart shows anyway.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

SRC = "docs/images/motors/measured"
OUT = "docs/images/motors"

ACCENT = "#1f5fa8"
WARM = "#b5532a"
GRAY = "#9aa0a6"
INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9.5,
                     "svg.fonttype": "none", "axes.titlesize": 10,
                     "axes.titleweight": "bold", "axes.titlecolor": INK,
                     "axes.titlelocation": "left"})


def trace(name):
    """(frequency, dB SPL) read off one screenshot."""
    im = np.asarray(Image.open(os.path.join(SRC, name + ".jpg")).convert("RGB")).astype(int)
    r, g, b = im[:, :, 0], im[:, :, 1], im[:, :, 2]
    blue = (b > 150) & (r < 150) & (g < 150) & (b - r > 60)
    xs, ys = [], []
    for x in range(60, 1110):
        hit = np.where(blue[100:2050, x])[0]
        if len(hit):
            xs.append(x)
            ys.append(hit.min() + 100)
    xs, ys = np.array(xs), np.array(ys)
    return 1000 * 2 ** ((xs - 660) / 105.4), 80 - (ys - 371.5) / 20.3


def style(ax):
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    for s in ("left", "bottom"):
        ax.spines[s].set_color(MUTED)
    ax.tick_params(colors=MUTED, length=3)
    ax.grid(axis="y", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)
    ax.set_xscale("log")
    ax.set_xlim(150, 18500)
    ax.set_ylim(-5, 92)
    ticks = [250, 500, 1000, 2000, 4000, 8000, 16000]
    ax.set_xticks(ticks)
    ax.set_xticklabels(["250", "500", "1k", "2k", "4k", "8k", "16k"])
    ax.minorticks_off()
    ax.set_ylabel("dB SPL", color=MUTED)


def mark(ax, f, label, y=86):
    ax.axvline(f, color=MUTED, linestyle=(0, (2, 3)), linewidth=0.8, zorder=0)
    ax.text(f, y, label, ha="center", va="bottom", fontsize=8.5, color=INK,
            bbox=dict(facecolor="white", edgecolor="none", pad=1))


fig, axes = plt.subplots(2, 1, figsize=(7.2, 6.4), sharex=True)
for ax, tool, title in ((axes[0], "drill", "DeWalt DCD780 drill driver"),
                        (axes[1], "impact", "DeWalt DCF885 impact driver")):
    style(ax)
    for kind, color, lw, label in (("ambient", GRAY, 0.9, "room alone"),
                                   ("low", ACCENT, 1.1, "trigger just in"),
                                   ("full", WARM, 1.1, "trigger fully in")):
        f, db = trace(f"{tool}-{kind}")
        ax.plot(f, db, color=color, linewidth=lw, label=label)
    ax.set_title(title)
axes[1].set_xlabel("hertz (log scale)", color=MUTED)

# the drill: a clean line and its harmonics, moving down at full trigger
mark(axes[0], 3850, "3.85 kHz")
mark(axes[0], 7700, "7.7 kHz")
mark(axes[0], 15400, "15.4 kHz")
axes[0].annotate("full trigger:\nabout 3.3 kHz", xy=(3270, 79), xytext=(1150, 80),
                 fontsize=8.5, color=WARM, va="center", ha="right",
                 arrowprops=dict(arrowstyle="-", color=WARM, linewidth=0.8))

# the impact driver: lines at 7.7 and 15.4 kHz, a broad hump below, and a speed line
mark(axes[1], 7700, "7.7 kHz")
mark(axes[1], 15400, "15.4 kHz")
axes[1].annotate("motor speed:\n320 Hz rising to 380 Hz", xy=(378, 82), xytext=(600, 84),
                 fontsize=8.5, color=INK, va="center", ha="left",
                 arrowprops=dict(arrowstyle="-", color=MUTED, linewidth=0.8))

fig.tight_layout(h_pad=1.5, rect=(0, 0, 1, 0.95))
h, l = axes[0].get_legend_handles_labels()
fig.legend(h, l, loc="upper center", ncol=3, frameon=False, fontsize=8.5)
fig.savefig(os.path.join(OUT, "tool-spectra.svg"), format="svg", bbox_inches="tight")
print("wrote", os.path.join(OUT, "tool-spectra.svg"))
