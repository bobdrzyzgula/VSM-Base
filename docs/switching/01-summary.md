# Summary

*About this paper.* The text, analysis, figures and simulations were written
by Claude, an AI model made by Anthropic, at the direction of Robert
Drzyzgula, who set its scope and questions. It is the second companion to
*Speed Control of Universal Motors in Sewing Machines* (cited here as "the
speed-control paper"). The first companion, *Inside the Motor*, looks inside
the motors. This one looks inside the switches that control them. The
sources are listed in the last section; please report errors as issues on
the project's GitHub repository.

**What it covers.** The speed-control paper treats a phase-control pedal as
a box that chops the line: it sets a firing angle, and the motor gets part
of each half-cycle. This paper opens the box.

- **The thyristor (SCR).** It starts with the device the others grew from:
  four layers of silicon that latch on when their gate is pulsed and stay on
  until the current stops. It explains why it latches, with the
  two-transistor model, and the ways it can be turned on that nobody
  intended.
- **The triac and the diac.** A triac is two thyristors in one piece of
  silicon, back to back, so it conducts both ways. It covers how it fires in
  four "quadrants", why it is harder to turn off than two separate SCRs, and
  how the diac gives it a clean trigger.
- **Phase control.** A minimal pedal circuit, part by part: how its RC
  network sets the firing angle, why the circuit remembers the last
  half-cycle, and why that memory makes a pedal snap on.
- **The snubber.** What the little resistor and capacitor across a triac
  are for, why some triacs don't need them, and why one might be fitted
  anyway.
- **The donor board.** The KB3151C pedal board that the VSM Base's knee
  controller reuses, worked through in detail: its pot and trimmer in
  parallel, and what its minimum-speed trimmer does to the pedal's feel,
  simulated across its range.
- **Switches a gate can turn off.** Power MOSFETs, IGBTs and their
  relatives: how they differ from thyristors, why a cordless drill uses one
  kind and a variable-frequency drive another, and what that means for
  leading-edge and trailing-edge control.
- **Where each appears in the project.** The knee controller, the MCU
  controller and its two DC variants, and the KB Electronics controllers
  the speed-control paper discusses.

**The short answers.**

1. **A thyristor is a latch.** Its four layers form two transistors, each
   feeding the other's base. A gate pulse starts the loop, and once the
   current is large enough the loop holds itself on. Only stopping the
   current resets it. On AC the line does that every half-cycle, which is
   why thyristors and phase control grew up together.
2. **A triac is two thyristors sharing silicon, and it pays for that in
   turn-off.** One gate fires it either way. But when the current reverses
   it has no time to recover between the two directions. A fast-rising
   voltage just after a current zero can turn it straight back on. Inductive
   loads such as a motor cause exactly that.
3. **In a pedal, a resistor and a capacitor are the clock.** The capacitor
   charges through the pedal's resistance, lagging the line, until it
   reaches the diac's breakover, about 32 V. More resistance means later
   firing and less voltage. Past about 137 kΩ with 0.1 µF it never fires.
   The capacitor carries charge from one half-cycle to the next. That
   memory is why the motor starts at about 40% of the line's voltage and
   then runs slower than it would start.
4. **The snubber slows the voltage edge** that would otherwise re-fire the
   triac after an inductive turn-off. Triacs built for inductive loads
   ("snubberless") can do without it, at the cost of a less sensitive gate.
5. **The donor board's trimmer sets where in the pedal's travel the motor
   snaps on, not how gently.** Set high, it leaves a quarter of the travel
   dead. Set near 430 kΩ, the motor starts as soon as the pedal leaves its
   off zone. Set below the pot's own 200 kΩ, the pedal stops being
   monotonic.
6. **Transistor switches turn off on command.** That makes PWM and
   trailing-edge control possible, and with them DC motor drives, VFDs and
   brakes. MOSFETs rule at low voltage and high speed, as in the cordless
   drill. IGBTs rule at mains-derived voltages and kilowatts, as in a VFD or
   an industrial servo. Thyristors survive where the line does the turning
   off for free.

**On the simulations.** The firing curves are computed from a simple model
of the timing network, not measured. It uses a 32 V breakover, 22 V left on
the capacitor after firing, a 120 V line and a resistive load. The voltage
left after firing is the least certain of these. The motor test rig is
meant to measure the real board, and its results should replace these
figures.
