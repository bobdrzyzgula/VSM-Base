# Validation required before anything here could be called a product

*Written by Claude at Bob Drzyzgula's direction, November 2026, from a
safety review of the repository.*

VSM Base is an open-source hobby project, provided under the MIT license
"as is", without warranty. Its printed parts are tested as far as one person
can at a workbench; its motor-control designs are research artifacts:
concepts, some of them simulated, none built, tested or assessed against an
electrical safety standard. This checklist records what would have to be
done, for a specific configuration and a specific jurisdiction, before it
could be called a product: buildable, shippable, or safe to sell. Anyone who
wants to make one takes that on. Until every item applying to a design has
been completed, a motor control keeps its status as research only, and a
printed configuration its status as a hobby build used at the builder's own
risk.

The list is a minimum. It is not a substitute for an engineer qualified in
product safety, the applicable standards themselves, or a test laboratory.

## The printed base and its accessories

- A reference build from a named model version, with the printer, slicer,
  material and filament batch, drying, nozzle, layer height, walls, top
  and bottom layers, infill, orientation, supports and hardware recorded.
- Static vertical and lateral load on the seat, joint and hinges.
- Lifting by each handhold, by the harness rods, and asymmetrically;
  set-down and impact loads; a dropped or struck part.
- Repeated machine insertion and removal, hinge tilting, lid opening, and
  extension fitting and removal; peg and peg-hole wear.
- Creep under load over time; behavior warm, cold, after oil or moisture,
  and after print defects or partial delamination.
- The printed hinge, if used: pin engagement, pivot retention, arm and
  block strength, stop strength, sideways loads, wear and creep.
- Heat-set inserts, nut traps and mending plates: hole sizes, insertion,
  tightening, and pull-out under cyclic load.
- Every other machine profile, end to end, with its underside clearance
  checked through the mechanisms' full movement.
- Each printer's usable bed, not only its nominal build volume.
- Transport and shipping, separately from use at home.
- Independent stops: the hinge's tilt stop and the tilt prop, each on
  its own, and what happens to the machine and the user's hands when one
  of them fails.
- Dropped-load scenarios: a handhold, rod, slide or seam letting go, or
  a slide slipping, at carrying height, with and without the machine's
  front held down.

## Carrying harnesses

The guide's harness and the printed handle are experimental: none has
been made, and the arithmetic in the guide and the handle's README is
illustrative, with an arbitrary factor of 2, not a recognized one.

- Proof-load and ultimate-load factors taken from the standard applicable
  to lifting gear where it will be used (synthetic slings, for example,
  are commonly proof-tested at twice their rated load and designed to five
  times it), applied to the complete assembly as built.
- Rated slides or buckles (working load, and slip under steady and
  cyclic loads with the webbing actually used), rated webbing, and
  stitch patterns and thread with tested seam strength.
- Slip tests of the slide with the exact webbing, threaded exactly as
  instructed, dry, wet and dirty, under steady and repeated loads, to set
  the tail length and an allowable movement (the guide's 50 mm tail is
  provisional).
- Bearing tests of printed notches with rods, steady and repeated, with
  inspection for whitening, cracking and a deformed rod seat.
- A proof-load test of each assembly, with inspection criteria, and
  destructive tests of samples to find the actual ultimate load and where
  it fails.
- Dynamic loads: a jolt, a short drop, a swing; the loss of one leg, and
  what the base and machine do then.
- Balance: machines whose weight is off center, and how far the base
  tilts.
- Repeated lifts (fatigue of the print and seams, and creep of the
  webbing through the slides), creep under a sustained load, heat,
  sunlight and aging of the webbing.
- The printed handle across printers, materials and print settings; one
  print report is one sample.
- Instructions, markings and a stated maximum load, if the harness were
  ever offered to anyone else.
- Inspection criteria for cracks, whitening, loose inserts, worn holes,
  hinge play and distortion, and a replacement-part workflow.

## Motor controls: requirements and analysis

- Formal requirements and intended-use limits.
- Risk and hazard analysis, including foreseeable misuse and abuse.
- The applicable IEC, UL, CSA and EN standards, and national deviations.
- Single-fault analysis, and the fault modes of each component.

## Electrical safety

- Insulation class; reinforced or double insulation where required.
- Protective earthing, where applicable.
- Creepage and clearance, from the standard, for the pollution degree,
  overvoltage category, working and transient voltages, and material group.
- Dielectric withstand (hi-pot) testing.
- Leakage current and touch current.
- Fuse and overload coordination; locked-rotor and stall current.
- Surge, MOV and transient immunity, including the MOV's failure behavior.
- USB and debug isolation, and every other path across a barrier
  (programming leads, chargers, instruments, earth).

## Thermal, fire and environment

- Temperature rise, in normal and abnormal operation.
- Enclosure flammability and impact.
- Ingress protection, moisture, contamination and cleaning.
- Abnormal voltage and abnormal operation.

## Mechanical

- Mechanical strength of the enclosure and mechanism.
- Spring, latch, switch and relay endurance.
- Cord retention, wiring and strain relief; connectors and mating.
- Pinch, crush and snag hazards; sudden release; loss of the rest position.
- Motor commutation and brush life; bearing and belt failure.
- Stop and braking behavior; needle-position accuracy.
- Behavior with a stalled motor, a jammed or blocked needle, and an
  accidental full-speed command.
- Behavior with a dropped or damaged cord, plug or connector.

## Electromagnetic compatibility

- Conducted and radiated emissions (brush noise, phase-control switching).
- Immunity of the sensors, low-voltage circuits and firmware.

## Firmware

- Firmware functional safety; hardware independence of the stop function.
- Watchdog and reset behavior; brownout and power-loss behavior.
- Sensor and switch diagnostics.
- Software update and recovery.

## Product

- Markings and instructions; maintenance and repair instructions.
- End-of-life and replacement-part requirements.
- Transport and shipping.
- Field trials and serviceability.
- Test-laboratory certification; independent safety review.
- Registration, or its exemptions, where applicable.

No energized testing of a new design should begin before an independent
review of the design and of the test setup.
