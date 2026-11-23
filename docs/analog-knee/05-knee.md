# The knee

## Force, or position?

An FSR measures force. The knee controller as it stands is a position
device: the knee pushes a bar through about an inch of speed range against
a light spring, and a pot measures where the bar is (the User's Guide's
knee-controller chapter). The original Singer knee controller worked the
same way. A force sensor can still serve a moving lever, because a spring
turns position into force. But the shape of that conversion matters a
great deal.

![Speed along the knee's travel, from the rest switch closing at 1 inch to
full travel at 2 inches, when the sensor is loaded by a linear spring
(solid) and by a progressive stack (dashed), for 20 N and 50 N on the
sensor at full travel.](../images/analog-knee/analog-knee-travel.svg){width=100%}

**A linear spring crowds the range.** If the knee compresses an ordinary
spring onto the sensor, force rises in proportion to travel. But the FSR's
resistance falls as a power of force, so the first few newtons do most
of the work. With 50 N at full travel, the simulation puts 50% of line
voltage 1.6 mm past the switch point and 90% at 7.2 mm, out of 25 mm of
speed range. The rest of the inch does almost nothing. A softer spring
(20 N at full travel) helps a little but not much.

There are two ways out.

**1. A progressive stack.** If the force on the sensor rises
geometrically with travel, each millimeter multiplying it by the same
factor, then the FSR's power law and the log-shaped speed curve cancel,
and the speed spreads over the whole range: 25% at 5.4 mm, 50% at 9.1 mm,
75% at 13.3 mm and 90% at 17.5 mm past the switch point, with 50 N at
full travel. Practical ways to get a progressive force:

- **Nested springs** of increasing stiffness, engaging one after another:
  a soft one from the switch point, a stiffer one partway, a stiff one
  near full travel. Three springs approximate a geometric curve well.
- **An elastomer pad** under the puck. Rubber in compression stiffens as
  it is squeezed, which is progressive by nature, though its curve
  depends on its shape and hardness and drifts with temperature.
- **A cam or a toggle linkage** between the crank and the sensor, shaped
  so the force rises geometrically. Printable, but the most work.

**2. A near-isometric knee.** Alternatively, make the knee lever nearly
rigid: a few millimeters of travel against a stiff spring, and speed set
by how hard the knee presses, not how far. That is the FSR's natural use,
and the carbon pile's way of working (speed-control paper, §4): force in,
speed out. It would feel different from the Singer knee controller,
firmer and more like pressing a button with the knee, and whether that is
better or worse is a question for the bench, not the simulation.

The FSRs on order make this an easy experiment. A 402 under a printed
lever, read by this circuit or simply by a meter, answers how each
arrangement feels before any of them is built into the base.

## Fitting the existing knee

The knee controller's hub, crank, spring housing, rest and stop screws and
snap switch all stay. What changes:

- **The gear train and the pot go.** No sector gears, no idler, no pot
  bushing. The shaft only carries the hub.
- **The sensor goes in the spring housing.** The housing already holds a
  return spring and a stop screw standing up through it. The sensor sits
  on the housing's floor or the stop screw's head, under its puck, and
  the sensor's spring (or stack) between the puck and the crank pin
  engages at the switch point. The return spring keeps its job, returning
  the knee and giving its preload, and carries most of the knee's force.
- **The rest switch stays exactly as it is**, now the motor's only
  mechanical cutoff (§3): one layer of protection, not a single-fault-proof
  safety device (§7).
- **The hard stop protects the sensor.** At the stop, the crank's pin
  meets the stop screw, so the sensor never sees more than the stack's
  force at full travel.

The sensor's tail and its two wires would be on the side intended to be
SELV (§7), so they would run to the board like any low-voltage lead; that
the isolation holds is for testing to show, not assume.

**A printable draft** (`standalone/fsr-knee/fsr_knee_housing.scad`, with
its README) puts the sensor beside the return spring rather than under it:
the housing's bottom is already less than 5 mm above the table, and the
402's pad is wider than the spring's bore. A sensor tower on the shaft
side, under the crank, holds a 402, a puck, a soft and a stiff spring
nested together, and a plunger that the crank meets just before the
switch point. At 38 mm from the shaft the plunger moves 3.2 mm by full
speed and 4.0 mm by the stop, and the stack reaches 54 N at full speed,
sized for §6's 10 kΩ divider. Since the sector gear goes, the rest
switch's cam needs a new home on the shaft.
