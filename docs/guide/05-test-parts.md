# Test parts

*This chapter is an outline, still to be written. It will cover:*

- Why print tests, and the order to print them in.
- Test parts and tools: `test_parts` gives pieces of the base for trying
  fits, and each piece is also a part of its own, named below, so any one
  can be printed by itself; `tools` gives the things printed to help build or measure, which
  aren't part of the base: the hinge nut tool (`hinge_nut_tool`), the
  printed hinge's rod-fit test (`printed_hinge_test`), and the two halves
  of the foot-locating rig (`foot_rig_left`, `foot_rig_right`), and the
  tilt prop (`tilt_prop`). Each tool is also a part of its own.
- Top slice of the base (`top_test`): does the bed drop in and sit flat, and do the hinge pins line up?
- Bottom slice (`bottom_test`): the floor, a little way up into the cavity.
- Dovetail coupon (`dovetail_test`): joint clearance (`split_clearance`, `key_flare_angle`) and the plate-pocket bridge.
- Center slice (`center_test`): all three dovetails with the plates installed, the front seam, and clearance under the machine.
- Left-end strip (`end_strip_test`): handhold feel, knock-out wall, rod fit (`rod_hole_d`).
- Hinge block (`hinge_block_test`): hinge fit and bolt length.
- Hinge coupon (also `part = "hinge_coupon"`): a quick check of the hinge
  recess and pin slot without printing a slice of the base.
- Center slice: the front-wall serrations, and which half goes on first
  (lower the right half onto the left).
- Rod plugs (`rod_plugs`): press fit in the end strip's rod holes.
- Lid hinge test (`lid_hinge_test`, in the test set since version 81): a
  small lid in its frame, with the lids' snap-in hinge.
- Compartment test (its own part, `part = "compartment_test"`, built-in
  compartment only): the base's whole right end, from just left of the
  divider, so both ends of the cord pass-through and their knock-out walls
  are included, to the right end wall with its handhold and harness rods.
  It prints as the base does, and is the way to build and try the outlet
  (or any other) compartment by itself.
- Printed-hinge rod fit (its own part, `part = "printed_hinge_test"`): a bar
  with five vertical holes for the pin, printed as the arm prints them, and
  five horizontal teardrop holes for the pivot rod, printed as the block
  prints them, from − 0.2 mm to + 0.2 mm left to right around their own
  settings (one to five notches on the top edge mark them): `ph_pin_press`
  for the pin holes, `ph_press` for the pivot holes. At the loose end,
  under a plus on the top, is a sixth hole, horizontal only: the arm's
  running fit for the pivot rod, `ph_slip`. Press the pin into each
  vertical hole and the rod into each horizontal one, and set each
  setting to the step that holds firmly without splitting the plastic;
  the two often differ, since vertical and horizontal holes print
  differently. The rod should turn freely in the sixth. To home in, print
  a second bar with the settings at their best steps and a finer
  `ph_test_step` (0.05 mm, say).
- Controller panel test (`ctrl_panel_test`, controller bay only; in the test set): the outer part of the back wall behind the controller bay, with the IEC inlet's and the jacks' cutouts in their thinned panels and a short length of each tunnel, printed face down, to try the inlet and the jack modules before printing the base.
- Cordset entry test (`knee_entry_test`, knee controller only; in the test set): the 4.4 mm wall with the cordset's entry hole, the dimple for its clip and the clip's guides, to try the cordset's molded entry and steel clip.
- Attached-bay joint test (`attach_test`, attached bay only; in the test set): the base's end wall and the bay's inner wall around one screw and one dowel, each printed upright as in its part. Fit an M5 heat-set insert, press in a dowel, and try the screw and the fit of the two faces.
- Split test (its own part, `part = "split_test"`, not in the test set): just the front of the split joint, both halves, with the front-wall serrations and the first dovetail key, for a quick check of a serrated joint. The wall stubs are `split_test_h` tall (30 mm; 0 for full height).
- Pass-through (`passthrough_test`, outlet, knee or controller compartment):
  the divider around the cord tunnel, cut down its middle into two pieces,
  each with one of the two knock-out walls, as the base has one on each
  face of the divider. Try knocking each out. (Before version 81 it was one
  piece, with the tunnel sealed inside it between the walls; a slicer that
  split it into its shells filled the tunnel solid.) Set `test_passthrough_whole` to print it whole
  instead, as the base has it; then leave it as one object in the slicer.
- Turn button (`turn_button_test`, with `turn_button` on): a slice of the
  front rim with the button's pad and nut slot, and the button.
- Outlet block (`outlet_test`, outlet compartment only): curbs, screw height, and the
  insert or through-screw hole, with your outlet and plugs in place. With a
  through screw, try the printed cap (`outlet_cap`) in its recess: printed
  in November 2026 in Sunlu High-Speed PETG Matte, dried and calibrated, it snapped in flush and
  held until pushed out from behind. An earlier print from damp filament,
  before the recess became a teardrop, fitted poorly; if the cap is loose
  or won't seat, look to the filament and the printer's calibration first.
- Extension top slices (`ext_top_test`): lip fit, pegs, supports, and the bobbin-plate trench.
- Lids (each its own part: `base_lid`, `back_lid` and so on): snap-in hinge, swing, and the lean-back stop.
- Front corners (`front_corner_test`): the base's front
  left and right corners, full height and a little deeper than the front
  wall, each printed upright as in the base, for trying the logos and the
  ruler: relief depth, line widths, and, raised or inlaid, the filament
  changes and colors. Each is wide enough for a 40 mm logo, or the logo if
  wider, with the ruler below it; `test_corner_w` sets the width instead.
- Ruler and logos: every piece cut from the base carries the raised or
  inlaid ruler and logos it crosses (the center slice, the top and bottom
  slices, the corners), each as its own color-tagged part, so export 3MF to
  keep the colors. (Before version 75 the test pieces left them off.)

> **Note: the hinge coupon as a wooden-base insert.** The hinge coupon has
> countersunk corner holes for #8 flat-head wood screws, so it can also be
> used in a base made of wood. Print two, mortise them flush into the top of
> the base with their front edges on the back wall of the bed opening, at the
> hinge spacing the console gives, and screw them down. The console also
> gives how far below the bed's top surface the coupon's top must sit, and
> where the hinge-pin axis falls. The router work for the hinge recesses,
> the hardest part of a wooden base, is then done by the printer.

In the `part` list, the test parts come last, together; before them come
the views, the base and its small parts, the extensions and boxes, the
printed hinges, the knee controller, the controller bay, the bobbin and
notion trays, and the tools. The compartment test (the base's whole right
end) and the split test (which the center slice covers) stay out of the
test set; print them by name.
