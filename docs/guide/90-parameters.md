# Parameter reference

This chapter is generated from the comments in `scad/vsm_base.scad` by `tools/extract_params.py`. Do not edit it by hand; change the comment in the model and rebuild.

There are 255 parameters; 253 of them appear in the Customizer. The rest are lists the Customizer cannot show, and are marked *edit in the file*.

## Part

| Parameter | Default | Description |
|---|---|---|
| `part` | `"assembly"` | What to render *Choices: assembly, exploded, all, test_parts, base, base_lid, back_ext, back_lid, left_ext, left_lid, corner_ext, corner_lid, rod_plugs, outlet_cap, hinge_coupon, back_box, left_box, corner_box, ext_pegs, lid_hinge_test, turn_button, passthrough_cover.* |
| `explode` | `40` | Spacing between parts in the "exploded" layout |
| `test_top_h` | `12.7` | Test parts: height of the top slices |
| `test_floor_extra` | `3` | Test parts: height of the base bottom slice above the cavity floor |
| `test_coupon_w` | `40` | Test parts: width of the dovetail coupon (X) |
| `test_slice_w` | `112` | Test parts: width of the center slice (X); covers the plates at 112 |
| `test_stub_w` | `20` | Test parts: full-height wall stubs either side of the joint in the center slice |
| `test_hinge_w` | `40` | Test parts: size of the hinge block (X), centered on the left hinge |
| `test_split_gap` | `10` | Gap between the two halves of split test parts |
| `printer_size` | `[256, 256, 256]` | Printer build volume, for the size check and the print plates |
| `printer_margin` | `8` | Keep parts this far inside the bed's edges (room for supports, brims and skirts) *Range 0 to 30, step 1.* |
| `print_plate` | `0` | Print plates (part all): 0 = every plate, laid out side by side; N = plate N only *Range 0 to 30, step 1.* |
| `purge_tower_size` | `40` | Purge tower kept clear on plates with supported parts (square, mm); 0 = none *Range 0 to 80, step 5.* |
| `plate_gap` | `8` | Space between parts on a plate *Range 2 to 30, step 1.* |

## Options

| Parameter | Default | Description |
|---|---|---|
| `compartment_option` | `"storage"` | Small-compartment option ("none" = base fitted to the bed alone) *Choices: none, storage, outlet, knee, jack.* |
| `hinge_type` | `"lollipop"` | Hinge type *Choices: lollipop.* |
| `split` | `true` | Split into two dovetailed halves for printing |

## Machine

