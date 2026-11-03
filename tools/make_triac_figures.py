#!/usr/bin/env python3
"""Figures for the motor-control paper's triac sections: a minimal triac
phase control (section 5), its waveforms, and the KB3151C board's timing
network with its RV2 trimmer (section 11). Written by Claude at Robert
Drzyzgula's direction.

Usage: tools/make_triac_figures.py   (run from the repository root)
Writes SVGs to docs/images/diagrams/.

The firing curves are SIMULATED from a simple model, not measured:
  - 120 V, 60 Hz line (170 V peak).
  - Before the triac fires, the timing network sees the whole line voltage
    across the triac (the motor drops almost nothing at the network's mA or
    so). Once it fires, it sees about 1 V until the half-cycle ends.
  - Resistive load: the triac turns off at the voltage zero. (A motor's
    inductance carries conduction a little past it, which this ignores.)
  - The timing capacitor charges through R_total = R_eq + R2. When it
    reaches the diac's breakover, 32 V, the diac fires and the capacitor
    drops to 22 V (DB3: 28-36 V breakover, at least 5 V breakback; the
    drop is the least certain number here), then decays toward 1 V for the
    rest of the half-cycle.
Within each half-cycle the capacitor voltage is solved exactly (an RC
driven by a sine); the state is carried from half-cycle to half-cycle, so
the start and stop thresholds (snap-on hysteresis) come out of the model.
"motor voltage" is the RMS voltage a resistive load would see, as a
percentage of the line: a stand-in for speed, which also depends on load.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Circle, Polygon, Rectangle, FancyArrowPatch
import numpy as np

OUT = "docs/images/diagrams"
os.makedirs(OUT, exist_ok=True)

INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
ACCENT, WARM, GREEN = "#1f5fa8", "#b5532a", "#3c8a4e"
GRAY1, GRAY2 = "#7d8288", "#b4b8bd"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9.5,
                     "svg.fonttype": "none", "svg.hashsalt": "triac"})


def save(fig, name):
    fig.savefig(os.path.join(OUT, name), format="svg", bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.join(OUT, name))


def style(ax):
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    for s in ("left", "bottom"):
        ax.spines[s].set_color(MUTED)
    ax.tick_params(colors=MUTED, length=3)
    ax.grid(True, color=GRID, lw=0.8)
    ax.set_axisbelow(True)


# ------------------------------------------------------------------ model
F = 60.0
W = 2 * np.pi * F
VPK = 120 * np.sqrt(2)
C2 = 0.1e-6
R2 = 1e3
VBO, VAFTER, VON = 32.0, 22.0, 1.0
TH = np.linspace(0, np.pi, 4001)[1:]


def half(vc0, rt, s):
    """One half-cycle from a zero crossing, sign s. Returns the capacitor
    voltage at its end and the firing angle (None if it didn't fire)."""
    wt = W * rt * C2
    a = VPK / np.sqrt(1 + wt ** 2)
    phi = np.arctan(wt)
    u = a * np.sin(TH - phi) + (s * vc0 + a * np.sin(phi)) * np.exp(-TH / wt)
    i = np.argmax(u >= VBO)
    if u[i] >= VBO:
        al = TH[i]
        return s * (VON + (VAFTER - VON) * np.exp(-(np.pi - al) / wt)), al
    return s * u[-1], None


def run(rt, vc, cycles=12):
    al = None
    for _ in range(cycles):
        vc, al = half(vc, rt, 1)
        vc, _ = half(vc, rt, -1)
    return vc, al


def cold(rt):
    """Capacitor voltage at an upward zero crossing when nothing has fired:
    the plain RC's steady state."""
    wt = W * rt * C2
    return -VPK / np.sqrt(1 + wt ** 2) * np.sin(np.arctan(wt))


def vfrac(al):
    return 0.0 if al is None else np.sqrt((np.pi - al + 0.5 * np.sin(2 * al)) / np.pi)


def thresholds():
    start = stop = None
    for r in np.arange(250e3, 50e3, -500):
        if run(r + R2, cold(r + R2))[1] is not None:
            start = r
            break
    vc = 0.0
    for r in np.arange(50e3, 300e3, 500):
        vc, al = run(r + R2, vc)
        if al is None:
            stop = r
            break
    return start, stop


R_START, R_STOP = thresholds()
print(f"model: starts from cold at R_eq = {R_START/1e3:.1f}k, keeps firing to {R_STOP/1e3:.1f}k")


# ------------------------------------------------------------------ minimal circuit
def wire(ax, pts, ls="-", col=INK):
    pts = np.array(pts)
    ax.plot(pts[:, 0], pts[:, 1], color=col, lw=1.2, ls=ls, solid_capstyle="round")


def node(ax, x, y):
    ax.add_patch(Circle((x, y), 0.055, fc=INK, ec=INK, zorder=5))


def vres(ax, x, y0, y1, n=6, amp=0.12):
    ys = np.linspace(y0, y1, 2 * n + 1)
    xs = np.full_like(ys, x)
    xs[1:-1:2] += amp
    xs[2:-1:2] -= amp
    ax.plot(xs, ys, color=INK, lw=1.2)


def vcap(ax, x, y, w=0.36, gap=0.13):
    ax.plot([x - w / 2, x + w / 2], [y + gap / 2] * 2, color=INK, lw=2.0)
    ax.plot([x - w / 2, x + w / 2], [y - gap / 2] * 2, color=INK, lw=2.0)


def triac(ax, x, y0, y1):
    """Vertical triac: MT2 at y1 (top), MT1 at y0, gate off the MT1 side."""
    w = 0.32
    ax.plot([x - w - 0.05, x + w + 0.05], [y1, y1], color=INK, lw=1.4)
    ax.plot([x - w - 0.05, x + w + 0.05], [y0, y0], color=INK, lw=1.4)
    ax.add_patch(Polygon([[x - w, y1], [x, y1], [x - w / 2, y0]], closed=True, fc="white", ec=INK, lw=1.2))
    ax.add_patch(Polygon([[x, y0], [x + w, y0], [x + w / 2, y1]], closed=True, fc="white", ec=INK, lw=1.2))
    ax.plot([x + w * 0.55, x + w + 0.25], [y0, y0 - 0.25], color=INK, lw=1.2)
    return x + w + 0.25, y0 - 0.25


def diac(ax, x0, x1, y):
    h = 0.3
    xm = (x0 + x1) / 2
    ax.plot([x0, x0], [y - h, y + h], color=INK, lw=1.4)
    ax.plot([x1, x1], [y - h, y + h], color=INK, lw=1.4)
    ax.add_patch(Polygon([[x0, y], [x1, y + h], [x1, y]], closed=True, fc="white", ec=INK, lw=1.1))
    ax.add_patch(Polygon([[x1, y], [x0, y - h], [x0, y]], closed=True, fc="white", ec=INK, lw=1.1))
    del xm


def note(ax, x, y, text, ha="left", va="center", col=INK, size=8.5):
    ax.text(x, y, text, ha=ha, va=va, color=col, fontsize=size)


fig, ax = plt.subplots(figsize=(8.6, 4.6))
ax.set_aspect("equal")
ax.axis("off")
top, bot = 4.0, 0.0
xt, xr, xs = 3.2, 5.6, 9.3          # triac, timing branch, snubber
# line, motor, rails
note(ax, -0.15, top, "L", ha="right", size=10)
note(ax, -0.15, bot, "N", ha="right", size=10)
ax.text(-0.75, (top + bot) / 2, "120 V\n60 Hz", ha="center", va="center", color=MUTED, fontsize=8.5)
wire(ax, [[0, top], [0.9, top]])
ax.add_patch(Circle((1.4, top), 0.5, fc="white", ec=INK, lw=1.2, zorder=3))
ax.text(1.4, top, "M", ha="center", va="center", color=INK, fontsize=11, weight="bold", zorder=4)
note(ax, 1.4, top + 0.8, "universal motor", ha="center")
wire(ax, [[1.9, top], [xs, top]])
wire(ax, [[0, bot], [xs, bot]])
node(ax, xt, top); node(ax, xr, top); node(ax, xt, bot); node(ax, xr, bot)
# triac
wire(ax, [[xt, top], [xt, 2.55]])
gx, gy = triac(ax, xt, 1.55, 2.55)
wire(ax, [[xt, 1.55], [xt, bot]])
note(ax, xt - 0.55, 2.55, "MT2", ha="right", col=MUTED)
note(ax, xt - 0.55, 1.55, "MT1", ha="right", col=MUTED)
note(ax, xt - 0.9, 2.05, "triac\n(BT136)", ha="right")
# gate -> diac -> timing node
yd = gy
wire(ax, [[gx, gy], [4.05, yd]])
diac(ax, 4.05, 4.65, yd)
wire(ax, [[4.65, yd], [xr, yd]])
node(ax, xr, yd)
note(ax, 4.35, yd + 0.6, "diac (DB3)\nbreaks over\nat ±32 V", ha="center")
note(ax, gx - 0.05, gy - 0.3, "G", ha="right", col=MUTED)
# timing branch: pot, fixed R, capacitor
wire(ax, [[xr, top], [xr, 3.65]])
vres(ax, xr, 3.65, 2.85)
ax.add_patch(FancyArrowPatch((xr + 0.45, 2.95), (xr + 0.1, 3.4), arrowstyle="-|>", mutation_scale=8, color=INK, lw=1.0))
wire(ax, [[xr, 2.85], [xr, 2.55]])
vres(ax, xr, 2.55, 1.95, n=4)
wire(ax, [[xr, 1.95], [xr, yd]])
wire(ax, [[xr, yd], [xr, 0.62]])
vcap(ax, xr, 0.55)
wire(ax, [[xr, 0.48], [xr, bot]])
note(ax, xr + 0.35, 3.25, "VR  speed control\n(pedal pot, ~250 kΩ)")
note(ax, xr + 0.35, 2.25, "R  limits the top end\n(a few kΩ)")
note(ax, xr + 0.35, 0.55, "C  timing\n(0.1 µF)")
# snubber
ax.add_patch(Rectangle((xs - 0.55, 0.25), 1.3, 3.3, fc="none", ec=GRAY1, lw=0.9, ls=(0, (4, 3))))
wire(ax, [[xs, top], [xs, 3.3]])
vres(ax, xs, 3.3, 2.5, n=4)
wire(ax, [[xs, 2.5], [xs, 1.55]])
vcap(ax, xs, 1.48)
wire(ax, [[xs, 1.41], [xs, bot]])
note(ax, xs + 0.3, 2.9, "Rs")
note(ax, xs + 0.3, 1.48, "Cs")
note(ax, xs + 0.95, 2.2, "snubber\n(needed with\nmost triacs;\noptional with\na snubberless\none)", col=MUTED)
ax.set_xlim(-1.4, 11.6)
ax.set_ylim(-0.4, 5.0)
save(fig, "triac-minimal.svg")


# ------------------------------------------------------------------ waveforms
def trace(rt, cycles=2, settle=12, n=2000):
    vc, _ = run(rt, 0.0, settle)
    tt, vl, vm, vcs, fires = [], [], [], [], []
    for c in range(cycles):
        for k, s in enumerate((1, -1)):
            wt = W * rt * C2
            th = np.linspace(0, np.pi, n)
            dt = th[1] - th[0]
            on = False
            for t in th:
                line = s * VPK * np.sin(t)
                vt = s * VON if on else line
                vc += (vt - vc) * (1 - np.exp(-dt / wt))
                if not on and s * vc >= VBO:
                    on = True
                    fires.append((c * 2 * np.pi + k * np.pi + t, vc))
                    vc = s * VAFTER
                tt.append(c * 2 * np.pi + k * np.pi + t)
                vl.append(line)
                vm.append(line if on else 0.0)
                vcs.append(vc)
    return (np.degrees(np.array(tt)), np.array(vl), np.array(vm), np.array(vcs), fires)


rt_demo = 105e3 + R2
tt, vl, vm, vcs, fires = trace(rt_demo)
al_demo = np.degrees(fires[0][0])
fig, (a1, a2) = plt.subplots(2, 1, figsize=(8.4, 5.4), sharex=True,
                             gridspec_kw={"height_ratios": [1.15, 1], "hspace": 0.12})
style(a1)
a1.plot(tt, vl, color=GRAY2, lw=1.2, label="line voltage")
a1.fill_between(tt, 0, vm, color=WARM, alpha=0.25, lw=0)
a1.plot(tt, vm, color=WARM, lw=1.4, label="voltage at the motor")
a1.set_ylabel("volts", color=MUTED)
a1.set_ylim(-200, 200)
a1.legend(loc="lower left", frameon=False, fontsize=8.5, ncol=2)
a1.annotate(f"firing angle α ≈ {al_demo:.0f}°", (al_demo, VPK * np.sin(np.radians(al_demo))),
            xytext=(al_demo + 40, 175), color=INK, fontsize=8.5,
            arrowprops=dict(arrowstyle="-", color=MUTED, lw=0.7))
style(a2)
a2.plot(tt, vcs, color=ACCENT, lw=1.4, label="timing capacitor C")
for v in (VBO, -VBO):
    a2.axhline(v, color=GREEN, lw=0.9, ls=(0, (4, 3)))
a2.text(722, VBO + 2, "diac breakover, ±32 V", color=GREEN, fontsize=8.5, ha="right", va="bottom")
for t, v in fires:
    a2.plot(np.degrees(t), v, "o", ms=4, color=WARM)
a2.set_ylim(-45, 45)
a2.set_ylabel("volts", color=MUTED)
a2.set_xlabel("degrees of the line cycle (360° = 16.7 ms)", color=MUTED)
a2.set_xticks(np.arange(0, 721, 90))
a2.set_xlim(0, 720)
a2.legend(loc="lower right", frameon=False, fontsize=8.5)
a1.set_title("Phase control, simulated: R + VR = 106 kΩ, C = 0.1 µF, resistive load", loc="left",
             fontsize=10, color=INK)
save(fig, "triac-waveforms.svg")


# ------------------------------------------------------------------ KB3151C timing network
R1T = 200e3                       # RV1, the slide pot's whole track
RV2S = [2e6, 1e6, 425e3, 200e3, 100e3, 0.0]
COLS = {2e6: "#1f5fa8", 1e6: "#5b8fd1", 425e3: "#3c8a4e", 200e3: "#c98a1d", 100e3: "#b5532a", 0.0: "#7a3b8f"}


def lab(rv):
    return "RV2 = 0" if rv == 0 else (f"RV2 = {rv/1e6:g} MΩ" if rv >= 1e6 else f"RV2 = {rv/1e3:g} kΩ")


def req(x, rv):
    """x: pedal travel, 0 at the off zone (wiper at RV1's pin-3 end), 1 at
    full speed (pin 1). a is the pin-1-to-wiper section."""
    a = (1 - x) * R1T
    return a * (rv + R1T - a) / (rv + R1T)


xs = np.linspace(0, 1, 401)
fig, ax = plt.subplots(figsize=(8.4, 4.4))
style(ax)
for rv in RV2S:
    ax.plot(xs * 100, [req(x, rv) / 1e3 for x in xs], color=COLS[rv], lw=1.6, label=lab(rv))
ax.axhline(R_START / 1e3, color=GRAY1, lw=0.9, ls=(0, (4, 3)))
ax.axhline(R_STOP / 1e3, color=GRAY1, lw=0.9, ls=(0, (1, 2)))
ax.text(99, R_START / 1e3 - 2, f"starts below {R_START/1e3:.0f} kΩ", ha="right", va="top", color=GRAY1, fontsize=8.5)
ax.text(99, R_STOP / 1e3 + 2, f"once running, keeps going up to {R_STOP/1e3:.0f} kΩ", ha="right", va="bottom",
        color=GRAY1, fontsize=8.5)
ax.set_xlim(0, 100)
ax.set_ylim(0, 200)
ax.set_xlabel("pedal travel, % (0 = just past the off zone, at RV1's pin-3 end; 100 = pin 1, full speed)",
              color=MUTED)
ax.set_ylabel("timing resistance R_eq, kΩ", color=MUTED)
ax.legend(frameon=False, fontsize=8.5, loc="upper left", bbox_to_anchor=(1.01, 1.0))
ax.set_title("KB3151C: R_eq = a ∥ (RV2 + RV1 − a), RV1 = 200 kΩ", loc="left", fontsize=10, color=INK)
save(fig, "kb3151c-req.svg")


def sweep(rv):
    rq = np.array([req(x, rv) for x in xs])
    press, vc, running = [], 0.0, False
    for r in rq:
        if not running:
            vc = cold(r + R2)
        vc, al = run(r + R2, vc)
        running = al is not None
        press.append(vfrac(al))
    rel, vc = [], 0.0
    for r in rq[::-1]:
        vc, al = run(r + R2, vc)
        if al is None:
            vc = cold(r + R2)
        rel.append(vfrac(al))
    return np.array(press) * 100, np.array(rel[::-1]) * 100


fig, ax = plt.subplots(figsize=(8.4, 4.8))
style(ax)
table = []
for rv in RV2S:
    p, r = sweep(rv)
    ax.plot(xs * 100, p, color=COLS[rv], lw=1.7, label=lab(rv))
    if np.any(np.abs(p - r) > 0.5):
        ax.plot(xs * 100, r, color=COLS[rv], lw=1.2, ls=(0, (4, 2)))
    on = xs[p > 0]
    table.append((rv, req(0, rv), on[0] * 100 if len(on) else None, p[p > 0][0] if len(on) else 0,
                  r[r > 0].min() if np.any(r > 0) else 0))
ax.set_xlim(0, 100)
ax.set_ylim(0, 105)
ax.set_xlabel("pedal travel, % (0 = just past the off zone; 100 = full speed)", color=MUTED)
ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
ax.legend(frameon=False, fontsize=8.5, loc="upper left", bbox_to_anchor=(1.01, 1.0))
ax.text(35, 12, "solid: pressing from rest\ndashed: easing back, where it differs", color=MUTED, fontsize=8.5, va="center")
ax.set_title("KB3151C, simulated: motor voltage through the pedal's travel, by RV2 setting", loc="left",
             fontsize=10, color=INK)
save(fig, "kb3151c-voltage.svg")

print("RV2      R_eq at end   starts at   first V   lowest V while running")
for rv, re, st, v0, vmin in table:
    print(f"{lab(rv):16s} {re/1e3:6.1f}k   {st if st is None else round(st,1)}%   {v0:5.1f}%   {vmin:5.1f}%")


# ------------------------------------------------------------------ "Inside a Switching Circuit"
# (written to docs/images/switching/)
OUT2 = "docs/images/switching"
os.makedirs(OUT2, exist_ok=True)


def save2(fig, name):
    fig.savefig(os.path.join(OUT2, name), format="svg", bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.join(OUT2, name))


# SCR: four layers, and the same layers as two transistors
PCOL, NCOL = "#f2c9b0", "#b9d3ee"
fig, ax = plt.subplots(figsize=(8.6, 4.2))
ax.set_aspect("equal")
ax.axis("off")
# left: the four-layer stack, anode on top
lay = [("P", PCOL), ("N", NCOL), ("P", PCOL), ("N", NCOL)]
for k, (t, col) in enumerate(lay):
    y = 3.0 - k * 0.75
    ax.add_patch(Rectangle((0, y), 2.0, 0.75, fc=col, ec=INK, lw=1.0))
    ax.text(1.0, y + 0.375, t, ha="center", va="center", fontsize=11, weight="bold", color=INK)
for k, jn in enumerate(("J1", "J2", "J3")):
    y = 3.0 - k * 0.75
    ax.plot([2.0, 2.25], [y, y], color=MUTED, lw=0.8)
    ax.text(2.3, y, jn, va="center", fontsize=8.5, color=MUTED)
wire(ax, [[1.0, 3.75], [1.0, 4.3]]); note(ax, 1.0, 4.45, "anode (A)", ha="center")
wire(ax, [[1.0, 0.75], [1.0, 0.2]]); note(ax, 1.0, 0.05, "cathode (K)", ha="center")
wire(ax, [[0.0, 1.875], [-0.6, 1.875]]); note(ax, -0.7, 1.875, "gate (G)", ha="right")
note(ax, 1.0, -0.5, "J2 blocks when the anode is positive;\nJ1 and J3 block when it is negative", ha="center",
     col=MUTED, size=8)
# right: the same layers as two transistors, side by side at the same heights
x0, x2 = 4.4, 7.2
for k, (t, col) in enumerate(lay[:3]):           # PNP (Q1): P N P
    y = 3.0 - k * 0.75
    ax.add_patch(Rectangle((x0, y), 1.4, 0.75, fc=col, ec=INK, lw=1.0))
    ax.text(x0 + 0.7, y + 0.375, t, ha="center", va="center", fontsize=10, weight="bold")
for k, (t, col) in enumerate(lay[1:]):           # NPN (Q2): N P N, one layer lower
    y = 2.25 - k * 0.75
    ax.add_patch(Rectangle((x2, y), 1.4, 0.75, fc=col, ec=INK, lw=1.0))
    ax.text(x2 + 0.7, y + 0.375, t, ha="center", va="center", fontsize=10, weight="bold")
note(ax, x0 + 0.7, -0.15, "PNP (Q1)", ha="center")
note(ax, x2 + 0.7, -0.15, "NPN (Q2)", ha="center")
# Q2's collector (its N, level 2.25) feeds Q1's base (its N); Q1's collector (its lower P, level 1.5) feeds Q2's base
ax.add_patch(FancyArrowPatch((x2, 2.625), (x0 + 1.4, 2.625), arrowstyle="-|>", mutation_scale=11,
                             color=ACCENT, lw=1.5))
ax.add_patch(FancyArrowPatch((x0 + 1.4, 1.875), (x2, 1.875), arrowstyle="-|>", mutation_scale=11,
                             color=WARM, lw=1.5))
note(ax, (x0 + 1.4 + x2) / 2, 3.45, "Q2's collector current\nis Q1's base current", ha="center", col=ACCENT, size=8)
note(ax, (x0 + 1.4 + x2) / 2, 1.2, "Q1's collector current\nis Q2's base current", ha="center", col=WARM, size=8)
wire(ax, [[x0 + 0.7, 3.75], [x0 + 0.7, 4.3]]); note(ax, x0 + 0.7, 4.45, "A", ha="center", col=MUTED)
wire(ax, [[x2 + 0.7, 0.75], [x2 + 0.7, 0.2]]); note(ax, x2 + 1.0, 0.35, "K", col=MUTED)
wire(ax, [[x2 + 1.4, 1.875], [x2 + 1.9, 1.875]]); note(ax, x2 + 2.0, 1.875, "G", col=MUTED)
ax.set_xlim(-2.2, 10.2)
ax.set_ylim(-1.2, 4.8)
save2(fig, "scr-structure.svg")

# leading edge versus trailing edge, same RMS on a resistive load
th = np.linspace(0, 720, 2000)
v = VPK * np.sin(np.radians(th))
ph = th % 180
lead = np.where(ph >= 90, v, 0.0)
trail = np.where(ph <= 90, v, 0.0)
fig, (b1, b2) = plt.subplots(2, 1, figsize=(8.0, 4.6), sharex=True, gridspec_kw={"hspace": 0.18})
for axx, w, title in ((b1, lead, "Leading edge (triac): off until 90°, then on to the zero"),
                      (b2, trail, "Trailing edge (MOSFET or IGBT): on from the zero, off at 90°")):
    style(axx)
    axx.plot(th, v, color=GRAY2, lw=1.1)
    axx.fill_between(th, 0, w, color=WARM, alpha=0.25, lw=0)
    axx.plot(th, w, color=WARM, lw=1.4)
    axx.set_ylim(-200, 200)
    axx.set_ylabel("volts", color=MUTED)
    axx.set_title(title, loc="left", fontsize=9.5, color=INK)
b2.set_xticks(np.arange(0, 721, 90))
b2.set_xlim(0, 720)
b2.set_xlabel("degrees of the line cycle", color=MUTED)
save2(fig, "leading-trailing.svg")
