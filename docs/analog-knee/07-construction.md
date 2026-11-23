# Safety and construction

## The barrier

The design's safety would rest on keeping the mains side and the SELV side
apart, with only three parts bridging them: the IRM-05-5, the H11AA1 and
the MOC3023, each certified for its own isolation. Their certifications
cover the parts, not the board around them. The notes below are the
starting points of a layout, not a safety assessment: a real one would set
creepage and clearance from the applicable standard (for the pollution
degree, overvoltage category, working and transient voltages, and the
board material), and then verify the built board with insulation testing,
leakage and touch-current measurements, and checks of fusing, surge
protection and the MOV's failure behavior. On the board:

- **Two zones.** Lay the mains parts and the SELV parts out in separate
  areas, with the optocouplers and the supply straddling the boundary and
  nothing else crossing it.
- **Distance.** Keep the gap between the zones' copper at least as wide
  as the optocouplers' own pin rows, about 7 mm on a DIP-6, and wider
  where the layout allows; on perfboard, cut a slot along the boundary.
  This is a rule of thumb, not a creepage figure from a standard.
- **Wiring.** Mains wiring in 300 V-rated wire, routed and tied down so a
  loose wire can't reach the SELV side; SELV wiring kept away from it.

## Earth

The inlet's earth should go to anything metal a user can touch that a
fault could make live. In the base, that is chiefly the machine itself:
an earth lead to the machine's bed, through a ring terminal under one of
its screws, earths the cast iron, which a two-wire cordset never did.

The SELV side can float, or be tied to earth at one point to keep noise
down. Either is acceptable in principle, because the barrier, not the earth
connection, is meant to protect the user; but that holds only for a barrier
that has been built and verified. A computer on the USB port, a debug
probe, a battery charger or a scope's earthed ground clip can each make a
path across it: until a built board's isolation has been checked, connect
none of them with the board connected to the mains.

## The rest switch

The snap switch at the knee's rest position is in series with the motor,
on the mains side. It must be rated for the motor's current at 125 VAC,
and mounted so its terminals are covered. Because it opens whenever the
knee is at rest, a shorted triac, a stuck comparator or a damaged sensor
should run the motor only while the knee is pressed. That is not a
guarantee: a welded or stuck switch, a jammed knee mechanism or a broken
return spring defeats it. A rest switch is one layer of protection, not a
complete safety function; its own failure modes, and those of whatever
else stops the motor, would need validating.
