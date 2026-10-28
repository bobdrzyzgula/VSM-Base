#!/usr/bin/env python3
"""Simulated waveforms and curves for the companion paper on motor
construction ("Inside the Motor"). Written by Claude at Robert Drzyzgula's
direction.

Usage: tools/make_motor_waveforms.py   (run from the repository root)
Writes SVGs to docs/images/motors/.

Everything here is SIMULATED from simple lumped models with representative
values, not measured; the paper says so, and the motor test rig is meant to
replace these with real scope captures.

Universal (series) motor, after the speed-control paper's model, made
instantaneous:
    L di/dt = v - R i - K w i          (back-EMF e = K w i: flux follows i)
    J dw/dt = K i^2 - (T0 + b w)
Representative 99-class values: R = 30 ohm (field + armature + brushes),
L = 0.15 H, K = 0.1037 H, chosen so that on 120 V, 60 Hz it runs near
7000 rpm drawing about 1 A. J = 1e-4 kg m^2 (armature plus the machine
reflected through the belt). While a triac is off the motor carries no
current and shows only a small residual-field voltage.

Brushed permanent-magnet DC motor (a 775-size 24 V motor): R = 0.98 ohm,
L = 0.2 mH, Ke = 0.0271 V s/rad, on a low-side MOSFET with a freewheeling
diode, PWM at 2 kHz and 20 kHz.
"""
import os

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

OUT = "docs/images/motors"
os.makedirs(OUT, exist_ok=True)

ACCENT = "#1f5fa8"      # current
WARM = "#b5532a"        # voltage at the motor
GRAY1, GRAY2 = "#7d8288", "#b4b8bd"
INK, MUTED, GRID = "#1f2328", "#5d6670", "#e3e5e8"
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 9.5,
                     "svg.fonttype": "none", "axes.titlesize": 10,
                     "axes.titleweight": "bold", "axes.titlecolor": INK,
                     "axes.titlelocation": "left"})


def style(ax, ygrid=True):
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    for s in ("left", "bottom"):
        ax.spines[s].set_color(MUTED)
    ax.tick_params(colors=MUTED, length=3)
    if ygrid:
        ax.grid(axis="y", color=GRID, linewidth=0.8)
    ax.set_axisbelow(True)


def save(fig, name):
    fig.savefig(os.path.join(OUT, name), format="svg", bbox_inches="tight")
    plt.close(fig)
    print("wrote", os.path.join(OUT, name))


# ------------------------------------------------------------ universal motor
F = 60.0
VPK = 120 * np.sqrt(2)
R, L, K = 30.0, 0.15, 0.1037
J, T0, B = 1e-4, 0.02, 1.14e-4
E_RES = 3.0 / 733          # residual-field volts per rad/s while no current flows
DT = 5e-6


def sim_universal(mode="line", alpha_deg=90.0, rs=0.0, t_end=2.5, keep=3 / F):
    """mode: 'line' (straight on the line), 'rheostat' (rs in series),
    'triac' (fired alpha degrees into each half-cycle)."""
    n = int(t_end / DT)
    t = np.arange(n) * DT
    v = VPK * np.sin(2 * np.pi * F * t)
    i = 0.0
    w = 300.0
    on = mode != "triac"
    alpha = np.radians(alpha_deg)
    k0 = int((t_end - keep) / DT)
    I = np.zeros(n - k0); VM = np.zeros(n - k0); WW = np.zeros(n - k0)
    last_fire_half = -1
    for k in range(n):
        th = (2 * np.pi * F * t[k]) % (2 * np.pi)
        half = int(2 * F * t[k])
        if mode == "triac" and not on:
            # fire once per half-cycle, alpha after its zero crossing
            if half != last_fire_half and (th % np.pi) >= alpha:
                on = True
                last_fire_half = half
        if on:
            vm = v[k] - rs * i
            di = (vm - R * i - K * w * i) / L
            i_new = i + di * DT
            if mode == "triac" and i != 0 and np.sign(i_new) != np.sign(i):
                i_new, on = 0.0, False        # the triac drops out at current zero
            elif mode == "triac" and i == 0 and np.sign(di) != np.sign(v[k]):
                i_new = 0.0
            vmotor = v[k] - rs * i
            i = i_new
        else:
            i = 0.0
            vmotor = E_RES * w * np.sign(np.sin(th))   # only the small residual-field voltage
        w += (K * i * i - (T0 + B * w)) / J * DT
        w = max(w, 0.0)
        if k >= k0:
            I[k - k0], VM[k - k0], WW[k - k0] = i, vmotor, w
    tt = t[k0:] - t[k0]
    return tt, v[k0:], VM, I, WW


