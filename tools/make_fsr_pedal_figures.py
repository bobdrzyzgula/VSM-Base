#!/usr/bin/env python3
"""Figures and numbers for "A Force-Sensing Pedal", the design study of a
passive two-wire phase control driven by a force-sensing resistor.
Written by Claude at Robert Drzyzgula's direction.

Usage: tools/make_fsr_pedal_figures.py   (run from the repository root)
Writes SVGs to docs/images/fsr-pedal/ and prints the numbers the paper
quotes.

Everything here is SIMULATED from a simple model, not measured:
  - 120 V, 60 Hz line (170 V peak). Before the triac fires the pedal sees
    the whole line voltage (the motor drops almost nothing at the timing
    network's few mA); after, about 1 V until the half-cycle ends.
    Resistive load: the triac turns off at the voltage zero.
  - The timing supply: RD from the triac's MT2 to a node N, clamped at
    +/-VZ by two back-to-back zeners to MT1. From N, RS and the FSR in
    series charge C; RB (a fixed resistor plus a trimmer) bleeds C. When C
    reaches the diac's breakover (DB3: 28-36 V, nominally 32 V) the diac
    fires, and C drops to 22 V and then decays.
  - The FSR follows a power law, R = 100 kOhm x (F / FA)^-n, with FA the
    force at which it reaches 100 kOhm (Interlink's "actuation"). For the
    UX series, FA = 0.5 N and n = 0.8, which gives about 1 kOhm at 150 N,
    the top of its range: an ASSUMPTION fitted to Interlink's stated range
    and to its "about 1 kOhm at full load", to be replaced by measured
    curves. The base 400 series: FA = 0.2 N, n = 1.0.
The state of C is carried from half-cycle to half-cycle, so the model
shows the start and stop forces (hysteresis) as the force is raised and
lowered. "Motor voltage" is the RMS voltage a resistive load would see, as
a percentage of the line: a stand-in for speed.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUT = "docs/images/fsr-pedal"
os.makedirs(OUT, exist_ok=True)

INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
ACCENT, WARM, GREEN, PURPLE = "#1f5fa8", "#b5532a", "#3c8a4e", "#7a3b8f"
GRAY1, GRAY2 = "#7d8288", "#b4b8bd"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9.5,
                     "svg.fonttype": "none", "svg.hashsalt": "fsrpedal"})


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
VAFTER, VON = 22.0, 1.0
N = 1500
NOM = dict(RD=22e3, VZ=56.7, C=0.1e-6, RS=12e3, RB=330e3, VBO=32.0)


def half(vc, s, p, rf, rec=False):
    """One half-cycle from a zero crossing, sign s, FSR resistance rf.
    Returns C's voltage at the end, the firing angle (None if none), the
    FSR's peak voltage and current, the energy in RD, and (if rec) traces."""
    th = np.linspace(0, np.pi, N + 1)[1:]
    dt = (np.pi / N) / W
    rx = p["RS"] + rf
    on, al = False, None
    vmax = imax = e = 0.0
    tr = []
    for t in th:
        vl = s * VON if on else s * VPK * np.sin(t)
        vn = (vl / p["RD"] + vc / rx) / (1 / p["RD"] + 1 / rx)
        vn = max(-p["VZ"], min(p["VZ"], vn))
        i = (vn - vc) / rx
        vmax = max(vmax, abs(i) * rf)
        imax = max(imax, abs(i))
        e += (vl - vn) ** 2 / p["RD"] * dt
        vc += (i - vc / p["RB"]) / p["C"] * dt
        if not on and s * vc >= p["VBO"]:
            on, al, vc = True, t, s * VAFTER
        if rec:
            tr.append((t, s * VPK * np.sin(t), vn, vc, on))
    return vc, al, vmax, imax, e, tr


def steady(rf, p, vc=0.0, cycles=6):
    vmax = imax = 0.0
    for _ in range(cycles):
        vc, al, v1, i1, e1, _ = half(vc, 1, p, rf)
        vc, _, v2, i2, e2, _ = half(vc, -1, p, rf)
        vmax, imax = max(vmax, v1, v2), max(imax, i1, i2)
    return vc, al, vmax, imax, (e1 + e2) * F


