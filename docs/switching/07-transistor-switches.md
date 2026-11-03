# Switches a gate can turn off

A thyristor can only be switched on; the circuit has to switch it off. That
suits AC phase control, where the line does the switching off for free,
and little else. Everything that chops DC, which includes every brake, every
PWM motor drive and every inverter, needs a switch its control terminal can
turn off as well as on. Three families do that job: bipolar transistors,
power MOSFETs and IGBTs.

## Bipolar transistors

A bipolar transistor conducts while current flows into its base, and stops
when it doesn't. That's the turn-off a thyristor lacks, but it is
expensive: a power transistor's current gain is low, often 10 or 20, so
switching 10 A takes most of an amp of continuous base drive. Darlington
pairs raise the gain but add a volt or more of drop. Power bipolars ran the
first transistor motor drives and switching supplies of the 1970s and
1980s. They have since been almost entirely replaced by the next two
devices.

## Power MOSFETs

A MOSFET's gate is insulated from the channel by a thin oxide, so it draws
no steady current. It is voltage-driven: about 10 V on the gate (4–5 V for
a "logic-level" part) turns the channel fully on, and 0 V turns it off. The
gate is a capacitor, so switching it takes a burst of current to move the
gate charge, and a gate driver supplies that. Power MOSFETs reached the
market in the late 1970s.

Its character:

- **On, it is a resistor,** $R_{DS(on)}$. Conduction loss is $I^2 R$.
  Low-voltage parts have resistances of a few milliohms, so at 24 V and
  tens of amps a MOSFET is nearly lossless. But $R_{DS(on)}$ rises steeply
  with the voltage rating, roughly as its square in silicon, so at
  600 V a MOSFET of the same size is a much poorer conductor.
- **It switches fast,** in tens of nanoseconds. Switching losses stay small
  even at tens of kilohertz, which is why a MOSFET drive can run its PWM
  above hearing.
- **It has a built-in reverse diode,** the body diode, from the way it is
  made. In a bridge that diode is the freewheeling path for an inductive
  load's current when the MOSFET turns off.

MOSFETs rule at low voltage. A cordless drill's speed trigger is a MOSFET
switching the battery onto the motor at a few kilohertz, which is the
whine *Inside the Motor* measured (§5 there). So is the H-bridge on the
Pololu G2 board in the DC-motor variant of the MCU controller.

## IGBTs

The insulated-gate bipolar transistor, developed in the early 1980s
(notably by B. Jayant Baliga at General Electric), combines the two. A MOSFET
section at the gate drives a bipolar structure underneath, built on an
extra P layer. When it conducts, that layer floods the thick, lightly
doped region that blocks the high voltage with carriers, a process called
conductivity modulation, and the region's resistance collapses.

- **On, it behaves like a diode drop,** $V_{CE(sat)}$, about 1.5–2 V,
  nearly independent of the voltage rating. Conduction loss is
  $V_{CE(sat)} \times I$. At 600–1,700 V and tens of amps that beats a
  silicon MOSFET by a wide margin.
- **It is driven like a MOSFET,** by gate voltage, with no steady gate
  current.
- **It turns off with a tail.** The stored carriers have to recombine, so
  the current trails off over a microsecond or so after the gate goes low.
  That limits practical switching frequencies to a few kilohertz up to
  about 20–30 kHz, and it is the main switching loss.
- **It has no body diode.** Inverter modules pair each IGBT with a separate
  fast diode for the freewheeling path.

IGBTs rule at mains-derived voltages and kilowatts:

- **Variable-frequency drives** for induction motors (*Inside the Motor*,
  §7) are six IGBTs in a three-phase bridge, fed from rectified mains.
- **Industrial servo motors,** including the "brushless servo" motors that
  have replaced clutch motors on industrial sewing machines, run on the same
  kind of bridge.
- **Induction cooktops, welders, electric vehicles and trains** are all
  IGBT (or, increasingly, silicon carbide) machines.

## Newer and older relatives

- **Silicon carbide (SiC) and gallium nitride (GaN) transistors** are
  MOSFET-like switches in wide-bandgap materials. They block high voltage
  with a much thinner layer, so they combine MOSFET speed with low loss at
  high voltage. SiC is taking over electric-vehicle inverters, and GaN is
  what makes small USB-C chargers small.
- **Gate turn-off thyristors (GTOs) and IGCTs** are thyristors built so that
  a large negative gate current can turn them off. They held the
  very-high-power end, locomotives and grid converters, before IGBTs grew
  large enough, and still do at the largest sizes.

## Leading edge and trailing edge

A switch that can turn off allows a second way to chop the line.
**Leading-edge** (forward-phase) control, the only kind a triac can do,
starts conduction late in each half-cycle. **Trailing-edge** (reverse-phase)
control starts at the zero and cuts off part way through. It needs a
MOSFET or IGBT pair, one for each direction, or one inside a diode bridge.

![The same RMS voltage, 50% of the line's power on a resistive load,
two ways. Top: leading edge, as a triac does it, switching on at 90°.
Bottom: trailing edge, switching on at the zero and off at
90°.](../images/switching/leading-trailing.svg){width=90%}

Which suits a load depends on what it does at the edge:

- **Capacitive loads,** such as the electronic drivers in many LED lamps,
  draw a spike of current when a leading-edge control switches the line on
  abruptly. A trailing-edge control lets the voltage rise with the sine
  instead, so dimmers for those lamps use it.
- **Inductive loads,** such as a motor, are the opposite. Switching on
  abruptly is harmless, because the inductance limits how fast the current
  can rise. Cutting the current off abruptly is not: the inductance drives
  the voltage up until something conducts. A trailing-edge motor control
  therefore needs a path for that current, a freewheeling diode or a
  clamp, and on AC that is awkward. This is one reason AC motor speed
  controls have stayed with the triac.

On DC the freewheeling path is easy: a diode across the motor, or the body
diodes of an H-bridge. With it, a transistor switch can chop the supply at
any frequency and duty cycle, which is pulse-width modulation. The motor's
inductance smooths the current between pulses. *Inside the Motor* shows the
waveforms (§5 there).

## The families compared

| | SCR | Triac | Power MOSFET | IGBT |
|---|---|---|---|---|
| Turned off by | the circuit (current zero) | the circuit (current zero) | its gate | its gate |
| Conducts | one way | both ways | one way, plus body diode | one way |
| Gate drive | current pulse | current pulse, either sign | voltage, gate charge | voltage, gate charge |
| On-state loss | about 1–1.5 V drop | about 1–1.5 V drop | $I^2 R_{DS(on)}$ | about 1.5–2 V drop |
| Switching speed | line frequency | line frequency | tens of ns; up to hundreds of kHz | about 1 µs tail; up to tens of kHz |
| Typical home | controlled rectifiers, big AC switches | pedals, dimmers, appliance motors | battery tools, DC drives, power supplies | VFDs, servos, cooktops, EVs |