def rpm(w):
    return w * 60 / (2 * np.pi)


def wave_panel(ax, tt, vline, vm, i, title, show_line=True, ilim=4.5):
    ms = tt * 1000
    if show_line:
        ax.plot(ms, vline, color=GRAY2, linewidth=1.0, label="line voltage")
    ax.plot(ms, vm, color=WARM, linewidth=1.4, label="voltage at the motor")
    ax.set_ylim(-190, 190)
    ax.set_ylabel("volts", color=MUTED)
    ax2 = ax.twinx()
    ax2.plot(ms, i, color=ACCENT, linewidth=1.8, label="motor current")
    ax2.set_ylim(-ilim, ilim)
    ax2.set_ylabel("amps", color=ACCENT)
    ax2.tick_params(colors=ACCENT, length=3)
    for s in ("top", "left", "bottom"):
        ax2.spines[s].set_visible(False)
    ax2.spines["right"].set_color(ACCENT)
    style(ax)
    ax.set_title(title)
    ax.axhline(0, color=MUTED, linewidth=0.6)
    return ax2


# 1. straight on the line: current lags, torque pulses at 120 Hz
tt, vl, vm, i, w = sim_universal("line")
fig, (a, b) = plt.subplots(2, 1, figsize=(7.2, 4.6), sharex=True,
                           gridspec_kw={"height_ratios": [3, 2]})
ax2 = wave_panel(a, tt, vl, vm, i, f"Straight on the line: {rpm(w[-1]):.0f} rpm, "
                 f"{np.sqrt(np.mean(i**2)):.2f} A rms", show_line=False, ilim=2.2)
lag = None
zc_v = np.where((vl[:-1] < 0) & (vl[1:] >= 0))[0][0]
zc_i = zc_v + np.where((i[zc_v:-1] < 0) & (i[zc_v + 1:] >= 0))[0][0] if np.any((i[zc_v:-1] < 0) & (i[zc_v + 1:] >= 0)) else None
if zc_i is not None:
    lag = (tt[zc_i] - tt[zc_v]) * 1000
    a.set_title(a.get_title(loc="left") + f"; current lags {lag:.1f} ms ({lag * 360 * F / 1000:.0f}°)")
torque = K * i * i
b.plot(tt * 1000, torque, color=INK, linewidth=1.4)
b.axhline(np.mean(torque), color=MUTED, linewidth=0.8, linestyle=(0, (3, 3)))

b.set_ylabel("torque, N·m", color=MUTED)
b.set_xlabel("milliseconds", color=MUTED)
b.set_title(f"Torque, K·i²: always positive, pulsing at 120 Hz; mean {np.mean(torque):.3f} N·m (dashed)")
style(b)
save(fig, "universal-on-line.svg")
print(f"  line: {rpm(w[-1]):.0f} rpm, {np.sqrt(np.mean(i**2)):.3f} A rms, lag {lag} ms, mean T {np.mean(torque):.4f}")

# 2. triac at three firing angles, with a resistive load's current for comparison
fig, axes = plt.subplots(3, 1, figsize=(7.2, 7.6), sharex=True)
results = {}
for ax, al in zip(axes, (45, 90, 120)):
    tt, vl, vm, i, w = sim_universal("triac", al)
    results[al] = (np.sqrt(np.mean(i ** 2)), rpm(w[-1]))
    a2 = wave_panel(ax, tt, vl, vm, i,
                    f"Triac fired at {al}°: {rpm(w[-1]):.0f} rpm, "
                    f"{np.sqrt(np.mean(i**2)):.2f} A rms", ilim=4.5)
    if al == 90:
        # what a plain resistor would draw: a sliver of sine that stops at the zero
        th = (2 * np.pi * F * tt) % np.pi
        ir = np.where(th >= np.radians(al), vl / 120.0, 0.0)
        a2.plot(tt * 1000, ir * 1.0, color=ACCENT, linewidth=1.0, linestyle=(0, (3, 2)),
                alpha=0.8, label="a resistor's current (scaled)")
        a2.legend(loc="lower right", frameon=False, fontsize=8)
axes[0].legend(loc="lower left", frameon=False, fontsize=8, ncol=2)
axes[-1].set_xlabel("milliseconds", color=MUTED)
save(fig, "universal-triac.svg")
for al, (irms, r) in results.items():
    print(f"  triac {al}: {r:.0f} rpm, {irms:.3f} A rms")