def vfrac(al):
    return 0.0 if al is None else np.sqrt((np.pi - al + 0.5 * np.sin(2 * al)) / np.pi)


def rfsr(f, fa=0.5, n=0.8):
    return 100e3 * (f / fa) ** -n


FS = np.logspace(np.log10(0.5), np.log10(150), 70)


def sweep(p, fa=0.5, n=0.8):
    """Raise the force from rest, then lower it again. Returns motor
    voltage (%) up and down, and the FSR's peak voltage and current."""
    up, vmx, imx, vc = [], [], [], 0.0
    for f in FS:
        vc, al, vm, im, _ = steady(rfsr(f, fa, n), p, vc)
        up.append(vfrac(al) * 100)
        vmx.append(vm)
        imx.append(im)
    dn = []
    for f in FS[::-1]:
        vc, al, _, _, _ = steady(rfsr(f, fa, n), p, vc)
        dn.append(vfrac(al) * 100)
    return np.array(up), np.array(dn[::-1]), np.array(vmx), np.array(imx)


def window(u, d=None):
    s = FS[u > 0][0] if np.any(u > 0) else None
    k = np.argmax(u >= 90)
    f90 = FS[k] if u[k] >= 90 else None
    stop = FS[d > 0][0] if d is not None and np.any(d > 0) else None
    return s, f90, u.max(), stop


# ------------------------------------------------------------------ schematic
def wire(ax, pts, ls="-", col=INK, lw=1.4):
    xs, ys = zip(*pts)
    ax.plot(xs, ys, color=col, lw=lw, ls=ls, solid_capstyle="round")


def node(ax, x, y):
    ax.plot(x, y, "o", ms=4, color=INK)


def note(ax, x, y, text, ha="left", va="center", col=INK, size=8.5):
    ax.text(x, y, text, ha=ha, va=va, color=col, fontsize=size)


def hres(ax, x0, x1, y, n=6, amp=0.13, col=INK):
    L = x1 - x0
    xs = [x0, x0 + 0.15 * L]
    ys = [y, y]
    for k in range(n):
        xs.append(x0 + 0.15 * L + (k + 0.5) * 0.7 * L / n)
        ys.append(y + (amp if k % 2 == 0 else -amp))
    xs += [x0 + 0.85 * L, x1]
    ys += [y, y]
    ax.plot(xs, ys, color=col, lw=1.4)


def vres(ax, x, y0, y1, n=6, amp=0.13, col=INK):
    L = y1 - y0
    ys = [y0, y0 + 0.15 * L]
    xs = [x, x]
    for k in range(n):
        ys.append(y0 + 0.15 * L + (k + 0.5) * 0.7 * L / n)
        xs.append(x + (amp if k % 2 == 0 else -amp))
    ys += [y0 + 0.85 * L, y1]
    xs += [x, x]
    ax.plot(xs, ys, color=col, lw=1.4)


def vcap(ax, x, ym, w=0.36, gap=0.12):
    ax.plot([x - w / 2, x + w / 2], [ym + gap / 2] * 2, color=INK, lw=2)
    ax.plot([x - w / 2, x + w / 2], [ym - gap / 2] * 2, color=INK, lw=2)


def zener(ax, x, ym, up=True, s=0.2):
    d = 1 if up else -1
    ax.add_patch(plt.Polygon([[x - s, ym - d * s], [x + s, ym - d * s], [x, ym + d * s * 0.8]],
                             closed=True, fill=False, ec=INK, lw=1.3))
    yb = ym + d * s * 0.8
    ax.plot([x - s, x + s], [yb, yb], color=INK, lw=1.3)
    ax.plot([x - s, x - s - 0.08], [yb, yb - d * 0.1], color=INK, lw=1.3)
    ax.plot([x + s, x + s + 0.08], [yb, yb + d * 0.1], color=INK, lw=1.3)


