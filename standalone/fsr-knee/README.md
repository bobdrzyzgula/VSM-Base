# Force-sensing knee controller: spring housing (draft)

*Drawn by Claude at Bob Drzyzgula's direction, November 2026. A draft to
print and try; it has not been printed, fitted or tested.*

The VSM Base's knee controller turns a pot through two gear stages. This
draft replaces the gears and the pot with an Interlink FSR 402 in the knee's
spring housing, for the analog controller in the design study *An Analog
Force-Sensing Knee Controller* (`docs/analog-knee/`, §5 and §6). It is the
housing alone, drawn in its own frame, to be folded into the main model
(`scad/vsm_base.scad`) once it has been tried.

![Section through the housing at rest: the return spring and its cap under
the crank pin on the left, the sensor tower on the right with the plunger's
domed head just under the crank, the guide, the soft (green) and stiff
(red) springs, the puck and the sensor (gold) on the floor](fsr-knee-rest.png)

## What stays and what changes

The return-spring side is the main model's, at its defaults: the hub with
its crank and pin, the 9001T46 spring and its cap, the rest screw in the
roof, the stop screw standing up through the spring, the ears and the
tongue into the base's front face. At rest the spring holds the crank up
against the rest screw; at the hard stop the pin comes down onto the stop
screw.

What is new is a **sensor tower** joined to the housing on the shaft side,
under the crank's flat bottom, 38 mm from the shaft (`sensor_r`):

- **A plunger** stands up through a guide bushing at the tower's top. Its
  domed head sits just under the crank. The crank meets it at 24 mm of
  knee travel (`contact_travel`), just before the motor's start point at
  25.4 mm, and pushes it down from there to the stop.
- **Two springs** under the plunger's flange: a soft one, bearing from
  contact on, and a stiff one nested inside it that joins after 1.45 mm.
  Together they make the force on the sensor rise progressively with
  travel, which spreads the speed over the knee's travel (§5 of the paper)
  instead of crowding it into the first few millimeters.
- **A puck** faced with a 1 mm rubber pad presses the springs' force onto
  the sensor, which lies flat on the tower's floor. Its tail leaves through
  a slot in the back wall and the tongue, into the base.
- **The return spring keeps its job:** the knee's preload, its return, and
  most of its feel. The sensor sees only the stack's force.

![The same section at full speed (50.8 mm at the knee): the crank has
pressed the plunger down about 3.2 mm, both springs are working, and the
pin is still clear of the stop screw](fsr-knee-full.png)

**Why beside the spring, not under it.** §5 of the paper put the sensor
under the return spring. It doesn't fit there: the housing's bottom is
already less than 5 mm above the table, and the 402's pad (18.3 mm) is
wider than the spring's inside diameter (11.6 mm). Beside the spring and
nearer the shaft there is room, and the sensor moves less than the pin, so
it adds less to the force at the knee.

**The rest switch** stays as the motor's mechanical cutoff (§3 of the
paper). Its cam was on the sector gear, which goes, so it needs a cam of
its own on the shaft. That is not drawn here.

![The housing with the crank, from the front: the spring box with its
ears, and the sensor tower beside it with the guide's retaining screw
hole](fsr-knee-housing.png)

## The numbers

At the defaults, each render prints:

| | Knee travel | Plunger travel | Force on the sensor |
|---|---|---|---|
| Contact | 24 mm | 0 | 0.9 N (preload) |
| Motor's start | 25.4 mm | 0.17 mm | 1.7 N |
| Full speed | 50.8 mm | 3.25 mm | 54 N |
| Hard stop | 57.15 mm | 4.0 mm | 74 N |

The stack is sized for the paper's §6 circuit (RM = 10 kΩ, the pedal and
the knee sensors in parallel), whose curve starts at 2.8 N, reaches 50% at
12 N and 90% at about 50 N. With this stack those fall at 27, 37 and
50 mm of knee travel: the speed spreads over the inch from the start point
to full travel.

For the §3 circuit alone (RM = 22 kΩ: start 1.0 N, 50% at 4.1 N, 90% at
15 N), the springs would be about a third as stiff.

The sensor adds 6.4 N at the knee at full speed and 8.7 N at the stop, on
top of the return spring's 17.4 N and 18.9 N: the knee is about a third
firmer at the end of its travel than the main model's.

## Springs

The soft and stiff springs are placeholders, chosen by rate and size, not
yet matched to catalog parts:

- **Soft:** 12 mm outside diameter, 12 mm free length, about 4.7 N/mm. It
  is compressed to about 7.8 mm at the stop, so its solid height must be
  under about 7 mm.
- **Stiff:** 7.5 mm outside diameter, about 11.4 mm free length, about
  21 N/mm. It is compressed to about 8.8 mm at the stop; solid height under
  about 8 mm.

Any pair with the same rates and room to spare will do; the settings
(`soft`, `stiff_od`, `stiff_rate`, `stiff_gap`) take the real springs'
numbers, and the render prints the resulting curve.

## Parts

| `part` | What it is | Print |
|---|---|---|
| `housing` | Spring box and sensor tower in one | standing on its bottom |
| `cap` | The main model's spring cap | top face down |
| `guide` | Guide bushing for the plunger | flat |
| `plunger` | Rod, domed head, flange and spring spigot | flange down |
| `puck` | Puck over the sensor | seat up |
| `assembly` | Section view; `knee` sets the travel shown | — |

Hardware: the main model's return spring, crank pin, M4 rest and stop
screws with their nuts, M3 ear screws into heat-set inserts in the face;
an M3 screw through the tower's front wall, self-tapping into the guide;
the two sensor springs; a 14 mm disc of 1 mm rubber; an Interlink FSR 402.

## Assembly

1. Lay the sensor on the tower's floor, its tail out through the back slot.
2. Drop in the puck (pad down), the stiff spring in the puck's seat, the
   soft spring around it, then the plunger, flange down.
3. Press the guide down over the rod onto the flange and fix it with the
   M3 screw through the front wall.
4. Fit the return spring, cap and screws as in the main model's guide, and
   put the housing on the face, feeding the sensor's tail through the face
   into the bay.

## To do before folding it into the main model

- Check the tower against everything else on the front face, and cut a
  hole in the face for the sensor's tail behind the tongue.
- Draw the rest switch's cam on the shaft.
- Choose real springs, and check the curve against the sensors' measured
  resistance once they arrive.
- Try it: whether the progressive stack feels right, or a near-isometric
  knee (§5, way 2) is better, is a question for the bench.
