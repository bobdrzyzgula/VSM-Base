# The snubber

The snubber, Rs in series with Cs straight across the triac (the dashed box
in §4's figure), is there for the moment the triac turns off. §3 explained
the problem: a fast-rising voltage across a triac can turn it on, either
just after it has conducted (commutating dV/dt) or at any time (static
dV/dt).

## What can go wrong without one

**Commutation.** With a resistive load, the current reaches zero together
with the voltage, so the voltage across the triac grows gently from zero.
A motor is inductive: its current lags. By the time the current has fallen
to zero and the triac turns off, the line is already some way into the
next half-cycle, at tens of volts of the opposite polarity. That voltage
appears across the triac at once, limited only by stray capacitance: a
step of many volts per microsecond. The triac, still full of charge
carriers, turns straight back on and conducts the whole next half-cycle,
whatever the timing network wanted. Control is lost, and the motor runs on
at full speed or lurches.

**Static dV/dt.** Even a triac that has been off for some time can be
fired by a fast enough edge, through its own internal capacitance. A spike
on the line or the electrical noise from a motor's brushes can do it.

## What the snubber does

Cs has to charge through Rs and the motor, so the voltage across the triac
can rise no faster than that RC allows. The edge is slowed from a fraction
of a microsecond to tens of microseconds. Rs limits the current when the
triac fires and Cs dumps its charge into it, and it damps the ringing
between Cs and the motor's inductance. Typical values for a small motor
are 0.1 µF (X2-rated, for use across the line) and a few hundred ohms to
1 kΩ. The donor board's snubber is 1 kΩ and 0.1 µF.

A snubber has one cost: Cs passes current to the motor even with the triac
off. At 60 Hz, 0.1 µF is about 27 kΩ, which lets about 4 mA through. That
is enough to light a neon lamp but not to turn a motor. It does mean a
snubbed control is never fully off; only a switch is. The VSM Base's knee
controller has one.

## Snubberless triacs

Some triacs are built to switch inductive loads off without help. ST calls
these "Snubberless" (its BW and CW versions), and NXP and WeEn call theirs
"Hi-Com". They are the three-quadrant types of §3. ST's datasheet rates
the BTA08-600BW, chosen for the MCU design in the speed-control paper, to
turn off a current falling at 7 A/ms with no snubber, and to withstand
1,000 V/µs while off. A sewing motor's current falls far more slowly than
that. At 1 A RMS, its 1.4 A peak falls at no more than
$2\pi \times 60 \times 1.4 \approx 0.53$ A/ms. The price is a less
sensitive gate: the BW version needs up to 50 mA to fire and fires only in
quadrants I–III. The donor board's BT136-600E is an ordinary sensitive-gate
triac: it fires on 10 mA, its datasheet gives 50 V/µs static and no
commutating figure, and the board carries a snubber.

## Why fit one anyway

The MCU design uses a snubberless triac but leaves room for a snubber.
There are three reasons it might be needed:

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

So the plan is to build without a snubber, measure, and fit one if the
triac turns on by itself or fails to latch.