def drawing():
    fig, ax = plt.subplots(figsize=(9.6, 4.6))
    ax.set_aspect("equal")
    ax.axis("off")
    T, B = 4.0, 0.0
    # rails and terminals
    wire(ax, [(0, T), (11.2, T)])
    wire(ax, [(0, B), (0.35, B)])
    wire(ax, [(1.15, B), (11.2, B)])
    ax.add_patch(plt.Rectangle((0.35, B - 0.13), 0.8, 0.26, fill=False, ec=INK, lw=1.3))
    note(ax, 0.75, B - 0.35, "F1\nT2A", ha="center", va="top")
    for y, t in ((T, "J1: to the motor"), (B, "J2: to the line")):
        ax.plot(0, y, "o", ms=6, mfc="white", mec=INK)
        note(ax, -0.15, y, t, ha="right")
    note(ax, 5.6, T + 0.35, "MT2 side (follows the line until the triac fires)", ha="center", col=MUTED)
    note(ax, 5.6, B - 0.6, "MT1 side", ha="center", col=MUTED)
    # MOV
    vres(ax, 1.7, B, T, n=6, amp=0.12)
    ax.plot([1.45, 1.95], [1.4, 2.6], color=INK, lw=1.1)
    node(ax, 1.7, T); node(ax, 1.7, B)
    note(ax, 1.45, 2.0, "RV1\nMOV\n241K", ha="right")
    # RD
    vres(ax, 3.2, 2.5, T, n=6)
    node(ax, 3.2, T)
    note(ax, 3.45, 3.3, "RD 22 kΩ, 1 W")
    # zeners
    node(ax, 3.2, 2.5)
    wire(ax, [(3.2, 2.5), (3.2, 1.95)])
    zener(ax, 3.2, 1.7, up=False)
    wire(ax, [(3.2, 1.45), (3.2, 1.05)])
    zener(ax, 3.2, 0.8, up=True)
    wire(ax, [(3.2, 0.55), (3.2, B)])
    node(ax, 3.2, B)
    note(ax, 3.55, 1.25, "D1, D2\n56 V zeners,\nback to back")
    note(ax, 3.05, 2.72, "N", ha="right", col=ACCENT)
    # RS, FSR
    wire(ax, [(3.2, 2.5), (3.6, 2.5)])
    hres(ax, 3.6, 4.9, 2.5)
    note(ax, 4.25, 2.85, "RS 12 kΩ", ha="center")
    wire(ax, [(4.9, 2.5), (5.2, 2.5)])
    ax.add_patch(plt.Rectangle((5.2, 2.25), 1.4, 0.5, fill=False, ec=WARM, lw=1.5))
    hres(ax, 5.2, 6.6, 2.5, amp=0.1, col=WARM)
    ax.annotate("", xy=(5.9, 2.78), xytext=(5.9, 3.35),
                arrowprops=dict(arrowstyle="-|>", color=WARM, lw=1.3))
    note(ax, 6.05, 3.25, "force", col=WARM)
    note(ax, 5.9, 2.0, "FSR (UX 406)", ha="center", col=WARM)
    wire(ax, [(6.6, 2.5), (7.4, 2.5)])
    node(ax, 7.4, 2.5)
    note(ax, 7.4, 2.75, "X", ha="center", col=ACCENT)
    # C
    wire(ax, [(7.4, 2.5), (7.4, 1.3)])
    vcap(ax, 7.4, 1.24)
    wire(ax, [(7.4, 1.18), (7.4, B)])
    node(ax, 7.4, B)
    note(ax, 7.15, 1.24, "C\n0.1 µF\nfilm", ha="right")
    # RB
    wire(ax, [(7.4, 2.5), (8.3, 2.5)])
    node(ax, 8.3, 2.5)
    vres(ax, 8.3, 1.3, 2.5, n=5)
    vres(ax, 8.3, B, 1.3, n=5)
    ax.annotate("", xy=(8.15, 0.55), xytext=(8.75, 0.95),
                arrowprops=dict(arrowstyle="-|>", color=INK, lw=1.0))
    node(ax, 8.3, B)
    note(ax, 8.5, 1.95, "RB 100 kΩ")
    note(ax, 8.85, 0.85, "+ 1 MΩ trim\n(start force)")
    # diac, RG
    wire(ax, [(8.3, 2.5), (9.0, 2.5)])
    for xx in (9.0, 9.55):
        ax.plot([xx, xx], [2.25, 2.75], color=INK, lw=1.4)
    ax.add_patch(plt.Polygon([[9.0, 2.5], [9.55, 2.72], [9.55, 2.28]], closed=True, fill=False, ec=INK, lw=1.1))
    ax.add_patch(plt.Polygon([[9.55, 2.5], [9.0, 2.72], [9.0, 2.28]], closed=True, fill=False, ec=INK, lw=1.1))
    note(ax, 9.2, 2.95, "DB3", ha="center")
    wire(ax, [(9.55, 2.5), (9.75, 2.5)])
    hres(ax, 9.75, 10.55, 2.5, n=4, amp=0.1)
    note(ax, 10.35, 2.95, "RG 100 Ω", ha="center")
    wire(ax, [(10.55, 2.5), (10.7, 2.5), (10.7, 1.75), (10.95, 1.75)])
    # triac
    x = 11.2
    wire(ax, [(x, T), (x, 2.45)])
    wire(ax, [(x, 1.55), (x, B)])
    ax.plot([x - 0.35, x + 0.35], [2.45, 2.45], color=INK, lw=1.4)
    ax.plot([x - 0.35, x + 0.35], [1.55, 1.55], color=INK, lw=1.4)
    ax.add_patch(plt.Polygon([[x - 0.32, 2.45], [x - 0.02, 2.45], [x - 0.17, 1.55]], closed=True, fill=False, ec=INK, lw=1.2))
    ax.add_patch(plt.Polygon([[x + 0.02, 1.55], [x + 0.32, 1.55], [x + 0.17, 2.45]], closed=True, fill=False, ec=INK, lw=1.2))
    note(ax, x + 0.45, 2.0, "TR1\nBTA16-600BW\n(insulated tab)")
    note(ax, x + 0.1, 2.75, "MT2", col=MUTED, size=7.5)
    note(ax, x + 0.1, 1.25, "MT1", col=MUTED, size=7.5)
    note(ax, 10.75, 1.55, "G", col=MUTED, size=7.5)
    node(ax, x, T); node(ax, x, B)
    ax.set_xlim(-2.6, 13.6)
    ax.set_ylim(-1.0, 4.7)
    save(fig, "fsr-pedal-schematic.svg")


