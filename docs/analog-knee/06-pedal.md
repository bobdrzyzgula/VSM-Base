# Adding a foot pedal

The same circuit can take a foot pedal as well as the knee lever, or
instead of it. At low voltage the pedal can be passive: a force sensor and
a resistor, on a light two-conductor cable to a jack on the base. This
section covers the changes to the base's circuit; the pedal itself is a
printable draft in `standalone/fsr-pedal/` (§6.4).

![The additions. The pedal's FSR, with 470 Ω in series, reaches the
command node D through jack J7, in parallel with the knee's sensor (also
with 470 Ω in series); RM drops to 10 kΩ. Comparators C2 and C3 close the
relay K1 whenever a sensor is pressed and the command isn't shorted. C1 is
§3's firing comparator, unchanged.](../images/analog-knee/analog-knee-pedal-schematic.svg){width=100%}

## One command node, two sensors

The pedal's sensor and the knee's are wired in parallel at D. With
neither pressed, both are open and D sits at 5 V. Press either and its
resistance pulls D down; press both and the lower resistance, the harder
press, wins. No switch is needed to choose between them.

Two things change on the base's board:

- **RM drops to 10 kΩ,** moving the force range up to suit a foot.
- **Each sensor gets 470 Ω in series, at the sensor**, on its own board.
  That puts a floor under D. A sensor at its full load, about 1 kΩ, leaves
  D at about 0.64 V; a sensor failed short leaves it at 0.22 V, and a
  short in the cable or the jack at zero. C3 watches for anything below
  0.4 V (§6.3).

![Motor voltage against force on either sensor, with the shared
command.](../images/analog-knee/analog-knee-pedal-curve.svg){width=100%}

Simulated with the same assumed UX curve, the motor starts at about 2.8 N
on the sensor, reaches 25% at 6.6 N, 50% at 12 N, 75% at 24 N and 90% at
about 50 N, and tops out at 98%. Those are forces beyond whatever the
pedal's springs carry: the springs hold up a resting foot (§6.4), and
the sensor feels only the push beyond it. A firm press is roughly 50 to
100 N, so this suits a foot pressing the sensor directly, with no force
divider. The knee's sensor stack should then be sized to reach about
50 N at full travel, the "progressive, 50 N" curve of §5.

## The relay comes back

With a pedal, the knee's mains rest switch can't be the motor's cutoff: it
would be open, at rest, whenever the pedal is in use. So the MCU
controller's relay K1 returns, with its contact in series with the triac
on the mains side, and the low-voltage side closes it only when there is
a reason to:

- **C2, "pressed":** high when D is below 3.8 V, just above the ramp's
  3.6 V peak. D crosses 3.8 V on the way down before the triac starts
  firing, so the relay closes about a half-cycle *before* any current
  flows, and its contact never makes under load.
- **C3, "not shorted":** high when D is above 0.4 V. A healthy sensor,
  with its 470 Ω, can't bring D below about 0.64 V; a sensor failed short
  brings it to 0.22 V, and a shorted cable or jack to zero.
- **The logic.** C2's output charges node E through a diode; C3's output,
  through a diode the other way, pulls E down at once when it goes low.
  E drives Q4, a 2N7000, which drives K1's coil (the 5 V G5LE draws about
  80 mA, within the 2N7000's rating), with a 1N4148 across the coil.
- **A short hold.** 330 kΩ and 1 µF hold E up for about a third of a
  second after the press ends, so K1 opens after the triac has stopped
  firing, again with no current through its contact. A short isn't held:
  C3 pulls E down immediately.

C1, C2 and C3 fit one MCP6564, the quad version of the MCP6562, with one
comparator spare.

## When things go wrong

| Fault | D | Result |
|---|---|---|
| Pedal unplugged | 5 V (open) | Off; the knee still works |
| Cable cut, or a sensor's lead broken | 5 V (open) | Off |
| Cable or jack shorted | 0 V | C3 opens K1 at once: off |
| A plug inserted while running (a jack shorts briefly as the plug goes in) | 0 V for an instant | K1 drops out; press again |
| Triac shorted | — | Runs only while a sensor is pressed (K1); off at rest |
| Sensor shorted inside | 0.22 V | C3 opens K1: off |

The faults the circuit can't catch are the slow ones: a sensor drifting
so that a light press reads as a harder one. That shows up as a pedal
that feels touchy, and a check with a meter answers it: unloaded, the
sensor should read above 1 MΩ.

## The pedal and its cable

**The connector.** A two-conductor cable, shielded, with the shield as
0 V and the center conductor as D. An RCA (phono) plug works; a 6.35 mm
(1/4") mono phone plug, the kind on a keyboard's sustain pedal, is
sturdier and harder to pull out by accident. Either way, use a connector
that no mains plug can mate with, and expect the brief short as it goes
in; C3 handles it. Strain-relieve the cable at both ends.

**The pedal's board.** The pedal needs almost no circuit: the 470 Ω
resistor, the sensor's tail soldered to two pads, and the cable's two
conductors. On perfboard that is about 25 × 20 mm; the draft allows
35 × 25 mm, for room to solder.

**The draft** (`standalone/fsr-pedal/fsr_pedal.scad`, with its README) is
a heel-hinged tread over a rigid pedestal. The UX 406 lies flat on the
pedestal, with the board beside it on the same plane, so the sensor's
tail never bends. A 22 mm puck under the tread, faced with a 1.5 mm
rubber pad, presses the sensor's center. Two springs near the toe hold
the tread up, carry a resting foot and return it; two posts beside the
pedestal stop the tread after 2 mm of travel at the puck, so a stamp
can't crush the sensor. It is low voltage throughout, so it needs no
insulation beyond keeping the cable's strain relief honest.
