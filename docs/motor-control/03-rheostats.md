# Series resistance pedals (rheostats)

A wire-wound or stepped-contact rheostat puts a variable resistance $R_s$ in
series with the motor on the full line voltage $V_{line}$. It is the
worst-regulating of the common methods, because it lowers speed by adding
resistance rather than lowering voltage.

With $R_s$ in the circuit the speed–torque curve becomes:

$$\omega(T) = \frac{V_{line}}{\sqrt{K T}} - \frac{R + R_s}{K}$$

The slope $d\omega/dT = -V_{line} / (2\sqrt{K}\,T^{3/2})$ does not depend on
$R_s$ at all. Turning the pedal down shifts the curve toward zero speed but
keeps the full-speed slope, so a given torque pulse costs the same absolute rpm
at a crawl as at full speed. As a fraction of the remaining speed, the loss is
enormous. A voltage-reducing control (variac, phase control) also lowers the
slope, because it scales $V$.

Three further problems follow from the same equation:

- **Weak starting torque.** At standstill the current is $V_{line}/(R + R_s)$
  and the torque $K I^2$. With a large $R_s$ the torque may not overcome static
  friction, so the pedal is pressed further, the machine breaks free, and it
  lurches. A Kenmore carbon-pile restorer describes this as poor starting
  torque at light pressure
  ([softsolder.com](https://softsolder.com/2009/03/10/old-kenmore-sewing-machine-foot-control-repair/)).
- **Heat.** The pedal dissipates $I^2 R_s$, largest at middle speeds where
  $R_s$ and $I$ are both substantial. A 120 V, 1 A sewing motor can put tens of
  watts into the pedal, which is why old pedals have ceramic formers and vents.
- **Steps.** Stepped-contact rheostats change resistance in jumps, so speed
  changes in jumps. Each step is also a make-and-break contact carrying motor
  current, which arcs and pits.