# ------------------------------------------------------------------ figures
def waveforms(p):
    rf = rfsr(4.0)
    vc, al, _, _, _ = steady(rf, p, cycles=10)
    rows = []
    for c in range(2):
        for k, s in enumerate((1, -1)):
            vc, a, _, _, _, tr = half(vc, s, p, rf, rec=True)
            for t, vl, vn, v, on in tr:
                rows.append((c * 360 + k * 180 + np.degrees(t), vl, vn, v, vl if on else 0.0))
    r = np.array(rows)
    fig, (a1, a2) = plt.subplots(2, 1, figsize=(8.4, 5.6), sharex=True,
                                 gridspec_kw={"height_ratios": [1.15, 1], "hspace": 0.12})
    style(a1)
    a1.plot(r[:, 0], r[:, 1], color=GRAY2, lw=1.2, label="line")
    a1.fill_between(r[:, 0], 0, r[:, 4], color=WARM, alpha=0.25, lw=0)
    a1.plot(r[:, 0], r[:, 4], color=WARM, lw=1.4, label="voltage at the motor")
    a1.set_ylim(-200, 200)
    a1.set_ylabel("volts", color=MUTED)
    a1.legend(loc="lower left", frameon=False, fontsize=8.5, ncol=2)
    style(a2)
    a2.plot(r[:, 0], r[:, 2], color=GREEN, lw=1.3, label="clamped node N")
    a2.plot(r[:, 0], r[:, 3], color=ACCENT, lw=1.4, label="timing capacitor C")
    for v in (p["VBO"], -p["VBO"]):
        a2.axhline(v, color=GRAY1, lw=0.9, ls=(0, (4, 3)))
    a2.text(718, p["VBO"] + 2, "diac breakover ±32 V", color=GRAY1, fontsize=8.5, ha="right", va="bottom")
    a2.set_ylim(-70, 70)
    a2.set_ylabel("volts", color=MUTED)
    a2.set_xlabel("degrees of the line cycle (360° = 16.7 ms)", color=MUTED)
    a2.set_xticks(np.arange(0, 721, 90))
    a2.set_xlim(0, 720)
    a2.legend(loc="lower right", frameon=False, fontsize=8.5, ncol=2)
    a1.set_title(f"Simulated at 4 N on the sensor (FSR ≈ {rf/1e3:.0f} kΩ): fires at about {np.degrees(al):.0f}°",
                 loc="left", fontsize=10, color=INK)
    save(fig, "fsr-pedal-waveforms.svg")
    return np.degrees(al)


