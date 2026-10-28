# Optical shaft encoder: a concept

*Drawn by Claude at Bob Drzyzgula's direction, October 2026. A concept
to look at and argue with. It is not a finished design and has not been
built.*

This is the optical alternative from the motor-control paper's "Fitting the
encoder" (§11), sized for a Kenmore 158's arm shaft. The shaft measures about 12.25 mm
(an earlier, rougher figure was 11 mm), and its underside is 20 mm above
the casting floor, measured with the gauge below and confirmed with
calipers, which puts the axis about 26.1 mm up. The
measurements behind it are about 5–10 mm of clear shaft at the candidate
spots, with room for a ring of up to about 40 mm diameter (50 mm in places).
`optical_encoder_concept.scad` models it. Its parts are `assembly` and
`exploded`, and the printed parts: `ring_half` and `ring_half_bottom`, the
`insert_cradle` for pressing in the inserts, and the `saddle` that carries
the forks.

![In place: the slotted ring on the shaft, and the two forks and the Hall
switch in the saddle on the casting floor below it](enc_iso.png)

## How it works

**The ring** is a printed disc, 40 mm across, with 36 open-ended slots
around its rim, like a comb. It is split through the shaft's axis, so the
two halves clamp on from either side without taking the shaft out. Two M2
screws run across the split, through a hub on one side of the disc. The
split falls in a slot, so no tooth is cut. The hub is the part that grips,
and it could equally clamp over an existing collar. Hub and disc together
are about 7 mm long along the shaft.

**The forks** are two slotted photo-IC interrupters, each with an infrared
LED in one arm and a detector with a logic output in the other. The disc's
rim runs through their slots, so each one sees the light cut on and off as
the teeth pass. The two forks are 42.5° apart, which is 4¼ slot pitches.
That puts their signals a quarter-cycle out of step: quadrature. The order
in which the two change gives the direction, and counting every edge of
both gives four counts per slot, **144 counts a turn, 2.5° each**. A
12-magnet Hall ring gives 24.

**The index** comes from a Hall switch working alongside the optics, as Bob suggested, and it works well. One magnet
sits in a small boss on the disc's face, inside the radius the forks reach,
and a Hall switch on the saddle reads it once a turn from about a
millimeter away. Mixing the two technologies has two advantages. The index
doesn't depend on the optics staying clean. And because the index comes
round once a turn, the firmware can check that the count is still 144
since the last index. If it isn't, a fork is fouling or missing edges, and
the controller can say so instead of stopping in the wrong place.

**The saddle** is a low printed block that sits on the casting floor
under the ring. Under the shaft of a Kenmore 158 there is only about 20 mm,
and the ring's teeth come within about 6 mm of the floor, so there is no
room for a bracket hanging from anything. The floor itself is the mount.

- **Its top is an arc** 1 mm outside the tooth tips. At the bottom it is
  about 5 mm above the floor, and it rises to at most 10 mm at the sides.
- **The forks sit in pockets** in that arc, at ±21.25° from straight down.
  Their bodies are sunk in, and their arms stand up round the rim. Each
  fork's leads go out through a hole under its body, bend toward one end,
  and leave along a channel in the underside. The model reports the room
  under the bodies for that bend, about 2.9 mm with the generic fork; it
  calls it tight below 2 mm.
- **A finger rises beside the disc** to carry the Hall switch about 1 mm
  from the magnet, with its own lead groove and channel.
- **Nothing is screwed.** The ring's position is set by the shaft, so only
  the saddle's place on the floor needs setting, and that is done by eye.
  Fit the ring through the forks, and turn it by hand. Slide the saddle
  until the disc runs centred in both forks' slots all the way round. Then
  fix the saddle with beads of hot glue or RTV along its edges, which peel
  off later. Foam tape also works: set `mount_gap` to its thickness.
- **Its height comes from the measurement.** `axis_h`, 26.1 mm, is the
  shaft's axis above the floor (20 mm to the underside plus half the
  shaft). If the forks sit too deep or too shallow over the teeth, change
  it and reprint.
- **Ribs and the spring are cut away** with `keepouts`, a list of boxes
  measured from the floor. It is empty until the ribs and the spring are
  measured.

