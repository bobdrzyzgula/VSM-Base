# What the pedal has to work with

## Two wires, no earth, unknown polarity

A cordset pedal sits in one leg of the motor circuit. When the pedal is
open, the motor is off and the pedal's two terminals see the whole line
voltage between them. When it conducts, the motor runs. The pedal has no
other connection, so whatever is inside it must:

- **run from the voltage across itself**, as the KB3151C does (switching
  paper, §6). Before the triac fires in each half-cycle, that is nearly
  the whole line, because the motor drops almost nothing at the timing
  network's few milliamps. After it fires, it is about a volt.
- **be live throughout.** Either terminal may be the hot one. Unpolarized
  plugs leave it to chance, and even cordsets with polarized plugs are
  wired to the pedal at random: in Robert Drzyzgula's experience the
  makers don't try. Nothing
  inside is referenced to earth. Every part in the pedal, the sensor and
  its tail included, has to be treated as being at mains potential. The
  user is protected by the housing, not by the circuit.
- **let a little current through when it is off.** A two-wire pedal can't
  open completely, as a carbon pile's contacts do, because its timing
  network has to be connected across it. That leakage flows through the
  motor, a few milliamps, far too little to turn it.

## What an FSR is built for

An FSR is two films: one printed with interleaved silver fingers, the
other with a carbon-based ink. Pressing them together shorts the fingers
through the ink, and the harder the press, the lower the resistance.
Interlink's integration guides (sources 1 and 2) give the numbers this
design depends on:

- **Resistance.** More than 1 MΩ unloaded (the X and UX guide gives a
  stand-off resistance above 10 MΩ), falling to about 1 kΩ at full load.
  Interlink defines "actuation" as the force that brings it below 100 kΩ.
  Between actuation and saturation, the resistance follows an inverse
  power law of force.
- **Range.** Base 400 series, 0.2 to 20 N. X series, 0.3 to 50 N. UX
  series, 0.5 to 150 N.
- **Drive.** "Any voltage that suits your circuit is fine. From 0.1 V ...
  to 5 V is the typical range."
- **Current.** Less than 1 mA per square centimeter of applied force:
  the area actually loaded, not the sensor's whole area.
- **Repeatability and drift.** About ±2% for one part with a repeatable
  actuator; about 10% hysteresis between loading and unloading; a long-term
  drift under constant load of less than 4–5% per decade of time.
- **Overload.** Keep the pressure below 10 N/mm² of actuator area.
- **Life.** Typically beyond a million actuations.

## Why the KB3151C's pot position won't do

The KB3151C charges its timing capacitor from the triac's MT2 through the
pot (switching paper, §6). Until the diac fires, the capacitor is below
32 V and MT2 follows the line, so the pot carries the difference: up to
about 140 V in the half-cycles where the triac fires late, and the full
170 V peak when it doesn't fire at all, which is most of the time the
pedal is at rest. That is thirty times the FSR's typical drive, across
silver fingers a fraction of a millimeter apart. An FSR dropped in where
the pot was would work at first. The question is how long.

There is also a gate problem. The KB3151C drives its BT136-600E through a
1 kΩ resistor, which suits that sensitive-gate triac (10 mA). The
snubberless BTA16-600BW the project is buying needs up to 50 mA, so its
gate resistor must be smaller (§3).