def curves():
    fig, ax = plt.subplots(figsize=(8.4, 4.6))
    style(ax)
    res = {}
    for rs, col in ((6.8e3, PURPLE), (12e3, ACCENT), (18e3, GREEN)):
        p = dict(NOM, RS=rs)
        u, d, vm, im = sweep(p)
        res[rs] = (u, d, vm, im)
        ax.plot(FS, u, color=col, lw=1.7, label=f"RS = {rs/1e3:g} kΩ")
        if np.any(np.abs(u - d) > 0.5):
            ax.plot(FS, d, color=col, lw=1.1, ls=(0, (4, 2)))
    ax.set_xscale("log")
    ax.set_xlim(0.5, 150)
    ax.set_ylim(0, 102)
    ax.set_xticks([0.5, 1, 2, 5, 10, 20, 50, 100, 150])
    ax.set_xticklabels(["0.5", "1", "2", "5", "10", "20", "50", "100", "150"])
    ax.set_xlabel("force on the sensor, N (log scale); UX-series FSR, assumed curve", color=MUTED)
    ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
    ax.legend(frameon=False, fontsize=8.5, loc="lower right")
    ax.text(0.55, 92, "solid: pressing from rest\ndashed: easing off, where it differs", color=MUTED,
            fontsize=8.5, va="top")
    sec = ax.secondary_xaxis("top", functions=(lambda f: 5 * f, lambda f: f / 5))
    sec.set_xlabel("force on a 5 : 1 pedal (foot), N", color=MUTED)
    sec.tick_params(colors=MUTED)
    sec.set_xticks([5, 10, 20, 50, 100, 200, 500])
    sec.set_xticklabels(["5", "10", "20", "50", "100", "200", "500"])
    ax.set_title("Motor voltage against force, simulated (RB = 330 kΩ, DB3 at 32 V)", loc="left",
                 fontsize=10, color=INK, pad=28)
    save(fig, "fsr-pedal-curve.svg")
    return res


def trim():
    fig, ax = plt.subplots(figsize=(8.4, 4.4))
    style(ax)
    out = []
    for vbo, rb, col, ls in ((28.0, 330e3, GRAY1, (0, (4, 2))), (36.0, 330e3, GRAY1, (0, (1, 1.5))),
                             (32.0, 330e3, ACCENT, "-"), (28.0, 100e3, WARM, "-"), (36.0, 1.1e6, GREEN, "-")):
        p = dict(NOM, VBO=vbo, RB=rb)
        u, d, _, _ = sweep(p)
        ax.plot(FS, u, color=col, lw=1.6 if ls == "-" else 1.2, ls=ls,
                label=f"DB3 at {vbo:g} V, RB = {rb/1e3:g} kΩ")
        out.append((vbo, rb, window(u)))
    ax.set_xscale("log")
    ax.set_xlim(0.5, 150)
    ax.set_ylim(0, 102)
    ax.set_xticks([0.5, 1, 2, 5, 10, 20, 50, 100, 150])
    ax.set_xticklabels(["0.5", "1", "2", "5", "10", "20", "50", "100", "150"])
    ax.set_xlabel("force on the sensor, N (log scale)", color=MUTED)
    ax.set_ylabel("motor voltage, % of line (RMS)", color=MUTED)
    ax.legend(frameon=False, fontsize=8.5, loc="lower right")
    ax.set_title("The diac's spread, and how far the RB trimmer corrects it (RS = 12 kΩ)", loc="left",
                 fontsize=10, color=INK)
    save(fig, "fsr-pedal-trim.svg")
    return out


