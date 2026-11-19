# Safety and construction

## The barrier

The design's safety rests on keeping the mains side and the SELV side
apart, with only three parts bridging them: the IRM-05-5, the H11AA1 and
the MOC3023, each certified for the isolation. On the board:

- **Two zones.** Lay the mains parts and the SELV parts out in separate
  areas, with the optocouplers and the supply straddling the boundary and
  nothing else crossing it.
- **Distance.** Keep the gap between the zones' copper at least as wide
  as the optocouplers' own pin rows, about 7 mm on a DIP-6, and wider
  where the layout allows. On perfboard, cut a slot along the boundary.
- **Wiring.** Mains wiring in 300 V-rated wire, routed and tied down so a
  loose wire can't reach the SELV side; SELV wiring kept away from it.

## Earth

The inlet's earth should go to anything metal a user can touch that a
fault could make live. In the base, that is chiefly the machine itself:
an earth lead to the machine's bed, through a ring terminal under one of
its screws, earths the cast iron, which a two-wire cordset never did.

The SELV side can float, or be tied to earth at one point to keep noise
down. Either is safe: the barrier, not the earth connection, protects the
user.

## The rest switch

The snap switch at the knee's rest position is in series with the motor,
on the mains side. It must be rated for the motor's current at 125 VAC,
and mounted so its terminals are covered. Because it opens whenever the
knee is at rest, a shorted triac, a stuck comparator or a damaged sensor
can at worst run the motor while the knee is pressed, never when it is
released.
