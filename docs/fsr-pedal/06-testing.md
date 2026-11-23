# Testing, and the open questions

## What testing would involve

> **Mains testing.** Do not perform the mains experiments described here
> unless you are qualified to work on mains circuits, are using an
> appropriately controlled test facility and protective equipment (including
> residual-current protection: a GFCI in the US), and have had the setup
> reviewed by an appropriate person. An isolation transformer does not make
> such work safe.

If the design were taken further, testing would go in this order, each
step answering one question. The sensor measurements involve no mains;
the mains steps are described as research, for a qualified person in a
controlled setup, not as instructions:

1. **Measure the sensors.** Before any mains wiring, measure each FSR's
   resistance against force: the three pre-terminated 402s (base, X and
   UX) and a UX 406. A kitchen scale makes a good force gauge: put the
   sensor on the scale, press it through the puck, and read the force from
   the scale and the resistance from a meter. Ten or fifteen points from
   actuation to full load give the curve that replaces the model's
   assumed one. Rerun `tools/make_fsr_pedal_figures.py` with the fitted
   values.
2. **Measure the DB3s.** Raise a variable DC supply slowly through a
   100 kΩ resistor across each diac and note the voltage where it snaps.
   Keep the ones near 32 V.
3. **The voltage test on the sensor.** This is the test that decides the
   design (below).
4. **The circuit on the bench, with a lamp.** On the isolation
   transformer (the Hammond 171B), with a 60 to 100 W incandescent bulb as
   the load. A bulb is close to the model's resistive load, so the scope
   should show §4's waveforms, and the firing angle against force can be
   checked directly against the simulation. Look at node N, C and the
   gate pulse.
5. **The motor on the rig.** Then the motor test rig, with the motor as
   the load: check that the triac commutates cleanly without a snubber,
   and how the start feels with a real motor. A universal motor needs some
   voltage before it turns at all, which may make the abrupt start less
   noticeable, or more.
6. **The pedal.** Only then the housing, the spring or lever and the puck.

## The voltage test

The open question is whether an FSR tolerates this circuit's voltage for
years: up to 66 V, alternating, at well under a milliamp. Interlink calls
0.1 to 5 V typical but publishes no maximum. The risks are slow ones:
silver migration between the fingers, or a change in the ink, either of
which would show up as drift or a falling unloaded resistance.

A test that answers it:

- **The setup.** Two UX 406s (or a 406 and a spare 402) under fixed
  weights, one at a light load (where the voltage is highest) and one at
  rest, unloaded. Drive each from a 60 V AC source through a resistor sized
  to give the circuit's current: a small transformer secondary will do,
  or the rig's isolation transformer through a divider. Keep a third,
  identical sensor unpowered, under the same weight, as a control.
- **The measurement.** Each day or two, disconnect the drive and measure
  the resistance at the same load, and the unloaded resistance.
- **The duration.** A few weeks is a start: a thousand hours is a
  respectable soak.
- **Pass.** The powered sensors drift no more than the unpowered control,
  and the unloaded resistance stays above 10 MΩ.

If the sensors passed, the sensor question would be settled in the
design's favor; the design itself would still be a research concept,
needing everything in `docs/VALIDATION.md` before it could be built. If
they drift, the fallbacks are, in order:

- **Lower the voltage.** A lower clamp (back-to-back 43 V zeners, with
  DB3s selected below 32 V) cuts the sensor's peak voltage by a quarter,
  at the cost of more sensitivity to the diac.
- **Move the sensor out of the high-voltage position.** Put the FSR
  across a smaller part of the timing resistance, with a fixed resistor
  taking most of the voltage. This narrows the force range the sensor
  controls.
- **Isolate it.** Design (b) from the earlier discussion: a vactrol whose
  photocell sits in the timing network, with the FSR driving its LED at
  5 V. It needs a supply in the pedal, which a two-wire pedal has to
  harvest, and a vactrol whose cell is rated for the voltage it sees.

## Other open questions

- **The abrupt start.** Whether a quarter of line voltage at turn-on
  feels wrong with a real motor, and if so, whether a second RC stage
  fixes it.
- **The real FSR curve.** The model's power law is a fit to two numbers.
  The measured curves will move the force window, and RS, RB and the
  pedal's force division will move with them.
- **The 402 alternatives.** The base and X sensors reach full scale
  sooner, which would move the window down and make the pedal's force
  division larger. The 406's area still makes it the better choice for
  the current (§4.5).
- **Temperature.** FSRs and diacs both drift with temperature, and a
  pedal near a heater or in a cold garage will feel different. The model
  ignores it.