def stress(res):
    u, d, vm, im = res[12e3]
    fig, (a1, a2) = plt.subplots(1, 2, figsize=(8.6, 3.6))
    for a in (a1, a2):
        style(a)
        a.set_xscale("log")
        a.set_xlim(0.5, 150)
        a.set_xticks([0.5, 1, 5, 10, 50, 150])
        a.set_xticklabels(["0.5", "1", "5", "10", "50", "150"])
        a.set_xlabel("force on the sensor, N", color=MUTED)
    a1.plot(FS, vm, color=WARM, lw=1.6)
    a1.axhline(5, color=GRAY1, lw=0.9, ls=(0, (4, 3)))
    a1.text(0.6, 7, "Interlink's typical drive: up to 5 V", color=GRAY1, fontsize=8)
    a1.set_ylabel("peak volts across the FSR", color=MUTED)
    a1.set_ylim(0, 90)
    a2.plot(FS, im * 1e3, color=ACCENT, lw=1.6)
    for lim, txt in ((1.27, "402 fully loaded (1.27 cm²)"), (3.1, "406 under a 20 mm puck (3.1 cm²)")):
        a2.axhline(lim, color=GRAY1, lw=0.9, ls=(0, (4, 3)))
        a2.text(150, lim + 0.08, txt, color=GRAY1, fontsize=8, ha="right")
    a2.set_ylabel("peak mA through the FSR", color=MUTED)
    a2.set_ylim(0, 4)
    fig.suptitle("Stress on the sensor, simulated (RS = 12 kΩ); current limits at 1 mA per cm² of loaded area",
                 x=0.02, ha="left", fontsize=10, color=INK)
    fig.tight_layout()
    save(fig, "fsr-pedal-stress.svg")
    return vm.max(), im.max()


drawing()
al = waveforms(NOM)
res = curves()
tr = trim()
vmax, imax = stress(res)

# off-state and full-on numbers
_, _, _, _, p_off = steady(1e12, NOM, cycles=6)
_, al_full, vf_full, if_full, p_full = steady(rfsr(150), NOM, cycles=6)
# RMS current through RD with the pedal at rest (the leakage through the motor)
th = np.linspace(0, np.pi, 4000)
vl = VPK * np.sin(th)
i_off = (vl - np.minimum(vl, NOM["VZ"])) / NOM["RD"]
print(f"waveform example fires at {al:.0f} deg")
for rs, (u, d, vm, im) in res.items():
    s, f90, mx, stop = window(u, d)
    print(f"RS {rs/1e3:g}k: starts {s:.2f} N (first {u[u>0][0]:.0f}%), stops {stop:.2f} N, 90% at {f90 if f90 else 0:.1f} N, max {mx:.0f}%")
for vbo, rb, (s, f90, mx, _) in tr:
    print(f"DB3 {vbo} V, RB {rb/1e3:g}k: starts {s:.2f} N, 90% at {f90 if f90 else 0:.1f} N, max {mx:.0f}%")
print(f"FSR peak {vmax:.0f} V, {imax*1e3:.2f} mA (RS 12k)")
print(f"at rest: RD dissipates {p_off:.2f} W; leakage {np.sqrt(np.mean(i_off**2))*1e3:.1f} mA RMS")
print(f"at 150 N: fires at {np.degrees(al_full):.0f} deg, RD {p_full:.3f} W")
