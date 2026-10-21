# Tilt prop

A stand that holds a sewing machine tipped back in its base. Stand it on
the table behind the base and tip the machine back onto it: its top
catches the machine's arm, or some other solid part, so the machine stays
put while you oil it or work on the mechanism underneath, with both hands
free. The machine's weight goes into the table through the prop, instead
of tipping the base up.

![Two tilt props: a cradle for a round arm, and a flat top sloped
20°](tilt-prop.png)

- **The top** is a cradle, for a round arm, or flat. Either can slope, to
  meet a part that comes to rest at an angle. The top turns about its
  width axis (the cradle's axis), rising toward the back.
- **The foot** is sized for stability. A load on the top, pressing square
  to it, can lean a further `stability_angle` (15°) either way before its
  line passes the foot's edge. So neither a knock nor a sloping top will
  tip the prop over. A sloping top gets a longer foot.
- **Two tapered legs**, front and back, carry the top. The opening between
  them is gabled, so the prop prints upright without supports.

All in one self-contained OpenSCAD file, `tilt_prop.scad`, with no
libraries needed.

## Settings

- **`height`**: from the table to the cradle's bottom, or to the middle of
  the flat top's surface. To find it, tip the machine back to where you
  want it, check the angle with a level or a tilt gauge, and measure from
  the table to the part that will rest on the prop. The default, 6", suits
  a Singer 99K at 90°.
- **`top`**: `cradle` or `flat`.
- **`cradle_r`**: the cradle's radius, the arm's radius plus a little
  (1" for a 99K, whose arm is 1.75–2" across there). `cradle_clear` adds a
  further 1 mm.
- **`width`**: along the arm, 1.5" by default, narrow enough to keep clear
  of anything else on the machine.
- **`flat_length`**: the flat top's length, front to back.
- **`slope`**: degrees from level, rising toward the back (negative:
  toward the front).
- **`stability_angle`**, **`foot_t`**, **`leg_t`**.

Line the top with felt or cork. Print standing on the foot; 15% infill is
plenty.

Spun off from the [VSM Base](../../README.md), whose main model also makes
this prop, sized from its machine profiles, as part `tilt_prop`.

Designed by Robert Drzyzgula; the OpenSCAD code was written by Claude
(Anthropic) at his direction. MIT license; see the [LICENSE](../../LICENSE)
in the main project.
