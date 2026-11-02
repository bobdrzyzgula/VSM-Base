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
  the lid fit, the hinge and the thumb tab, and an image on any face (below).
- **Parts:** `box`, `lid`, `bottom_tray`, `upper_tray` (print trays − 1 of
  them), `all`, and two test parts: `test` (one cell of each tray, to try
  a bobbin on its post and the pin in its socket) and `hinge_test` (the back
  of the box and a strip of the lid, to try the hinge).
- **Printing:** no supports. Print the box upright, the lid top face down
  and the trays floor down.
- **Needs:** OpenSCAD and the [BOSL2](https://github.com/BelfrySCAD/BOSL2)
  library.

## Images on the faces

Any of the six faces can carry an SVG image, centered on it: the front,
back and two ends, the bottom, and the lid's top. It works like the logos on
the VSM Base's front face.

![Inlaid images on the front, the right end and the lid, using the
project's example logo. Each image and the body has its own random color
tag.](bobbin-box-images.png)

- **Choosing the images.** Set `img_front`, `img_back`, `img_left`,
  `img_right`, `img_bottom` and `img_lid` to an SVG's path, relative to
  `bobbin_box.scad`; leave a face `""` for none. Each image is stretched to
  its `…_size`, width and height, so set that to the image's own
  proportions. Every image reads correctly seen from outside its face. The
  bottom's reads with the box tipped over backward, its front edge at the
  top.
- **Raised, engraved or inlaid.** `img_relief` sets all of them: `raised`
  stands `img_depth` (0.6 mm) proud of the face, `engraved` cuts it in, and
  `inlaid` cuts it in and fills the recess flush with a separate part.
- **Colors.** Raised and inlaid images are color-tagged for a second
  filament. The body (box and lid) gets one random color, and each image
  gets its own: up to six in the box (the body and five faces) and two in
  the lid. They are spaced evenly round the color wheel, so no two are
  alike; `color_seed` picks another set. The console lists them. The colors
  only tell the parts apart; you choose the actual filament for each in the
  slicer.
- **Export as 3MF, not STL,** to keep the color tags: Bambu Studio and Orca
  open it as a multi-color part and ask which filament each color gets. STL
  merges everything into one color. Color-tagged 3MF export needs a recent
  OpenSCAD with the Manifold backend; 2021.01 doesn't write the tags.
- **Where a second color is practical.** The lid and the bottom print face
  down, so an inlaid image there is in the first few layers, and only those
  layers change filament. That suits a single extruder with an AMS too. The
  four sides print standing, so an image on any of them runs up through
  dozens of layers, and every one of those layers changes filament. On a
  single-nozzle printer that means a purge for each change, a great deal of
  waste, and hours added; it is realistic only on a printer with several
  toolheads. Engraved images on the sides, or images in the body's color,
  avoid it.
- **Raised images** on the bottom or the lid land on the print bed, and on
  the bottom they stop the box sitting flat, so use engraved or inlaid
  there; the console says so.
- **SVGs** must be clean outlines: text converted to paths, overlapping
  shapes merged, no path crossing itself, and no invisible frames or
  unfilled rectangles. OpenSCAD ignores fill and stroke, so an invisible
  shape imports as a solid block. The VSM Base guide's section on the ruler
  and logos has more.
- **Fit.** The console warns when an image is larger than its face (inside
  the round-overs), when the front image reaches the thumb scoop, when the
  lid's runs into the hinge's flex slots, and when `img_depth` cuts too deep
  into the floor, lid or walls.

The images have not been printed yet.

The trays are the same design as the VSM Base's, which have been printed
and used in PETG. The freestanding box itself has not been printed yet.

Designed and tested by Robert Drzyzgula (images on the faces at his
request, November 2026); the OpenSCAD code was written by
Claude (Anthropic) at his direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
