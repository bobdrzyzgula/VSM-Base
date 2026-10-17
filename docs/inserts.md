# Writing organizer inserts

Inserts (bobbin trays, tool holders and so on) are separate `.scad` files
that fit the accessory bays of a configured base. They read the bay sizes
from the base model, so an insert follows the user's settings automatically.

## The interface

```openscad
include <../scad/vsm_base.scad>   // path to the base model
part = "none";                   // render nothing from the base, and keep its console quiet

bay = [for (b = compartments) if (b[0] == "corner") b][0];
// bay = ["corner", [x0, y0, z0], [x1, y1, z1]]
```

`compartments` lists the bays present in the current configuration, each as
`[name, [x0, y0, z0], [x1, y1, z1]]` in the base's assembly coordinates:

| Name | Bay |
|---|---|
| `base` | The small compartment at the right end of the base (left out when it holds the outlet) |
| `back` | The back extension, or its freestanding box |
| `left` | The left extension, or its freestanding box |
| `corner` | The left-rear corner piece, or its freestanding box |

An extension bay is listed when the extension is part of the configuration
or its freestanding box is made (`make_back_box`, `make_left_box`,
`make_corner_box`). An insert file for a freestanding corner box can simply
set `make_corner_box = true` after the `include`. The box and the attached
extension have the same bay and the same lid.

The box is the bay's usable interior: `z0` is its floor and `z1` the
underside of its closed lid, or the top of the bay when that lid's type is
`none`. At the defaults the corner bay is 83.2 × 83.2 × 81.2 mm; it is kept
square (`corner_bay_square`), so an insert can go in either way round.

**Read only `compartments` and `lid_hinge_reach`.** Don't read any other
name from the base model; those are internal and may change. These two are
kept stable. Setting the base's ordinary Customizer settings (such as
`make_corner_box` or a lid type) is fine.

## Clearance

The bay is the exact interior, so an insert needs its own clearance, at
least 0.5 mm per side. On a hinged lid's hinge side the ledge is widened so
the open lid stays clear of the bay; `lid_hinge_reach` gives how far the open
lid's pivot edge reaches past that ledge (negative means clear, −0.5 mm at
the defaults). Read `lid_hinge_reach` directly: the console report is off
when the base file is included with `part = "none"`.
