#!/usr/bin/env python3
"""Figures and numbers for "An Analog Force-Sensing Knee Controller", the
design study of a microcontroller-free phase control on the low-voltage side
of an isolation barrier. Written by Claude at Robert Drzyzgula's direction.

Usage: tools/make_analog_knee_figures.py   (run from the repository root)
Writes SVGs to docs/images/analog-knee/ and prints the numbers the paper
quotes.

SIMULATED from a simple model, not measured:
  - 120 V, 60 Hz line. The H11AA1 zero-cross output holds the ramp reset
    for THZ degrees either side of each zero crossing (the window's
    half-width).
  - The ramp: an LM334 current source (I = 67.7 mV / RSET) charges CR
    linearly from the end of the reset window, so the ramp reaches
    VPEAK = I x t / CR just before the next window.
  - The command: the FSR to ground with RM to 5 V, so VD = 5 R / (R + RM)
    falls as the force rises. The comparator turns the MOC3023's LED on
    when the ramp passes VD, and the LED stays on until the next reset, so
    the triac is gated from the firing angle to the end of the half-cycle.
  - The FSR: R = 100 kOhm x (F / 0.5 N)^-0.8 for the UX series, the same
    ASSUMED curve as the force-sensing pedal paper (about 1 kOhm at
    150 N), to be replaced by measurements.
  - Resistive load; "motor voltage" is the RMS voltage a resistive load
    would see, as a percentage of the line.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUT = "docs/images/analog-knee"
os.makedirs(OUT, exist_ok=True)

INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
ACCENT, WARM, GREEN, PURPLE = "#1f5fa8", "#b5532a", "#3c8a4e", "#7a3b8f"
GRAY1, GRAY2 = "#7d8288", "#b4b8bd"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9.5,
                     "svg.fonttype": "none", "svg.hashsalt": "analogknee"})


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
HALF = 1 / (2 * F)                     # 8.33 ms
VCC = 5.0
NOM = dict(THZ=4.0, RSET=1.5e3, CR=0.1e-6, RM=22e3)


def vpeak(p):
    i = 0.0677 / p["RSET"]
    t = HALF * (180 - 2 * p["THZ"]) / 180
    return i * t / p["CR"]


def alpha(vd, p):
    """Firing angle in degrees, or None if the ramp never reaches vd."""
    vp = vpeak(p)
    if vd >= vp:
        return None
    return p["THZ"] + vd / vp * (180 - 2 * p["THZ"])


def vfrac(al):
    if al is None:
        return 0.0
    a = np.radians(al)
    return np.sqrt((np.pi - a + 0.5 * np.sin(2 * a)) / np.pi)


def rfsr(f, fa=0.5, n=0.8):
    return 100e3 * (np.asarray(f, float) / fa) ** -n


def vd(f, p, scale=1.0):
    r = rfsr(f) * scale
    return VCC * r / (r + p["RM"])


def speed(f, p, scale=1.0):
    return np.array([vfrac(alpha(v, p)) * 100 for v in np.atleast_1d(vd(f, p, scale))])


def f_start(p, scale=1.0):
    vp = vpeak(p)
    r = p["RM"] * vp / (VCC - vp) / scale
    return 0.5 * (r / 100e3) ** (-1 / 0.8)


FS = np.logspace(np.log10(0.3), np.log10(150), 400)


# ------------------------------------------------------------------ drawing helpers
def wire(ax, pts, ls="-", col=INK, lw=1.4):
    xs, ys = zip(*pts)
    ax.plot(xs, ys, color=col, lw=lw, ls=ls, solid_capstyle="round")


def node(ax, x, y):
    ax.plot(x, y, "o", ms=4, color=INK)


def note(ax, x, y, text, ha="left", va="center", col=INK, size=8.5):
    ax.text(x, y, text, ha=ha, va=va, color=col, fontsize=size)


def vres(ax, x, y0, y1, n=6, amp=0.12, col=INK):
    L = y1 - y0
    ys = [y0, y0 + 0.15 * L]
    xs = [x, x]
    for k in range(n):
        ys.append(y0 + 0.15 * L + (k + 0.5) * 0.7 * L / n)
        xs.append(x + (amp if k % 2 == 0 else -amp))
    ys += [y0 + 0.85 * L, y1]
    xs += [x, x]
    ax.plot(xs, ys, color=col, lw=1.4)


def hres(ax, x0, x1, y, n=6, amp=0.12, col=INK):
    L = x1 - x0
    xs = [x0, x0 + 0.15 * L]
    ys = [y, y]
    for k in range(n):
        xs.append(x0 + 0.15 * L + (k + 0.5) * 0.7 * L / n)
        ys.append(y + (amp if k % 2 == 0 else -amp))
    xs += [x0 + 0.85 * L, x1]
    ys += [y, y]
    ax.plot(xs, ys, color=col, lw=1.4)


def vcap(ax, x, ym, w=0.34, gap=0.12):
    ax.plot([x - w / 2, x + w / 2], [ym + gap / 2] * 2, color=INK, lw=2)
    ax.plot([x - w / 2, x + w / 2], [ym - gap / 2] * 2, color=INK, lw=2)


def box(ax, x0, y0, w, h, text, col=INK, size=8.5, ls="-"):
    ax.add_patch(plt.Rectangle((x0, y0), w, h, fill=False, ec=col, lw=1.3, ls=ls))
    note(ax, x0 + w / 2, y0 + h / 2, text, ha="center", col=col, size=size)


def drawing():
    fig, ax = plt.subplots(figsize=(10.0, 6.4))
    ax.set_aspect("equal")
    ax.axis("off")
    T, B = 5.0, 0.0
    # rails
    wire(ax, [(0.3, T), (10.2, T)])
    wire(ax, [(0.3, B), (10.2, B)])
    note(ax, 0.2, T, "+5 V (isolated, from PS1)", ha="right")
    note(ax, 0.2, B, "0 V", ha="right")
    # zero-cross: H11AA1 output, pull-up, reset FET
    vres(ax, 1.0, 3.2, T)
    node(ax, 1.0, T)
    note(ax, 1.25, 4.3, "RZ\n100 kΩ")
    node(ax, 1.0, 3.2)
    note(ax, 0.85, 3.4, "Z", ha="right", col=ACCENT)
    box(ax, 0.45, 1.3, 1.1, 1.0, "U2\nH11AA1\noutput", size=7.5)
    wire(ax, [(1.0, 3.2), (1.0, 2.3)])
    wire(ax, [(1.0, 1.3), (1.0, B)])
    node(ax, 1.0, B)
    wire(ax, [(1.0, 3.2), (2.2, 3.2), (2.2, 2.0), (2.55, 2.0)])
    # Q3 2N7000 (drawn simply)
    ax.plot([2.55, 2.55], [1.75, 2.25], color=INK, lw=1.4)
    ax.plot([2.7, 2.7], [1.7, 2.3], color=INK, lw=1.4)
    wire(ax, [(2.7, 2.25), (3.2, 2.25), (3.2, 3.2)])
    wire(ax, [(2.7, 1.75), (3.2, 1.75), (3.2, B)])
    note(ax, 2.55, 1.45, "Q3 2N7000\n(ramp reset)", ha="center", size=7.5)
    node(ax, 3.2, B)
    # LM334 and RSET
    box(ax, 2.75, 3.75, 0.9, 0.6, "LM334", size=7.5)
    wire(ax, [(3.2, T), (3.2, 4.35)])
    node(ax, 3.2, T)
    wire(ax, [(3.2, 3.75), (3.2, 3.2)])
    wire(ax, [(3.65, 4.05), (4.0, 4.05)])
    hres(ax, 4.0, 4.9, 4.05, n=4, amp=0.09)
    wire(ax, [(4.9, 4.05), (5.05, 4.05), (5.05, 3.6)])
    node(ax, 5.05, 3.6)
    note(ax, 4.45, 4.35, "RSET 1.5 kΩ", ha="center", size=8)
    # ramp node and CR
    node(ax, 3.2, 3.2)
    wire(ax, [(3.2, 3.2), (4.3, 3.2)])
    node(ax, 4.3, 3.2)
    wire(ax, [(4.3, 3.2), (4.3, 1.66)])
    vcap(ax, 4.3, 1.6)
    wire(ax, [(4.3, 1.54), (4.3, B)])
    node(ax, 4.3, B)
    note(ax, 4.55, 1.6, "CR 0.1 µF\nfilm")
    note(ax, 3.75, 2.95, "ramp", ha="center", col=ACCENT)
    # comparator
    cx, cy = 7.9, 3.22
    ax.add_patch(plt.Polygon([[cx - 0.7, cy + 0.75], [cx - 0.7, cy - 0.75], [cx + 0.6, cy]],
                             closed=True, fill=False, ec=INK, lw=1.4))
    note(ax, cx - 0.55, cy + 0.38, "−", size=10)
    note(ax, cx - 0.55, cy - 0.38, "+", size=10)
    note(ax, cx - 0.05, cy - 1.15, "U4  MCP6562\n(rail-to-rail)", ha="center", size=7.5)
    wire(ax, [(4.3, 3.2), (4.3, cy + 0.38), (cx - 0.7, cy + 0.38)])
    # FSR divider, from a local +5 V
    xd = 6.0
    ax.plot([xd - 0.18, xd + 0.18], [3.35, 3.35], color=INK, lw=1.4)
    note(ax, xd + 0.25, 3.36, "+5 V", size=7.5)
    vres(ax, xd, cy - 0.38, 3.35, n=4)
    note(ax, xd - 0.25, 3.05, "RM 22 kΩ", ha="right", size=8)
    node(ax, xd, cy - 0.38)
    note(ax, xd + 0.12, cy - 0.6, "D", col=ACCENT)
    wire(ax, [(xd, cy - 0.38), (cx - 0.7, cy - 0.38)])
    ax.add_patch(plt.Rectangle((xd - 0.25, 0.6), 0.5, 1.5, fill=False, ec=WARM, lw=1.5))
    vres(ax, xd, 0.6, 2.1, n=6, amp=0.1, col=WARM)
    wire(ax, [(xd, cy - 0.38), (xd, 2.1)])
    wire(ax, [(xd, 0.6), (xd, B)])
    node(ax, xd, B)
    note(ax, xd - 0.35, 1.35, "FSR\n(knee)", ha="right", col=WARM)
    node(ax, 6.8, cy - 0.38)
    wire(ax, [(6.8, cy - 0.38), (6.8, 1.46)])
    vcap(ax, 6.8, 1.4)
    wire(ax, [(6.8, 1.34), (6.8, B)])
    node(ax, 6.8, B)
    note(ax, 6.95, 1.0, "CF\n0.1 µF", size=7.5)
    # LED drive: +5 -> RL -> MOC LED -> comparator output
    xo = 9.5
    wire(ax, [(cx + 0.6, cy), (xo, cy)])
    node(ax, xo, cy)
    note(ax, xo, cy - 0.3, "low = fire", ha="center", col=MUTED, size=7.5)
    vres(ax, xo, 4.3, T, n=4)
    node(ax, xo, T)
    note(ax, xo + 0.25, 4.65, "RL 330 Ω")
    box(ax, xo - 0.55, 3.5, 1.1, 0.8, "U3 LED\nMOC3023", size=7.5)
    wire(ax, [(xo, 3.5), (xo, cy)])
    # barrier
    ax.plot([10.5, 10.5], [-0.4, 5.6], color=WARM, lw=1.6, ls=(0, (6, 3)))
    note(ax, 10.55, 5.45, "isolation barrier", col=WARM, size=8)
    box(ax, 10.8, 3.4, 2.4, 1.0, "U3's triac output\n→ triac TR1\n(as the MCU controller)", col=WARM, size=7.5)
    box(ax, 10.8, 1.3, 2.4, 1.0, "U2's LEDs ← line\nthrough R7, R8\n(as the MCU controller)", col=WARM, size=7.5)
    wire(ax, [(xo + 0.55, 3.9), (10.8, 3.9)], ls=(0, (2, 2)), col=GRAY1, lw=1.0)
    wire(ax, [(1.55, 1.8), (1.8, 1.8), (1.8, 0.35), (12.0, 0.35), (12.0, 1.3)], ls=(0, (2, 2)), col=GRAY1, lw=1.0)
    ax.set_xlim(-2.6, 13.4)
    ax.set_ylim(-0.6, 5.8)
    save(fig, "analog-knee-schematic.svg")


def waveforms(p):
    f = 6.0
    v_d = float(vd(f, p))
    al = alpha(v_d, p)
    vp = vpeak(p)
    th = np.linspace(0, 720, 4000)
    line = 170 * np.sin(np.radians(th))
    ph = th % 180
    z = (ph < p["THZ"]) | (ph > 180 - p["THZ"])
    ramp = np.where(z, 0.0, np.clip((ph - p["THZ"]) / (180 - 2 * p["THZ"]) * vp, 0, None))
    led = (~z) & (ph >= al)
    mot = np.where(led | ((ph >= al) & (ph < 180)), line, 0.0)
    mot = np.where(ph >= al, line, 0.0)
    fig, (a1, a2, a3) = plt.subplots(3, 1, figsize=(8.4, 6.6), sharex=True,
                                     gridspec_kw={"height_ratios": [1.1, 1, 0.45], "hspace": 0.14})
    style(a1)
    a1.plot(th, line, color=GRAY2, lw=1.2, label="line")
    a1.fill_between(th, 0, mot, color=WARM, alpha=0.25, lw=0)
    a1.plot(th, mot, color=WARM, lw=1.4, label="voltage at the motor")
    a1.set_ylim(-200, 200)
    a1.set_ylabel("volts", color=MUTED)
    a1.legend(loc="lower left", frameon=False, fontsize=8.5, ncol=2)
    style(a2)
    a2.plot(th, ramp, color=ACCENT, lw=1.4, label="ramp (CR)")
    a2.axhline(v_d, color=WARM, lw=1.2, ls=(0, (4, 3)), label=f"command D = {v_d:.2f} V")
    a2.set_ylim(0, 4.2)
    a2.set_ylabel("volts", color=MUTED)
    a2.legend(loc="upper left", frameon=False, fontsize=8.5, ncol=2)
    style(a3)
    a3.fill_between(th, 0, z.astype(float), step="mid", color=GREEN, alpha=0.5, lw=0, label="Z: reset")
    a3.fill_between(th, 0, led.astype(float) * 0.6, step="mid", color=PURPLE, alpha=0.5, lw=0, label="MOC3023 LED on")
    a3.set_yticks([])
    a3.set_ylim(0, 1.1)
    a3.legend(loc="upper right", frameon=False, fontsize=8, ncol=2, bbox_to_anchor=(1.0, 1.35))
    a3.set_xticks(np.arange(0, 721, 90))
    a3.set_xlim(0, 720)
    a3.set_xlabel("degrees of the line cycle (360° = 16.7 ms)", color=MUTED)
    a1.set_title(f"Simulated at {f:g} N on the sensor (FSR ≈ {float(rfsr(f))/1e3:.1f} kΩ): fires at {al:.0f}°",
                 loc="left", fontsize=10, color=INK)
    save(fig, "analog-knee-waveforms.svg")
    return f, v_d, al


def curves():
    fig, ax = plt.subplots(figsize=(8.4, 4.4))
    style(ax)
    out = []
    for rm, col in ((10e3, PURPLE), (22e3, ACCENT), (47e3, GREEN)):
        p = dict(NOM, RM=rm)
        s = speed(FS, p)
        ax.plot(FS, s, color=col, lw=1.7, label=f"RM = {rm/1e3:g} kΩ")
        k = np.argmax(s >= 90)
        out.append((rm, f_start(p), FS[k] if s[k] >= 90 else None, s.max()))
    ax.set_xscale("log")
    ax.set_xlim(0.3, 150)
    ax.set_ylim(0, 102)
    ax.set_xticks([0.3, 0.5, 1, 2, 5, 10, 20, 50, 100, 150])
    ax.set_xticklabels(["0.3", "0.5", "1", "2", "5", "10", "20", "50", "100", "150"])
    ax.set_xlabel("force on the sensor, N (log scale); UX-series FSR, assumed curve", color=MUTED)
    ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
    ax.legend(frameon=False, fontsize=8.5, loc="lower right")
    ax.set_title("Motor voltage against force, simulated (ramp peak 3.6 V, reset window ±4°)", loc="left",
                 fontsize=10, color=INK)
    save(fig, "analog-knee-curve.svg")
    return out


def travel(p):
    """Speed against knee travel, with the sensor engaged so the motor
    starts as the rest switch closes (1 inch). Two ways to load the
    sensor: a linear spring (force proportional to travel) reaching FMAX at
    full travel (2 inches), and a progressive stack whose force grows
    geometrically from the starting force to FMAX."""
    x_on, x_full = 25.4, 50.8
    fs0 = f_start(p)
    fig, ax = plt.subplots(figsize=(8.4, 4.2))
    style(ax)
    xs = np.linspace(x_on, x_full, 300)
    res = []
    for fmax, col in ((20, PURPLE), (50, ACCENT)):
        x0 = x_on - (x_full - x_on) * fs0 / (fmax - fs0)
        k = fmax / (x_full - x0)
        ax.plot(xs, speed(k * (xs - x0), p), color=col, lw=1.6,
                label=f"linear spring, {fmax} N at full travel")
        res.append(("linear", fmax, x0, k))
    for fmax, col in ((20, WARM), (50, GREEN)):
        fsn = fs0 * (fmax / fs0) ** ((xs - x_on) / (x_full - x_on))
        ax.plot(xs, speed(fsn, p), color=col, lw=1.6, ls=(0, (5, 2)),
                label=f"progressive stack, {fmax} N at full travel")
        res.append(("progressive", fmax, None, None))
    ax.set_xlim(x_on, x_full)
    ax.set_ylim(0, 102)
    ax.set_xlabel("knee travel, mm (the rest switch closes at 25.4 mm, 1\"; full speed by 50.8 mm, 2\")", color=MUTED)
    ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
    ax.legend(frameon=False, fontsize=8.5, loc="lower right")
    ax.set_title("Speed along the knee's travel: a linear spring against a progressive one (RM = 22 kΩ)",
                 loc="left", fontsize=10, color=INK)
    save(fig, "analog-knee-travel.svg")
    return res


def tolerance():
    fig, ax = plt.subplots(figsize=(8.4, 4.4))
    style(ax)
    s0 = speed(FS, NOM)
    ax.plot(FS, s0, color=ACCENT, lw=1.8, label="nominal")
    cases = [(dict(NOM, RSET=1.5e3 * 1.1), 1.0, GRAY1, (0, (4, 2)), "ramp 10% slower (current source, CR)"),
             (dict(NOM, RSET=1.5e3 / 1.1), 1.0, GRAY1, (0, (1, 1.5)), "ramp 10% faster"),
             (NOM, 1.25, WARM, (0, (4, 2)), "FSR 25% higher resistance"),
             (NOM, 0.8, WARM, (0, (1, 1.5)), "FSR 20% lower resistance"),
             (dict(NOM, THZ=8.0), 1.0, GREEN, (0, (4, 2)), "reset window ±8°")]
    out = []
    for p, sc, col, ls, lab in cases:
        s = speed(FS, p, sc)
        ax.plot(FS, s, color=col, lw=1.2, ls=ls, label=lab)
        k = np.argmax(s >= 90)
        out.append((lab, f_start(p, sc), FS[k] if s[k] >= 90 else None, s.max()))
    ax.set_xscale("log")
    ax.set_xlim(0.3, 150)
    ax.set_ylim(0, 102)
    ax.set_xticks([0.3, 0.5, 1, 2, 5, 10, 20, 50, 100, 150])
    ax.set_xticklabels(["0.3", "0.5", "1", "2", "5", "10", "20", "50", "100", "150"])
    ax.set_xlabel("force on the sensor, N (log scale)", color=MUTED)
    ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
    ax.legend(frameon=False, fontsize=8, loc="lower right")
    ax.set_title("What moves the curve (RM = 22 kΩ)", loc="left", fontsize=10, color=INK)
    save(fig, "analog-knee-tolerance.svg")
    return out


drawing()
f, v_d, al = waveforms(NOM)
cv = curves()
tv = travel(NOM)
tol = tolerance()
print(f"ramp current {0.0677/NOM['RSET']*1e6:.1f} uA, peak {vpeak(NOM):.2f} V")
print(f"waveform: {f} N, D = {v_d:.2f} V, fires {al:.0f} deg, {vfrac(al)*100:.0f}%")
for rm, fs0, f90, mx in cv:
    print(f"RM {rm/1e3:g}k: starts {fs0:.2f} N, 90% at {f90 if f90 else 0:.1f} N, max {mx:.0f}%")
for kind, fmax, x0, k in tv:
    print(kind, fmax, x0, k)
x_on, x_full = 25.4, 50.8
xs = np.linspace(x_on, x_full, 300)
fs0 = f_start(NOM)
for kind in ("linear", "progressive"):
    fsn = (50 / (x_full - (x_on - (x_full - x_on) * fs0 / (50 - fs0)))) * (xs - (x_on - (x_full - x_on) * fs0 / (50 - fs0))) if kind == "linear" else fs0 * (50 / fs0) ** ((xs - x_on) / (x_full - x_on))
    sp = speed(fsn, NOM)
    print(kind, "50 N:", ", ".join(f"{q}% at {xs[np.argmax(sp >= q)] - x_on:.1f} mm" for q in (25, 50, 75, 90)))
for lab, fs0, f90, mx in tol:
    print(f"{lab}: starts {fs0:.2f} N, 90% at {f90 if f90 else 0:.1f} N, max {mx:.0f}%")
s0 = speed(FS, NOM)
for pct in (25, 50, 75):
    print(f"nominal {pct}% at {FS[np.argmax(s0 >= pct)]:.2f} N")
