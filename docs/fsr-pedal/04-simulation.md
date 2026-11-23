# The circuit simulated

## The model

Everything in this chapter is simulated from assumed values. Nothing in
it has been measured, and none of it is evidence of how a built pedal would
behave or whether it would be safe.

The figures in this section come from `tools/make_fsr_pedal_figures.py`,
the same kind of half-cycle model the switching paper uses for the
KB3151C (its §4 and §6). Its assumptions:

- **The line** is 120 V, 60 Hz (170 V peak). Until the triac fires, the
  pedal sees the whole line; after, about 1 V. The load is resistive, so
  the triac turns off at each voltage zero. A motor's inductance carries
  the current a little past the zero, which this ignores.
- **The clamp** is ideal at ±56.7 V.
- **The diac** fires at 32 V and drops C to 22 V, as in the switching
  paper. Its 28–36 V spread is explored separately.
- **The FSR** follows a power law, $R = 100\ \text{k}\Omega \times
  (F/F_a)^{-n}$. For the UX series, $F_a = 0.5$ N and $n = 0.8$, which
  gives about 1 kΩ at 150 N. That curve is an **assumption**, fitted to
  Interlink's stated range and its "about 1 kΩ at full load"; Interlink
  publishes the shape of the curve, not a formula. The sensors on order
  will replace it with measurements (§6).
- **Hysteresis.** C's state carries from half-cycle to half-cycle, so the
  model shows the start and stop forces as the force rises and falls. The
  FSR's own hysteresis, about 10%, is not modeled; it adds to what the
  figures show.
- **"Motor voltage"** is the RMS voltage a resistive load would see, as a
  percentage of the line: a stand-in for speed, which also depends on
  load.

## One operating point

![At 4 N on the sensor, the FSR is about 19 kΩ. Node N (green) rises with
the line, flattens at 57 V, and collapses when the triac fires. C (blue)
charges from it to the diac's 32 V at about 84°, then drops to 22 V and
drains through RS, the FSR and RB for the rest of the half-cycle. The motor
gets the shaded part of each half-cycle.](../images/fsr-pedal/fsr-pedal-waveforms.svg){width=100%}

The figure shows what the clamp buys. In the simulation, node N stays
below 57 V, and so does everything downstream of it; a real clamp's
tolerance, aging and failure modes are not modeled. The highest voltage the FSR sees
is when it is barely pressed and C swings from one polarity to the other:
about 66 V (§4.5).

## Force against speed

![Motor voltage against force on the sensor, for three values of RS. The
top axis shows the foot force if the pedal passes a fifth of it to the
sensor (§5). Dashed lines show the curve when easing off, where it
differs.](../images/fsr-pedal/fsr-pedal-curve.svg){width=100%}

With the nominal values (RS = 12 kΩ, RB = 330 kΩ, DB3 at 32 V):

| | Force on the sensor | On a 5:1 pedal |
|---|---|---|
| Motor starts | 1.6 N, jumping to about 23% | 8 N |
| Motor stops when easing off | 1.5 N | 7 N |
| 90% of line voltage | 13.6 N | 68 N |
| Top | 94% at 150 N | |

Three things to see in the figure:

- **The curve is roughly logarithmic in force.** Each doubling of force
  adds a similar step of speed through the middle of the range, the
  carbon pile's virtue the speed-control paper (its §4) wanted to keep.
  It falls out of the FSR's power law and the RC timing together, with no
  shaping circuit.
- **RS spreads or compresses the top.** With RS at 6.8 kΩ the curve
  reaches 90% by 7 N; at 18 kΩ, not until 127 N, and the top is lower
  (90%). RS is the "how hard do I have to push for full speed" setting.
- **The start is abrupt, and slightly hysteretic.** The motor starts at
  about a quarter of line voltage rather than from zero, and once
  started keeps going down to a slightly lower force. This is the same
  snap-on the switching paper (§4) explains for any single-RC pedal: C's
  leftover charge from the last firing helps the next one. It is milder
  here than the KB3151C's, about 8% in force against the KB3151C's 15% in
  resistance, but it is there. A second RC stage, the usual cure in
  better dimmers, would soften it at the cost of a few more parts and
  another round of simulation.

## The diac's tolerance

![The same curve with the DB3 at the ends of its tolerance, gray dashed
and dotted, and with RB trimmed to compensate, in color.](../images/fsr-pedal/fsr-pedal-trim.svg){width=100%}

A DB3 may break over anywhere from 28 to 36 V. Because C charges toward a
fixed 57 V, a higher breakover takes disproportionately longer to reach,
and the curve moves a long way:

| DB3 | RB | Starts at | 90% at |
|---|---|---|---|
| 28 V | 330 kΩ | 1.2 N | 7.7 N |
| 32 V | 330 kΩ | 1.6 N | 13.6 N |
| 36 V | 330 kΩ | 2.2 N | 37 N |
| 28 V | 100 kΩ | 1.5 N | 8.3 N |
| 36 V | 1.1 MΩ | 2.0 N | 31 N |

The RB trimmer brings the starting force back into line, but it can't
correct the top of the curve, which depends on RS and the breakover
together. Two practical answers: measure a few DB3s (a variable supply
through a 100 kΩ resistor shows the snap) and keep the ones near 32 V; or
make RS a trimmer as well, so each pedal is set at both ends. A higher
clamp voltage would make the circuit less sensitive to the diac, but it
raises the voltage on the FSR, the one number this design most needs to
keep down.

## The stress on the sensor

![Peak voltage across, and peak current through, the FSR as the force
rises (RS = 12 kΩ), against Interlink's guidance: the typical drive, and
1 mA per square centimeter of loaded area for a fully loaded 402 and for a
406 under a 20 mm puck.](../images/fsr-pedal/fsr-pedal-stress.svg){width=100%}

- **Current.** The FSR's current peaks at 2.5 mA at full force. That is
  twice what a 402 may carry fully loaded (1.27 cm²), but within the
  guidance for a 406 pressed through a 20 mm puck (3.1 cm²) or anything
  larger. This is the main reason the design calls for the 406.
- **Voltage.** The voltage is highest, about 62–66 V, when the sensor is
  barely loaded and its resistance is high, and falls to a few volts at
  full force. The current at those voltages is under a milliamp, so the
  power in the sensor is small: tens of milliwatts at most.
- **Polarity.** The voltage alternates every half-cycle. That matters,
  because the failure most feared for silver conductors under voltage,
  silver migration, is driven by a steady DC voltage across the gap in
  the presence of moisture. Alternating voltage greatly reduces it, and
  the pedal is dry.

Even so, 66 V is well above the 5 V Interlink calls typical, and Interlink
does not publish a maximum. That is the open question in this design, and
§6 proposes how to answer it.
