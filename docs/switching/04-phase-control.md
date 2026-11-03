# Phase control: a pedal circuit, part by part

## The minimal circuit

![A minimal triac phase control. The triac is in series with the motor, and
everything to its right is connected across it, from MT2 to MT1. The values
are typical ones, not taken from any one board. The snubber, in the dashed
box, is covered in §5.](../images/diagrams/triac-minimal.svg){width=95%}

The figure strips a phase-control pedal to its essentials, without the
extra parts of a real board such as the donor board in §6.

**The triac** sits in series with the motor, as §3 describes. While it is
off, it holds off the whole line and the motor gets nothing.

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

**The diac** fires the triac when C reaches about 32 V, in quadrant I on
the positive half-cycle and quadrant III on the negative (§3).

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
half-cycle applied to the motor. For a resistive load, the RMS output is:

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
plain RC's lagging sine.

## Snap-on hysteresis

That difference is why a simple pedal snaps on. The setting that starts
the motor is not the one that stops it:

- **Starting.** In the model, the motor starts when VR + R falls to about
  137 kΩ. The first firing comes late in the half-cycle, but it leaves C
  partly discharged, so the next one comes earlier. Within a few cycles the
  firing angle settles at about 125°, roughly 40% of the line's RMS
  voltage. The motor jumps from stopped to a brisk speed.
- **Running.** Once running, it keeps firing as the resistance rises, until
  about 158 kΩ, near 155° and roughly a tenth of the line.

So the pedal needs a push to start, the motor jumps to a speed above where
you wanted it, and then it will run slower than it would start. The jump
happens near 125° whatever the pot's value, because it comes from the
capacitor's memory. A different pot or trimmer only moves where in the
pedal's travel it happens (§6).

**Two-stage networks** reduce the jump. A second resistor and capacitor
feed the timing capacitor from a node that is itself an RC delay of the
line. After each firing, that second capacitor recharges the timing
capacitor from a defined voltage, so the timing capacitor starts each
half-cycle from nearly the same place whether or not the last one fired.
The memory, and with it most of the hysteresis, is erased. Lamp-dimmer and
tool-speed application notes have used this since the 1960s; better
pedals do it, and cheap ones don't.

## A little accidental feedback

Before the triac fires, the RC network charges from the voltage across the
triac. That is the line voltage minus the small back-EMF the turning
armature generates from residual field magnetism. A slowing motor makes
less back-EMF, so the capacitor charges slightly faster and fires earlier,
which speeds the motor back up. The effect is small in a simple pedal.
Exploiting it deliberately, with the network arranged to sense the
armature's voltage, is the basis of the regulated designs in the
speed-control paper (§7 there).

## The model behind the figures

The simulation is in `tools/make_triac_figures.py`. Within each
half-cycle it solves the RC network exactly (a capacitor charged through a
resistor from a sine), and it carries the capacitor's voltage from one
half-cycle to the next, so the start and stop thresholds come out of the
model rather than being put in. Its assumptions:

- a 120 V, 60 Hz line;
- before firing, the whole line across the triac; after it, about 1 V
  until the half-cycle ends;
- a resistive load, so the triac turns off at the voltage zero;
- a 32 V breakover, with the capacitor dropping to 22 V when the diac
  fires. A DB3 breaks over anywhere from 28 to 36 V and falls back by at
  least 5 V; the voltage left after firing is the least certain number.
