# Summary

*About this paper.* The text, analysis, figures and simulations were written
by Claude, an AI model made by Anthropic, at the direction of Robert
Drzyzgula, who set its scope and questions. It is a companion to *Speed
Control of Universal Motors in Sewing Machines* (cited here as "the
speed-control paper"), which covers the physics of the series motor and
each method of controlling it. This paper looks inside the motors
themselves. The sources are listed in the last section; please report errors
as issues on the project's GitHub repository.

**What it covers.** The speed-control paper treats the sewing-machine motor
as three letters in an equation: a resistance $R$, a motor constant $K$, and a
speed $\omega$. This paper starts from the metal and copper.

- **Construction.** It shows how a universal motor is built, and which parts
  of it make up each term of that equation:
  - its laminated field iron and field coils;
  - its wound armature;
  - its commutator and carbon brushes.
- **Other motor types.** It treats four related motors the same way, as
  parallel subjects rather than footnotes:
  - the wound-field DC motor, the universal motor's DC relatives;
  - the brushed permanent-magnet DC motor;
  - the brushless DC motor;
  - the induction motor, with the industrial clutch motor and the
    variable-frequency drive.

  For each it covers how the motor is built, what its equations say, and how
  its speed is controlled.
- **Waveforms.** It shows what each control method looks like on the wire:
  - the universal motor straight on the line, behind a rheostat, and
    chopped by a triac, where the winding's inductance stretches and
    smooths the current;
  - a permanent-magnet motor on pulse-width modulation;
  - a brushless motor's six-step drive.
- **A practical question.** It closes by asking whether a DC motor exists
  that has a sewing motor's power and speed, about 50–100 W at around
  6,000 rpm, and also fits the space a sewing motor occupies. If so, could
  the MCU controller designed for the VSM Base drive it?

**The short answers.**

1. **The universal motor is a DC series motor built to survive AC.** Its iron
   is laminated, its brushes are high-resistance carbon, and its field and
   armature share one current. That shared current is why it runs on AC at
   all. It is also why its speed sags under load and why its back-EMF
   vanishes whenever the current stops.
2. **The inductance is mostly in the field coils, and it matters.** It makes
   the current lag the line by about 30° at full speed. Behind a triac, it
   carries the current past the point where the line voltage reverses. It
   also turns each chopped slice of voltage into a smooth hump of current.
   At speed the back-EMF acts like extra resistance and shortens that
   smoothing. At a crawl the back-EMF is gone, so the smoothing lasts longer
   but the torque pulses grow sharper.
3. **Permanent-magnet and brushless motors behave like voltage-controlled
   speed sources.** Their flux is fixed by magnets, so speed follows voltage
   and torque follows current, each on its own. That makes them far easier
   to regulate, to hold still, and to brake. They need DC and, in the
   brushless case, an electronic commutator.
4. **The induction motor needs no commutator at all.** A three-phase
   supply makes a field that rotates by itself, and the rotor's bars have
   their currents induced by the field sweeping past. It runs at nearly
   fixed speed off the line, a few percent below the field, and only a
   variable-frequency drive changes that. The sewing trade's clutch motor
   was an induction motor with the speed control in a slipping clutch.
5. **Suitable DC motors exist, and they are small and cheap.** Common 24 V
   brushed motors of the "775" size (42 mm across) deliver 60 W or more near
   7,000 rpm. Brushless motors of 42–57 mm deliver 50–100 W at 3,000–4,000
   rpm. Both fit easily within the envelope of a Singer external motor.
   Driving one would change the controller's power stage completely:
   - a certified 24 V supply, with no mains anywhere else;
   - an H-bridge or a three-phase bridge;
   - current sensing.

   The RP2350B, its encoder and its firmware structure would carry over.
   Such a controller could do what a triac never can: brake actively and
   hold the needle exactly where it is put.

**On the simulations.** The waveforms here are computed from simple lumped
models with representative values for a 99-class motor, not measured. They
show the shapes and the cause and effect correctly. The exact numbers
belong to the motor test rig, which is designed to measure $R$, $L$ and $K$
and to put these waveforms on a scope. Its captures should replace these
figures.
