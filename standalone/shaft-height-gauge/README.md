# Shaft height gauge

A small printed slide gauge for measuring from a floor up to the underside
of a shaft, in a space too cramped for calipers, such as inside a sewing
machine's arm casting.

![The gauge set at 20 mm under a shaft](shaft-height-gauge.png)

- **The base** is a foot that stands on the floor, with an upright rail.
  The rail is engraved in millimeters on both faces, 12–32 mm by default,
  with numbers every 5.
- **The slider** rides the rail, and its flat arm reaches sideways under
  the shaft. A sprung tongue cut in its back wall presses on the rail, so
  the slider stays wherever it's left.

## Using it

1. Set the gauge on the floor beside the shaft, slider down, with the arm
   pointing under the shaft.
2. Push the slider up by its back tab, with a pick, until the arm just
   touches the shaft.
3. The reading is the scale mark level with the slider's top edge, which is
   level with the arm's top face. Read it in place, with a dental mirror if
   need be.

Because the friction holds the slider, you can also lift the gauge out and
measure from the bottom of the foot to the top of the arm with calipers.
That gives the better number. Rubbing a fine marker into the engraved
ticks and wiping the surface makes them much easier to read.

All in one self-contained OpenSCAD file, `shaft_height_gauge.scad`, with
no libraries needed. Its `part` setting gives `base`, `slider`, or
`assembly` to see them together.

## Printing

Print the base standing up, on its foot; it needs no supports.

Print the slider upright, sleeve on the bed, as the model's `slider` part
gives it, with tree supports under the arm, using support interface
material if your printer has it. Upside down, which the first version of
these notes suggested, doesn't work: the friction tongue is cut free of
the sleeve's wall on three sides, so it would be an island in mid-air for
most of its height. No orientation avoids every unsupported cantilever,
and with tree supports the slider prints cleanly.

## Settings

- **`foot`**: the foot's size (16 × 12 × 2 mm). Make it smaller to fit
  between ribs on the floor.
- **`rail`**, **`rail_h`**: the rail's section and height (34 mm). Lower it
  if the space beside the shaft is short.
- **`slider_len`**: the slider's length. The smallest reading is the foot's
  thickness plus this.
- **`arm_len`**, **`arm_w`**, **`arm_t`**: the arm's reach, width and
  thickness.
- **`grip`**: the friction tongue's interference (0.35 mm). Raise it if
  the slider is loose, lower it if it's stiff.
- **`scale_from`**, **`scale_to`**: the range of the scale.

## First use

On a Kenmore 158 (October 2026), it measured 20 mm from the arm casting's
floor to the underside of the arm shaft, and calipers on the removed gauge
agreed.

Spun off from the [VSM Base](../../README.md). Robert Drzyzgula proposed
the gauge and tested it; the design and the OpenSCAD code were written by
Claude (Anthropic) at his direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
