# Harness handle

A grip for the VSM Base's carrying harness: two lengths of 1" webbing,
each from a front corner's harness rod to the opposite back corner's,
crossing over the machine. Here they cross in the handle. Both lengths
run through a tunnel along the grip, one on top of the other, and are
sewn together just outside each end. See "Carrying" in the
[User's Guide](../../docs/guide/07-assembly.md#carrying) for the harness
and its loads.

> **Not load-tested.** This handle has not been printed or used. It is
> part of an open-source hobby project, provided as is, without
> warranty, and used at your own risk. Try it with the base empty, then
> with a light machine, before trusting it with a heavy one, and don't
> carry a machine over anything (or anyone) you can't afford to have it
> fall on.

![The harness handle as carried: a grip with a ridge at each end, and a
flat tunnel through it for the webbing](harness-handle.png)

- **The webbing carries the load.** Your hand lifts the webbing through
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
and stops if a wall would be too thin.

## Making the harness

1. **Thread first.** The tunnel is closed, so pass both lengths of
   webbing through it before sewing anything else: one from each end,
   lying flat, one on top of the other.
2. **Lay it out over the machine** in its base, with the handle centered
   above the machine and high enough to clear the head and the spool pins
   (about 380 mm above the rods on the 99K base). Mark each end where it
   meets its rod.
3. **Sew the two lengths together just outside each end of the handle**,
   a bar tack or a short box-and-X, through both layers. **This is
   required, not optional.** If the webbing can slide through the handle,
   the harness is a sling over a pulley: the base can rock in it, and
   since its weight sits above the rods, it will tip. Sewn, each of the
   four legs has a fixed length, and the base hangs steady below the
   handle.
4. **Sew a snap hook into each end**, with a box-and-X stitch, at the
   marks.
5. Hang it on the rods with the base empty, lift, and check that the base
   hangs level and the handle stays put before trying it loaded. Loaded,
   the base tips until the machine's weight is under the handle; a head
   and hand wheel are heavier than the far end, so it may hang low on that
   side. If it hangs far enough off level to matter, it's better found
   now: unpick and resew with the handle moved toward the heavy end.

## The loads, worked by hand

As in the guide: a 50 lb machine in a 4 kg base, doubled for jolts, is
523 N. The handle is 154 mm long, so each leg runs from a handle end to its
corner, about 153 mm across and 380 mm up, and pulls about 141 N along
the webbing.

- *The grip.* The hand's 523 N spread under the fingers is a fraction of
  a megapascal. Taking the worst case, the hand's whole load at the
  middle and each end's 262 N at the lip, the grip bends by about
  20 N·m, about 3 MPa in a 40 × 34 mm section. That stress lies along
  the layers, against tens of MPa for PETG.
- *The lips.* Each leg presses on a 6 mm radius across the webbing's
  width: under 1 MPa.

These are estimates from simplified geometry, not measurements. The weak
points are the bought parts and the sewing: the hooks, the webbing, and
the stitching. A crack, a void, poor layer adhesion or heat can remove
most of a printed part's margin; inspect the handle, especially its ends,
before each carry.

Part of the [VSM Base](../../README.md). The harness is Robert
Drzyzgula's idea; this handle was designed, and its OpenSCAD code
written, by Claude (Anthropic) at his direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