# 3. rheostat: same speed as the 90-degree triac, by series resistance
target = results[90][1]
lo, hi = 0.0, 400.0
for _ in range(14):
    mid = (lo + hi) / 2
    _, _, _, _, w = sim_universal("rheostat", rs=mid, t_end=2.0, keep=1 / F)
    if rpm(w[-1]) > target:
        lo = mid
    else:
        hi = mid
rs = (lo + hi) / 2
tt, vl, vm, i, w = sim_universal("rheostat", rs=rs)
fig, ax = plt.subplots(figsize=(7.2, 2.9))
wave_panel(ax, tt, vl, vm, i, f"Rheostat of {rs:.0f} Ω: {rpm(w[-1]):.0f} rpm, "
           f"{np.sqrt(np.mean(i**2)):.2f} A rms, {np.mean(rs * i * i):.0f} W in the pedal", ilim=2.2)
ax.legend(loc="lower left", frameon=False, fontsize=8, ncol=2)
ax.set_xlabel("milliseconds", color=MUTED)
save(fig, "universal-rheostat.svg")
print(f"  rheostat {rs:.1f} ohm: {rpm(w[-1]):.0f} rpm, {np.sqrt(np.mean(i**2)):.3f} A rms, pedal {np.mean(rs*i*i):.1f} W")

# 4. the triac feeding the motor through a bridge rectifier, with a freewheeling
# diode across the motor (the motor-control paper's rectified-DC variant).
# While the triac conducts the motor sees |v|; at the line's zero the motor's
# current moves onto the freewheeling diode (drop VF) and the triac drops out;
# the current then decays until the next firing, or reaches zero and stays there.
VF = 0.9


def sim_bridge(alpha_deg=90.0, t_end=2.5, keep=3 / F):
    n = int(t_end / DT)
    t = np.arange(n) * DT
    v = VPK * np.sin(2 * np.pi * F * t)
    i, w = 0.0, 300.0
    alpha = np.radians(alpha_deg)
    k0 = int((t_end - keep) / DT)
    I = np.zeros(n - k0); VM = np.zeros(n - k0); WW = np.zeros(n - k0)
    for k in range(n):
        th = (2 * np.pi * F * t[k]) % np.pi          # angle into this half-cycle
        if th >= alpha:                              # triac on: the rectified line
            vmotor = abs(v[k])
        elif i > 0:                                  # freewheeling through the diode
            vmotor = -VF
        else:                                        # no current: residual field only
            vmotor = E_RES * w
        if th >= alpha or i > 0:
            i = max(i + (vmotor - R * i - K * w * i) / L * DT, 0.0)
        w += (K * i * i - (T0 + B * w)) / J * DT
        w = max(w, 0.0)
        if k >= k0:
            I[k - k0], VM[k - k0], WW[k - k0] = i, vmotor, w
    return t[k0:] - t[k0], v[k0:], VM, I, WW


fig, axes = plt.subplots(2, 1, figsize=(7.2, 5.4), sharex=True)
tt, vl, vm, i, w = sim_universal("triac", 120)
wave_panel(axes[0], tt, vl, vm, i, f"Triac at 120°, motor on AC: {rpm(w[-1]):.0f} rpm, "
           f"{np.sqrt(np.mean(i**2)):.2f} A rms", ilim=2.2)
tt, vl, vm, i, w = sim_bridge(120)
wave_panel(axes[1], tt, vl, vm, i, f"Triac at 120°, through a bridge and freewheeling diode: "
           f"{rpm(w[-1]):.0f} rpm, {np.sqrt(np.mean(i**2)):.2f} A rms", ilim=2.2)
axes[0].legend(loc="lower left", frameon=False, fontsize=8, ncol=2)
axes[-1].set_xlabel("milliseconds", color=MUTED)
save(fig, "universal-bridge.svg")
for al in (45, 90, 120, 135, 150):
    tt, vl, vm, i, w = sim_bridge(al)
    gap = np.mean(i < 1e-6)
    print(f"  bridge {al}: {rpm(w[-1]):.0f} rpm, {np.sqrt(np.mean(i**2)):.3f} A rms, min i {i.min():.3f} A, zero {100*gap:.0f}% of the time")

# ------------------------------------------------------------ PM DC on PWM
VDC, RA, LA, KE = 24.0, 0.98, 0.2e-3, 0.0271
VD = 0.7            # freewheeling diode drop


