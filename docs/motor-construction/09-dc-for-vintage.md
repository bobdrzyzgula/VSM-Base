# Could a DC motor drive a vintage machine?

## What the job asks for

The universal motors that drive these machines set the target (§2):

- **Power:** an output of roughly 40–80 W.
- **Speed:** about 6,000–7,000 rpm, so a running torque near 0.06–0.11 N·m.
- **Reserve torque:** a good deal more for a few moments, for a heavy seam
  or a cold start in old oil.

**The space.** A Singer external motor's body, as measured for the test
rig's cradle, is about 51 × 64 mm in section and 114 mm long. It hangs from
a bracket on the back of the machine and drives the hand wheel through a
belt.

Speed itself is negotiable: the belt's ratio sets it. A motor with twice the
torque at half the speed, given a motor pulley twice the size, turns the
hand wheel just as well. **Power is what has to match.**

## Candidates

All of these run on 24 V DC. The first three fit well inside the Singer
motor's envelope. The 57 mm brushless motor fits its length and its 64 mm
side, but is a little wider than its 51 mm side. Specifications are as published by the
sellers cited. Ratings for generic motors vary between sellers and should
be checked on the bench.

| Motor | Type | Size | Ratings at 24 V | Approx. price |
|---|---|---|---|---|
| "775" brushed motor | Brushed PM | 42 mm dia. × 66.5 mm, 5 mm shaft | 8,300 rpm no load; 0.082 N·m and 3.5 A at 7,354 rpm (about 63 W); 0.72 N·m at a stall ([RobotShop](https://robotshop.com/products/e-s-motor-775-dc-motor-high-speed-big-torque-24v-8300-rpm)) | $12 |
| "50SRZ" brushed motor | Brushed PM | 50 mm dia. × about 100 mm, 6 mm shaft | Sold in 2,000–8,000 rpm versions; power ratings vary by seller ([eBay listing](https://www.ebay.de/itm/226397386344)) | $55 |
| 42BLS02 | Brushless, 8 poles | 42 mm square flange × 61 mm | 4,000 rpm; 0.125 N·m and 3.3 A rated (52.5 W); 0.38 N·m peak ([Robu](https://st.robu.in/product/42bls02-24v-rpm4000-0-125-n-cm-61mm)) | $25 |
| 57BLY100, with driver | Brushless, 4 poles, Hall sensors | 57 mm dia. × 87 mm, 8 mm shaft | 3,000 rpm; 0.33 N·m and 5 A rated (103 W) ([RobotShop](https://www.robotshop.com/products/e-s-motor-57mm-brushless-dc-motor-w-driver-kits-24v-103w)) | $77 with driver |

There is also evidence from practice:

- **A Janome 415 conversion.** Robert Scheibe replaced the motor of a Janome
  415 with a 24 V, 50 mm brushed motor of the SRZ family (a Tsukasa
  TS-50SRZ-R: 5,000 rpm, 50 × 101.5 mm, rated 10.8–50.4 W). He drove it
  with an off-the-shelf PWM controller and an old guitar volume pedal,
  through a toothed belt. He reports much better control at low speed,
  especially when starting difficult seams
  ([Scheibe](https://robert-scheibe.de/repair_janome.html)).
- **A brushless attempt.** A SimpleFOC forum thread on brushless drives for
  sewing machines set targets at the hand wheel of 2,000 rpm and 0.7 N·m
  (about 140 W), and a smooth crawl below 8 rpm with over 1 N·m. That
  calls for a substantial motor. The thread recommends field-oriented
  control with a magnetic angle sensor, and reports no finished build
  ([SimpleFOC](https://community.simplefoc.com/t/motor-drive-for-sewing-machines/4621)).
- **Industrial machines.** Brushless servo motors are the standard on
  industrial machines (§6), but at a few hundred watts they are far too
  large for a domestic machine's bracket.

So the answer to the first question is **yes**. Small, cheap DC motors with
a sewing motor's power exist, and they fit its space. A brushed 775 at
24 V is the simplest candidate. A 42 mm or 57 mm brushless motor is the
better one.

## What the controller would become

The MCU controller in the speed-control paper is built around a triac
because the motor runs on mains AC. A DC motor changes its power stage
completely and leaves its brain much as it is. A concept schematic of the brushed version, a 775 on an
off-the-shelf H-bridge, is in the speed-control paper's §11 ("A DC-motor
variant") and in the repository at `hardware/mcu-controller-dc/`.

- **The supply becomes a certified 24 V adapter.** A 24 V, 5 A (120 W)
  supply with a safety listing does all of the isolation from the mains,
  inside a part that is bought, not built. The triac, the opto-triac, the
  zero-cross detector, the relay and the mains wiring all disappear. Every
  wire the builder touches is at 24 V. For a published hobby design, that
  may be the largest single benefit.
- **The power stage becomes a bridge.**
  - *For a brushed motor:* an H-bridge (four MOSFETs and a gate driver, or
    an integrated H-bridge rated for 10 A or more).
  - *For a brushless motor:* a three-phase bridge (six MOSFETs and a
    three-phase gate-driver IC, such as one of TI's DRV83xx family), with
    the motor's three Hall sensors wired to three GPIOs.
  - *Either way:* a shunt resistor and amplifier measure the current into
    one of the RP2350B's spare analog inputs.
- **The firmware gains a current loop.** The current loop runs at the PWM
  rate (20 kHz or more), with the speed loop around it, and a position
  loop around that for needle stops. All three fit comfortably in an
  RP2350. The pedal, knee and heel inputs, the speed-limit knob and the
  stop teaching carry over unchanged.
- **Needle stops become exact.** A triac controller can only cut power
  early and let the machine coast to its stop, learning the coast as it
  goes (speed-control paper, §11). A bridge can brake the motor
  electrically, then hold the needle where it is with current: true servo
  positioning.
- **The encoder may become optional.** A brushless motor's Hall sensors
  report 6 states per pole pair per turn, 24 per turn for the 8-pole
  42BLS02. Say the motor turns three to five times per stitch, as a
  6,000 rpm motor driving 1,200–2,000 stitches a minute must. That is
  70–120 positions per stitch, comparable to the optical encoder's 144.
  Round and V-belts slip a little, so the hand-wheel index would still be
  needed to re-anchor the count once a stitch, but the expensive part of
  the encoder would not.

## What it costs

- **Authenticity.** For a collector, a vintage Singer with a modern motor is
  a different object. A bolt-on motor on an adapter bracket, with the
  original motor kept, keeps the change reversible. Machines with a potted
  motor built into the casting (the 15-91, the 201) are out of reach.
- **Mechanics.**
  - *Fitting:* an adapter to the machine's motor bracket, and a pulley
    sized to the new motor's speed for the machine's belt.
  - *Bench testing:* the test rig's cradle could take a 42 mm motor with a
    printed adapter.
- **A motor that needs its controller.** The original motor runs from any
  pedal; a DC motor runs only from its electronics. A brushless motor does
  not run at all without its controller.
- **Brushes, still, for a brushed motor.** A 775 costs little enough to
  treat as a wear part. A brushless motor has no brushes.
- **Electrical noise of a new kind.** PWM at 20 kHz, with short, twisted
  motor leads and a filtered supply, replaces the brush hash of the
  universal motor.

## Recommendation

A DC-motor variant of the controller is worth keeping open, in the same
spirit as the parked ideas in the speed-control paper's §11.

1. **Start on the bench, not in the machine.**
   - *Measure the candidate:* run a 775 and a 42BLS02 from a 24 V supply
     with off-the-shelf drivers, and measure speed, current and torque with
     the rig's Prony brake, as for the universal motor.
   - *Try it on a machine:* put the better one on a machine on a temporary
     bracket.
2. **If that goes well, design a low-voltage power stage for the RP2350B
   board,** H-bridge first, three-phase second. Keep the triac design for
   machines that keep their original motors.

The two would share their sensors, their pedals and most of their firmware.
