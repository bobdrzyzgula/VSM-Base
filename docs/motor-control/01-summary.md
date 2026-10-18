# Summary

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
