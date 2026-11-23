# Validation required before any motor control could be called buildable

*Written by Claude at Bob Drzyzgula's direction, November 2026, from a
safety review of the repository.*

None of the motor-control designs in this repository is a safe, buildable
design. They are research artifacts: concepts, some of them simulated, none
built, tested or assessed against an electrical safety standard. This
checklist records what would have to be done, for a specific design and a
specific jurisdiction, before that design could be called buildable or
shippable. Until every item has been completed for a design, it keeps its
status as research only.

The list is a minimum. It is not a substitute for an engineer qualified in
product safety, the applicable standards themselves, or a test laboratory.

## Requirements and analysis

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
