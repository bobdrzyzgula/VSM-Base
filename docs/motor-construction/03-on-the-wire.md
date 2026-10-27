# The universal motor on the wire

This section shows what a scope would see at the motor's terminals, and in
its current, under each kind of control. The plots are computed with the
model of §2, using the representative values listed with the figures:
$R$ = 30 Ω, $L$ = 0.15 H, $K$ = 0.104 H, and a load that rises with speed.
They come from `tools/make_motor_waveforms.py`. On the test rig, the same
traces are taken with the scope behind an isolation transformer, voltage
across the motor's terminals and current across a small shunt (rig guide,
§7).

## Straight on the line

![Simulated: the motor connected straight to 120 V, 60 Hz. The current
(blue) is nearly a sine wave and lags the voltage (orange) by about 1.3 ms,
or 28°. Below, the torque $K i^2$: always positive, pulsing at 120 Hz
between zero and twice its mean.](../images/motors/universal-on-line.svg){width=100%}

Three things show here:

- **The current lags the voltage.** At full speed the back-EMF behaves like
  extra resistance, $K\omega$, in series with $R$. That gives an effective
  resistance of about 106 Ω against the inductance's 57 Ω of reactance, so
  the current lags by $\arctan(57/106) \approx 28°$. The power factor is
  about 0.88. The supply's volt-amperes exceed its watts by that much, and a
  plug-in power meter shows both.
- **The torque pulses.** The armature is pushed in 120 Hz bursts, hardest at
  the current's peaks, with nothing at each zero. At full speed the
  armature's inertia and the machine's flywheel average this out, and all
  that remains is a hum at 120 Hz.
- **The current is almost a sine.** The line is a sine, and the motor at
  steady speed is close to a fixed impedance, so the current is too. Its
  small distortion comes from the iron's saturation, which the model leaves
  out.

## Behind a rheostat or carbon pile

![Simulated: a 65 Ω rheostat in series, chosen to bring the motor down to
the same speed as the 90° triac below (about 3,950 rpm). The motor sees a
smaller sine, and the pedal turns about 42 W into heat.](../images/motors/universal-rheostat.svg){width=100%}

A series resistance leaves every waveform a sine; it only makes them
smaller. The motor sees a reduced sinusoidal voltage, and the current lags
it a little less, because the circuit is now more resistive. What the scope
does not show is the cost. At this setting the pedal dissipates about 42 W
as heat in the foot control, more than the 28 W or so that the motor
delivers. That is the heat the speed-control paper describes in §3. It also
explains the carbon pile in that paper's §11, which grew hot when held just
short of starting. With the motor stalled there is no back-EMF, so most of
the power goes into the pile.

## Chopped by a triac

![Simulated: a triac fired 45°, 90° and 120° into each half-cycle. The gray
trace is the line, the orange trace the voltage at the motor, and the blue
trace the motor current. In the middle panel, the dashed line shows what a
plain resistor's current would look like: a slice of sine that stops dead
at the voltage zero.](../images/motors/universal-triac.svg){width=100%}

A triac switches the full line on part-way through each half-cycle, at the
firing angle $\alpha$, and leaves it on until the current falls to zero. The
plots show what the inductance does with that.

- **The voltage is a sliced sine.** Before firing, the motor sees almost
  nothing. The line is held off by the triac, and the motor's own terminals
  show only a few volts of residual-field back-EMF. At $\alpha$ the motor
  snaps to the line voltage and follows it.
- **The current is a smooth hump, not a slice.** A resistor would draw a
  current shaped exactly like the voltage: a vertical step at $\alpha$, then
  a sine segment ending at the zero (the dashed trace). The motor's
  inductance forbids the step. The current must start from zero and rise at
  a rate set by $L$, so it builds gradually after firing.
- **The current outlasts the voltage.** Once the line passes its peak and
  starts falling, the inductance keeps the current flowing. That stored
  energy drives the current on *past the voltage zero*, into the start of
  the next half-cycle. For a short time the motor's voltage is negative
  while its current is still positive, and the motor returns some of its
  stored magnetic energy to the line. Only when the current reaches zero
  does the triac turn off. This is the "conduction stretched past the
  voltage zero" that the speed-control paper mentions in §5.
- **Speed changes how much the current is smoothed.** At high speed the
  back-EMF adds about 76 Ω of effective resistance. The current's time
  constant is then $L/(R + K\omega) \approx 1.4$ ms, short against the
  8.3 ms half-cycle, and the current follows the chopped voltage fairly
  closely (top panel). At a crawl the back-EMF has almost gone, and the time
  constant approaches $L/R = 5$ ms. Each pulse then becomes a slow,
  rounded hump that rises late and decays late (bottom panel).
- **At low speed the torque comes in pulses.** At 120° the motor gets a
  short hump of current twice per cycle and nothing between. Each hump
  gives a squared kick of torque. With the inertia of a sewing machine,
  this representative motor still turns at about 970 rpm. Five degrees
  later it is down to about 450 rpm, and by 135° this load stalls it
  outright. The narrow band between running and stalling is the
  "cogging" region of the speed-control paper, §5. It is also why an
  open-loop triac pedal is twitchy at the bottom of its travel.

Two practical consequences for the MCU controller:

- **The triac must be fired with a pulse long enough to latch.** At large
  firing angles the current rises slowly from zero. If the gate pulse ends
  before the current exceeds the triac's latching current, the triac drops
  out and the half-cycle is lost. AN1662 uses a gate pulse of about 100 µs
  for this reason, and so does the concept circuit.
- **Back-EMF between pulses is tiny.** While the triac is off there is no
  current, so there is no field and almost no back-EMF. A universal motor
  cannot simply be listened to for its speed, as a permanent-magnet motor
  can (§5). This is why the concept controller uses a hand-wheel sensor.

**What else the scope shows.** The model leaves out two effects that a real
trace has:

- **Commutation spikes.** Each time a brush leaves a commutator bar, the coil
  it was shorting is opened with current in it. This makes small sharp
  spikes on the voltage, and the radio noise that the split field coils and
  the controller's snubber help contain.
- **A slower start.** A real triac fires only once its gate current is
  enough. Near $\alpha$ = 180° it may not fire at all, and the motor simply
  stops.
