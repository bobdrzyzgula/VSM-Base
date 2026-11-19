# Summary

*About this paper.* The text, analysis, figures and simulations were written
by Claude, an AI model made by Anthropic, at the direction of Robert
Drzyzgula, who set its scope and questions. It is a companion to *Inside a
Switching Circuit* (cited here as "the switching paper") and to *Speed
Control of Universal Motors in Sewing Machines* ("the speed-control
paper"). It is a design study: nothing in it has been built or measured
yet. The sources are listed in the last section; please report errors as
issues on the project's GitHub repository.

**The question.** Many vintage machines take a standard cordset: a cord
from the wall to a molded block on the machine, and a second cord from the
block to the foot pedal. In most of these the pedal is a two-terminal
device in series with the motor, as a carbon pile is. The pedal gets no
neutral and no earth, and with an unpolarized plug nobody knows which of
its two wires is hot. Could a pedal that fits that cordset unchanged sense
the foot's *force* with a force-sensing resistor (FSR) instead of its
travel, and do it with no supply and no microcontroller: a passive circuit,
like the KB3151C board but driven by the FSR?

**The answer, on paper, is yes, with one open question.**

- **The FSR can't simply replace the KB3151C's pot.** In that board the
  pot carries nearly the whole line voltage, about 170 V peak, and an FSR
  is made for a few volts (§2).
- **A clamped timing supply fixes most of that.** A resistor from the
  line feeds a pair of 56 V zeners, which hold the timing network's supply
  to ±57 V whatever the line does. The FSR, in series with a fixed
  resistor, charges the timing capacitor from that. The diac and triac
  then work as in any pedal (§3). The FSR sees at most about 66 V, and
  only while it is lightly pressed and carrying well under a milliamp.
- **Simulated, it works like a pedal.** The motor starts at about 1.6 N
  on the sensor, reaches 90% of line voltage at about 14 N, and tops out
  at 94%. A pedal that passes a fifth of the foot's force to the sensor
  puts that between about 8 N and 70 N of foot force: from resting the
  foot on it to pressing firmly (§4).
- **Two weaknesses the model shows.** Like every simple RC pedal, it
  starts abruptly, at about a quarter of line voltage. And the diac's
  tolerance (28 to 36 V) moves the whole curve by a factor of about two,
  which a trimmer only partly corrects (§4).
- **The open question is the sensor.** Interlink rates its FSRs by force
  and current, and describes 0.1 to 5 V as the typical drive. The
  circuit's current is within Interlink's guidance; its peak voltage is
  well above the typical drive. Whether an FSR runs for years at 60 V of
  alternating voltage is something to test, not assume. §6 sets out the
  test, and what to do if it fails.

**What it is not.** A passive pedal has no speed regulation, no
needle-position stop and no calibration: the MCU controller (speed-control
paper, §9) does all of those. This design is the simplest thing that fits
a stock cordset and gives a force pedal a better feel than a slide pot and
a weak spring.
