# Bobbin box

A small lidded box that holds 40 class 15 or class 66 bobbins on five
stacking trays, eight to a tray. A knob on the bottom tray's center column
lifts the whole stack out at once, and every bobbin can be seen from the
side. The lid is hinged on two snap-in dimple hinges and leans back open at
about 135°, or it can be a plain lift-out plate.

![The bobbin box (part `assembly`)](bobbin-box.png)

It is the corner bay and bobbin trays of the [VSM Base](../../README.md)
made into a freestanding box, in one self-contained OpenSCAD file,
`bobbin_box.scad`. You don't need the main model to make it.

- **Size:** about 95 × 97 × 88 mm at the defaults. The box grows with the
  number of trays and the bobbin size, and the console reports the size.
- **Settings:** the number of trays, the lid type, the bobbin's diameter
  and thickness (any round bobbin), the gap between bobbins, the walls,
  the lid fit, the hinge and the thumb tab.
- **Parts:** `box`, `lid`, `bottom_tray`, `upper_tray` (print trays − 1 of
  them), `all`, and two test parts: `test` (one cell of each tray, to try
  a bobbin on its post and the pin in its socket) and `hinge_test` (the back
  of the box and a strip of the lid, to try the hinge).
- **Printing:** no supports. Print the box upright, the lid top face down
  and the trays floor down.
- **Needs:** OpenSCAD and the [BOSL2](https://github.com/BelfrySCAD/BOSL2)
  library.

The trays are the same design as the VSM Base's, which have been printed
and used in PETG. The freestanding box itself has not been printed yet.

Designed and tested by Robert Drzyzgula; the OpenSCAD code was written by
Claude (Anthropic) at his direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
