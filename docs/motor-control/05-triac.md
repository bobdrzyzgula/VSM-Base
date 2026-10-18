# Triac phase-angle control (open loop)

Modern electronic pedals, including the boards examined for this project, are
phase-angle controllers. They lower the average voltage by switching, not by
burning power in a resistance, so they run cool. Their speed regulation,
though, is roughly that of a variac, and their low-speed behavior is worse.

**How it works.** A triac sits in series with the motor. Each half-cycle, an RC
network charges through the pedal's resistance until the capacitor reaches the
diac's breakover voltage (about 30 V). The diac then dumps a pulse into the
triac gate, and the triac conducts until the motor current falls to zero, a
little after the voltage zero because the motor is inductive. Delaying the
firing angle $\alpha$ reduces the share of each half-cycle applied to the motor
([Skalka, Freescale AN1662](https://nxp.com/docs/en/application-note/AN1662.pdf)).
For a resistive load the RMS output is:

$$V_{rms} = V_{pk}\sqrt{\frac{1}{2\pi}\left(\pi - \alpha + \tfrac{1}{2}\sin 2\alpha\right)}$$

The motor's inductance stretches the conduction past the voltage zero, so the
real curve differs, but the shape holds: a smooth fall from full voltage at
$\alpha = 0$ to nothing at $\alpha = \pi$.

What it means for sewing:

- **Regulation like a voltage source.** Because the motor sees a chopped
  version of the full line, not a resistance, the speed–torque slope scales
  with the effective voltage, as for a variac. That is better than a rheostat
  or carbon pile at a given speed. But nothing corrects for load: the pedal
  sets $\alpha$, and the load sets speed.
- **Torque arrives in pulses.** At a large $\alpha$ the motor gets a short, high
  current pulse every 8.3 ms (on 60 Hz) and nothing between. At full speed,
  inertia smooths this out. At a crawl the armature can nearly stop between
  pulses, giving the jerky "cogging" low-speed running that simple phase
  controls are known for
  ([Silicon Chip, Oct 2002](https://www.siliconchip.com.au/Issue/2002/October/Speed+Controller+For+Universal+Motors)).
- **Snap-on hysteresis.** In a single-RC diac circuit, the capacitor is partly
  discharged each time the diac fires, so the setting that starts the motor is
  not the one that stops it. The pedal tends to need a push to start, then the
  motor jumps to a speed above where you wanted it. Two-stage RC networks (an
  extra R and C feeding the timing capacitor) reduce this.
- **A little accidental feedback.** Before the triac fires, the RC network
  charges from the voltage across the triac. That is the line voltage minus the
  small back-EMF the turning armature generates from residual field magnetism.
  A slowing motor makes less back-EMF, so the capacitor charges slightly faster
  and fires earlier. The effect is small in a simple pedal. Deliberately
  exploiting it is the basis of the regulated designs below.
