# The pedal around it

## Dividing the force

A foot resting on a pedal pushes with something like 5 to 10 N, and a firm
press is several times that. The simulated curve runs from about 1.6 N to
14 N on the sensor, so the pedal should pass the sensor roughly a fifth of
the foot's force. Two ways to do it:

- **A spring in parallel.** The tread rests on a spring that carries most
  of the load, and presses the sensor through a puck with the rest. The
  spring also gives the pedal travel and feel: an FSR itself moves about
  0.15 mm, so without a spring the pedal is a stiff button. This is the
  arrangement Interlink recommends for designs that need travel ("use
  soft rubber or a spring as part of the actuator").
- **A lever.** The tread pivots, and the sensor sits closer to the pivot
  than the foot does. A 5:1 lever gives the 5:1 division directly. It is
  simpler, with less travel.

Either way, three things protect the sensor:

- **A puck to spread the load.** A rigid disc about 20 mm across with a
  thin rubber face, pressing on the 406's center. It sets the loaded area
  that the current limit depends on (§4.5), keeps the pressure far below
  Interlink's 10 N/mm² damage threshold, and makes the response
  repeatable.
- **A hard stop.** The tread should bottom out on the housing before the
  sensor sees much more than the force for full speed, so a stamp on the
  pedal can't crush it.
- **A flat, rigid seat** for the sensor, with its vent, at the end of the
  tail, left open. Interlink warns that a blocked vent makes the response
  non-repeatable.

The UX's range helps here. Because it reads to 150 N, the force division
needn't be precise: a pedal that passes a quarter or a third of the
foot's force still stays within the sensor's range, and RS and RB move
the curve to suit.

## Everything is live

Every part of this pedal is at mains potential, the FSR, its tail and the
puck's underside included. The user is protected by the housing alone, as
in a carbon-pile pedal, so the housing has to provide what standards call
reinforced insulation:

- **Only insulating material where a foot or hand can reach**: a printed
  or molded tread, no metal screws or plates exposed, and fasteners
  recessed below insulating plugs.
- **An insulating layer between the tread and the sensor.** The puck
  presses on the FSR's top film. That film is thin polyester, not an
  insulation barrier, so the puck itself must be plastic, and the tread
  plastic above it.
- **Creepage and clearance.** The spacing between live parts and the
  outside of the housing, along surfaces and through air, should follow
  what IEC 60335-1 (household appliances) requires for reinforced
  insulation at 120 V, several millimeters. Printed parts make this easy
  to design in.
- **Strain relief** on the cord, as on any pedal, so a yank can't pull
  live conductors against the housing or out of the board.
- **Heat.** About 1.5 W in the triac and 0.2 W in RD, in a closed box
  under a foot. The clip heatsink and a few cubic inches of air are
  enough, but the triac shouldn't sit against the tread.

Because every part is live, nothing inside needs isolating from anything
else. That is what lets this design skip the vactrol: the FSR can be wired
straight into the circuit, as long as the voltage across it is acceptable
(§6).

## Fitting the cordset

The pedal needs only its two terminals, so it fits any cordset that wires
the pedal in series with the motor. Most do, the Kenmore's among them as
far as this paper knows, but check before building: some cordsets carry a
third conductor to the pedal, for a lamp or a two-speed switch, and that
conductor must not be connected to anything in this design. A pedal from
the same cordset family, opened and traced, answers it in a minute.
