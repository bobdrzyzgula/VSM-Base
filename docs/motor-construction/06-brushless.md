# Brushless DC motors

## Construction

Turn the PM motor inside out:

- **The magnets are on the rotor.** They turn with the shaft.
- **The windings are on the stator.** They stay fixed and are cooled
  directly through the frame.
- **The commutator goes away.** There are no brushes to wear, spark or
  shed dust. Its job, switching current between coils at the right moment,
  is done by a controller with transistors.

The stator is wound as three phases, usually connected in a star.

![Left: a brushless inrunner, schematically. Six stator teeth are wound as
three phases (A, B, C, each on two opposite teeth), with a four-pole magnet
rotor inside. Three Hall sensors report the rotor's position. Right: the
three-phase bridge that drives it, six switches, one pair per
phase.](../images/motors/bldc-construction.svg){width=100%}

Two arrangements are common:

- **The inrunner.** The rotor turns inside the stator, as drawn. It is the
  form of industrial motors, including the 42 mm and 57 mm motors of §9.
- **The outrunner.** The rotor is a cup of magnets turning *outside* a
  stationary wound core. This is the form of drone and model-aircraft
  motors: more torque for their size, but an exposed rotating can.

**Poles and Hall sensors.** Motors usually have 4–14 magnet poles. With $p$
pole pairs, the current pattern must go round its cycle $p$ times per
mechanical revolution. Three Hall-effect sensors, set 120 electrical degrees
apart, divide each electrical cycle into six states, so an 8-pole motor
(4 pole pairs) reports 24 distinct positions per turn. That point returns
in §9.

**The ratings.** Brushless motors are rated by:

- **Voltage and speed**, or by $K_V$, rpm per volt, which is just $1/K_e$ in
  other units.
- **Rated torque, rated current**, and a **peak torque**, often about three
  times the rated torque, available for short periods.

## Driving it

A brushless motor cannot run without its controller. Connect it to a supply
and it sits still. The controller's three-phase bridge does the
commutator's work, in one of two ways.

- **Six-step (trapezoidal) drive.** At any moment two of the three phases
  carry current, one in and one out, and the third floats. The Hall sensors
  say which 60° step the rotor is in, and the controller switches to the
  next pair as each step is reached. Speed is set by PWM on the active
  switches, as for a PM motor.

![Idealized six-step drive. Top three rows: each phase's back-EMF
(trapezoidal, flat for 120°) and the current block the driver applies while
that phase's back-EMF is flat. Fourth row: the three Hall signals, whose
edges fall at the commutation points. Bottom: which two phases carry
current in each 60° step.](../images/motors/bldc-six-step.svg){width=100%}

- **Field-oriented control (FOC).** The controller drives all three phases
  with sinusoidal currents, placed at exactly 90 electrical degrees to the
  rotor's field. That gives the most torque per ampere and almost no torque
  ripple. It needs the rotor's angle continuously, from an encoder or
  magnetic angle sensor, or estimated from the motor's own voltages, and
  more arithmetic each PWM period. A Cortex-M33 with a floating-point unit,
  like the RP2350's, does it comfortably.

**On the wire.** In six-step drive:

- **The phase voltages** are PWM-chopped blocks. Each phase is driven high
  for 120°, floats for 60°, driven low for 120°, then floats again. During
  the floating intervals the scope shows the back-EMF rising or falling
  through zero. Sensorless controllers watch for that zero crossing in
  place of Hall sensors.
- **The phase currents** are rounded trapezoids. Each rises and falls at
  every step at a rate set by the winding's inductance, and carries a PWM
  ripple like the PM motor's.

Under FOC the currents become clean sines with a little PWM ripple.

**What it gives a sewing machine.** It gives everything the PM motor does:

- torque from current at any speed;
- active braking;
- holding still.

On top of that it gives:

- no brushes to wear or spark;
- higher efficiency, so less heat;
- quiet running at 20 kHz PWM;
- in Hall sensors that come built in, a measure of the motor's position.

Brushless servo motors replaced the clutch motor (§7) on industrial sewing
machines for these reasons. They are typically a few hundred watts, mounted
under the table, with the controller in the same housing
([Leather Machine Co.](https://leathermachineco.com/product/brushless-digital-d-c-servo-motor/)).
