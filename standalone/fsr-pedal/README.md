# Force-sensing foot pedal (draft)

*Drawn by Claude at Bob Drzyzgula's direction, November 2026. A draft to
print and try; it has not been printed or tested.*

> **Research use only: not a safe, buildable design.** The motor-control
> circuits, schematics, enclosures, mechanisms, test procedures and software
> in this project have not been safety-designed, safety-validated,
> certified, or tested as a complete appliance. None of the controller
> designs should be built or connected to the mains as drawn, and none
> should be operated. A concept drawing, simulation, component listing,
> historical example or commercial component is not evidence of compliance
> or safety; printed plastic is not an assessed insulation system or fire
> enclosure, and a barrier drawn on a schematic is not proof of isolation.
> The work is meant to support understanding of how existing and historical
> controls work and what hazards they carry, and to guide the development of
> safer alternatives.
> It is personal learning done in public, not a product, and anyone who
> uses or builds on any of it does so on their own responsibility.
> Any future buildable design would need a new system-
> level engineering assessment, independent review, qualified
> implementation, complete-product testing and applicable certification;
> `docs/VALIDATION.md` lists what that would cover. The pedal is meant to
> carry only low voltage, but that depends entirely on the isolation of the
> controller it plugs into, which exists only as an unbuilt design.

A low-voltage foot pedal built around an Interlink FSR 406 (UX series,
0.5–150 N). It is passive: the sensor, a 470 Ω resistor in series, and a
two-conductor shielded cable to a jack on the base. It is designed for the
analog controller in the design study *An Analog Force-Sensing Knee
Controller* (`docs/analog-knee/`, §6), where it runs in parallel with the
knee lever's sensor. It is meant to carry only low voltage: no mains, provided the controller's isolation holds.

![The pedal assembled, tread shown translucent: the sensor (gold) on the
pedestal, its board (green) behind it, the puck over the sensor's center,
the springs near the toe and the hinge at the heel](fsr-pedal-assembly.png)

## How it works

- **The tread** is hinged at the heel on an M4 bolt or a 4 mm rod and
  slopes up toward the toe (about 8°). A puck under it, 22 mm across and
  faced with a 1.5 mm rubber pad, sits 0.8 mm above the sensor's center at
  rest, where the ball of the foot falls.
- **The pedestal** is a rigid block on the base's floor. Its top, parallel
  to the tread, holds the sensor in a shallow seat and the board in a
  pocket beside it on the same plane, so the sensor's tail lies flat and
  never bends. The sensor sits on a flat, rigid surface, as Interlink
  asks, and its vent, at the end of the tail, stays open.
- **Two springs** near the toe hold the tread up, carry a resting foot and
  return the tread. The sensor feels only the push beyond them.
- **Two stop posts** beside the pedestal take the load once the tread has
  moved 2 mm at the puck (1.2 mm of pad compression). That caps the force
  on the sensor, so a stamp can't crush it.
- **The cable** leaves the board through a slot in the pedestal and exits
  through the heel wall, under the hinge. Strain-relieve it inside the
  base (a cable tie through the slot will do).

![The base: the pedestal with the sensor's seat, the tail channel and the
board pocket with its two inserts; the spring cups and the stop posts;
the hinge knuckles at the heel](fsr-pedal-base.png)

![The tread, as printed, top face down: the puck, the spring bosses, the
skirt and the hinge knuckle](fsr-pedal-tread.png)

## Printing

- `part = "base"`: as modeled, floor down. No supports.
- `part = "tread"`: top face down, as the part setting places it. The
  knuckle sits on the bed. No supports.
- PETG or PLA; the tread takes the foot's load across its whole span, so
  give it 4 or more walls and 30% infill or more.

## Hardware

| Part | Qty | Notes |
|---|---|---|
| Interlink FSR UX 406, solder tabs | 1 | Interlink 34-00130 |
| Perfboard, about 35 × 25 mm | 1 | |
| 470 Ω resistor | 1 | In series with the sensor, on the board |
| M3 × 6 screws and M3 heat-set inserts | 2 | Hold the board |
| Compression springs, 9.5 mm OD, about 19 mm free | 2 | Rate to taste; they set how much foot the pedal ignores |
| M4 × 130 bolt and nut, or a 4 mm rod cut to 115 mm | 1 | Hinge pin, through all the knuckles |
| Rubber pad, 1.5 mm, 22 mm disc | 1 | Glued to the puck's face |
| Rubber feet, 12 mm | 4 | In the recesses under the base |
| Two-conductor shielded cable, with an RCA or 6.35 mm mono plug | 1 | Shield to 0 V |

## Settings worth knowing

| Setting | Default | What it does |
|---|---|---|
| `len_x`, `wid_y` | 190, 115 mm | The pedal's footprint |
| `h_heel`, `h_toe` | 22, 50 mm | Tread height at each end; sets its slope |
| `sensor_x` | 128 mm | Where the sensor sits, from the hinge: under the ball of the foot |
| `puck_d` | 22 mm | The loaded area; keep it 20 mm or more for the sensor's current limit |
| `gap`, `stop_travel` | 0.8, 2.0 mm | Puck-to-sensor gap at rest, and travel to the stops |
| `board` | 35 × 25 mm | The board pocket |
| `spring_od`, `spring_free`, `spring_preload` | 9.5, 19, 4 mm | The return springs |
| `cable_d` | 5 mm | The cable's exit hole |

The console reports the tread's slope, the sensor's height and the
board's position. `press` in the assembly view shows the tread pressed
(up to `stop_travel` at the puck).

## Still to settle

- **The springs.** Their rate decides how much of a resting foot the
  pedal ignores. Start soft and try.
- **The pad.** Its hardness and the stop travel together set the largest
  force the sensor sees before the stops take over, and so where full
  speed falls. Try a few pads with the sensor and a meter before the
  circuit is built.
- **Feel.** It is a near-isometric pedal: the tread moves a couple of
  millimeters, and speed follows how hard you press, not how far. Whether
  that suits a given sewist is for the bench.
