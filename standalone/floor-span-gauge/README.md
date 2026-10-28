# Floor span gauge

A small printed sliding gauge for measuring the clear floor between two
ribs, in a space too cramped for a rule or calipers, such as the casting
floor under a sewing machine's arm shaft. It was made for the Kenmore 158,
where a 4" rule won't reach the floor under the shaft.

![The gauge set at 36 mm: the white body with its back jaw on the left, the
dark slider coming out to the right](floor-span-gauge.png)

- **The body** is a low channel that lies on the floor. Its closed back
  end is one jaw, and its open front end is the reading edge.
- **The slider** is a flat bar in the channel, and its front end is the
  other jaw. It carries the scale: millimeters along one edge, numbered
  every 5, and inches along the other, in sixteenths, labeled at the
  quarters as 1.25, 1.5 and 1.75. Every line in the scale is at least
  0.5 mm wide, and the lettering is thickened to match, so a slicer keeps
  it. A spring beam along one side presses on the channel wall, so
  the slider stays wherever it's left.
- **It reads 28–46 mm (1.10–1.81")** by default.
- **It's 3.5 mm tall,** lower than the 158's 4 mm ribs, so both jaws meet
  the ribs' faces rather than riding up over them. Each jaw's lower edge is
  chamfered, so a cast fillet at a rib's foot doesn't hold the jaw off.
- **It's 17 mm wide,** so it fits inside a 1¼" bay whichever way it's
  laid.

## Using it

1. Lay the gauge on the floor, closed, with the body's back against one
   rib.
2. Push the slider out with a pick in the hole near its tail, reached
   through the channel's open top, until its front end meets the other rib.
3. The reading is the mark level with the body's front edge. It reads
   upright with the body on the left, and the numbers rise toward the body.

Measure the bay in each direction separately. Left in place, it can be
photographed from a level camera on a tripod. You can also lift it out
without disturbing the slider and measure across the jaws with calipers,
which gives the better number.

## Printing

Print both parts flat, as the model gives them. Neither needs supports.
The body prints channel up; its lips overhang the channel by only 0.6 mm.

For contrast, print the body in one color, and the slider in a dark color
with light markings (or the reverse). The scale stands 0.4 mm proud of the
slider's top face:

- **With several filaments,** export the `slider` part as 3MF, not STL.
  Its bar and scale are colour-tagged (black and white), so Bambu Studio
  and Orca open it as a two-colour part and ask which filament each gets.
  (Bob Drzyzgula's tip.) The `slider_marks` part, the scale alone in the
  slider's coordinates, is there for a slicer or a workflow that wants them
  as separate files.
- **With one extruder,** print the slider face up and change filament at
  the first layer above the face (in Bambu Studio, add a filament change at
  that layer in the layer slider). That is z = 1.7 mm with the default
  `slide_t`.

## Settings

- **`slide_len`**, **`overlap`**: the slider's length, and how much of it
  stays in the channel at full stretch (8 mm). The range runs from the
  body's length (`slide_len` plus the 2 mm back wall) to that plus
  `slide_len − overlap`. A longer slider reaches farther, but closes longer
  too.
- **`slide_w`**: the slider's width (14 mm). The body is 3.2 mm wider.
- **`grip`**: the spring beam's interference with the wall (0.3 mm). Raise
  it if the slider is loose, lower it if it's stiff.
- **`clr`**: the clearance round the slider (0.2 mm).
- **`chamfer`**: the chamfer on each jaw's lower edge (0.8 mm).
- **`mark_h`**, **`text_size`**: the scale's height and lettering size.
- **`line_w`**: the narrowest line in the scale (0.5 mm). Keep it at or a
  little over your nozzle's width. The first print, with 0.3 mm lines and
  unthickened lettering, sliced to scattered blobs.

All in one self-contained OpenSCAD file, `floor_span_gauge.scad`, with no
libraries needed. Its `part` setting gives `body`, `slider`,
`slider_marks`, or `assembly` to see them together at `show_at`.

*Designed by Claude at Bob Drzyzgula's direction, October 2026. Printed
by Bob in PLA (orange body, black slider with a white scale, as a
two-colour 3MF), October 2026; not yet used in a machine.*