![The saddle in print orientation: underside on the bed, the fork pockets
open upward, the Hall finger standing beside where the disc runs. The lead
channels are in the underside.](enc_saddle.png)

![Looking along the shaft: the forks at ±21.25° below it, the Hall finger
between them, the saddle on the floor](enc_end.png)

## Cleaning

The slots are open at the rim, so a brush or a puff of air clears them.
Once the top cover is off, the forks' slots face the shaft and can be
reached. The ring comes off with two screws, and the forks lift out of
their pockets. Nothing here holds oil. A wipe of the forks and ring can
then join the regular oiling and cleaning.

![Exploded: the two ring halves, the shaft, and the saddle with the forks
and Hall switch, above the floor](enc_exploded.png)

## What the concept does not settle

- **The fork part.** The model's fork is generic: 10 mm along the shaft,
  4.5 mm across, a 3 mm slot 6 mm deep. Real photo-IC interrupters vary.
  The one chosen fixes the pocket sizes, and its aperture fixes how fine
  the slots can be. A single dual-channel fork, with both detectors in one
  body, would save space and fix the quadrature spacing. It would also need
  the slot pitch to match its detector spacing.
- **Axial room at the rim.** The forks are longer along the shaft than the
  ring is thick, so the room that counts is the clear length at the ring's
  outer radius, not only at the shaft.
- **Supply and leads.** The LEDs draw 10–20 mA each, so they run from 5 V
  with a resistor each. The lead path inside the casting, clear of moving
  parts, is per machine.
- **Runout and end play.** The disc must stay centered in a 3 mm slot
  through a full turn, and its teeth must stay over the apertures. Checking
  the saddle's placement against the shaft's actual play is a job for the
  bench.
- **Slot count.** 36 slots at 40 mm leaves teeth and slots about 1.6 mm
  wide at the apertures. More slots need a finer aperture, a larger ring,
  or both.

## Measuring tools

Two printed tools made for fitting this encoder are useful well beyond it,
so they live with the other standalone projects:

- [`standalone/shaft-height-gauge/`](../../standalone/shaft-height-gauge/):
  a slide gauge for the height from the casting floor to the underside of
  the shaft. On the Kenmore 158 it read 20 mm, confirmed with calipers.
- [`standalone/shaft-fit-collars/`](../../standalone/shaft-fit-collars/):
  snap-on test collars for finding the bore. On the 158, 12.25 mm stayed
  put but turned under a couple of ounces, 12.5 mm spun freely, and
  12.0 mm went on only with force, so the ring's `ring_bore` is 12.25 mm.

## Assembling the ring

**Print the ring halves with the finest layers your printer does well**
(0.12 mm has worked). The screw and insert holes run across the layers
when the halves print flat, so they come out round only with thin
layers. On parts this small it adds only a few minutes.

The clamp screws are M2 socket-head cap screws through the top half, into
**M2 heat-set inserts** (M2 × 4 × 3.5) in the bottom half. The inserts go
in on the bench, so nothing small has to be handled inside the machine.
`clamp_fastener = "nut"` gives the earlier nut traps instead.

1. Print `insert_cradle`. Set the bottom half in it, split face up; the
   face sits level with the cradle's top, and the cradle supports the hub
   right under the insert holes. The half rests on its hub, with the teeth
   hanging clear, and one thin rib in the disc's pocket, with a pointed
   lead-in, sits in the slot straight below the bore, so the half can't roll
   while one insert is pressed. Lower the half straight down onto the rib.
   (The first cradle let the half bottom on its teeth, 0.4 mm low, and roll
   under the iron. The second had ribs in three slots; the two off the
   vertical met their slots at an angle as the half dropped in, and broke
   teeth.)
2. Press the two inserts in from the split face with the iron, square to
   the face, and let them cool before lifting the half out.
3. In the machine, swivel the bottom half around the shaft through the
   forks first, then add the top half and drive the screws, evenly, until
   the ring just stops turning.

Screws from M2 × 11 to M2 × 16 work: the hole runs on through below the
insert, so a longer screw passes out the far side instead of bottoming. The
hub was widened from 22 to 25 mm to leave enough plastic around the inserts.
