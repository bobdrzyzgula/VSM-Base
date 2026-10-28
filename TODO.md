# To do

*A working list, kept by Claude at Bob Drzyzgula's direction. Tick items
off as they're done; ideas that are only parked are listed last so they
aren't forgotten.* Last gathered October 25, 2026.

## Measure

- [ ] **Kenmore 158, for the encoder** (`hardware/encoder/`):
  - [x] the shaft's underside above the casting floor: 20 mm (gauge and
        calipers); shaft about 12.25 mm, so the axis is about 26.1 mm up;
  - [ ] the floor's ribs: pitch, height (about 4 mm) and thickness, and
        where the nearest ones are relative to the shaft, along it and
        across it. The bay under the target stretch is roughly 1.5" × 1.25";
        measure it with `standalone/floor-span-gauge/`, photographed from a
        level camera, with the spring out for some shots;
  - [ ] the clear length of shaft at the chosen spot;
  - [ ] the spring's position next to the shaft;
  - [ ] the room along the shaft at the ring's outer radius, not only at
        the shaft;
  - [ ] a photo straight down, with a scale in the frame.
- [ ] Kenmore 158 feet positions (the foot-locating rig).
- [ ] The "full size" class: the dozen or so flatbeds, starting with the 15K.
- [ ] The Singer 306W profile.
- [ ] Fit tests on the 99K:
  - [ ] the 7 mm and 9/32" hinge pins;
  - [ ] the barrel-hinge coupon.

## Print, build and test

- [ ] Finish the motor rig's plates. Reprint the five corrected parts:
  `board_cover`, `wago_lid`, `bb_lid`, `iec_box`, `jack_panel`.
  - [ ] Check that the sockets' rear nuts clear the jack panel's middle rib.
  - [ ] See whether the IEC box's inlet opening bridges without support.
- [ ] Try glue stick as a release layer for the Inslogic PETG Pro on
  textured PEI.
- [ ] Build and wire the rig. Then run the two measurements that settle
  the open questions:
  - [ ] the 99 motor's current and speed on a variac at several voltages,
        which gives K and R for the model in §2 of the motor-control paper;
  - [ ] its top speed on rectified DC.
- [ ] Keep the 4-relay module (Songle SRD-05VDC-SL-C) to the bench, under
  watch. If it serves as K1 on a prototype, log it in `hardware/PARTS.md`.
- [ ] Log substitutions in `hardware/PARTS.md` as parts arrive.
- [ ] When the WeAct RP2350B boards arrive, print the header stand
  (`rp2350b-controller/` in the Header-Soldering-Jigs repository) and solder
  their headers.

## Decide

- [ ] Pedal and sensor connectors: GX12 or M8. The pin counts are settled:
  4 pins for each pedal, 5 for the hand-wheel sensor, 3 for the knee lever.
- [ ] Pedal sensors: a pot or a linear Hall sensor for travel; how to build
  the pressure (FSR) pedal.
- [ ] Encoder for the 158:
  - [ ] optical or Hall;
  - [ ] which fork part (perhaps one dual-channel fork);
  - [ ] ring size, 36 or 40 mm.
- [ ] Next full build: a Kenmore 158.1702x or 158.1703x. Find a prettier
  one, and put the 158.17021 through its bench service either way.
- [ ] Machine classes: kept as they are for now; revisit if something
  better occurs, the local class-file idea among them.

## Design (with Claude)

- [ ] A 158 version of the optical encoder: a low saddle on the floor,
  notched for the ribs and the spring, with the forks in pockets. Drafted
  as the `saddle` part (October 27); its `keepouts` await the rib and
  spring measurements.
  - [ ] Assembly order: swivel the first ring half through the forks, then
        add the second and clamp.
  - [ ] Removable adhesive, on a degreased floor.
- [ ] The Kenmore 158 profile in VSM Base, with inserts for the pattern
  cams. Release 0.2.0 is to cover the printed hinge, flush beds, and the
  Kenmore profile.
- [ ] The knee controller, and the detachable right-side bays (outlet bay
  first).
- [ ] MCU controller firmware (Pico SDK, C, no RTOS):
  - [ ] the phase-control loop and speed loop;
  - [ ] taught stops, and the heel tap;
  - [ ] a count check at each index;
  - [ ] on hand-wheel machines, a prompt to set top dead center again
        after bobbin winding.
- [ ] A hand-wheel encoder mount for the 99K, on the wheel's sloped back
  face, with the sensor coming up past the belt.
- [ ] Manuals: Bob's own text, and a clear statement of what has actually
  been printed and tested.

## Parked ideas (no action; guardrails so nothing precludes them)

- A pedal-first controller without feedback, as a feedback-free mode of the
  MCU design, with mains kept in the base and an ergonomic pressure pedal.
- IR compensation without a machine sensor, using the optional current
  transformer T1 now on the schematic, tuned per motor.
- A tabletop controller for accessibility: 3.5 mm switch jacks and other
  assistive inputs, with switch-only firmware modes.
- Reflective optical encoders, as the last resort.
- Danielle's idea: compare the Bernina 730's and 830's pedals side by side.
- The rectified-DC variant (`hardware/mcu-controller-rectified/`): on the
  motor rig, the same motor on AC and through a bridge with a freewheeling
  diode; compare the current on the scope, and the speed at low firing.
- The DC-motor variant (`hardware/mcu-controller-dc/`): first run a 775 on a
  24 V supply on the motor rig, driven by the H-bridge module the schematic
  uses (Pololu's G2 High-Power Motor Driver 24v13), measuring speed, current
  and torque; then try it on a machine on a temporary bracket.