| Parameter | Default | Description |
|---|---|---|
| `machine` | `"Singer 99K"` | Your machine. A listed machine supplies every setting in the "Custom machine" section; choose Custom to use those settings instead. *Choices: Singer 99K, Custom.* |
| `bed_cushion_in` | `0.0625` | Bed cushion thickness, compressed, in inches (1/16") |

## Custom machine: IGNORED unless machine = Custom

| Parameter | Default | Description |
|---|---|---|
| `custom_bed_length_in` | `12.1875` | IGNORED unless machine = Custom. Bed length, inches (99K: 12 3/16") |
| `custom_bed_width_in` | `6.5625` | IGNORED unless machine = Custom. Bed width, inches (99K: 6 9/16") |
| `custom_bed_plate_thickness_in` | `0.3125` | IGNORED unless machine = Custom. Thickness of the flat bed plate, inches (99K: 5/16") |
| `custom_hinge_hole_inset_in` | `1.4375` | IGNORED unless machine = Custom. Hinge hole center from each end of the bed, inches (99K: 1 7/16") |
| `custom_hinge_hole_drop_in` | `0.375` | IGNORED unless machine = Custom. Hinge hole center below the bed top surface, inches (99K: 3/8") |
| `custom_back_trench` | `[0, 0, 0, 0]` | IGNORED unless machine = Custom. Back bobbin trench, mm: [center from the bed's left end, width, length back from the bed edge, depth]; all zeros = none |
| `custom_left_trench` | `[83.34, 57.6, 40, 2.5]` | IGNORED unless machine = Custom. Left bobbin trench, mm: [center from the bed's front edge, width, length left from the bed edge, depth]; all zeros = none |
| `custom_base_lid_notch` | `[8, 23]` | IGNORED unless machine = Custom. Notch in the base lid's left edge clearing the motor boss as the lid opens, mm: [depth, width]; [0, 0] = none |
| `custom_relief_1_edge` | `"left"` | IGNORED unless machine = Custom. Casting relief 1: which edge of the bed the thickened area is on (none = not used) *Choices: none, left, right, back, front.* |
| `custom_relief_1` | `[83.34, 76.2, 15]` | IGNORED unless machine = Custom. Casting relief 1, mm: [center, length, thickness]. Center is along the edge from the bed's left end (back/front edges) or front edge (left/right edges); thickness is measured down from the bed top |
| `custom_relief_2_edge` | `"right"` | IGNORED unless machine = Custom. Casting relief 2: edge *Choices: none, left, right, back, front.* |
| `custom_relief_2` | `[83.34, 76.2, 15]` | IGNORED unless machine = Custom. Casting relief 2, mm: [center, length, thickness] |
| `custom_relief_3_edge` | `"back"` | IGNORED unless machine = Custom. Casting relief 3: edge *Choices: none, left, right, back, front.* |
| `custom_relief_3` | `[36.51, 50.8, 20]` | IGNORED unless machine = Custom. Casting relief 3, mm: [center, length, thickness] |
| `custom_relief_4_edge` | `"back"` | IGNORED unless machine = Custom. Casting relief 4: edge *Choices: none, left, right, back, front.* |
| `custom_relief_4` | `[273.05, 50.8, 20]` | IGNORED unless machine = Custom. Casting relief 4, mm: [center, length, thickness] |
| `custom_relief_5_edge` | `"none"` | IGNORED unless machine = Custom. Casting relief 5: edge *Choices: none, left, right, back, front.* |
| `custom_relief_5` | `[0, 0, 0]` | IGNORED unless machine = Custom. Casting relief 5, mm: [center, length, thickness] |
| `custom_relief_6_edge` | `"none"` | IGNORED unless machine = Custom. Casting relief 6: edge *Choices: none, left, right, back, front.* |
| `custom_relief_6` | `[0, 0, 0]` | IGNORED unless machine = Custom. Casting relief 6, mm: [center, length, thickness] |

## Bed seat

| Parameter | Default | Description |
|---|---|---|
| `bed_clearance` | `0.75` | Clearance between bed and seat wall, per side |
| `bed_ledge` | `8` | How far the bed rests on the ledge around the machine cavity *Range 3 to 15, step 0.5.* |
| `rabbit_depth` | `4` | Depth of the bed seat and lid rabbet below the top surface *Range 2 to 8, step 0.1.* |

## Body

| Parameter | Default | Description |
|---|---|---|
| `rim_width` | `9` | Top rim: outer face to seat/rabbet edge, front, left and right *Range 5 to 20, step 0.5.* |
| `end_wall` | `22.225` | End wall thickness at the bottom, left and right (7/8" = 22.225) |
| `back_rim_width` | `0` | Top rim: back of the bed seat to outer back face (0 = from the hinge) |
| `hinge_back_skin` | `5` | With automatic back rim: solid behind the hinge's rear edge *Range 2 to 15, step 0.5.* |
| `bottom_thickness` | `12.7` | Bottom thickness |
| `inner_depth` | `70` | Cavity depth below the top surface |
| `divider_web` | `4` | Solid web at the top between the bed seat and the lid rabbet *Range 2 to 10, step 0.5.* |
| `outer_rounding` | `5` | Outer edge rounding (top and vertical edges) *Range 0 to 10, step 0.5.* |

## Small compartment

| Parameter | Default | Description |
|---|---|---|
| `storage_inner_length` | `70` | Inner length of the small compartment (X) |
| `lid_ledge` | `10` | Lid ledge width around the small compartment *Range 5 to 20, step 0.5.* |

## Cord pass-through

| Parameter | Default | Description |
|---|---|---|
| `cord_hole_width` | `46` | Cord pass-through width (wide enough for both plugs' cords side by side) |
| `cord_hole_height` | `36` | Cord pass-through height (without gable) |
| `passthrough_knockouts` | `false` | Close both ends of the pass-through with knock-out walls (tap them out with a punch when you fit the outlet) |
| `passthrough_knockout_t` | `1.6` | Knock-out wall thickness *Range 0.8 to 3, step 0.1.* |
| `passthrough_score_depth` | `0.6` | Score groove around each knock-out wall's edge, on its tunnel side: depth (deeper = easier to knock out) *Range 0.2 to 1.5, step 0.1.* |
| `passthrough_score_w` | `0.8` | Score groove width *Range 0.4 to 2, step 0.1.* |
| `passthrough_cover` | `false` | Make a removable cover for the pass-through (part passthrough_cover), pushed into its compartment end |
| `passthrough_cover_depth` | `6` | Cover: depth of the plug into the tunnel *Range 3 to 15, step 0.5.* |

## Outlet compartment

| Parameter | Default | Description |
|---|---|---|
| `outlet_size` | `[76, 40, 22]` | Outlet body, mm: [length, width, thickness]. Modern: 76 x 40 x 22; early Bakelite: 83 x 45 x 22 |
| `outlet_receptacle_spacing` | `34` | Receptacle spacing, center to center (modern 34, Bakelite 38) *Range 20 to 60, step 0.5.* |
| `outlet_clearance` | `1.5` | Clearance around the outlet inside its curbs, per side |
| `outlet_y_offset` | `0` | Outlet center, front-to-back offset from the middle of the compartment *Range -50 to 50, step 0.5.* |
| `outlet_curb_h` | `3` | Height of the curbs on the floor around the outlet *Range 1 to 8, step 0.5.* |
| `outlet_curb_w` | `3` | Width of the curbs *Range 1 to 8, step 0.5.* |
| `outlet_mount` | `"through"` | How the outlet is held: a heat-set insert in the end wall (needs a soldering iron), or a flat-head screw through the end wall from outside, with a nut on the outlet's face *Choices: through, insert.* |
| `outlet_screw_spec` | `"#8-32"` | Screw through the outlet's center hole (drill out the membrane) |
| `outlet_screw_hole_d` | `4.6` | Through mount: clearance hole for the screw |
| `outlet_screw_head_d` | `8.4` | Through mount: flat-head diameter (#8: 8.4) |
| `outlet_screw_cap` | `true` | Through mount: recess the head under a printed cap (part outlet_cap) |
| `outlet_cap_d` | `12` | Through mount: cap diameter *Range 9 to 20, step 0.5.* |
| `outlet_cap_t` | `2` | Through mount: cap thickness *Range 1 to 4, step 0.1.* |
| `outlet_insert_d` | `5.6` | Hole for the heat-set insert in the right end wall (use the insert maker's recommended diameter) |
| `outlet_insert_depth` | `12` | Depth of the insert hole into the wall *Range 4 to 20, step 0.5.* |
| `outlet_lid_hinge` | `"left"` | Edge the outlet-compartment lid hinges on *Choices: left, right, front, back.* |
| `outlet_slot_1_side` | `"front"` | Cord slot 1: lid edge it opens from *Choices: none, front, right, back.* |
| `outlet_slot_2_side` | `"back"` | Cord slot 2: lid edge it opens from *Choices: none, front, right, back.* |
| `outlet_slot_1_pos` | `0` | Slot 1 position along its edge, mm from the lid's left end (front/back edges) or front end (right edge); 0 = automatic |
| `outlet_slot_2_pos` | `0` | Slot 2 position along its edge; 0 = automatic |
| `outlet_slot_w` | `9` | Cord slot width *Range 4 to 20, step 0.5.* |
| `outlet_slot_depth` | `25` | Cord slot depth in from the lid edge |
| `outlet_slot_chamfer` | `1.5` | Chamfer on the slot's top edges, easing a cord pulled over them |

## Lollipop hinge

| Parameter | Default | Description |
|---|---|---|
| `hinge_flange_diameter` | `29` | Hinge flange diameter *Range 15 to 50, step 0.1.* |
| `hinge_flange_thickness` | `3` | Hinge flange thickness *Range 1 to 8, step 0.1.* |
| `hinge_thickness` | `8` | Hinge body depth below the top surface *Range 3 to 20, step 0.1.* |
| `hinge_inner_diameter` | `27` | Hinge body diameter *Range 10 to 50, step 0.1.* |
| `hinge_pin_thickness` | `8` | Hinge pin thickness (X) *Range 3 to 15, step 0.1.* |
| `hinge_pin_height` | `8` | Hinge pin height (Z) *Range 3 to 15, step 0.1.* |
| `hinge_pin_extension` | `25` | Hinge pin extension *Range 5 to 60, step 0.5.* |
| `hinge_pin_square_projection` | `10` | Hinge pin square projection *Range 2 to 30, step 0.5.* |
| `hinge_pin_allowed_projection` | `2` | Hinge pin allowed square projection into the bed seat *Range 0 to 6, step 0.1.* |
| `hinge_pin_internal_length` | `15` | Hinge pin internal length *Range 5 to 40, step 0.5.* |
| `hinge_pin_sweep_depth` | `1` | Extra depth below the pin for its corner to sweep through *Range 0 to 4, step 0.1.* |
| `hinge_mounting_hole_diameter` | `5` | Hinge mounting hole diameter *Range 2 to 10, step 0.1.* |
| `hinge_mounting_hole_offset` | `9.5` | Mounting hole center, inward from the flange's back edge |

## Hinge coupon

| Parameter | Default | Description |
|---|---|---|
| `hinge_coupon_margin` | `12` | Solid margin around the hinge flange (room for the corner screws) |
| `hinge_coupon_floor` | `4` | Floor left under the deepest hinge cut *Range 2 to 10, step 0.5.* |
| `hinge_coupon_screw_d` | `4.6` | Corner holes for #8 flat-head wood screws: clearance hole |
| `hinge_coupon_head_d` | `8.4` | Corner holes: countersink diameter at the top face |

## Hinge nut traps

| Parameter | Default | Description |
|---|---|---|
| `hinge_nut_spec` | `"#8-32"` | Nut for the hinge screws (BOSL2 spec, e.g. "#8-32", "M4") |
| `hinge_nut_width` | `0` | Nut width across flats; 0 = from the spec *Range 0 to 20, step 0.05.* |
| `hinge_nut_depth` | `21` | Depth of the nut's upper face below the top surface *Range 8 to 60, step 0.5.* |
| `hinge_nut_bridge` | `0.2` | Sacrificial bridge over the nut trap (0 = none; drill through after printing) |

## Mending plates

| Parameter | Default | Description |
|---|---|---|
| `plate_count` | `3` | Number of plates across the split (0 = none) |
| `plate_length` | `101.6` | Plate length (McMaster 1394A34: 4") |
| `plate_width` | `15.875` | Plate width (5/8") |
| `plate_thickness` | `1.778` | Plate thickness (0.070") |
| `plate_holes` | `[[-33.866, 2.375], [-11.289, -2.375], [11.289, 2.375], [33.866, -2.375]]` | Hole centers [along, across] from the plate center (0.889" pitch, staggered 0.094") *Edit in the file; not shown in the Customizer.* |
| `plate_hole_bridge` | `0.3` | Sacrificial layer over each screw hole at the pocket ceiling (0 = none); drill through |
| `plate_pocket_clearance` | `0.5` | Clearance around the plate in its pocket, per side |
| `plate_standoff` | `1.0` | How far the plate sits up inside its pocket, so screw heads stay off the table |
| `plate_screw_clearance` | `4.6` | Screw clearance hole diameter (#8) |
| `plate_nut_spec` | `"#8-32"` | Nut for the plate screws (BOSL2 spec) |
| `plate_nut_width` | `0` | Nut width across flats; 0 = from the spec *Range 0 to 20, step 0.05.* |
| `plate_nut_trap_depth` | `3.5` | Nut trap depth into the cavity floor |
| `plate_wall_margin` | `8` | Minimum distance from the cavity walls to the plate edge *Range 2 to 20, step 0.5.* |

## Nut fit

| Parameter | Default | Description |
|---|---|---|
| `nut_clearance` | `0.15` | Extra clearance added to nut width (applied to each side) |

## Casting reliefs

| Parameter | Default | Description |
|---|---|---|
| `relief_clearance` | `1` | Clearance below the casting in a relief (the reliefs themselves come from the machine profile) *Range 0 to 4, step 0.1.* |
| `relief_margin` | `2` | Extra length added at each end of a relief *Range 0 to 10, step 0.5.* |

## Back wall lightening

| Parameter | Default | Description |
|---|---|---|
| `lighten_back_wall` | `true` | Hollow the back wall between the hinges |
| `back_skin` | `17` | Back wall thickness left behind the tunnels *Range 6 to 40, step 0.5.* |
| `back_top_skin` | `6` | Solid material above the tunnel peaks *Range 2 to 20, step 0.5.* |
| `tunnel_width` | `30` | Target tunnel width |
| `tunnel_web` | `6` | Web between tunnels |
| `hinge_tunnel_margin` | `7.5` | Extra solid kept beyond each side of the hinge footprint |
| `split_keepout` | `15` | Solid zone kept on either side of the split, from the cut line |

## Split

| Parameter | Default | Description |
|---|---|---|
| `split_part` | `"both"` | Which part to render when split *Choices: both, left, right.* |
| `split_spread` | `30` | Separation between the two halves when both are shown |
| `split_clearance` | `0.1` | Clearance in the joint, per face |
| `key_neck` | `8` | Dovetail key width at the cut line (neck) *Range 4 to 16, step 0.5.* |
| `key_flare_angle` | `30` | Dovetail flare, per side, in degrees; steeper = less pull-apart play |
| `key_depth` | `8` | Dovetail key length, past the cut line into the right half *Range 4 to 16, step 0.5.* |
| `key_ys` | `[]` | Key positions in Y; empty = automatic (floor keys between plate rows, one centered in the back wall) *Edit in the file; not shown in the Customizer.* |
| `serrations` | `true` | Vertical V-serrations across the front wall's joint faces |
| `serration_pitch` | `3` | Serration pitch (ridge to ridge) *Range 2 to 6, step 0.1.* |
| `serration_height` | `1.5` | Serration height (ridge tip beyond the cut line); pitch / 2 gives a 90-degree V |
| `serration_setback` | `2.5` | Solid wall kept between the serrations and each face of the front wall (outer skin and cavity side) |
| `serration_top_gap` | `3` | Serrations stop this far below the bed ledge *Range 1 to 10, step 0.5.* |
| `serration_top_clear` | `0.5` | Extra clearance at the top of each groove, so the ridges never bottom out |

## Extensions

| Parameter | Default | Description |
|---|---|---|
| `back_ext` | `true` | Include the back extension (outfeed support / compartment) |
| `left_ext` | `true` | Include the left extension |
| `corner_ext` | `true` | Include the left-rear corner piece (needs both of the above) |
| `back_ext_length` | `240` | Back extension length (X), from the base's left face |
| `back_ext_depth` | `100` | Back extension body depth (Y), behind the base |
| `left_ext_width` | `100` | Left extension body width (X), left of the base |
| `ext_gap` | `0.3` | Gap between an extension body and the base or another extension |
| `lip_clearance` | `0.2` | Clearance between the lip and the base top |
| `ext_top_adjust` | `0` | Trim to the extensions' top plane (lids, lips, trenches) against the real bed, mm; negative lowers it *Range -3 to 3, step 0.1.* |
| `ext_floor` | `3` | Extension floor thickness *Range 1.5 to 8, step 0.1.* |
| `ext_frame` | `4` | Frame width around each lid, at the top *Range 2 to 10, step 0.1.* |
| `ext_ledge` | `4` | Ledge the lid rests on, inside the frame *Range 2 to 10, step 0.1.* |
| `ext_lid_thickness` | `4` | Lid thickness (= depth of the lid rabbet) *Range 2 to 8, step 0.1.* |
| `ext_lid_clearance` | `0.3` | Clearance around the lid in its rabbet, per side |
| `ext_hinge_margin` | `0.5` | Hinged lids: the ledge on the hinge side is widened so the open lid stays this far clear of the bay |
| `corner_bay_square` | `true` | Keep the corner bay square, with matching extra ledge on its other two sides |
| `ext_finger_hole` | `22` | Finger hole in each lid |
| `ext_rounding` | `3` | Rounding of the extensions' exposed edges *Range 0 to 8, step 0.5.* |

## Turn button

| Parameter | Default | Description |
|---|---|---|
| `turn_button` | `false` | Turn button on the front rim that holds the bed's front edge down (off by default) |
| `turn_button_x` | `0` | Position along the front rim (X); 0 = automatic, between the split and the compartment |
| `turn_button_overlap` | `4` | How far the button reaches over the bed's front edge *Range 1 to 10, step 0.5.* |
| `turn_button_w` | `9` | Button width *Range 6 to 16, step 0.5.* |
| `turn_button_t` | `4` | Button thickness *Range 2 to 8, step 0.5.* |
| `turn_button_gap` | `0.3` | Gap between the button and the bed top |
| `turn_button_ease` | `10` | Easing: how far the pad's smooth slopes run out along the rim, each side |
| `turn_button_swell` | `3` | How far the pad swells out of the front face, enclosing the nut *Range 0 to 8, step 0.5.* |
| `turn_button_swell_taper` | `10` | Below the nut, the swelling blends back into the front face over this height |
| `turn_button_nut_spec` | `"#8-32"` | Nut for the button screw (BOSL2 spec) |

## Freestanding boxes

| Parameter | Default | Description |
|---|---|---|
| `make_back_box` | `false` | Also make a freestanding version of the back extension (part back_box): same bay and lid, no lip, pegs or dovetails |
| `make_left_box` | `false` | Also make a freestanding left box (part left_box) |
| `make_corner_box` | `false` | Also make a freestanding corner box (part corner_box) |

## Extension pegs

| Parameter | Default | Description |
|---|---|---|
| `ext_peg_holes` | `true` | Holes in the base rim for the extension pegs |
| `ext_peg_style` | `"insert"` | Pegs: insert (separate printed pegs, part ext_pegs, printed lying down), pin (cut from rod_d rod), or molded into the lip (as before v20) *Choices: insert, pin, molded.* |
| `peg_d` | `4` | Peg diameter (printed pegs) *Range 3 to 8, step 0.1.* |
| `peg_len` | `3` | Peg length below the lip *Range 1.5 to 6, step 0.1.* |
| `peg_hole_d` | `4.4` | Hole diameter in the base (for printed pegs; pins use rod_d + 0.2) |
| `peg_lip_clearance` | `0.2` | Peg hole in the lip, over the peg diameter (the peg's crush ribs make the press fit) |
| `pin_lip_interference` | `0.1` | Metal pins: press fit in the lip, hole under the rod diameter |
| `peg_hole_depth` | `3.5` | Hole depth in the base |
| `back_peg_xs` | `[16, 230]` | Back-rim peg positions (X); keep clear of the hinges and the split |
| `left_peg_ys` | `[35, 150]` | Left-rim peg positions (Y) |
| `right_peg_ys` | `[35, 150]` | Right-rim peg positions (Y), for future right-side extensions; [] for none |

## Corner dovetails

| Parameter | Default | Description |
|---|---|---|
| `ext_dt_neck` | `6` | Dovetail width at the mating face *Range 3 to 12, step 0.5.* |
| `ext_dt_head` | `9` | Dovetail width at its head *Range 4 to 16, step 0.5.* |
| `ext_dt_depth` | `4` | Dovetail depth into the mating wall *Range 2 to 10, step 0.5.* |
| `ext_dt_clearance` | `0.2` | Dovetail clearance per face |

## Handholds

| Parameter | Default | Description |
|---|---|---|
| `handholds` | `true` | Handholds under each end |
| `handhold_bottom_len` | `76.2` | Handhold length along the end, at the bottom face (3") |
| `handhold_top_len` | `50.8` | Handhold length at its top (2") |
| `handhold_height` | `12.7` | Handhold height above the bottom face (1/2") |
| `handhold_depth` | `15.875` | Handhold depth into the end wall (5/8") |
| `handhold_lip_flat` | `4` | Flat underside of the lip at the face, before the ceiling climbs *Range 0 to 10, step 0.5.* |
| `handhold_lip_round` | `2` | Radius rounding the lip's outer edge *Range 0 to 6, step 0.5.* |
| `handhold_knockout` | `true` | Knock-out wall under the lip, removed after printing |
| `knockout_t` | `1.2` | Knock-out wall thickness |
| `knockout_gap` | `0.2` | Gap between the knock-out wall and the lip |
| `knockout_tab` | `true` | Breakaway tab tying one end of the knock-out wall to the pocket end |
| `knockout_tab_h` | `0.8` | Tab height (the tab sits just under the lip gap) |
| `knockout_brim` | `true` | Brim around the foot of each knock-out wall, so it stands until the tab joins it |
| `knockout_brim_w` | `5` | Brim width each side of the wall |
| `knockout_brim_h` | `0.2` | Brim height (about one first layer) |

## Harness rods

| Parameter | Default | Description |
|---|---|---|
| `harness_rods` | `true` | Rod notches and rods either side of each handhold |
| `rod_d` | `4.7625` | Rod diameter (3/16") |
| `rod_hole_d` | `4.95` | Rod hole diameter (printed as a teardrop, point up) |
| `rod_x` | `7` | Rod center in from the end face *Range 3 to 15, step 0.1.* |
| `rod_z` | `7` | Rod center above the bottom face *Range 3 to 15, step 0.1.* |
| `notch_len` | `25` | Notch length along the rod |
| `notch_clear` | `4` | Clear space around the rod in the notch, behind and above it *Range 1 to 10, step 0.5.* |
| `notch_inset` | `25` | Distance from each outer face (front, back) to its notch |
| `rod_stop` | `5` | Material left between a rod's blind end and the handhold |
| `rod_plug_len` | `5` | Printed plug closing the open end of each rod hole (0 = no plugs; rods run to the face) *Range 0 to 10, step 0.5.* |
| `rod_plug_clearance` | `0.1` | Plug clearance in the hole, per side (the crush ribs make the press fit) |
| `rod_plug_rib` | `0.15` | Crush rib interference, beyond the hole wall |

## Left lip

| Parameter | Default | Description |
|---|---|---|
| `lip_edge_round` | `2` | Radius of the rounded top edge along the lip front *Range 0 to 5, step 0.5.* |
| `lip_fillet` | `5` | Radius of the inside corner where the lip front meets the body *Range 0 to 15, step 0.5.* |

## Lid hinges

| Parameter | Default | Description |
|---|---|---|
| `base_lid_hinge` | `"right"` | Lid edge each lid hinges on *Choices: left, right, front, back.* |
| `back_lid_hinge` | `"back"` |  *Choices: left, right, front, back.* |
| `left_lid_hinge` | `"left"` |  *Choices: left, right, front, back.* |
| `corner_lid_hinge` | `"back"` |  *Choices: left, right, front, back.* |
| `base_lid_type` | `"hinged"` | Base compartment lid: hinged (snap-in dimple hinge), lift-out (plain lid resting on the ledge), or none (rabbet left for a lid later) *Choices: hinged, lift-out, none.* |
| `back_lid_type` | `"hinged"` | Back extension lid type *Choices: hinged, lift-out, none.* |
| `left_lid_type` | `"hinged"` | Left extension lid type *Choices: hinged, lift-out, none.* |
| `corner_lid_type` | `"hinged"` | Corner piece lid type *Choices: hinged, lift-out, none.* |
| `base_lid_style` | `"solid"` | Base compartment lid style: solid, or perforated for ventilation *Choices: solid, perforated.* |
| `back_lid_style` | `"solid"` | Back extension lid style *Choices: solid, perforated.* |
| `left_lid_style` | `"solid"` | Left extension lid style *Choices: solid, perforated.* |
| `corner_lid_style` | `"solid"` | Corner piece lid style *Choices: solid, perforated.* |
| `base_lid_grip` | `"finger hole"` | Base compartment lid grip: finger hole, or a thumb tab reaching over a notch in the wall *Choices: finger hole, tab.* |
| `base_lid_tab_edge` | `"front"` | Base lid tab edge (front only is practical, on a lift-out lid) *Choices: front, back, left, right.* |
| `back_lid_grip` | `"finger hole"` | Back extension lid grip *Choices: finger hole, tab.* |
| `back_lid_tab_edge` | `"right"` | Back lid tab edge (back or right) *Choices: front, back, left, right.* |
| `left_lid_grip` | `"finger hole"` | Left extension lid grip *Choices: finger hole, tab.* |
| `left_lid_tab_edge` | `"front"` | Left lid tab edge (front or left) *Choices: front, back, left, right.* |
| `corner_lid_grip` | `"finger hole"` | Corner piece lid grip *Choices: finger hole, tab.* |
| `corner_lid_tab_edge` | `"left"` | Corner lid tab edge (left or back) *Choices: front, back, left, right.* |
| `grip_tab_w` | `25` | Thumb tab width |
| `grip_tab_over` | `1.5` | Thumb tab overhang past the outer face |
| `grip_tab_r` | `2` | Thumb tab corner radius *Range 0 to 5, step 0.5.* |
| `grip_scoop_d` | `2.5` | Thumb scoop below the tab: depth into the outer face |
| `grip_scoop_h` | `6` | Thumb scoop height below the lid *Range 2 to 12, step 0.5.* |
| `base_lid_notch_r` | `4` | Base lid motor-boss notch (size from the machine profile): inner corner radius *Range 0 to 10, step 0.5.* |
| `base_lid_notch_flare` | `10` | Notch: radius blending it into the lid edge |
| `base_lid_notch_offset` | `0` | Notch: front-to-back offset from the middle of the lid *Range -50 to 50, step 0.5.* |
| `lid_perf_d` | `5` | Perforation hole diameter *Range 2 to 12, step 0.5.* |
| `lid_perf_pitch` | `8` | Perforation pitch (hex grid) *Range 4 to 20, step 0.5.* |
| `lid_perf_margin` | `6` | Solid margin kept around the lid's edges, finger hole and hinge *Range 2 to 20, step 0.5.* |
| `lid_bump_d` | `3` | Hinge bump diameter at its base *Range 1.5 to 6, step 0.1.* |
| `lid_bump_engage` | `1.0` | How far each bump engages the wall |
| `lid_tab_len` | `15` | Flex tab carrying each bump: length along the end |
| `lid_tab_w` | `4` | Flex tab width *Range 1.5 to 8, step 0.1.* |
| `lid_slot_w` | `1` | Slot that frees the flex tab *Range 0.5 to 3, step 0.1.* |
| `lid_bump_angle` | `35` | Bump flank angle from its axis: smaller is steeper and holds better (45 = the v19 cone) *Range 15 to 60, step 1.* |
| `lid_hinge_end_clearance` | `0.15` | Clearance at the lid's two hinge ends (less end float keeps both bumps engaged) |
| `lid_recess_clearance` | `0.075` | Clearance between bump and recess, per side |
| `lid_open_stop` | `true` | Cut a chamfer behind the hinge so an open lid leans back and stays up |
