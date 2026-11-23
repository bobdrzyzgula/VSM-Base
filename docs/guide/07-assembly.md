# Assembly

*This chapter is an outline, still to be written. It will cover:*

- Clearing the membranes and knock-out walls.
- Nuts into the plate and hinge nut traps.
- Joining the halves: dovetails, then the mending plates from below.
- Tip: once the nuts are in their traps in the cavity floor, put a strip of
  masking tape over them. Then they stay put when you turn the base over to
  drive the plate screws in from below; peel the tape off afterward.

![The joined halves from below: three mending plates across the split,
each with four 1/2" #8-32 flat-head screws.](../images/photos/plates-underside.jpg){width=80%}

![Inside, the screws' nylon-insert locknuts sit in their traps in the
cavity floor, either side of the dovetail keys. The screws push through the
traps' printed membranes; no drilling needed.](../images/photos/plate-nuts.jpg){width=70%}

- Installing the hinges and setting the machine on its pins.
- The hinge nuts (lollipop hinges): the nut traps open on the underside. Push a nut onto the
  tip of the printed nut tool (`part = "hinge_nut_tool"`), nylon side
  first for a locknut, slide it up the trap until it seats, and hold it
  there while you start the screw from above; once the screw has caught,
  pull the tool out and finish. The tip is sized for the 1/8" bore of a
  nylon-insert locknut (`hinge_nut_tool_tip`). A standalone version for other nut sizes
  and trap depths is in `standalone/nut-tool/`.
- Printed hinges: cut the pins and pivots to the console's lengths and
  deburr them. Press a pin into each arm's front face to the bottom of its
  hole (a vise works). Slide a nut into the slot in each block's front
  face, under the arm's channel, until it lines up with the screw hole. Set
  the arm between the block's cheeks and press the pivot rod through cheek,
  arm and cheek until its ends are flush with the block's sides, with the
  arm's engraved arrow on its bottom face, pointing toward the pin (the arm
  isn't symmetrical top to bottom); the arm should swing freely. Drop the block into its recess, pin toward the bed;
  the recess's front wall closes the nut's slot. Drive the screw (#8-32 ×
  5/8", pan or socket head) up from under the base, through the round
  counterbore (its head bears on the counterbore's roof; push it through
  the printed membrane), into the block's nut. The recess walls
  keep the pivot rod from working out.
- Trim strips, with the extensions off: tap the peg inserts into the
  trims' holes, as into the lips, and press the trims into the rim cuts.
  The cord slot's trim presses into the top of the slot once the cords are
  in.
- Outlet cords through the walls: with the outlet in place, lay each cord
  down into its wall slot (with `rear`, press the controller cord on edge
  into the floor channel first, past its lips, starting at the bend), then
  press the trims in from above.
- Harness rods: push one into each hole, plug the hole with a printed
  plug (`rod_plugs`) if the console calls for them. See *Carrying*, below.
- An attached bay: inserts into its inner wall, dowels into the base's end face, then the four screws from inside the machine cavity.
- Extensions on their pegs, the corner piece's dovetails, and snapping in the lids.

## Carrying

*This section describes what the base is meant to carry and a harness
for it. Nothing here has been load-tested: not the base, its handholds or
its rods, and not the harness, which has not been made. The figures at the
end are illustrative arithmetic, not evidence of strength.*

**What is meant to be carried.** In its basic build, the base is a base:

- **Across a room,** lift the base, machine and all, by its two
  handholds, one hand at each end, low over the floor, and keep it level.
  (The handholds were printed in the version 15 99K build, but have not
  been load-tested.)
- **Farther,** use a harness on the four harness rods (below).
- **Take the extensions off first.** They are accessories, not part of
  what the base carries: lift them off their pegs and carry them
  separately. (There is no good way yet to carry them; a box or bag
  sized to them is one answer.)
- **Close the lids**, or take them off, so nothing falls out.
- **Keep the machine in its seat.** With hinges, the hinge pins hold the
  machine's back edge, but nothing holds the front down if the base is
  tilted: keep it level, and consider the turn button (`turn_button`,
  not yet printed), which holds the bed's front edge down, or a strap
  round the bed. With
  `hinge_type = "none"`, **nothing at all holds the machine**: carry the
  machine and the base separately, or strap them together.
- **Never lift by the machine's arm**, or by the extensions or lids.
- **If a hinge, peg, dovetail, mending plate, handhold or rod is cracked,
  loose or bent, don't carry the base with a machine in it** until it is
  repaired or reprinted.

A commercial portable base would come with a cover and a handle on the
cover. That needs a very large printer and solves harder structural
problems, so it isn't part of this project.

**A harness (experimental: do not carry a machine with it yet).** Don't
carry a machine with a harness until the complete assembly (hooks,
webbing, stitching, handle and rods, as built) has been proof-load tested
and inspected; the handle's README outlines what that test would involve,
and `docs/VALIDATION.md` what more a dependable design would need. Until
then, what follows is a design to build and test, not a way to carry. One
way to make one, sketched below: two lengths of 1"
polyester or nylon webbing, each running from a front corner's rod to the
opposite back corner's, crossing in an X above the machine. They cross
in a printed handle (`standalone/harness-handle/`): both lengths run
through a tunnel along its grip, one on top of the other, and are sewn
together just outside each end of it (a bar tack or a short box-and-X,
with bonded nylon or polyester thread). A snap hook at each end clips onto
the rod where it is exposed in its notch. The handle's
[README](../../standalone/harness-handle/README.md) gives the order of
work: the webbing has to go through the handle before anything is sewn.

![An experimental harness, not made or tested, on the four harness rods: two lengths of webbing crossing in an
X over the machine, running together through the handle, each end clipped
to a rod in its notch with a snap hook. The machine is an outline only.](../images/diagrams/carry-harness.svg){width=90%}

- **The webbing must not slide through the handle.** Sewn on both sides
  of it, each of the four legs has a fixed length, and the base hangs
  steady below the handle. Unsewn, the harness is a sling over a pulley:
  the base can rock in it, and since its weight sits above the rods, it
  will tip.
- **The handle has to clear the machine.** On the 99K base it sits about
  380 mm above the rods, enough to clear the head and the spool pins; each
  leg is then about 410 mm from hook to handle, so each length is about
  1 m (two legs and the handle's 154 mm) plus what the hooks' loops take. Lay the harness over your
  machine before cutting. The webbing will rest against the machine near
  the head and the hand wheel; pad it there, or it will rub the finish.
- **The hooks have to fit the notch.** The notch leaves `notch_clear`
  (4 mm) round the rod, behind it and above it, so a hook's wire must be
  thinner than that to pass. Pick the hooks before printing the base, and
  raise `notch_clear` if they need it.
- **The hooks, webbing and stitching** are the parts most likely to fail.
  Use metal snap hooks with a stated working load of at least 25 kg each,
  and webbing rated well above that. Ratings of the parts are not a rating
  of the assembly: a seam, a hook's gate or a twisted leg can each be the
  weakest point, and only a test of the assembly finds it.

**The loads, worked by hand.** These are illustrative estimates from
simplified, static geometry and assumed weights, not measurements and not
a load rating; they show where stresses are high and where they are low,
nothing more. They do not cover a dropped or swung load, the loss of one
leg, fatigue, creep or heat.

- *The load.* A 50 lb (22.7 kg) machine in a base of about 4 kg is 262 N.
  Doubling that, an arbitrary illustrative allowance for jolts and uneven
  lifting, gives 523 N, a quarter of it, 131 N, at each corner. The factor
  of 2 is not a recognized proof-load or design factor; lifting gear is
  ordinarily rated with much larger ones (see `docs/VALIDATION.md`).
- *The webbing.* With the handle 380 mm above the rods and each corner
  223 mm from the center, each length of webbing rises at about 60°, so
  each end pulls 152 N along the webbing, 77 N of it inward. A lower
  handle raises that: 163 N at 300 mm. (These figures take the legs to
  one point. The printed handle is 154 mm long, which makes the legs
  steeper and the pull a little less, about 141 N; the handle's own
  loads are in its README.)
- *The rods.* Each 3/16" rod spans the 25 mm notch, with the hook pulling
  at its middle. As a simply supported beam that is a bending moment of
  about 950 N·mm and a stress of about 90 MPa. A hardened steel dowel pin
  yields at well over 1,000 MPa and 303 stainless at about 240 MPa, so
  in this arithmetic steel's yield is 2.7 or more times the stress; brass is weaker and varies, so use
  steel for rods that will carry the machine.
- *The plastic round the rods.* The hook pulls up and inward, so the rod
  bears into the solid end wall above and behind it, not into the 4.5 mm
  of plastic below and outside it. Spread over about 10 mm either side of
  the notch, the bearing stress is under 2 MPa, against tens of MPa for
  printed PETG.
- *The base as a beam.* Lifted at its ends with the machine's weight in
  the middle, the base bends by about 27 N·m. Even counting only the floor
  and two 10 mm walls, that is under 1 MPa of bending stress. Across the
  split it puts roughly 360 N of tension into the floor, shared by the
  three mending plates and the dovetails, about 120 N per plate.
- *The handholds.* Each carries half the load, and the fingers pull up
  into the solid end wall, as the rods do.

So in this arithmetic the printed structure's stresses are low next to
the material's strength, and the weak points are the bought parts: hooks,
webbing, stitching, and the rods' material. That is arithmetic, not
strength validation. Layer adhesion, voids, a crack, creep, heat (a car
in summer) or a print defect can each remove most of a margin, and the
numbers say nothing about fatigue. Inspect the rods' notches, the
handholds and the split joint before each carry, and redo the arithmetic
for a heavier machine.

