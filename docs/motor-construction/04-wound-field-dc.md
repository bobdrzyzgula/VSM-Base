# Wound-field DC motors: the universal motor's relatives

A universal motor is one member of a family. Every brushed motor with a
wound field is built from the same parts: field iron and coils, a slotted
armature, a commutator and brushes. They differ in **how the field coil is
connected to the armature**, and that one choice sets the speed–torque
character. Before permanent magnets became strong and cheap, these were the
DC motors, and they still drive treadmills, cranes and machine tools.

- **Series-wound.** The field in series with the armature, carrying the same
  current. Many turns of heavy wire, because the field carries the full
  load current. This is the universal motor's connection. Its torque goes
  as $i^2$, its speed falls steeply with load, and it races when unloaded.
  On DC, a series motor with no load can over-speed until it damages
  itself, which is why large ones are never run without a load.
- **Shunt-wound.** The field across the supply, in parallel with the
  armature, with many turns of fine wire carrying a small, steady current.
  The flux is then nearly constant whatever the load. Back-EMF is
  proportional to speed alone, $e = K_e\omega$, and torque to armature
  current alone, $T = K_t i_a$ (the two constants are explained in §2). The speed falls only by the small $i_a R_a$
  drop as load rises: the "nearly constant speed" motor of machine shops.
- **Separately excited.** A shunt motor whose field has its own supply. This
  makes two independent controls: armature voltage sets speed up to base
  speed, and weakening the field raises speed above it, trading torque for
  speed.
- **Compound.** Both a series and a shunt winding, blending the series
  motor's starting torque with the shunt motor's steadier speed.

**Speed control.** For a shunt or separately excited motor, the controller
sets the **armature voltage**. Industrial drives do this with a controlled
rectifier, SCRs fired in phase like a triac but feeding a DC motor through a
bridge. That is the KBIC's circuit (speed-control paper, §8). Because the
flux is constant, the armature voltage minus its $IR$ drop is a direct
measure of speed. That is why "IR compensation" regulates a shunt motor
well, and a series motor only to a first approximation.

**On the wire.** A DC motor on a controlled rectifier sees the rectified
line's humps, with chopped leading edges. Its armature and field
inductance smooth the current much as they do for the universal motor on
the triac (§3). With enough inductance, the current flows continuously
from one hump to the next instead of in pulses.

**Why none of this is in a sewing machine.**

- **The shunt field.** A shunt field wound for 120 V DC is many turns of
  fine wire and dissipates power continuously. The motor needs a DC supply
  and a rectifier either way.
- **The series connection already works.** The universal motor runs directly
  on AC, gives high torque from a standstill, and costs little. For a
  machine that only ever turned one way, at the speed a foot asked for,
  that was enough.

Permanent magnets now give the shunt motor's constant flux with no field
winding at all, and that is the next section.

![Speed against load torque, normalized to full speed at full load, at
100%, 70% and 40% of full voltage. Left: a series (universal) motor, whose
speed collapses as load rises and soars as it falls. Right: a
constant-flux motor, permanent-magnet or shunt, whose speed is set by its
voltage and falls only slightly with load. Illustrative, from the two
motors' ideal equations.](../images/motors/speed-torque-types.svg){width=100%}
