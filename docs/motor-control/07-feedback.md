# Feedback controllers: holding speed under load

Every method so far sets a voltage and lets the load set speed. A feedback
controller measures speed, compares it with the pedal's command, and fires
earlier when the motor slows. This is the only class that fixes the low-speed
weakness at its root: in the fragile region it simply adds voltage until the
stitch is through. There are three ways to measure speed.

**1. Back-EMF sensed between pulses (half-wave SCR).** In a half-wave circuit
the motor carries no current on alternate half-cycles. During that gap the
spinning armature, in the field's residual magnetism, generates a small
voltage proportional to speed. The firing circuit compares this against the
pedal's reference: a slower motor means a lower back-EMF and an earlier
trigger. This trick, used in 1960s–70s drills and some sewing pedals, gives
real regulation with a handful of parts. Its limits are half-wave operation
(half the power, more torque ripple) and a weak, temperature-dependent
residual field. Silicon Chip's regulated universal-motor controller uses a
refined form of the same principle
([Silicon Chip, Oct 2002](https://www.siliconchip.com.au/Issue/2002/October/Speed+Controller+For+Universal+Motors)).

**2. Armature voltage with IR compensation (full-wave SCR DC drive).** A
rectifying DC drive powers the motor from a full-wave bridge and regulates the
armature voltage. It then adds a correction proportional to current, because
the $I R$ drop in the windings is the main reason speed falls with load. KB's
KBIC is an example: rated for shunt, PM and AC/DC (universal) motors, with MIN,
MAX, ACCEL, IR and current-limit trimpots, and a load regulation of 1% of base
speed over a 50:1 range
([KB KBIC data sheet D-210](https://forums.parallax.com/uploads/attachments/41167/71583.pdf)).
For a series motor the regulation is less exact than for a PM motor, because
the back-EMF depends on current as well as speed ($E = K I \omega$), so IR
compensation is a first-order correction. In practice it still transforms
low-speed behavior.

**3. Tachometer (closed-loop phase control).** A shaft sensor gives speed
directly, and a controller adjusts the triac firing angle to hold it. Washing
machines do this with dedicated ICs such as onsemi's TDA1085C, a phase-angle
triac controller with a tachometer input, frequency-to-voltage converter, ramps
and current limiting
([onsemi TDA1085C](https://onsemi.com/download/data-sheet/pdf/tda1085c-d.pdf)).
An MCU can do the same with a PI loop; Freescale's AN1662 is a worked example
using a 16-pole tachometer and a triac
([Skalka, AN1662](https://nxp.com/docs/en/application-note/AN1662.pdf)). This
is the most precise method, but it needs a sensor on the motor or the
handwheel.

For the sewer, all three convert the pedal from a voltage command into a speed
command. At low speed the machine punches through a seam at the speed you asked
for instead of stalling, which is the "full power at slow speed" quality of good
electronic machines.
