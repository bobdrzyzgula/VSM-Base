# Harness handle

A grip for the VSM Base's carrying harness: two lengths of 1" webbing,
each from a front corner's harness rod to the opposite back corner's,
crossing over the machine. Here they cross in the handle. Both lengths
run through a tunnel along the grip, one on top of the other, and are
sewn together just outside each end. See "Carrying" in the
[User's Guide](../../docs/guide/07-assembly.md#carrying) for the harness
and its loads.

> **Experimental: do not carry a machine with it.** This handle has not
> been printed, and no harness using it has been made or load-tested.
> Don't carry a machine with it until the complete assembly (handle,
> webbing, stitching, slides and the base's rods, as built) has passed a
> proof-load test and been inspected; "Before any use" below outlines that
> test, and the VSM Base's `docs/VALIDATION.md` what more would be needed.
> The figures here are illustrative arithmetic, not a load rating. It is
> part of an open-source hobby project, personal learning done in public,
> not a product; it is provided as is, without warranty, and anyone who
> makes or uses it does so on their own responsibility.

![The harness handle as carried: a grip with a ridge at each end, and a
flat tunnel through it for the webbing](harness-handle.png)

- **The webbing is meant to carry the load.** Your hand would lift the webbing through
  the grip's floor, so the plastic is mostly in compression. The tunnel's
  ends are rounded where the webbing turns down toward the corners (top
  and bottom, so the handle works either way up) and at the sides, where
  the lengths leave toward the front and the back.
- **A ridge at each end** keeps the hand off those turns.
- **Sized for a large hand:** 130 mm between the ridges, and a 40 × 34 mm
  grip.
- **Prints on its side, with no supports.** The tunnel stands on edge, so
  its roof is a 5 mm bridge, and the hand's load lies in the layers. The
  long edges on the bed side are 45° chamfers, not rounds, so they don't
  droop. PETG, 4 walls, 25% infill or more.

All in one self-contained OpenSCAD file, `harness_handle.scad`, with no
libraries needed.

## Settings

- **`webbing_w`**, **`webbing_t`**, **`layers`**: the webbing's width,
  one layer's thickness (measure yours: 1" nylon or polyester is about
  1.2 to 2 mm), and how many layers pass through (two). **`tunnel_clear`**
  is added to the tunnel's width and height.
- **`grip_length`**: the length for the hand, between the ridges.
- **`grip_h`**, **`grip_w`**, **`grip_r`**: the grip's height and width
  as carried, and the radius of its long edges.
- **`ridge`**, **`ridge_len`**: how far the end ridges rise above and
  below the grip, and their length.
- **`lip_r`**, **`side_r`**: the radii the webbing turns over at the
  tunnel's top and bottom edges, and at its sides.
- **`orientation`**: `print` lays it on its side; `carried` shows it as
  used.

The console gives the overall size, the tunnel, and the walls round it,
and stops if a wall would be too thin. Those are geometry checks only; the
model knows nothing about loads, and no setting makes it rated for any.

## Making a harness to test

This is how one would be made for testing, not a carrying procedure.

1. **Thread first.** The tunnel is closed, so pass both lengths of
   webbing through it before sewing anything else: one from each end,
   lying flat, one on top of the other.
2. **Lay it out over the machine** in its base, with the handle centered
   above the machine and high enough to clear the head and the spool pins
   (about 380 mm above the rods on the 99K base). Leave each end about
   150 mm longer than it takes to reach its rod, for the loop and a tail.
3. **Sew the two lengths together just outside each end of the handle**,
   a bar tack or a short box-and-X, through both layers. **This is
   required, not optional.** If the webbing can slide through the handle,
   the harness is a sling over a pulley: the base can rock in it, and
   since its weight sits above the rods, it will tip. Sewn, each of the
   four legs has a fixed length, and the base hangs steady below the
   handle.
4. **Fit each end to its rod.** Put a metal three-bar slide (1", a
   "tri-glide", with a working-load rating from its maker) on the leg
   first. Then feed the end into the rod's notch
   over the rod, down behind it and out underneath, bring it back up
   beside the leg, and thread it through the slide as its maker shows,
   so that the leg's pull pinches the tail against the center bar. Seal
   the cut end with heat, and leave at least 50 mm of tail beyond the
   slide (a provisional figure; a slip test should set it). The slide should sit above the base's top. The base's notches
   have to be the version 88 ones (32 mm long, 5 mm round the rod); the
   earlier 25 mm notch is too short for 1" webbing.
5. **Adjust and mark.** Hang it with the base empty, lift an inch or two,
   and set the four legs so the base hangs level and the handle is
   centered. With a machine in it the base tips until the machine's
   weight is under the handle, and a head and hand wheel make one end
   heavier, so level it again loaded. Then mark the webbing with a pen
   on both sides of each slide, leg and tail. A mark that has moved means
   something changed (slip, stretch, a seam settling, a slide bending):
   find out which before lifting again.

## Before any use: what a proof-load test would involve

None of this has been done. At the least:

- **Test the assembly, not the parts.** The handle as printed, the
  webbing and stitching as sewn, the slides as bought and threaded, on a base with its
  rods, hung from a fixed point, not a hand.
- **Load it with dead weight, not a machine:** well above the heaviest
  machine and base it will carry, by a factor taken from lifting practice
  (synthetic slings, for example, are commonly proof-tested at twice their
  rated load and designed to five times it), not the 2× used for
  illustration below. Hold it, a few centimeters over a padded floor, with
  nobody under or beside it.
- **Then inspect:** the seams for pulled or broken stitches, the marks
  at the slides for any creep, the slides for bending, the webbing for
  cuts, glazing or wear where it wraps the rod, the handle's
  ends and lips for whitening or cracks, and the rods and notches for
  bending or crushing. Anything changed fails the test.
- **And the things a static hang doesn't show:** a jolt or short drop,
  the loss of one leg (the base then swings and tips: the test should show
  how far), a twisted leg, repeated lifts, a warm car, and aging of the
  webbing and the print.

Passing would show only that that one assembly held that load once. It
would not make the design rated, and each new harness would need its own
test.

## The loads, worked by hand

These are illustrative estimates from simplified, static geometry, not a
load rating. As in the guide: a 50 lb machine in a 4 kg base is 262 N;
doubled, an arbitrary illustrative allowance for jolts and not a proof or
design factor, it is 523 N. The handle is 154 mm long, so each leg runs from a handle end to its
corner, about 153 mm across and 380 mm up, and pulls about 141 N along
the webbing.

- *The grip.* The hand's 523 N spread under the fingers is a fraction of
  a megapascal. Taking the worst case, the hand's whole load at the
  middle and each end's 262 N at the lip, the grip bends by about
  20 N·m, about 3 MPa in a 40 × 34 mm section. That stress lies along
  the layers, against tens of MPa for PETG.
- *The lips.* Each leg presses on a 6 mm radius across the webbing's
  width: under 1 MPa.

These are estimates, not measurements, and say nothing about a dropped
or swung load, one leg lost, fatigue, creep or heat. In this arithmetic
the weak points are the bought parts and the sewing: the slides, the
webbing, and the stitching. A crack, a void, poor layer adhesion or heat can remove
most of a printed part's margin; inspect the handle, especially its ends,
before each carry.

Part of the [VSM Base](../../README.md). The harness is Robert
Drzyzgula's idea; this handle was designed, and its OpenSCAD code
written, by Claude (Anthropic) at his direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
