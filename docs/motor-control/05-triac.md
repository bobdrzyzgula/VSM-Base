# Triac phase-angle control (open loop)

Modern electronic pedals, including the boards examined for this project, are
phase-angle controllers. They lower the average voltage by switching, not by
burning power in a resistance, so they run cool. Their speed regulation,
though, is roughly that of a variac, and their low-speed behavior is worse.

## The minimal circuit

![A minimal triac phase control. The triac is in series with the motor, and
everything to its right is connected across it, from MT2 to MT1. The values
are typical ones, not taken from any one board. The snubber, in the dashed
box, is covered below.](../images/diagrams/triac-minimal.svg){width=95%}

The figure strips the circuit to its essentials, without the extra parts of
the donor board in §11.

**The triac** is the switch. It sits in series with the motor. While it is
off, it holds off the whole line voltage and the motor gets nothing. A pulse
of current into its gate turns it on, for either direction of current. Once
the load current has passed the triac's latching current, it stays on
without further gate current. It turns off only when the current through it
falls below its holding current, at the end of the half-cycle. The gate
cannot turn it off; the line does that, twice each cycle. (The companion
paper, *Inside the Motor*, describes the device itself under "How a triac
switches".) So all a control circuit can choose is when in each half-cycle
to fire it. That moment is the firing angle $\alpha$, measured from the
voltage zero.

**The timing network** is VR, R and C, connected across the triac. While
the triac is off, the network sees the whole line voltage. The motor in
series drops almost nothing, since the network draws well under a
milliamp. C charges through VR + R, and its voltage lags the line and is
smaller than it. In steady state it is the line voltage divided by
$\sqrt{1 + (\omega RC)^2}$ and delayed by $\arctan(\omega RC)$:

$$v_C = \frac{V_{pk}}{\sqrt{1 + (\omega RC)^2}}\,\sin\!\left(\omega t - \arctan \omega RC\right)$$

Here $R$ is VR + R, and $\omega = 2\pi \times 60$. With 106 kΩ and 0.1 µF,
$\omega RC = 4.0$, so C swings to 41 V peak, lagging the line by 76°.
Turning VR up both shrinks this voltage and delays it, so it reaches the
diac's breakover later in the half-cycle. Past a certain point its peak no
longer reaches the breakover at all, and nothing fires. On 120 V, setting
$V_{pk}/\sqrt{1 + (\omega RC)^2} = 32$ V gives $\omega RC = 5.2$. That is
$RC = 13.8$ ms, about 137 kΩ with 0.1 µF. It is where a pedal's motor
starts.

**The diac** is a two-terminal trigger. It blocks in both directions until
about 32 V (28–36 V for a DB3). Then it breaks over, its voltage falls back
by at least 5 V, and it dumps part of C's charge into the triac's gate as a
short, sharp pulse. Because it is symmetrical, it fires the triac in both
half-cycles. In the positive half, C and the gate pulse are positive with
MT2 positive (quadrant I); in the negative half, everything reverses
(quadrant III). A resistor straight from C to the gate would not do the
same job. The gate fires at a fraction of a volt and a few milliamps, so
it would fire on a slowly rising, poorly defined current that varies with
temperature and from one triac to the next. The diac waits for a definite
voltage, then delivers a pulse well above what any gate needs. The firing
point is therefore set by the RC and the diac, not by the triac's gate
sensitivity.

**R**, in series with VR, keeps the total resistance from reaching zero.
It limits the current through the pot's wiper and track at the full-speed
end, and so sets the earliest firing. Even with VR at zero, C still has to
reach 32 V while the line rises, so the circuit fires a little after the
line passes 32 V: about 11° into the half-cycle, essentially full voltage.

## The firing angle and the circuit's memory

![The circuit of the figure above, simulated with VR + R = 106 kΩ, C =
0.1 µF and a resistive load. Top: the line, and the part of each half-cycle
that reaches the motor. Bottom: the timing capacitor, firing the diac when
it reaches ±32 V (dots).](../images/diagrams/triac-waveforms.svg){width=95%}

Each half-cycle, C charges until it reaches the diac's breakover. The diac
then fires the triac, and the triac conducts until the motor current falls
to zero. That happens a little after the voltage zero, because the motor is
inductive. Delaying the firing angle $\alpha$ reduces the share of each
half-cycle applied to the motor
([Skalka, Freescale AN1662](https://nxp.com/docs/en/application-note/AN1662.pdf)).
For a resistive load, the RMS output is:

$$V_{rms} = V_{pk}\sqrt{\frac{1}{2\pi}\left(\pi - \alpha + \tfrac{1}{2}\sin 2\alpha\right)}$$

The motor's inductance stretches the conduction past the voltage zero, so
the real curve differs, but the shape holds: a smooth fall from full
voltage at $\alpha = 0$ to nothing at $\alpha = \pi$.

The bottom panel of the figure shows that the circuit has a memory. When
the diac fires, it leaves C at about 22 V. With the triac on, the network
sees only the triac's volt or so across it, so C drains slowly through
VR + R. It still holds about 15 V of the same sign when the line reverses.
The next half-cycle has to pull it back through zero before charging it the
other way. A capacitor that has not been firing starts each half-cycle
further back: at about −30 V near the start threshold, the trough of the
plain RC's lagging sine. That difference causes the snap-on hysteresis
described under "What it means for sewing", below.

The simulation behind these figures is in `tools/make_triac_figures.py`.
It uses a 32 V breakover, a 22 V capacitor voltage just after firing, a
120 V line and a resistive load. The voltage left after firing is the least
certain of these. The motor test rig is meant to measure the real board.

## The snubber

The snubber, Rs in series with Cs straight across the triac, is there for
the moment the triac turns off. Two problems arise then, and both are about
how fast voltage reappears across the triac.

**Commutation.** With a resistive load, the current reaches zero together
with the voltage, so the voltage across the triac grows gently from zero.
A motor is inductive: its current lags. By the time the current has fallen
to zero and the triac turns off, the line is already some way into the next
half-cycle, at tens of volts of the opposite polarity. That voltage appears
across the triac at once, limited only by stray capacitance: a step of many
volts per microsecond. A triac that has just been conducting is still full
of charge carriers, and a fast-rising voltage of the new polarity can sweep
them into the gate region and turn it straight back on. It then conducts
for the whole next half-cycle, whatever the timing network wanted. Control
is lost, and the motor runs on at full speed or lurches. Datasheets rate
this as the commutating dV/dt, or as the fastest fall of current,
(dI/dt)c, that the triac can still turn off from.

**Static dV/dt.** Even a triac that has been off for some time can be fired
by a fast enough edge, through its own internal capacitance. A spike on the
line or the electrical noise from a motor's brushes can do it.

**What the snubber does.** Cs has to charge through Rs and the motor, so the
voltage across the triac can rise no faster than that RC allows. The edge
is slowed from a fraction of a microsecond to tens of microseconds. Rs
limits the current when the triac fires and Cs dumps its charge into it,
and it damps the ringing between Cs and the motor's inductance. Typical
values for a small motor are 0.1 µF (X2-rated, for use across the line) and
a few hundred ohms to 1 kΩ. The donor board's snubber is 1 kΩ and 0.1 µF.

A snubber has one cost: Cs passes current to the motor even with the triac
off. At 60 Hz, 0.1 µF is about 27 kΩ, which lets about 4 mA through. That
is enough to light a neon lamp but not to turn a motor. It does mean a
snubbed control is never fully off; only a switch is. The knee controller
has one.

**Snubberless triacs.** Some triacs are built to switch inductive loads off
without help. ST calls these "Snubberless" (its BW and CW versions), and
NXP and WeEn call theirs "Hi-Com". ST's datasheet rates the BTA08-600BW,
chosen for the MCU design in §11, to turn off a current falling at 7 A/ms
with no snubber, and to withstand 1,000 V/µs while off. A sewing motor's
current falls far more slowly than that. At 1 A RMS, its 1.4 A peak falls
at no more than $2\pi \times 60 \times 1.4 \approx 0.53$ A/ms. The price is
a less sensitive gate: the BW version needs up to 50 mA to fire and fires
only in quadrants I–III. The donor board's BT136-600E is an ordinary
sensitive-gate triac: it fires on 10 mA, its datasheet gives 50 V/µs
static and no commutating figure, and the board carries a snubber.

**Why fit one anyway.** The MCU design in §11 uses a snubberless triac but
leaves room for a snubber. There are three reasons it might be needed:

- **Noise.** A universal motor's brushes spark at every commutation, and
  the line carries spikes from other loads. The triac itself tolerates
  fast edges, but the opto-triac that fires it (a MOC3023) is wired from
  MT2 to the gate, so it sees the same edges. Its own datasheet adds a
  snubber to its application circuit for noisy environments.
- **Latching into an inductor.** When the triac fires into an inductive
  load, its current starts from zero and rises slowly. It must pass the
  latching current (up to 70 mA for the BTA08-600BW) before the gate drive
  ends, or the triac drops out again. The MCU fires with a short pulse. At
  a late firing angle there is little voltage left to drive current
  through the motor's inductance, so the current may not get there in
  time. A snubber helps, because Cs is charged to the voltage across the
  triac at the moment it fires. It discharges through Rs and the triac,
  giving a brief current of the order of an amp, enough to latch it. (The
  alternative is a longer gate pulse or a train of pulses, which firmware
  can supply.)
- **Interference.** Slower edges radiate and conduct less noise.

So the plan in §11 is to build without a snubber, measure, and fit one if
the triac turns on by itself or fails to latch.

## What it means for sewing

- **Regulation like a voltage source.** Because the motor sees a chopped
  version of the full line, not a resistance, the speed–torque slope scales
  with the effective voltage, as for a variac. That is better than a rheostat
  or carbon pile at a given speed. But nothing corrects for load: the pedal
  sets $\alpha$, and the load sets speed.
- **Torque arrives in pulses.** At a large $\alpha$ the motor gets a short, high
  current pulse every 8.3 ms (on 60 Hz) and nothing between. At full speed,
  inertia smooths this out. At a crawl the armature can nearly stop between
  pulses, giving the jerky "cogging" low-speed running that simple phase
  controls are known for
  ([Silicon Chip, Oct 2002](https://www.siliconchip.com.au/Issue/2002/October/Speed+Controller+For+Universal+Motors)).
- **Snap-on hysteresis.** This comes from the memory described above. A
  capacitor that has not been firing starts each half-cycle further back
  than one that has. So the setting that starts the motor is not the one
  that stops it. In the model, the motor starts when VR + R falls to about
  137 kΩ. The first firing comes late in the half-cycle, but it leaves C
  partly discharged, so the next one comes earlier. Within a few cycles the
  firing angle settles at about 125°, roughly 40% of the line's RMS
  voltage. Once running, it keeps firing until about 158 kΩ, near 155° and
  roughly a tenth of the line. The pedal therefore needs a push to start,
  then the motor jumps to a speed above where you wanted it, and it will
  then run slower than it would start. Two-stage RC networks (an extra R
  and C feeding the timing capacitor) reduce this. §11 works it through for
  the donor board.
- **A little accidental feedback.** Before the triac fires, the RC network
  charges from the voltage across the triac. That is the line voltage minus the
  small back-EMF the turning armature generates from residual field magnetism.
  A slowing motor makes less back-EMF, so the capacitor charges slightly faster
  and fires earlier. The effect is small in a simple pedal. Deliberately
  exploiting it is the basis of the regulated designs below.
