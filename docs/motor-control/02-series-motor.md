# The series motor and why its speed sags under load

In a universal motor the field winding is in series with the armature, so one
current $I$ makes both the field flux and the armature current. Torque is flux
times current, so below saturation torque rises with the square of the current
([Wikipedia: Universal motor](https://en.wikipedia.org/wiki/Universal_motor)).
The same series connection is why it runs on AC: field and armature current
reverse together, so torque keeps its sign.

A simple steady-state model, with flux proportional to current and the
back-EMF proportional to flux times speed:

$$T = K I^2, \qquad V = I R + K I \omega$$

Here $V$ is the voltage at the motor terminals, $R$ the total winding and
brush resistance, $\omega$ the speed and $K$ a motor constant. Eliminating $I$
gives the speed–torque curve:

$$\omega(T) = \frac{V}{\sqrt{K T}} - \frac{R}{K}$$

Three consequences matter for sewing:

1. **Speed is set by voltage, not commanded.** At a fixed torque, speed rises
   roughly linearly with $V$. No pedal sets speed directly; every open-loop
   pedal sets a voltage, and the load decides the speed.
2. **Speed falls steeply as load rises.** The slope is
   $d\omega/dT = -V / (2\sqrt{K}\,T^{3/2})$, steepest at light load. Series
   motors slow down as load increases and race when unloaded
   ([Wikipedia](https://en.wikipedia.org/wiki/Universal_motor);
   [Fay, Motorola AN-443](https://ftp.mirrorservice.org/sites/www.bitsavers.org/components/motorola/_appNotes/AN-0443_Direction_And_Speed_Control_For_Series_Universal_And_Shunt_Motors.pdf)).
3. **Low speed is the fragile region.** Writing the fractional sensitivity as
   $(d\omega/\omega)/(dT/T) = -\tfrac{1}{2}\,\omega_0/\omega$, where
   $\omega_0 = V/\sqrt{KT}$ is the speed with no resistance, shows it grows
   without bound as $\omega$ approaches zero. When most of the voltage is spent
   on $I R$ rather than back-EMF, a small extra load stalls the motor.

A sewing machine's load is not steady. The needle piercing fabric, the take-up
lever, and the hook and feed cams produce a torque pulse every stitch, and a
seam crossing adds a step. At full speed the flywheel and armature inertia ride
through these pulses. At a few stitches per second the motor sits in the
fragile region of point 3, and each pulse produces the familiar
surge-and-stall behavior. Each control method below differs mainly in how it
handles that region.
