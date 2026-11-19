# Summary

*About this paper.* The text, analysis, figures and simulations were written
by Claude, an AI model made by Anthropic, at the direction of Robert
Drzyzgula, who set its scope and questions. It is a companion to *A
Force-Sensing Pedal* ("the pedal paper"), *Inside a Switching Circuit*
("the switching paper") and *Speed Control of Universal Motors in Sewing
Machines* ("the speed-control paper"). It is a design study: nothing in it
has been built or measured yet. The sources are listed in the last section;
please report errors as issues on the project's GitHub repository.

**The question.** The pedal paper designed a force-sensing pedal for a
stock cordset, where everything has to live at mains potential and run
from two wires. The knee controller in the VSM Base has none of those
constraints. It has an earthed IEC inlet, room for a certified isolated
5 V supply, and the MCU controller's optocouplers to carry signals across
an isolation barrier. What does a force-sensing knee controller look like
when it is designed for that setting from the start, with no
microcontroller and no firmware, and owing nothing to the KB3151C?

**The answer** is the circuit at the heart of industrial phase-control
chips, built from a handful of parts on the low-voltage side:

- **A ramp, restarted every half-cycle.** The H11AA1 zero-cross detector
  resets a capacitor at each zero crossing. A constant-current source
  charges it in a straight line until the next one.
- **A command from the sensor.** The FSR and a resistor divide the 5 V
  supply. The harder the knee presses, the lower the voltage.
- **A comparator.** When the ramp passes the command, the comparator
  turns on the MOC3023's LED, and the triac fires for the rest of the
  half-cycle.

The mains side is the MCU controller's, unchanged: inlet, fuse, MOV,
triac, opto-triac, zero-cross detector and supply. The two designs can
share it.

**What the simulation shows.**

- **It behaves well electrically.** The motor starts smoothly from zero,
  with none of the snap-on of an RC pedal, because the ramp is reset every
  half-cycle and remembers nothing. With nominal parts the speed rises
  from a start at about 1 N on the sensor, through half speed at about
  4 N, to 90% at about 15 N, and the curve is roughly logarithmic in force.
  The firing angle doesn't depend on the line voltage. The FSR sees at
  most 5 V and a quarter of a milliamp, inside Interlink's typical drive,
  so the pedal paper's open question about the sensor's voltage doesn't
  arise.
- **Tolerances are modest.** The current source, the ramp capacitor and
  the sensor's part-to-part spread move the curve by tens of percent, not
  by the factor of two the diac's tolerance causes in the pedal.
- **The mechanics are the real design problem.** An FSR measures force,
  and a knee lever is a position device. If the knee simply compresses a
  linear spring onto the sensor, the sensor's power law crowds the whole
  speed range into the first few millimeters of travel. A progressive
  spring stack spreads it over the full inch, or the knee can be made
  nearly rigid, so that the command really is force. §5 sets out both,
  and how they would fit the existing knee housing.

**A foot pedal too.** §6 adds a passive low-voltage pedal on a
two-conductor cable, in parallel with the knee's sensor, with the MCU
controller's relay restored as the motor's cutoff and a check for a
shorted cable. A printable draft of the pedal is in
`standalone/fsr-pedal/`.

**What it is not.** It has no speed regulation, needle stops or
calibration; the MCU controller (speed-control paper, §9) provides those.
This is the "no code" alternative, built to the same safety standard.
