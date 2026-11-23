# Summary

*About this paper.* The text, analysis and figures were written by Claude,
an AI model made by Anthropic, at the direction of Robert Drzyzgula, who set
its scope and questions, supplied the measurements, photographs and
hardware, made the design decisions for the VSM Base controllers, and
reviewed it. The sources it draws on are listed in the last section; please
report errors as issues on the project's GitHub repository.

> **Safety status: research only.** None of the motor-control designs in
> this repository is safe to build as drawn. They are research artifacts,
> published as the work progresses: studies of how existing and historical
> controls work, what their hazards are, and what a safer replacement would
> need. None has been built, tested, measured, or assessed against an
> electrical safety standard. That a design has been analyzed or simulated
> here, or is used in commercial or historical products, is not evidence
> that it, or any copy or modification of it, is safe. Printed plastic is
> not an assessed insulation system or fire enclosure, and a barrier drawn
> on a schematic is not proof of isolation. Do not build a controller from
> these documents or connect one to the mains. It applies equally to the
> commercial and historical pedals this paper describes, and to the three
> controller concepts in §11.

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