def sim_pwm(f_pwm, duty=0.5, w=370.0, periods=6):
    dt = 1.0 / f_pwm / 400
    t_end = 40e-3
    n = int(t_end / dt)
    i = 0.0
    keep = int(periods / f_pwm / dt)
    T_, V_, I_ = [], [], []
    for k in range(n):
        t = k * dt
        on = (t * f_pwm) % 1.0 < duty
        e = KE * w
        if on:
            vm = VDC
        elif i > 0:
            vm = -VD                      # current freewheels through the diode
        else:
            vm = e                        # no current: the terminals show the back-EMF
        di = (vm - RA * i - e) / LA if (on or i > 0) else 0.0
        i = max(i + di * dt, 0.0)
        if k >= n - keep:
            T_.append(t); V_.append(vm); I_.append(i)
    T_ = np.array(T_)
    return (T_ - T_[0]) * 1e3, np.array(V_), np.array(I_)


fig, axes = plt.subplots(1, 2, figsize=(7.2, 3.0), sharey=True)
for ax, f in zip(axes, (2000, 20000)):
    ms, vv, ii = sim_pwm(f)
    ax.plot(ms, vv, color=WARM, linewidth=1.2)
    ax.set_ylim(-3, 27)
    a2 = ax.twinx()
    a2.plot(ms, ii, color=ACCENT, linewidth=1.8)
    a2.set_ylim(0, 11)
    a2.tick_params(colors=ACCENT, length=3)
    for s in ("top", "left", "bottom"):
        a2.spines[s].set_visible(False)
    a2.spines["right"].set_color(ACCENT)
    if f == 20000:
        a2.set_ylabel("amps", color=ACCENT)
    else:
        a2.set_yticklabels([])
    style(ax)
    ax.set_title(f"PWM at {f // 1000} kHz, 50%: ripple {ii.max() - ii.min():.2f} A")
    ax.set_xlabel("milliseconds", color=MUTED)
    print(f"  pwm {f}: mean {ii.mean():.2f} A, ripple {ii.max()-ii.min():.3f} A")
axes[0].set_ylabel("volts at the motor", color=MUTED)
save(fig, "pmdc-pwm.svg")

# ------------------------------------------------------------ BLDC six-step (idealized)
th = np.linspace(0, 720, 1441)


def trap(theta):
    """Trapezoidal back-EMF, flat-topped for 120 electrical degrees."""
    x = theta % 360
    return np.interp(x, [0, 30, 150, 210, 330, 360], [0, 1, 1, -1, -1, 0])


fig, axes = plt.subplots(5, 1, figsize=(7.2, 7.0), sharex=True,
                         gridspec_kw={"height_ratios": [1, 1, 1, 1.1, 0.7], "hspace": 0.55})
names = ["A", "B", "C"]
for k, ax in enumerate(axes[:3]):
    sh = k * 120
    e = trap(th - sh)
    cur = np.where(np.abs(e) >= 0.999, np.sign(e), 0.0)
    ax.plot(th, e, color=WARM, linewidth=1.3)
    ax.fill_between(th, 0, cur * 0.75, step="mid", color=ACCENT, alpha=0.35, linewidth=0)
    ax.set_ylim(-1.3, 1.3)
    ax.set_yticks([])
    ax.set_ylabel(f"phase {names[k]}", color=MUTED, rotation=0, ha="right", va="center")
    style(ax, ygrid=False)
    ax.axhline(0, color=GRID, linewidth=0.8)
axes[0].set_title("Six-step drive: back-EMF (line) and the current the driver applies (blocks)")
for k in range(3):
    h = ((th - 30 - k * 120) % 360 < 180).astype(float)   # edges fall on the commutation points
    axes[3].plot(th, h * 0.8 + (2 - k) * 1.0, color=INK, linewidth=1.2, drawstyle="steps-mid")
axes[3].set_yticks([2.4, 1.4, 0.4]); axes[3].set_yticklabels(["H1", "H2", "H3"], color=MUTED)
axes[3].set_ylim(-0.2, 3.0)
style(axes[3], ygrid=False)
axes[3].set_title("Hall sensors: six states per electrical turn tell the driver where the rotor is")
steps = ["A+ B−", "A+ C−", "B+ C−", "B+ A−", "C+ A−", "C+ B−"]
for s in range(12):
    x0 = 30 + s * 60
    if x0 >= 720:
        break
    axes[4].axvspan(x0, min(x0 + 60, 720), color=(GRID if s % 2 else "#f4f5f7"), linewidth=0)
    axes[4].text(x0 + 30, 0.5, steps[s % 6], ha="center", va="center", fontsize=8, color=INK)
axes[4].axvspan(0, 30, color="#f4f5f7", linewidth=0)
axes[4].set_yticks([]); axes[4].set_ylim(0, 1)
style(axes[4], ygrid=False)
axes[4].set_title("Which two phases carry current in each 60° step")
axes[4].set_xlabel("rotor position, electrical degrees", color=MUTED)
axes[4].set_xticks(range(0, 721, 60))
save(fig, "bldc-six-step.svg")

