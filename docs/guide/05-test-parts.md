# Test parts

*This chapter is an outline, still to be written. It will cover:*

- Why print tests, and the order to print them in.
- Test parts and tools: `test_parts` gives pieces of the base for trying
  fits; `tools` gives the things printed to help build or measure, which
  aren't part of the base: the hinge nut tool (`hinge_nut_tool`), the
  printed hinge's rod-fit test (`printed_hinge_test`), and the two halves
  of the foot-locating rig (`foot_rig_left`, `foot_rig_right`), and the
  tilt prop (`tilt_prop`). Each tool is also a part of its own.
- Top slice of the base: does the bed drop in and sit flat, and do the hinge pins line up?
- Dovetail coupon: joint clearance (`split_clearance`, `key_flare_angle`) and the plate-pocket bridge.
- Center slice: all three dovetails with the plates installed, the front seam, and clearance under the machine.
- Left-end strip: handhold feel, knock-out wall, rod fit (`rod_hole_d`).
- Hinge block: hinge fit and bolt length.
- Hinge coupon (also `part = "hinge_coupon"`): a quick check of the hinge
  recess and pin slot without printing a slice of the base.
- Center slice: the front-wall serrations, and which half goes on first
  (lower the right half onto the left).
- Rod plugs: press fit in the end strip's rod holes.
- Printed-hinge rod fit (its own part, `part = "printed_hinge_test"`): a bar
  with five vertical holes for the pin, printed as the arm prints them, and
  five horizontal teardrop holes for the pivot rod, printed as the block
  prints them, from `ph_press` − 0.2 mm to + 0.2 mm left to right (one to
  five notches on the top edge mark them). At the loose end, under a plus
  on the top, is a sixth hole, horizontal only: the arm's running fit
  for the pivot rod, `ph_slip`. Press your rod into each and set
  `ph_press` to the step that holds it firmly without splitting the
  plastic; the rod should turn freely in the sixth. To home in, print a
  second bar with `ph_press` at the best step and a finer `ph_test_step`
  (0.05 mm, say).
- Cordset entry test (its own part, `part = "knee_entry_test"`, knee controller only): the 4.4 mm wall with the cordset's entry hole, the dimple for its clip and the clip's guides, to try the cordset's molded entry and steel clip.
- Attached-bay joint test (its own part, `part = "attach_test"`, attached bay only): the base's end wall and the bay's inner wall around one screw and one dowel, each printed upright as in its part. Fit an M5 heat-set insert, press in a dowel, and try the screw and the fit of the two faces.
- Split test (its own part, `part = "split_test"`, not in the test set): just the front of the split joint, both halves, with the front-wall serrations and the first dovetail key, for a quick check of a serrated joint. The wall stubs are `split_test_h` tall (30 mm; 0 for full height).
- Outlet block (outlet compartment only): curbs, screw height, and the
  insert or through-screw hole, with your outlet and plugs in place.
- Extension top slices: lip fit, pegs, supports, and the bobbin-plate trench.
- Lids: snap-in hinge, swing, and the lean-back stop.

> **Note: the hinge coupon as a wooden-base insert.** The hinge coupon has
> countersunk corner holes for #8 flat-head wood screws, so it can also be
> used in a base made of wood. Print two, mortise them flush into the top of
> the base with their front edges on the back wall of the bed opening, at the
> hinge spacing the console gives, and screw them down. The console also
> gives how far below the bed's top surface the coupon's top must sit, and
> where the hinge-pin axis falls. The router work for the hinge recesses,
> the hardest part of a wooden base, is then done by the printer.
