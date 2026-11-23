# Summary

*About this paper.* The text, analysis and figures were written by Claude,
an AI model made by Anthropic, at the direction of Robert Drzyzgula, who set
its scope and questions, supplied the measurements, photographs and
hardware, made the design decisions for the VSM Base controllers, and
reviewed it. The sources it draws on are listed in the last section; please
report errors as issues on the project's GitHub repository.

> **Research use only: not a safe, buildable design.** The motor-control
> circuits, schematics, enclosures, mechanisms, test procedures and software
> in this project have not been safety-designed, safety-validated,
> certified, or tested as a complete appliance. None of the controller
> designs should be built or connected to the mains as drawn, and none
> should be operated. A concept drawing, simulation, component listing,
> historical example or commercial component is not evidence of compliance
> or safety; printed plastic is not an assessed insulation system or fire
> enclosure, and a barrier drawn on a schematic is not proof of isolation.
> The work is meant to support understanding of how existing and historical
> controls work and what hazards they carry, and to guide the development of
> safer alternatives. Any future buildable design would need a new system-
> level engineering assessment, independent review, qualified
> implementation, complete-product testing and applicable certification;
> `docs/VALIDATION.md` lists what that would cover. It applies equally to
> the commercial and historical pedals this paper describes, and to the
> three controller concepts in §11. Its curves and figures are simulations
> from assumed component and motor values, not measurements, and are not
> evidence of performance or safety.

A sewing machine's universal motor is a series-wound machine whose speed
depends strongly on load, so the controller matters as much as the motor. A
pedal that only lowers the voltage (rheostat, carbon pile, variac, simple
triac) leaves speed at the mercy of the load. Only a controller that measures
speed and corrects it (back-EMF or tachometer feedback) holds speed when the
needle hits a seam.

The carbon pile wins among the open-loop pedals for two reasons. Its
resistance varies continuously and steeply with foot pressure, which gives
fine control at the bottom of the range. And because its resistance falls as
you press, the operator closes the feedback loop with their foot faster than
they consciously notice the machine slowing.

This paper covers the physics of the series motor, then each control method:
series rheostat, carbon pile, open-loop triac phase control, variac, and
feedback controllers including KB Electronics boards and MCU designs. It
closes with the two controller designs for the VSM Base: the knee controller
built around a repurposed foot-pedal triac board, and a microcontroller phase
controller now in design.

A companion paper, *Inside the Motor*, looks at how these motors are built
and how each part maps onto the model used here. It also compares the
universal motor with wound-field DC, permanent-magnet and brushless motors
and their controls, and shows the waveforms of each control method on the
wire. It closes by asking whether a small DC motor could drive a vintage
machine from a version of the MCU controller.

A second companion, *Inside a Switching Circuit*, looks inside the
controls: the thyristor and triac, a phase-control pedal circuit part by
part, the snubber, the donor board of the knee controller in detail, and
the transistor switches (MOSFETs and IGBTs) behind PWM drives and
variable-frequency drives.
