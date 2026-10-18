# VSM Base: printable hinged bases for vintage sewing machines

A parametric OpenSCAD model of a portable base for vintage flatbed sewing
machines, with the hinge recesses, bed seat and casting clearances worked
out from measurements of your own machine. It prints on an ordinary
desktop 3D printer, in two halves joined by dovetails and steel mending
plates.

![The base with its back, left and corner extensions](docs/images/renders/assembly.png)

## Why

A great many vintage sewing machines were sold installed in cabinets and
tables. Few people today have room for a sewing table, and a machine
without a portable base is hard to use, store or even give away, so too
many good machines end up in the landfill.

Collectors make their own bases, and a few small makers sell them. The hard
part has always been the hinge recesses and the fit of the bed, which need
careful machining, so most homemade bases are simply boxes the machine sits
in. Woodworking shops and the skills to use them are becoming rare; 3D
printers are now everywhere and cheap.

This project puts the careful part into the model. You measure the machine's
bed casting, enter the numbers, print a few small test pieces to confirm the
fit on your printer, and then print a base that fits.

## Features

- **Fitted to your casting.** The bed seat, hinge positions, hinge height and
  clearances under thickened parts of the casting are all computed from
  measurements of the bed, not copied from an old base.
- **Lollipop hinge recesses** with the pin axis checked against the bed's
  hinge holes; other hinge types can be added.
- **Prints in two halves** on a 256 mm printer, joined by dovetail keys and
  three recessed steel mending plates with captive nuts.
- **Optional side compartment**: storage; a mount for the machine's
  light-and-motor outlet with cord slots in its lid; a **knee controller**
  (draft) built around an inexpensive pedal speed-control board, with a
  geared pot, an off switch and hard stops; or a base fitted to the bed
  alone.
- **Handholds** under each end, after the original wooden bases, and steel
  rods for a carrying harness.
- **Removable extensions** that sit level with the bed: a back compartment
  and outfeed support, a left compartment and extension table, and a corner
  piece, each with a hinged or lift-out lid (solid or perforated, finger
  hole or thumb tab), and trenches so the bobbin cover can still slide open.
  Each also comes as a freestanding box with the same bay and lid.
- **Organizer inserts** for the bays: stacking bobbin trays for the corner
  bay (40 class 15/66 bobbins at the defaults), lifted out together by a
  center knob; stacking notion trays for the back or left bay in 10–30 mm
  and custom heights, plain or divided into compartments; and a spool tray
  that holds each spool with its bobbin on top. Others can be designed
  against a published list of bay sizes; see [docs/inserts.md](docs/inserts.md).
- **Test parts** for checking the fit, the joints and the hardware before
  committing to a long print.
- **Self-checking.** Every render prints the key dimensions and warns about
  problems such as a hinge pin that won't meet the bed's holes or a part too
  big for your printer.

## Status

Developed and test-printed for a **Singer 99K**, whose measurements are the
defaults. The test parts have been printed and checked in PETG; a full base
is being printed. Profiles for other machines (Singer 128, Kenmore flatbeds
and others) are welcome; see the guide.

## Quick start

1. Install [OpenSCAD](https://openscad.org) (2021.01 or later) and the
   [BOSL2](https://github.com/BelfrySCAD/BOSL2) library.
2. Open `scad/vsm_base.scad` and show the Customizer
   (*Window → Customizer*).
3. **Measure your machine's bed casting** and enter the numbers in
   *Machine bed*. The User's Guide ([measuring chapter](docs/guide/03-measuring.md)) explains each
   measurement. Don't skip this, even for a 99: castings vary.
4. Read the console output after each render (F5/F6), and fix any WARNING
   lines before going further.
5. Set `part = "test_parts"`, render, export the STL, print it, and check
   each piece against your machine and your hardware.
6. Set `printer_size` and `printer_margin` for your printer, then
   `part = "all"`: every part of the build, laid out flat in print
   orientation and grouped into plates. The console lists the plates; set
   `print_plate` to export them one at a time. `part = "exploded"` shows
   how everything goes together.

## What you need

- A printer with at least about 230 × 230 × 90 mm of build volume (the
  split 99 base halves are about 224 × 219 × 83 mm).
- PETG: roughly 2 kg for a base with a side compartment, and a few hundred
  grams for each extension. The base is about 3.4 litres of solid
  material, so the real figure depends on your walls and infill; your
  slicer will tell you.
- Hardware for the base:
  - 2 lollipop hinges
  - 3 flat steel mending plates, 4" × 5/8", countersunk for #8
    (McMaster-Carr 1394A34 or similar)
  - 12 #8-32 × 1/2" flat-head machine screws and 12 #8-32 hex nuts
    (mending plates)
  - 2 #8-32 machine screws, about 1" long, and 2 hex nuts (hinges)
  - 4 pieces of 3/16" rod, 2⅜" long (carrying harness; optional): mild steel,
    303 stainless, or lead-free brass such as 464; the hole ends are closed
    with printed plugs
  - Bed cushions, 1/16" thick when compressed

The console ends with a hardware list for your configuration, with screw
lengths rounded up to stock sizes.

## Documentation

- **User's Guide**: measuring, configuring, testing, printing and
  assembly. Each [release](https://github.com/bobdrzyzgula/VSM-Base/releases)
  carries it as a PDF and as a single HTML page that opens in any browser.
- Between releases, read the guide here: its source is in
  [`docs/guide/`](docs/guide/), one Markdown file per chapter, and reads
  directly on GitHub. Or build the PDF and HTML yourself (below).
- [`docs/guide/90-parameters.md`](docs/guide/90-parameters.md) lists every
  parameter. It is generated from the comments in the model.

To build the documentation, see the [`Makefile`](Makefile): `make params`,
`make images`, `make pdf`, `make html`, or `make docs` for both. They go in
`build/`. Both need pandoc 3.1.2 or later; the PDF also needs
[Typst](https://typst.app). A version tag (`v*`) builds both and attaches them
to a GitHub release (see
[`.github/workflows/release.yml`](.github/workflows/release.yml)).

## License

MIT; see [LICENSE](LICENSE). Copyright © 2026 Robert Drzyzgula.