# ------------------------------------------------------------ speed-torque, by motor type
fig, axes = plt.subplots(1, 2, figsize=(7.2, 3.2), sharey=True)
T = np.linspace(0.02, 2.2, 400)
for v, c in ((1.0, INK), (0.7, GRAY1), (0.4, GRAY2)):
    # series: w = V/sqrt(K T) - R/K with K=1, R=0.15 ; normalized to w=1 at T=1, V=1
    ws = (v / np.sqrt(T) - 0.15) / (1 - 0.15)
    axes[0].plot(T, np.clip(ws, 0, None), color=c, linewidth=1.8, label=f"{int(v*100)}% voltage")
    # PM / shunt: w = (V - R T)/K with R = 0.1 ; normalized the same way
    wp = (v - 0.1 * T) / (1 - 0.1)
    axes[1].plot(T, np.clip(wp, 0, None), color=c, linewidth=1.8)
for ax, ttl in zip(axes, ("Series (universal) motor", "Permanent-magnet or shunt DC motor")):
    style(ax)
    ax.set_title(ttl)
    ax.set_xlabel("load torque (1 = full load)", color=MUTED)
    ax.axvline(1, color=MUTED, linewidth=0.8, linestyle=(0, (3, 3)))
axes[0].set_ylim(0, 2.6)
axes[0].set_ylabel("speed (1 = full speed)", color=MUTED)
axes[0].legend(frameon=False, fontsize=8)
save(fig, "speed-torque-types.svg")

# ------------------------------------------------------------ induction motor, on the line and on a VFD
# Kloss approximation, T/Tmax = 2 / (s/sm + sm/s), for a representative
# four-pole motor: breakdown torque 2.8 x full load at 20% slip, which puts
# full load at about 3.7% slip (about 1,734 rpm on 60 Hz). On a VFD with constant
# volts per hertz the curve keeps its shape in slip *speed* (ns - n), so it
# slides down with the synchronous speed.
SM, TMAX, POLES = 0.2, 2.8, 4
fig, ax = plt.subplots(figsize=(7.2, 3.8))
style(ax)
NS60 = 120 * 60 / POLES
for f, c, lw in ((60, INK, 1.9), (40, GRAY1, 1.6), (20, GRAY2, 1.6)):
    ns = 120 * f / POLES
    n = np.linspace(0, ns * 0.9995, 800)
    slip_speed = ns - n
    x = slip_speed / (SM * NS60)
    torque = 2 * TMAX / (x + 1 / x)
    ax.plot(torque, n, color=c, linewidth=lw, label=f"{f} Hz" + (" (the line)" if f == 60 else " (VFD)"))
    ax.text(0.04, ns + 25, f"{ns:.0f} rpm synchronous", fontsize=8, color=c if f != 60 else MUTED, va="bottom")
    ax.axhline(ns, color=GRID, linewidth=0.8, zorder=0)
ax.axvline(1, color=MUTED, linewidth=0.8, linestyle=(0, (3, 3)))
# the 60 Hz landmarks
x_fl = (5.6 - np.sqrt(5.6 ** 2 - 4)) / 2                     # full-load slip / SM
n_fl = NS60 * (1 - x_fl * SM)
ax.plot([1], [n_fl], "o", color=ACCENT, markersize=5, zorder=5)
ax.annotate(f"full load: {n_fl:.0f} rpm, {100 * x_fl * SM:.1f}% slip", xy=(1, n_fl), xytext=(1.25, 1500),
            fontsize=8.5, color=INK, arrowprops=dict(arrowstyle="-", color=MUTED, linewidth=0.8))
ax.plot([TMAX], [NS60 * (1 - SM)], "o", color=WARM, markersize=5, zorder=5)
ax.text(TMAX + 0.09, NS60 * (1 - SM), "breakdown torque", fontsize=8.5, color=INK, va="center")
t_start = 2 * TMAX / (1 / SM + SM)
ax.annotate(f"starting torque\non the line:\n{t_start:.1f} x full load", xy=(t_start, 0), xytext=(0.12, 90),
            fontsize=8.5, color=INK, arrowprops=dict(arrowstyle="-", color=MUTED, linewidth=0.8))
ax.set_xlim(0, 3.7)
ax.set_ylim(0, 1950)
ax.set_xlabel("torque (1 = full load)", color=MUTED)
ax.set_ylabel("speed, rpm", color=MUTED)
ax.set_title("Four-pole induction motor")
ax.legend(frameon=False, fontsize=8, loc="upper right")
save(fig, "induction-speed-torque.svg")
