// SPDX-License-Identifier: MIT
// Singer 99 base, version 33
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// Coordinate system: the base's outer front-left-bottom corner is at the
// origin. +X runs left to right (balance wheel / small compartment at +X),
// +Y runs front to back (hinges at the back), +Z is up.
//
// The bed seat, machine cavity, and hinge positions are derived from the
// measured Singer 99 bed casting rather than from an old wooden base.
//
// v5: flat split with placed dovetail keys, joined by steel mending plates
// (McMaster 1394A34)
// recessed into the underside, with nut traps on the cavity floor;
// nut traps under the hinge screws; gabled lightening tunnels in the
// back wall between the hinges.
//
// v6: tunnel and cord-hole floors flush with the cavity floor; a tunnel
// behind the small compartment; compartment_option "none" (base fitted
// to the bed alone); hinge_type selects the hinge, and the hinge's
// footprint drives the back rim, hinge position and keep-outs.
//
// v7: removable extensions that sit on the table and reach over the base
// rim with a lip whose top is level with the machine bed: a back
// compartment / outfeed support, a left compartment / extension, and a
// left-rear corner compartment that dovetails to both. Each has a lid set
// in a frame, optional bobbin-plate trenches, and pegs that drop into
// holes in the base rim. `part` selects what to render.
//
// v8: hinge moved 2 mm back (pin square no longer enters the seat);
// reliefs cut below the bed ledge where the casting is thickened, from a
// list; back-wall tunnels skip the reliefs.
//
// v9: part "all" (exploded layout, base split); bobbin-plate trenches
// measured from the bed edges, with the 99's left trench on by default;
// snap-in dimple hinges on every lid, including a new lid for the base's
// small compartment.
//
// v10: split dovetails set by flare angle (default 30 degrees) with less
// clearance, cutting pull-apart play from about 1 mm to about 0.3 mm.
//
// v11: left lip starts at the bed's front edge, with a rounded top edge
// and a filleted inside corner where it meets the extension body; the
// body's front-right edge is rounded. Lids are turned over for printing
// by rotation (v9-v10 mirrored them). New part "test_parts".
//
// v12: end walls 7/8" thick with handholds under each end, after the old
// wooden base; notches either side of each handhold with 3/16" steel rods
// across them for a carrying harness; sacrificial membrane over the plate
// screw holes; extension top slices in test_parts print upright.
//
// v13: handholds open to the end face, with a rounded lip and a ceiling
// climbing 45 degrees into the wall, printed over a thin knock-out wall;
// rod-notch ceilings climb 45 degrees toward the face (no support needed);
// the test_parts center slice is floor plus full-height wall stubs at the
// joint.
//
// v14: a small breakaway tab ties each knock-out wall to the end of its
// pocket, so the wall stays with its part when a slicer splits objects.
// Peg holes in the right rim too, for future right-side extensions.
//
// v15: machine profiles. Pick the machine from a list; the casting
// measurements, reliefs and bobbin trenches come from the profile table.
// Choose "Custom" to use the settings in the "Custom machine" section
// instead. A one-layer brim around the foot of each knock-out wall.
//
// v16: vertical V-serrations across the front wall's joint faces, hidden
// inside the wall, so the front faces register flush (the right half is
// lowered onto the left). Harness rods stop short of the face and printed
// plugs close the holes (part "rod_plugs"). The console ends with a
// hardware list for the configuration, with screw lengths rounded up to
// stock sizes.
//
// v17: the "outlet" compartment. The outlet stands on the compartment
// floor against the right end wall, face to the left, held by a #8 screw
// into a heat-set insert in the wall and located by low curbs on the
// floor; the plugs point straight at the cord pass-through. Its lid hinges
// on the left and has two cord slots, each on a chosen edge. Wider
// default pass-through.
//
// v18: lid type per lid (hinged, lift-out or none) and lid style (solid or
// perforated); a `compartments` list giving each accessory bay's usable
// interior, for organizer inserts that include this file; console output
// only when something is rendered (`report`); the outlet can be held by a
// through screw from the end face instead of a heat-set insert; part
// "hinge_coupon", a hinge recess block that doubles as a hinge insert for
// a wooden base.
//
// v19: freestanding extension boxes (parts back_box, left_box, corner_box);
// a wider ledge on a hinged extension lid's hinge side, so an open lid
// stays clear of the bay, with the corner bay kept square; a thumb-tab lid
// grip as an alternative to the finger hole; a notch in the base lid's left
// edge to clear the motor boss, from the machine profile.
//
// v20: lid hinges hold better: less end float at the hinge ends, a closer
// recess, steeper bump flanks, and stiffer flex tabs and deeper engagement
// by default (from print tests in PLA and PETG); part "lid_hinge_test" to
// tune them quickly. ext_top_adjust trims the extensions' top plane to the
// real bed. Extension pegs can be separate, replaceable parts (printed
// lying down, or cut from 3/16" rod) instead of molded into the lip.
//
// v21: optional turn button on the front rim, after the wooden bases: a
// smooth raised pad level with the bed, a printed button on a #8 screw
// with click detents at closed (over the bed edge) and open, and a nut
// slot reached from inside the machine cavity (part turn_button).
//
// v22: part "all" is now every part of the build, flat on the bed in print
// orientation and grouped into printer-sized plates; part "exploded" is
// the old exploded view; print_plate picks one plate. Plates keep parts of
// one kind together, put supported parts together only when their support
// interface is on the same layer, and leave room for a purge tower. A
// printer edge margin; the outlet is held by a through screw by default;
// fractional Customizer steps where they matter.
//
// v23: no mending-plate pockets on an unsplit base; optional knock-out
// walls closing both ends of the cord pass-through (an outlet base can be
// used for storage until they are tapped out), and a removable
// pass-through cover (part passthrough_cover).
//
// v24: organizer inserts: bobbin trays for the corner bay (a second stack
// goes in the freestanding corner box); notion trays for the back or left
// bay in 30-10 mm and custom heights, plain or compartmented; a spool tray.
//
// v25: the back lip runs on past a short back extension to reach the last
// back peg hole, its free end rounded and filleted into the body; LIGHT and
// MOTOR recessed into the outlet compartment floor by their receptacles;
// part split_test, the front of the split joint (serrations and first
// dovetail) for a quick fit test.
//
// v26: knee controller (compartment_option "knee"): a knee bar turns a
// shaft in the right bay; a gear sector turns a pot that replaces the donor
// speed-control board's slide pot, a snap switch cuts the motor at rest,
// and hard stops on the front face take the knee's force. Bulkhead, board
// posts, cover, cord clamp; parts knee_sector, knee_pinion, knee_hub,
// knee_cover, knee_cord_clamp, and a knee_assembly cutaway view. (v29
// reworks the mechanism; see below.)
//
// v27: knee controller power options (knee_power): the standard pedal
// cordset's molded entry with its steel clip, or a fused IEC C14 inlet
// with a Wago lever-connector junction under the bed, or a bare cord and
// clamp. Board posts fixed (handedness) and measured; the board turned end
// for end, with room for its spade connectors; earth contact for the
// shaft; cover vents for motors over 1 A; pot set at the hard stop; part
// knee_entry_test.
//
// v28: knee return spring chosen (McMaster 9271K585 / 9271K651) with its
// torque in the console; the switch's actuating point from Omron's
// drawing (5.3 mm from the lever's free end).
//
// v29: knee controller reworked to a new feel: about 1 lb at rest rising
// 1.5 lb/in, an inch of dead travel before the motor starts, full speed at
// 2" and a hard stop at 2.25". The return spring is now a compression
// spring in a housing on the front face, pushed by a crank on the knee hub,
// with steel screw stops for rest and full travel, so the knee's force never
// reaches the shaft, its set screws or the gears. Two-stage gearing (about
// 11.75:1) through an idler on a stub pin; the switch lies under the shaft,
// worked by a cam on the sector. Parts knee_idler, knee_spring_housing and
// knee_spring_cap; the stop pin is gone.
//
// v30: organizer trays from the first prints: compartment trays default to
// a 2" target cell (2 x 4 in the back or left bay); small gussets at the
// foot of the long walls of every notion tray and the spool tray's curbs,
// where a thin wall meets the floor at a single layer line; the spool
// tray's curb is 14 mm tall (was 10), to stiffen its floor along its length.
//
// v31: the small compartment can be an attached bay (compartment_mount):
// a separate part screwed to the base's right end, for beds too long to
// print with a built-in compartment. Four M5 screws from inside the machine
// cavity into heat-set inserts in the bay's inner wall, and two rod_d
// dowels, hold it; its top is flush with the base, and it has its own
// handhold and harness rods so the whole carries as one. The base keeps a
// handhold, rods and right-rim peg holes of its own. Storage only for now;
// its lid defaults to none. Parts right_bay and attach_test.
//
// v32: part hinge_nut_tool, a rod with a tapered tip that holds a nut in
// its trap from below while the hinge screw is started from above.
//
// v33: hinge_type "none", a base for a machine without hinges: no hinge
// recesses, nut traps, checks or hardware; the back-wall tunnels run the
// whole back wall. The back rim stays as wide as with hinges unless
// back_rim_width is set, so extensions are shared.
//
// v34: hinge_type "printed", a hinge to print for machines without usable
// hinges: a printed arm carries a steel pin into the bed's hinge hole and
// turns on a steel pivot rod held in a printed block, which sits in a
// recess in the back rim on the hinge screw and nut trap. The pin is set at
// the bed hole's height whatever the machine. A stop face on the block
// holds the machine at ph_stop_angle when tilted back. Parts
// printed_hinges (two arms and two blocks) and printed_hinge_test (rod
// fits); the back extension's lip is notched around the hinges.
//
// v35: printed hinge: the stop is a tail on the arm behind the pivot,
// landing in a pocket in the block, and the block is held by a screw from
// below into a nut pressed into its underside; the arm and cheeks are cut
// flush with the rim where ph_min_cover allows. Pin diameter and depth
// come from the profile. Machines set flush (bed_flush) or standing on
// their feet (foot_height_mm, which sets the floor); seat depth no longer
// tied to the lid rabbet. Lips recessed into the rim when the bed stands
// less than lip_min_t above it, with trims (back_trim, left_trim) for use
// without extensions; cord_slot through the back rim, with cord_slot_trim.
// Kenmore 158.14001 profile (measured by Bob Drzyzgula).

include <BOSL2/std.scad>
include <BOSL2/screws.scad>

/* [Part] */
// What to render
part = "assembly"; // [assembly, exploded, all, test_parts, base, right_bay, base_lid, back_ext, back_lid, left_ext, left_lid, corner_ext, corner_lid, rod_plugs, outlet_cap, hinge_coupon, foot_rig, foot_rig_left, foot_rig_right, printed_hinges, printed_hinge_test, printed_hinge_view, back_trim, left_trim, cord_slot_trim, back_box, left_box, corner_box, ext_pegs, lid_hinge_test, turn_button, passthrough_cover, split_test, attach_test, hinge_nut_tool, knee_assembly, knee_sector, knee_idler, knee_pinion, knee_hub, knee_spring_housing, knee_spring_cap, knee_cover, knee_cord_clamp, knee_entry_test, bobbin_assembly, bobbin_trays, bobbin_bottom, bobbin_upper, bobbin_test, notion_assembly, notion_set, notion_30, notion_25, notion_20, notion_15, notion_10, notion_custom, spool_tray, spool_assembly, notion_test]
// Spacing between parts in the "exploded" layout
explode = 40;
// Test parts: height of the top slices
test_top_h = 12.7;
// Test parts: height of the base bottom slice above the cavity floor
test_floor_extra = 3;
// Test parts: width of the dovetail coupon (X)
test_coupon_w = 40;
// Test parts: width of the center slice (X); covers the plates at 112
test_slice_w = 112;
// Test parts: full-height wall stubs either side of the joint in the center slice
test_stub_w = 20;
// Test parts: size of the hinge block (X), centered on the left hinge
test_hinge_w = 40;
// Gap between the two halves of split test parts
test_split_gap = 10;
// Split test (part split_test): height of the front-wall stubs; 0 = full height
split_test_h = 30; // [0 : 1 : 100]
// Split test: width either side of the split line
split_test_w = 25; // [10 : 1 : 60]
// Printer build volume, for the size check and the print plates
printer_size = [256, 256, 256];
// Keep parts this far inside the bed's edges (room for supports, brims and skirts)
printer_margin = 8; // [0 : 1 : 30]
// Print plates (part all): 0 = every plate, laid out side by side; N = plate N only
print_plate = 0; // [0 : 1 : 30]
// Purge tower kept clear on plates with supported parts (square, mm); 0 = none
purge_tower_size = 40; // [0 : 5 : 80]
// Space between parts on a plate
plate_gap = 8; // [2 : 1 : 30]

/* [Options] */
// Small-compartment option ("none" = base fitted to the bed alone)
compartment_option = "storage"; // [none, storage, outlet, knee, jack]
// How the small compartment joins the base: built-in (one body with the base), or attached (a separate bay screwed to the base's right end, for beds too long to print with a built-in compartment; storage only, for now)
compartment_mount = "built-in"; // [built-in, attached]
// Hinge type
hinge_type = "lollipop"; // [lollipop, printed, none]
// Split into two dovetailed halves for printing
split = true;

/* [Machine] */
// Your machine. A listed machine supplies every setting in the "Custom machine" section; choose Custom to use those settings instead.
machine = "Singer 99K"; // [Singer 99K, Kenmore 158.14001, Custom]
// Bed cushion thickness, compressed, in inches (1/16"); for a machine standing on its feet, the pads under the feet
bed_cushion_in = 0.0625;

/* [Custom machine: IGNORED unless machine = Custom] */
// IGNORED unless machine = Custom. Bed length, inches (99K: 12 3/16")
custom_bed_length_in = 12.1875;
// IGNORED unless machine = Custom. Bed width, inches (99K: 6 9/16")
custom_bed_width_in = 6.5625;
// IGNORED unless machine = Custom. Thickness of the flat bed plate, inches (99K: 5/16")
custom_bed_plate_thickness_in = 0.3125;
// IGNORED unless machine = Custom. Hinge hole center from each end of the bed, inches (99K: 1 7/16")
custom_hinge_hole_inset_in = 1.4375;
// IGNORED unless machine = Custom. Hinge hole center below the bed top surface, inches (99K: 3/8")
custom_hinge_hole_drop_in = 0.375;
// IGNORED unless machine = Custom. Hinge hole diameter, mm: the printed hinge's pin (99K: 1/4")
custom_hinge_pin_d_mm = 6.35;
// IGNORED unless machine = Custom. How far the printed hinge's pin goes into the hinge hole, mm (no more than the hole's depth)
custom_hinge_pin_engage_mm = 12;
// IGNORED unless machine = Custom. Bed top flush with the base's rim (true) or standing above it by the plate less rabbit_depth (false, as for the 99K)
custom_bed_flush = false;
// IGNORED unless machine = Custom. A machine that stands on its own feet: from the plate's underside to the feet's bottoms, mm (0 = the bed rests on the ledge instead)
custom_foot_height_mm = 0;
// IGNORED unless machine = Custom. Slot through the back rim for cords leaving the casting, mm: [center from the bed's left end, width, slot bottom below the bed's top, height of the cords' channel left under the slot's trim]; all zeros = none
custom_cord_slot = [0, 0, 0, 0];
// IGNORED unless machine = Custom. Back bobbin trench, mm: [center from the bed's left end, width, length back from the bed edge, depth]; all zeros = none
custom_back_trench = [0, 0, 0, 0];
// IGNORED unless machine = Custom. Left bobbin trench, mm: [center from the bed's front edge, width, length left from the bed edge, depth]; all zeros = none
custom_left_trench = [83.34, 57.6, 40, 2.5];
// IGNORED unless machine = Custom. Notch in the base lid's left edge clearing the motor boss as the lid opens, mm: [depth, width]; [0, 0] = none
custom_base_lid_notch = [8, 23];
// IGNORED unless machine = Custom. Casting relief 1: which edge of the bed the thickened area is on (none = not used)
custom_relief_1_edge = "left"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 1, mm: [center, length, thickness]. Center is along the edge from the bed's left end (back/front edges) or front edge (left/right edges); thickness is measured down from the bed top
custom_relief_1 = [83.34, 76.2, 15];
// IGNORED unless machine = Custom. Casting relief 2: edge
custom_relief_2_edge = "right"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 2, mm: [center, length, thickness]
custom_relief_2 = [83.34, 76.2, 15];
// IGNORED unless machine = Custom. Casting relief 3: edge
custom_relief_3_edge = "back"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 3, mm: [center, length, thickness]
custom_relief_3 = [36.51, 50.8, 20];
// IGNORED unless machine = Custom. Casting relief 4: edge
custom_relief_4_edge = "back"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 4, mm: [center, length, thickness]
custom_relief_4 = [273.05, 50.8, 20];
// IGNORED unless machine = Custom. Casting relief 5: edge
custom_relief_5_edge = "none"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 5, mm: [center, length, thickness]
custom_relief_5 = [0, 0, 0];
// IGNORED unless machine = Custom. Casting relief 6: edge
custom_relief_6_edge = "none"; // [none, left, right, back, front]
// IGNORED unless machine = Custom. Casting relief 6, mm: [center, length, thickness]
custom_relief_6 = [0, 0, 0];

/* [Bed seat] */
// Clearance between bed and seat wall, per side
bed_clearance = 0.75;
// How far the bed rests on the ledge around the machine cavity
bed_ledge = 8; // [3 : 0.5 : 15]
// Depth of the bed seat and lid rabbet below the top surface
rabbit_depth = 4; // [2 : 0.1 : 8]
/* [Body] */
// Top rim: outer face to seat/rabbet edge, front, left and right
rim_width = 9; // [5 : 0.5 : 20]
// End wall thickness at the bottom, left and right (7/8" = 22.225)
end_wall = 22.225;
// Top rim: back of the bed seat to outer back face (0 = from the hinge)
back_rim_width = 0;
// With automatic back rim: solid behind the hinge's rear edge
hinge_back_skin = 5; // [2 : 0.5 : 15]
// Bottom thickness
bottom_thickness = 12.7;
// Cavity depth below the top surface
inner_depth = 70;
// Solid web at the top between the bed seat and the lid rabbet
divider_web = 4; // [2 : 0.5 : 10]
// Outer edge rounding (top and vertical edges)
outer_rounding = 5; // [0 : 0.5 : 10]
/* [Small compartment] */
// Inner length of the small compartment (X)
storage_inner_length = 70;
// Lid ledge width around the small compartment
lid_ledge = 10; // [5 : 0.5 : 20]
/* [Attached bay] */
// Attached bay's lid: none (the default, since cords from the machine may lie over the bay's edge), hinged (on the edge set by base_lid_hinge), or lift-out
attached_lid_type = "none"; // [none, hinged, lift-out]
// Joint screws: socket-head cap screws through the base's right end wall, from inside the machine cavity, into heat-set inserts in the bay's inner wall
attach_screw_spec = "M5";
// Joint screw clearance hole
attach_screw_hole = 5.5; // [3 : 0.1 : 8]
// Joint screw head counterbore, in the base's end wall from the cavity side
attach_head_d = 9.5; // [5 : 0.1 : 14]
// Wall left under each screw head
attach_head_seat = 8; // [4 : 0.5 : 15]
// Heat-set insert hole in the bay's inner wall (M5)
attach_insert_d = 6.4; // [3 : 0.05 : 9]
// Heat-set insert hole depth
attach_insert_depth = 10; // [5 : 0.5 : 14]
// Joint screws: distance in from the machine cavity's front and back walls
attach_screw_inset = 12; // [6 : 0.5 : 40]
// Dowels (rod_d rod, two): depth into each part
attach_dowel_depth = 10; // [5 : 0.5 : 13]
// Dowel hole in the base: press fit (diameter under rod_d)
attach_dowel_press = 0.1; // [0 : 0.05 : 0.5]
// Dowel hole in the bay: slip fit (diameter over rod_d)
attach_dowel_slip = 0.2; // [0 : 0.05 : 0.6]
// Bay's top web between the joint and its lid rabbet
attach_web = 4; // [2 : 0.5 : 10]

/* [Cord pass-through] */
// Cord pass-through width (wide enough for both plugs' cords side by side)
cord_hole_width = 46;
// Cord pass-through height (without gable)
cord_hole_height = 36;
// Close both ends of the pass-through with knock-out walls (tap them out with a punch when you fit the outlet)
passthrough_knockouts = false;
// Knock-out wall thickness
passthrough_knockout_t = 1.6; // [0.8 : 0.1 : 3]
// Score groove around each knock-out wall's edge, on its tunnel side: depth (deeper = easier to knock out)
passthrough_score_depth = 0.6; // [0.2 : 0.1 : 1.5]
// Score groove width
passthrough_score_w = 0.8; // [0.4 : 0.1 : 2]
// Make a removable cover for the pass-through (part passthrough_cover), pushed into its compartment end
passthrough_cover = false;
// Cover: depth of the plug into the tunnel
passthrough_cover_depth = 6; // [3 : 0.5 : 15]

/* [Outlet compartment] */
// Outlet body, mm: [length, width, thickness]. Modern: 76 x 40 x 22; early Bakelite: 83 x 45 x 22
outlet_size = [76, 40, 22];
// Receptacle spacing, center to center (modern 34, Bakelite 38)
outlet_receptacle_spacing = 34; // [20 : 0.5 : 60]
// Clearance around the outlet inside its curbs, per side
outlet_clearance = 1.5;
// Outlet center, front-to-back offset from the middle of the compartment
outlet_y_offset = 0; // [-50 : 0.5 : 50]
// Height of the curbs on the floor around the outlet
outlet_curb_h = 3; // [1 : 0.5 : 8]
// Width of the curbs
outlet_curb_w = 3; // [1 : 0.5 : 8]
// How the outlet is held: a heat-set insert in the end wall (needs a soldering iron), or a flat-head screw through the end wall from outside, with a nut on the outlet's face
outlet_mount = "through"; // [through, insert]
// Screw through the outlet's center hole (drill out the membrane)
outlet_screw_spec = "#8-32";
// Through mount: clearance hole for the screw
outlet_screw_hole_d = 4.6;
// Through mount: flat-head diameter (#8: 8.4)
outlet_screw_head_d = 8.4;
// Through mount: recess the head under a printed cap (part outlet_cap)
outlet_screw_cap = true;
// Through mount: cap diameter
outlet_cap_d = 12; // [9 : 0.5 : 20]
// Through mount: cap thickness
outlet_cap_t = 2; // [1 : 0.1 : 4]
// Hole for the heat-set insert in the right end wall (use the insert maker's recommended diameter)
outlet_insert_d = 5.6;
// Depth of the insert hole into the wall
outlet_insert_depth = 12; // [4 : 0.5 : 20]
// Recess the receptacle names into the floor in front of the outlet
outlet_labels = true;
// Receptacle wired always on (the light); the other is the controlled motor output
outlet_light_side = "back"; // [back, front]
// Name for the always-on receptacle
outlet_light_label = "LIGHT";
// Name for the controlled receptacle
outlet_motor_label = "MOTOR";
// Letter height
outlet_label_size = 7; // [3 : 0.5 : 12]
// Recess depth
outlet_label_depth = 0.6; // [0.2 : 0.1 : 2]
// Edge the outlet-compartment lid hinges on
outlet_lid_hinge = "left"; // [left, right, front, back]
// Cord slot 1: lid edge it opens from
outlet_slot_1_side = "front"; // [none, front, right, back]
// Cord slot 2: lid edge it opens from
outlet_slot_2_side = "back"; // [none, front, right, back]
// Slot 1 position along its edge, mm from the lid's left end (front/back edges) or front end (right edge); 0 = automatic
outlet_slot_1_pos = 0;
// Slot 2 position along its edge; 0 = automatic
outlet_slot_2_pos = 0;
// Cord slot width
outlet_slot_w = 9; // [4 : 0.5 : 20]
// Cord slot depth in from the lid edge
outlet_slot_depth = 25;
// Chamfer on the slot's top edges, easing a cord pulled over them
outlet_slot_chamfer = 1.5;

/* [Knee controller] */
// The knee controller (compartment_option = "knee"): a knee bar turns a shaft running front to back in the right bay. A crank on the bar's hub, outside the front face, pushes a compression spring in a housing beside it; steel screws in the housing set the rest and the hard stop, so the knee's force stays out of the shaft and gears. Inside, two gear stages turn a pot standing in for the donor board's slide pot, and a cam on the sector works a switch that cuts the motor for the first part of the travel. See the User's Guide before building: the board is live at mains voltage.
// Which way the knee pushes the bar
knee_push = "right"; // [right, left]
// Bar: drop from the shaft to where the knee meets it (12.5" = 317.5 mm)
knee_bar_drop = 317.5; // [150 : 0.5 : 450]
// Knee travel at that point where the switch closes and the motor starts; the travel before it is dead (1" = 25.4 mm)
knee_travel_on = 25.4; // [0 : 0.5 : 60]
// Knee travel at that point for full speed (2" = 50.8 mm)
knee_travel = 50.8; // [20 : 0.5 : 100]
// Knee travel at the hard stop (2.25" = 57.15 mm)
knee_travel_max = 57.15; // [20 : 0.5 : 120]
// Knee force at rest (the spring's preload), N (1 lb = 4.45 N)
knee_force_rest = 4.45; // [0.5 : 0.05 : 20]
// Knee force rise, N per mm of knee travel (1.5 lb/in = 0.263)
knee_force_rate = 0.263; // [0.05 : 0.001 : 1]
// Bar's square end (3/8" = 9.525 mm)
knee_bar_square = 9.525; // [5 : 0.025 : 16]
// Clearance on the bar's square end, per side
knee_bar_clearance = 0.15; // [0 : 0.05 : 0.5]
// Shaft diameter
knee_shaft_d = 8; // [6 : 0.5 : 12]
// Shaft axis: distance from the divider
knee_shaft_x = 17; // [10 : 0.5 : 40]
// Shaft axis: height above the bay floor; 0 = middle of the bay
knee_shaft_z = 0; // [0 : 0.5 : 60]
// Flanged bushings (2, front wall and bulkhead): [bore, outside diameter, length]
knee_bushing = [8, 12, 10];
// Bushing flange: [diameter, thickness]
knee_bushing_flange = [16, 2];
// Hole for a bushing's sleeve (press fit; FDM holes print a little small)
knee_bushing_hole = 12.1; // [8 : 0.05 : 20]
// Bulkhead (carries the rear bushing, the idler pin, the pot and the switch): distance behind the front wall's inside face
knee_bulkhead_pos = 36; // [25 : 0.5 : 80]
// Bulkhead thickness where the pot mounts (the pot's bushing must reach through it and take the nut)
knee_bulkhead_t = 3; // [2 : 0.1 : 5]
// Bulkhead height above the shaft axis
knee_bulkhead_above = 15; // [5 : 0.5 : 30]
// Gears: module (mm per tooth)
knee_gear_module = 1; // [0.5 : 0.05 : 2]
// First stage: idler pinion teeth (driven by the sector on the knee shaft)
knee_pinion_teeth = 16; // [12 : 1 : 30]
// First stage ratio, sector to idler pinion (the sector is cut from a gear with ratio x pinion teeth)
knee_ratio = 4; // [2 : 1 : 8]
// Second stage: idler gear teeth (a sector on the idler, driving the pot's pinion)
knee_gear2_teeth = 47; // [20 : 1 : 80]
// Second stage: pot pinion teeth
knee_pinion2_teeth = 16; // [12 : 1 : 30]
// Gear face width
knee_gear_face = 5; // [3 : 0.5 : 10]
// Tooth thinning per gear for backlash, at the pitch circle
knee_gear_backlash = 0.15; // [0 : 0.05 : 0.5]
// Extra center distance between the gears
knee_gear_cd_extra = 0.1; // [0 : 0.05 : 0.5]
// Direction from the shaft to the idler, degrees (0 = straight right, negative = down)
knee_idler_angle = 10; // [-60 : 1 : 60]
// Direction from the idler to the pot, degrees (-90 = straight down)
knee_pot_angle = -120; // [-180 : 1 : 0]
// Pot (Bourns 91, 5/8" square): body size
knee_pot_body = 15.88; // [10 : 0.01 : 25]
// Pot body depth behind the panel, with room for the pins and wires
knee_pot_depth = 22; // [10 : 0.5 : 40]
// Pot bushing (3/8-32 UNEF): panel hole
knee_pot_hole = 9.9; // [6 : 0.05 : 14]
// Pot bushing length
knee_pot_bushing_len = 9.53; // [5 : 0.01 : 15]
// Pot shaft diameter (1/4")
knee_pot_shaft_d = 6.35; // [3 : 0.05 : 8]
// Pot shaft length from the mounting face (B28: 7/8")
knee_pot_shaft_len = 22.23; // [12 : 0.01 : 30]
// Pot anti-rotation lug: radius from the shaft (0.305")
knee_pot_lug_r = 7.75; // [5 : 0.05 : 12]
// Pot anti-rotation lug: direction from the shaft, degrees (90 = up); turn the pot to suit
knee_pot_lug_angle = 90; // [-180 : 1 : 180]
// Pot anti-rotation lug: hole diameter
knee_pot_lug_hole = 2.6; // [1.5 : 0.1 : 4]
// Pot: total resistance, kOhm
knee_pot_r = 1000; // [10 : 10 : 5000]
// Pot: electrical travel, degrees
knee_pot_travel = 240; // [180 : 1 : 300]
// Pot: mechanical rotation, degrees (the end zones beyond the electrical travel take the overtravel to the stop)
knee_pot_mech = 300; // [180 : 1 : 330]
// Resistance span the board wants over the speed range (knee_travel_on to knee_travel), kOhm; a linear placeholder until the board is measured
knee_r_span = 220; // [10 : 5 : 2000]
// Off switch (Omron SS-5GL), lying under the shaft, lever up: body [length, height, thickness]
knee_switch_body = [19.8, 10.2, 6.4];
// Switch mounting holes: pitch, and height above the bottom (terminal) edge
knee_switch_holes = [9.5, 2.9];
// Switch operating position, from the mounting-hole line (8.8 +/- 0.8)
knee_switch_op = 8.8; // [5 : 0.1 : 15]
// Switch movement differential (release beyond the operating position)
knee_switch_md = 0.8; // [0.1 : 0.05 : 2]
// How far past the operating position the cam holds the lever at rest
knee_switch_press = 0.3; // [0 : 0.05 : 1.5]
// Actuating point: distance from the lever's free end (Omron's drawing: 14.5 mm from the lever's pivot end, so 5.3 from its free end)
knee_switch_act = 5.3; // [0 : 0.1 : 19]
// Switch body's bottom (terminal) edge above the bay floor, with room for the terminals and wires
knee_switch_floor = 5; // [2 : 0.5 : 15]
// Adjusting slots for the switch: travel up and down
knee_switch_adjust = 1.5; // [0 : 0.1 : 4]
// Switch screw clearance (M2 or #2-56)
knee_switch_screw = 2.4; // [1.8 : 0.05 : 3]
// Return spring (compression, standing in the housing beside the hub): [outside diameter, wire diameter, free length] (McMaster 9001T46: 0.6" OD, 0.072" wire, 1.25" long)
knee_spring = [15.24, 1.83, 31.75];
// Return spring: rate, N per mm (9001T46: 45 lb/in = 7.88)
knee_spring_rate = 7.88; // [1 : 0.01 : 50]
// Return spring: its maximum deflection, mm (9001T46: 26 lb at 0.668" long, 14.8 mm down)
knee_spring_max = 14.78; // [3 : 0.01 : 40]
// Crank radius, shaft to the crank pin; 0 = set from the spring rate to give knee_force_rate
knee_crank_r = 0; // [0 : 0.5 : 90]
// Board (75 x 35 mm donor board): [length, width]
knee_board = [75, 35];
// Board screw: [along from the board's notched end, across from the long edge nearer the screw]; the peg and rest post follow from it
knee_board_screw = [49.6, 12.5];
// Board orientation: 180 = notched end toward the back of the bay, spade tabs on the right; 0 = notched end forward, tabs on the left
knee_board_turn = 180; // [0, 180]
// Spade tabs, on the long edge away from the screw: positions along from the notched end
knee_board_tabs = [58, 70];
// Room beside the board for the spade connectors and their wires
knee_board_tab_room = 16; // [8 : 0.5 : 30]
// Mirror the board's posts across the board (for a board laid out the other way round)
knee_board_mirror = false;
// Board underside above the floor
knee_board_h = 8; // [4 : 0.5 : 20]
// Tallest part above the board underside
knee_board_parts_h = 13.6; // [5 : 0.1 : 40]
// Heat-set insert hole, M3
knee_insert_d = 4.6; // [3 : 0.05 : 6]
// How the controller is wired in: cordset = the standard pedal cordset's molded entry and clip (the control loop out to the cordset's junction); iec = fused IEC C14 inlet, with the motor and light wired at a junction under the bed; bare = a bare cord through a slot, held by a printed clamp
knee_power = "cordset"; // [cordset, iec, bare]
// Motor current (for the triac heating note and the cover vents)
knee_motor_amps = 1.0; // [0.2 : 0.1 : 3]
// Earth contact for the shaft: a post behind the shaft's end for a spring strip and the earth lead (iec)
knee_earth = true;
// Cordset entry: hole [width, height] (long side horizontal)
knee_entry_hole = [13.9, 8.5];
// Cordset entry: wall thickness at the hole
knee_entry_wall = 4.4; // [3 : 0.05 : 6]
// Cordset entry: dimple for the clip's bump, at the top of the hole [width, height, depth from the inside]
knee_entry_dimple = [3.4, 2.4, 2.8];
// Cordset entry: steel clip [width, height]
knee_entry_clip = [21.4, 9.5];
// Cordset entry: hole center above the bay floor (its pocket must clear the right handhold's ceiling)
knee_entry_z = 20; // [6 : 0.5 : 45]
// Cordset entry or IEC inlet: position from the bay's back wall; 0 = beside the board's spade tabs
knee_entry_pos = 0; // [0 : 0.5 : 140]
// Cordset: lead length inside, from the molded face to the connector tips
knee_entry_lead = 78; // [30 : 1 : 200]
// IEC inlet (Schurter KE snap-in, mounted on its side): panel cutout [along the wall, height]
knee_iec_cutout = [52.5, 27.5];
// IEC inlet: cutout corner radius
knee_iec_radius = 3; // [0 : 0.5 : 5]
// IEC inlet: panel thickness (KE: 1.5, 2 or 2.5 mm versions)
knee_iec_panel = 2; // [1.5 : 0.5 : 2.5]
// IEC inlet: depth behind the panel, with its connectors (check your inlet)
knee_iec_depth = 40; // [20 : 0.5 : 70]
// Junction: Wago 221-413 lever connector [width, depth, height]
knee_wago = [18.8, 18.8, 8.6];
// Junction: number of connectors (line, neutral, switched motor)
knee_wago_n = 3; // [1 : 1 : 6]
// Bare cord: [width, thickness] (flat SPT-2 about 7.5 x 4.5)
knee_cord = [7.5, 4.5];
// Bare cord: position along the right end wall, from the bay's back wall
knee_cord_pos = 14; // [8 : 0.5 : 120]
// Part knee_assembly: how far the knee is pushed, 0 (rest) to 1 (hard stop)
knee_view = 0; // [0 : 0.05 : 1]

/* [Lollipop hinge] */
// Hinge flange diameter
hinge_flange_diameter = 29; // [15 : 0.1 : 50]
// Hinge flange thickness
hinge_flange_thickness = 3; // [1 : 0.1 : 8]
// Hinge body depth below the top surface
hinge_thickness = 8; // [3 : 0.1 : 20]
// Hinge body diameter
hinge_inner_diameter = 27; // [10 : 0.1 : 50]
// Hinge pin thickness (X)
hinge_pin_thickness = 8; // [3 : 0.1 : 15]
// Hinge pin height (Z)
hinge_pin_height = 8; // [3 : 0.1 : 15]
// Hinge pin extension
hinge_pin_extension = 25; // [5 : 0.5 : 60]
// Hinge pin square projection
hinge_pin_square_projection = 10; // [2 : 0.5 : 30]
// Hinge pin allowed square projection into the bed seat
hinge_pin_allowed_projection = 2; // [0 : 0.1 : 6]
// Hinge pin internal length
hinge_pin_internal_length = 15; // [5 : 0.5 : 40]
// Extra depth below the pin for its corner to sweep through
hinge_pin_sweep_depth = 1; // [0 : 0.1 : 4]
// Hinge mounting hole diameter
hinge_mounting_hole_diameter = 5; // [2 : 0.1 : 10]
// Mounting hole center, inward from the flange's back edge
hinge_mounting_hole_offset = 9.5;

/* [Printed hinge] */
// Steel pin into the bed's hinge hole: diameter, just under the hole's; 0 = from the machine profile (1/4" for the 99K, 6 mm for the Kenmore 158)
ph_pin_d = 0; // [0 : 0.01 : 12]
// How far the pin enters the bed's hole; 0 = from the machine profile
ph_pin_engage = 0; // [0 : 0.5 : 30]
// Length of the pin pressed into the arm
ph_pin_embed = 16; // [8 : 0.5 : 30]
// Steel pivot rod, running along the back through the block and the arm: diameter
ph_pivot_d = 6.35; // [3 : 0.01 : 12]
// Press fit: printed hole diameter minus rod diameter (try part printed_hinge_test)
ph_press = 0; // [-0.4 : 0.05 : 0.4]
// Running fit: the arm's pivot hole is this much larger than the rod
ph_slip = 0.3; // [0 : 0.05 : 1]
// Plastic around the rods in the arm
ph_wall = 4; // [2.5 : 0.5 : 8]
// Arm width (X)
ph_arm_w = 14; // [8 : 0.5 : 30]
// Block cheeks either side of the arm (X)
ph_cheek = 6; // [3 : 0.5 : 15]
// Clearance between the moving arm and the block
ph_clear = 0.4; // [0.2 : 0.05 : 1.5]
// Base web left between the bed seat and the hinge recess
ph_web = 4; // [2 : 0.5 : 10]
// Block floor under the arm
ph_floor = 3; // [2 : 0.5 : 8]
// Fit of the block in its recess, each side
ph_recess_clear = 0.2; // [0 : 0.05 : 0.6]
// Tilt-back stop: a tail on the arm, behind the pivot, comes to rest in the block at about this angle (0 = no stop, 45 to 110)
ph_stop_angle = 60; // [0 : 1 : 110]
// Tail length behind the pivot (longer: less force on the stop, deeper block)
ph_tail = 12; // [6 : 0.5 : 25]
// Least plastic over the rods where the arm and cheeks are cut down to the rim
ph_min_cover = 2.5; // [1.5 : 0.25 : 5]

/* [Foot-locating rig] */
// Parts foot_rig_left and foot_rig_right: a thin box that fits round the bed, to stand the machine on paper and print its inked feet. Wall height
rig_height = 80; // [30 : 1 : 150]
// Wall thickness
rig_wall = 2.4; // [1.2 : 0.2 : 5]
// Floor rim, inward from the wall (it lies under the bed's edge)
rig_rim = 10; // [5 : 0.5 : 25]
// Floor rim thickness
rig_floor = 2; // [1 : 0.2 : 5]
// Overlap of the splice tabs past the split, each way
rig_lap = 15; // [8 : 1 : 30]
// Splice bolt holes (M3)
rig_bolt_d = 3.4; // [2 : 0.1 : 5]
// Screw holes through the floor rim, to fix the rig to a board
rig_screw_d = 3.5; // [2 : 0.1 : 6]
// Marking holes in the floor rim, this far in from the bed's edges at each corner and at the split, for a pencil or awl
rig_mark_in = 5; // [3 : 0.5 : 9]
rig_mark_d = 1.6; // [0.8 : 0.1 : 3]
// Floor bars across the rig, this far in from each end of the bed (mm), to keep each half square; set them where no foot can land (0 = none)
rig_bar_in = 100; // [0 : 1 : 250]
// Floor bar width, and the height of the stiffening rib along it
rig_bar_w = 10; // [5 : 0.5 : 20]
rig_bar_rib = 5; // [0 : 0.5 : 15]
// A floor bar across the split as well (it covers the paper there)
rig_crossbar = false;

/* [Hinge coupon] */
// Solid margin around the hinge flange (room for the corner screws)
hinge_coupon_margin = 12;
// Floor left under the deepest hinge cut
hinge_coupon_floor = 4; // [2 : 0.5 : 10]
// Corner holes for #8 flat-head wood screws: clearance hole
hinge_coupon_screw_d = 4.6;
// Corner holes: countersink diameter at the top face
hinge_coupon_head_d = 8.4;

/* [Hinge nut traps] */
// Nut for the hinge screws (BOSL2 spec, e.g. "#8-32", "M4")
hinge_nut_spec = "#8-32";
// Nut width across flats; 0 = from the spec
hinge_nut_width = 0; // [0 : 0.05 : 20]
// Depth of the nut's upper face below the top surface
hinge_nut_depth = 21; // [8 : 0.5 : 60]
// Sacrificial bridge over the nut trap (0 = none; drill through after printing)
hinge_nut_bridge = 0.2;
// Nut tool (part hinge_nut_tool): tip diameter, to fit the nut's bore (a nylon-insert locknut's insert: 1/8")
hinge_nut_tool_tip = 3.0; // [1.5 : 0.05 : 6]

/* [Mending plates] */
// Number of plates across the split (0 = none)
plate_count = 3;
// Plate length (McMaster 1394A34: 4")
plate_length = 101.6;
// Plate width (5/8")
plate_width = 15.875;
// Plate thickness (0.070")
plate_thickness = 1.778;
// Hole centers [along, across] from the plate center (0.889" pitch, staggered 0.094")
plate_holes = [[-33.866, 2.375], [-11.289, -2.375],
               [11.289, 2.375], [33.866, -2.375]];
// Sacrificial layer over each screw hole at the pocket ceiling (0 = none); drill through
plate_hole_bridge = 0.3;
// Clearance around the plate in its pocket, per side
plate_pocket_clearance = 0.5;
// How far the plate sits up inside its pocket, so screw heads stay off the table
plate_standoff = 1.0;
// Screw clearance hole diameter (#8)
plate_screw_clearance = 4.6;
// Nut for the plate screws (BOSL2 spec)
plate_nut_spec = "#8-32";
// Nut width across flats; 0 = from the spec
plate_nut_width = 0; // [0 : 0.05 : 20]
// Nut trap depth into the cavity floor
plate_nut_trap_depth = 3.5;
// Minimum distance from the cavity walls to the plate edge
plate_wall_margin = 8; // [2 : 0.5 : 20]
/* [Nut fit] */
// Extra clearance added to nut width (applied to each side)
nut_clearance = 0.15;

/* [Casting reliefs] */
// Clearance below the casting in a relief (the reliefs themselves come from the machine profile)
relief_clearance = 1; // [0 : 0.1 : 4]
// Extra length added at each end of a relief
relief_margin = 2; // [0 : 0.5 : 10]
/* [Back wall lightening] */
// Hollow the back wall between the hinges
lighten_back_wall = true;
// Back wall thickness left behind the tunnels
back_skin = 17; // [6 : 0.5 : 40]
// Solid material above the tunnel peaks
back_top_skin = 6; // [2 : 0.5 : 20]
// Target tunnel width
tunnel_width = 30;
// Web between tunnels
tunnel_web = 6;
// Extra solid kept beyond each side of the hinge footprint
hinge_tunnel_margin = 7.5;
// Solid zone kept on either side of the split, from the cut line
split_keepout = 15;

/* [Split] */
// Which part to render when split
split_part = "both"; // [both, left, right]
// Separation between the two halves when both are shown
split_spread = 30;
// Clearance in the joint, per face
split_clearance = 0.1;
// Dovetail key width at the cut line (neck)
key_neck = 8; // [4 : 0.5 : 16]
// Dovetail flare, per side, in degrees; steeper = less pull-apart play
key_flare_angle = 30;
// Dovetail key length, past the cut line into the right half
key_depth = 8; // [4 : 0.5 : 16]
// Key positions in Y; empty = automatic (floor keys between plate rows,
// one centered in the back wall)
key_ys = [];
// Vertical V-serrations across the front wall's joint faces
serrations = true;
// Serration pitch (ridge to ridge)
serration_pitch = 3; // [2 : 0.1 : 6]
// Serration height (ridge tip beyond the cut line); pitch / 2 gives a 90-degree V
serration_height = 1.5;
// Solid wall kept between the serrations and each face of the front wall (outer skin and cavity side)
serration_setback = 2.5;
// Serrations stop this far below the bed ledge
serration_top_gap = 3; // [1 : 0.5 : 10]
// Extra clearance at the top of each groove, so the ridges never bottom out
serration_top_clear = 0.5;

/* [Extensions] */
// Include the back extension (outfeed support / compartment)
back_ext = true;
// Include the left extension
left_ext = true;
// Include the left-rear corner piece (needs both of the above)
corner_ext = true;
// Back extension length (X), from the base's left face
back_ext_length = 240;
// Back extension body depth (Y), behind the base
back_ext_depth = 100;
// Left extension body width (X), left of the base
left_ext_width = 100;
// Gap between an extension body and the base or another extension
ext_gap = 0.3;
// Clearance between the lip and the base top
lip_clearance = 0.2;
// Least lip thickness: where the bed stands less than this above the rim (a bed set flush, say), the rim is cut down under the lips so they keep it, and trim strips (parts back_trim, left_trim) fill the cuts when the extensions are off
lip_min_t = 5.4; // [3 : 0.1 : 10]
// Clearance around the recessed lips and the trims, per side
lip_cut_clearance = 0.25; // [0.1 : 0.05 : 0.6]
// Trim to the extensions' top plane (lids, lips, trenches) against the real bed, mm; negative lowers it
ext_top_adjust = 0; // [-3 : 0.1 : 3]
// Extension floor thickness
ext_floor = 3; // [1.5 : 0.1 : 8]
// Frame width around each lid, at the top
ext_frame = 4; // [2 : 0.1 : 10]
// Ledge the lid rests on, inside the frame
ext_ledge = 4; // [2 : 0.1 : 10]
// Lid thickness (= depth of the lid rabbet)
ext_lid_thickness = 4; // [2 : 0.1 : 8]
// Clearance around the lid in its rabbet, per side
ext_lid_clearance = 0.3;
// Hinged lids: the ledge on the hinge side is widened so the open lid stays this far clear of the bay
ext_hinge_margin = 0.5;
// Keep the corner bay square, with matching extra ledge on its other two sides
corner_bay_square = true;
// Finger hole in each lid
ext_finger_hole = 22;
// Rounding of the extensions' exposed edges
ext_rounding = 3; // [0 : 0.5 : 8]
/* [Turn button] */
// Turn button on the front rim that holds the bed's front edge down (off by default)
turn_button = false;
// Position along the front rim (X); 0 = automatic, between the split and the compartment
turn_button_x = 0;
// How far the button reaches over the bed's front edge
turn_button_overlap = 4; // [1 : 0.5 : 10]
// Button width
turn_button_w = 9; // [6 : 0.5 : 16]
// Button thickness
turn_button_t = 4; // [2 : 0.5 : 8]
// Gap between the button and the bed top
turn_button_gap = 0.3;
// Easing: how far the pad's smooth slopes run out along the rim, each side
turn_button_ease = 10;
// How far the pad swells out of the front face, enclosing the nut
turn_button_swell = 3; // [0 : 0.5 : 8]
// Below the nut, the swelling blends back into the front face over this height
turn_button_swell_taper = 10;
// Nut for the button screw (BOSL2 spec)
turn_button_nut_spec = "#8-32";

/* [Freestanding boxes] */
// Also make a freestanding version of the back extension (part back_box): same bay and lid, no lip, pegs or dovetails
make_back_box = false;
// Also make a freestanding left box (part left_box)
make_left_box = false;
// Also make a freestanding corner box (part corner_box)
make_corner_box = false;

/* [Extension pegs] */
// Holes in the base rim for the extension pegs
ext_peg_holes = true;
// Pegs: insert (separate printed pegs, part ext_pegs, printed lying down), pin (cut from rod_d rod), or molded into the lip (as before v20)
ext_peg_style = "insert"; // [insert, pin, molded]
// Peg diameter (printed pegs)
peg_d = 4; // [3 : 0.1 : 8]
// Peg length below the lip
peg_len = 3; // [1.5 : 0.1 : 6]
// Hole diameter in the base (for printed pegs; pins use rod_d + 0.2)
peg_hole_d = 4.4;
// Peg hole in the lip, over the peg diameter (the peg's crush ribs make the press fit)
peg_lip_clearance = 0.2;
// Metal pins: press fit in the lip, hole under the rod diameter
pin_lip_interference = 0.1;
// Hole depth in the base
peg_hole_depth = 3.5;
// Back-rim peg positions (X); keep clear of the hinges and the split
back_peg_xs = [16, 230];
// Left-rim peg positions (Y)
left_peg_ys = [35, 150];
// Right-rim peg positions (Y), for future right-side extensions; [] for none
right_peg_ys = [35, 150];

/* [Corner dovetails] */
// Dovetail width at the mating face
ext_dt_neck = 6; // [3 : 0.5 : 12]
// Dovetail width at its head
ext_dt_head = 9; // [4 : 0.5 : 16]
// Dovetail depth into the mating wall
ext_dt_depth = 4; // [2 : 0.5 : 10]
// Dovetail clearance per face
ext_dt_clearance = 0.2;

/* [Handholds] */
// Handholds under each end
handholds = true;
// Handhold length along the end, at the bottom face (3")
handhold_bottom_len = 76.2;
// Handhold length at its top (2")
handhold_top_len = 50.8;
// Handhold height above the bottom face (1/2")
handhold_height = 12.7;
// Handhold depth into the end wall (5/8")
handhold_depth = 15.875;
// Flat underside of the lip at the face, before the ceiling climbs
handhold_lip_flat = 4; // [0 : 0.5 : 10]
// Radius rounding the lip's outer edge
handhold_lip_round = 2; // [0 : 0.5 : 6]
// Knock-out wall under the lip, removed after printing
handhold_knockout = true;
// Knock-out wall thickness
knockout_t = 1.2;
// Gap between the knock-out wall and the lip
knockout_gap = 0.2;
// Breakaway tab tying one end of the knock-out wall to the pocket end
knockout_tab = true;
// Tab height (the tab sits just under the lip gap)
knockout_tab_h = 0.8;
// Brim around the foot of each knock-out wall, so it stands until the tab joins it
knockout_brim = true;
// Brim width each side of the wall
knockout_brim_w = 5;
// Brim height (about one first layer)
knockout_brim_h = 0.2;

/* [Harness rods] */
// Rod notches and rods either side of each handhold
harness_rods = true;
// Rod diameter (3/16")
rod_d = 4.7625;
// Rod hole diameter (printed as a teardrop, point up)
rod_hole_d = 4.95;
// Rod center in from the end face
rod_x = 7; // [3 : 0.1 : 15]
// Rod center above the bottom face
rod_z = 7; // [3 : 0.1 : 15]
// Notch length along the rod
notch_len = 25;
// Clear space around the rod in the notch, behind and above it
notch_clear = 4; // [1 : 0.5 : 10]
// Distance from each outer face (front, back) to its notch
notch_inset = 25;
// Material left between a rod's blind end and the handhold
rod_stop = 5;
// Printed plug closing the open end of each rod hole (0 = no plugs; rods run to the face)
rod_plug_len = 5; // [0 : 0.5 : 10]
// Plug clearance in the hole, per side (the crush ribs make the press fit)
rod_plug_clearance = 0.1;
// Crush rib interference, beyond the hole wall
rod_plug_rib = 0.15;

/* [Left lip] */
// Radius of the rounded top edge along the lip front (also the free edges of an extended back lip)
lip_edge_round = 2; // [0 : 0.5 : 5]
// Radius of the inside corner where the lip front meets the body (also an extended back lip's corners)
lip_fillet = 5; // [0 : 0.5 : 15]

/* [Back lip] */
// Run the back lip on past a short back extension, over the base's back rim, to reach the last back peg hole
back_lip_extend = true;
// How far the lip runs past the last peg's center
back_lip_peg_margin = 10; // [6 : 0.5 : 30]
/* [Lid hinges] */
// Lid edge each lid hinges on
base_lid_hinge = "right"; // [left, right, front, back]
back_lid_hinge = "back"; // [left, right, front, back]
left_lid_hinge = "left"; // [left, right, front, back]
corner_lid_hinge = "back"; // [left, right, front, back]
// Base compartment lid: hinged (snap-in dimple hinge), lift-out (plain lid resting on the ledge), or none (rabbet left for a lid later)
base_lid_type = "hinged"; // [hinged, lift-out, none]
// Back extension lid type
back_lid_type = "hinged"; // [hinged, lift-out, none]
// Left extension lid type
left_lid_type = "hinged"; // [hinged, lift-out, none]
// Corner piece lid type
corner_lid_type = "hinged"; // [hinged, lift-out, none]
// Base compartment lid style: solid, or perforated for ventilation
base_lid_style = "solid"; // [solid, perforated]
// Back extension lid style
back_lid_style = "solid"; // [solid, perforated]
// Left extension lid style
left_lid_style = "solid"; // [solid, perforated]
// Corner piece lid style
corner_lid_style = "solid"; // [solid, perforated]
// Base compartment lid grip: finger hole, or a thumb tab reaching over a notch in the wall
base_lid_grip = "finger hole"; // [finger hole, tab]
// Base lid tab edge (front only is practical, on a lift-out lid)
base_lid_tab_edge = "front"; // [front, back, left, right]
// Back extension lid grip
back_lid_grip = "finger hole"; // [finger hole, tab]
// Back lid tab edge (back or right)
back_lid_tab_edge = "right"; // [front, back, left, right]
// Left extension lid grip
left_lid_grip = "finger hole"; // [finger hole, tab]
// Left lid tab edge (front or left)
left_lid_tab_edge = "front"; // [front, back, left, right]
// Corner piece lid grip
corner_lid_grip = "finger hole"; // [finger hole, tab]
// Corner lid tab edge (left or back)
corner_lid_tab_edge = "left"; // [front, back, left, right]
// Thumb tab width
grip_tab_w = 25;
// Thumb tab overhang past the outer face
grip_tab_over = 1.5;
// Thumb tab corner radius
grip_tab_r = 2; // [0 : 0.5 : 5]
// Thumb scoop below the tab: depth into the outer face
grip_scoop_d = 2.5;
// Thumb scoop height below the lid
grip_scoop_h = 6; // [2 : 0.5 : 12]
// Base lid motor-boss notch (size from the machine profile): inner corner radius
base_lid_notch_r = 4; // [0 : 0.5 : 10]
// Notch: radius blending it into the lid edge
base_lid_notch_flare = 10;
// Notch: front-to-back offset from the middle of the lid
base_lid_notch_offset = 0; // [-50 : 0.5 : 50]
// Perforation hole diameter
lid_perf_d = 5; // [2 : 0.5 : 12]
// Perforation pitch (hex grid)
lid_perf_pitch = 8; // [4 : 0.5 : 20]
// Solid margin kept around the lid's edges, finger hole and hinge
lid_perf_margin = 6; // [2 : 0.5 : 20]
// Hinge bump diameter at its base
lid_bump_d = 3; // [1.5 : 0.1 : 6]
// How far each bump engages the wall
lid_bump_engage = 1.0;
// Flex tab carrying each bump: length along the end
lid_tab_len = 15;
// Flex tab width
lid_tab_w = 4; // [1.5 : 0.1 : 8]
// Slot that frees the flex tab
lid_slot_w = 1; // [0.5 : 0.1 : 3]
// Bump flank angle from its axis: smaller is steeper and holds better (45 = the v19 cone)
lid_bump_angle = 35; // [15 : 1 : 60]
// Clearance at the lid's two hinge ends (less end float keeps both bumps engaged)
lid_hinge_end_clearance = 0.15;
// Clearance between bump and recess, per side
lid_recess_clearance = 0.075;
// Cut a chamfer behind the hinge so an open lid leans back and stays up
lid_open_stop = true;

/* [Inserts] */
// Spacing between parts in the insert print layouts
ins_spacing = 10; // [0 : 1 : 50]
// Bobbin diameter (class 15 and 66: 13/16"), for the bobbin trays and the spool tray
bobbin_d = 20.6375;
// Bobbin thickness (class 15 and 66: 7/16")
bobbin_t = 11.1125;

/* [Bobbin trays (corner bay)] */
// Number of trays, bottom included; 0 = as many as fit under the lid
bb_trays = 0; // [0 : 1 : 10]
// Post diameter (class 15 and 66 bores are a little over 6 mm)
bb_post_d = 5; // [3 : 0.1 : 10]
// Post grid [columns (X), rows (Y)]; cells that would crowd the center column are left empty
bb_grid = [3, 3];
// Tray floor thickness
bb_floor = 3; // [1.2 : 0.1 : 6]
// Clearance between a bobbin's top and the tray above
bb_bobbin_clear = 1; // [0 : 0.1 : 4]
// Clearance between the trays and the bay walls, per side
bb_wall_clear = 0.75; // [0.2 : 0.05 : 3]
// Tray corner radius
bb_corner_r = 2; // [0 : 0.5 : 10]
// Clearance between the top of the knob and the lid
bb_top_clear = 1; // [0 : 0.1 : 5]
// Lightening holes where four cells meet
bb_lighten = true;
// Lightening hole diameter
bb_lighten_d = 12; // [4 : 0.5 : 20]
// Pin on each post tip: diameter
bb_pin_d = 3; // [1.5 : 0.1 : 6]
// Pin height above the post shoulder
bb_pin_h = 2; // [0.5 : 0.1 : 5]
// Socket clearance around the pin, per side
bb_socket_clear = 0.2; // [0 : 0.05 : 1]
// Socket depth beyond the pin
bb_socket_extra = 0.4; // [0 : 0.1 : 2]
// Chamfer at the socket mouth (also absorbs elephant's foot)
bb_socket_chamfer = 0.6; // [0 : 0.1 : 2]
// Handle column diameter
bb_column_d = 12; // [6 : 0.5 : 20]
// Flare radius at the column's foot
bb_column_flare = 2; // [0 : 0.5 : 5]
// Knob diameter
bb_knob_d = 18; // [8 : 0.5 : 30]
// Knob height
bb_knob_h = 8; // [3 : 0.5 : 20]
// Clearance between the knob and the upper trays' center holes, per side
bb_hole_clear = 0.5; // [0.1 : 0.05 : 2]

/* [Notion trays (back or left bay)] */
// Bay the notion and spool trays go in
ot_bay = "back"; // [back, left]
// Custom tray height
ot_custom_h = 12; // [5 : 0.5 : 80]
// Tray heights shown stacked in part notion_assembly
ot_show = [25, 20, 15, 10];
// Clearance between the trays and the bay walls, per side
ot_wall_clear = 1; // [0.2 : 0.05 : 3]
// Wall thickness
ot_wall = 1.2; // [0.8 : 0.1 : 4]
// Floor thickness
ot_floor = 1.6; // [0.8 : 0.1 : 4]
// Outer corner radius
ot_corner_r = 2; // [0 : 0.5 : 10]
// Corner boss size (square, from the outer corner)
ot_boss = 9; // [5 : 0.5 : 20]
// Pin diameter
ot_pin_d = 3; // [1.5 : 0.1 : 6]
// Pin height above the wall tops
ot_pin_h = 2; // [0.5 : 0.1 : 5]
// Socket clearance around the pin, per side
ot_socket_clear = 0.2; // [0 : 0.05 : 1]
// Socket depth beyond the pin
ot_socket_extra = 0.4; // [0 : 0.1 : 2]
// Chamfer at the socket mouth (also absorbs elephant's foot)
ot_socket_chamfer = 0.5; // [0 : 0.1 : 2]
// Finger-hold lip length along each end wall
ot_grip_w = 40; // [10 : 1 : 120]
// How far the lip reaches in from the wall
ot_grip_reach = 5; // [0 : 0.5 : 15]
// Thickness of the lip at its top, above the 45-degree underside
ot_grip_t = 1.5; // [0.8 : 0.1 : 4]
// Clearance between the top tray's pins and the lid
ot_top_clear = 1; // [0 : 0.1 : 5]

/* [Notion tray compartments] */
// Divide the plain notion trays (not the spool tray) into compartments
ot_compartments = false;
// Target compartment size; the grid divides the tray evenly to come closest to it (2" gives 2 x 4 in the back or left bay; 1" gives 3 x 8)
ot_cell = 50.8; // [10 : 0.1 : 100]
// Compartments along the tray's length (0 = from ot_cell)
ot_cols = 0; // [0 : 1 : 20]
// Compartments across the tray's width (0 = from ot_cell)
ot_rows = 0; // [0 : 1 : 20]
// Divider height, as a fraction of the tray height
ot_divider_frac = 0.8; // [0.2 : 0.05 : 1]
// Divider thickness
ot_divider_t = 1.2; // [0.8 : 0.1 : 4]

/* [Spool tray] */
// Spool diameter
ot_spool_d = 38; // [20 : 0.5 : 80]
// Spool height
ot_spool_h = 44; // [20 : 0.5 : 100]
// Post diameter at the top, through the bobbin
ot_spool_post_d = 5; // [3 : 0.1 : 15]
// Post diameter at the floor; the post tapers to the top diameter at the spool top
ot_spool_post_base_d = 7; // [3 : 0.1 : 20]
// Smallest spool bore you expect (for the console check)
ot_spool_bore = 7.5; // [3 : 0.1 : 20]
// Space between neighboring spools
ot_spool_gap = 1.5; // [0 : 0.1 : 10]
// Space between the spools and the tray walls and corner bosses
ot_spool_wall_gap = 0.5; // [0 : 0.1 : 5]
// Clearance between the bobbin tops and the tray above
ot_spool_top_clear = 1; // [0 : 0.1 : 5]
// Cut the long side walls down to a curb between the corner bosses, so the spools can be grasped from the side
ot_spool_open_sides = true;
// Curb height left along the long sides (it stiffens the floor when the tray is lifted by its ends)
ot_spool_curb = 14; // [3 : 0.5 : 40]
// Radius at the bottom corners of the cutaway
ot_spool_cut_r = 5; // [0 : 0.5 : 20]

/* [Tray gussets] */
// Small triangular ribs at the foot of the trays' long walls, where a thin wall meets the floor at one layer line
ot_gussets = true;
// Gusset thickness (on the spool tray it must fit between neighboring spools)
ot_gusset_t = 1; // [0.6 : 0.1 : 3]
// Gusset reach along the floor, from the wall
ot_gusset_d = 5; // [1 : 0.5 : 15]
// Gusset height up the wall (less on low trays)
ot_gusset_h = 8; // [1 : 0.5 : 20]
// Spacing to aim for between gussets on plain trays
ot_gusset_pitch = 40; // [15 : 1 : 120]

/* [Hidden] */
// Overlap so cutters break cleanly through faces
overlap = 0.5;
$fa = 2;
$fs = 0.4;

in = 25.4;

// Console report (dimensions, checks, hardware) only when something is
// rendered; a file that includes this one with part = "none" stays quiet.
report = part != "none";

// Dovetail key width at its head, from the neck, depth and flare
key_head = key_neck + 2 * key_depth * tan(key_flare_angle);
// Free movement between the halves along X: flat faces plus slanted faces
key_play = split_clearance + split_clearance / sin(key_flare_angle);

// ---------------------------------------------------------------------------
// Machine profiles
//
// To add a machine: add an entry here, with every key, and add its name to
// the `machine` list in the Customizer section at the top. Keys are the
// "Custom machine" settings without "custom_". Measure your own casting
// before trusting a profile: castings vary, even within a model.
// ---------------------------------------------------------------------------

profiles = [
    ["Singer 99K", [
        // 12 3/16" x 6 9/16" bed, 5/16" plate; hinge holes 1 7/16" from
        // each end, 3/8" below the top
        ["bed_length_in",          12.1875],
        ["bed_width_in",           6.5625],
        ["bed_plate_thickness_in", 0.3125],
        ["hinge_hole_inset_in",    1.4375],
        ["hinge_hole_drop_in",     0.375],
        // 3" in the middle of each end at 15 mm; 1" either side of each
        // hinge hole at 20 mm
        ["bed_reliefs", [["left", 83.34, 76.2, 15], ["right", 83.34, 76.2, 15],
                         ["back", 36.51, 50.8, 20], ["back", 273.05, 50.8, 20]]],
        // Bobbin plate on the left end: 2 3/16" wide, centered, 2 mm thick,
        // slides about 1 1/4" past the casting
        ["back_trench", [0, 0, 0, 0]],
        ["left_trench", [83.34, 57.6, 40, 2.5]],
        // The base lid's left edge clears the motor boss as the lid opens
        ["base_lid_notch", [8, 23]],
        ["hinge_pin_d_mm",         6.35],
        ["hinge_pin_engage_mm",    12],
        ["bed_flush",              false],
        ["foot_height_mm",         0],
        ["cord_slot",              [0, 0, 0, 0]]
    ]],
    ["Kenmore 158.14001", [
        // 425 x 185 mm bed, 7 mm plate, sitting flush in its base on three
        // cast feet 63 mm below the plate; bobbin cover hinged, so no
        // trenches. Hinge holes 6 mm, 90 mm from each end, 6.75 mm below
        // the top; its own pins went 16 mm in. Measured by Bob Drzyzgula.
        ["bed_length_in",          425 / 25.4],
        ["bed_width_in",           185 / 25.4],
        ["bed_plate_thickness_in", 7 / 25.4],
        ["hinge_hole_inset_in",    90 / 25.4],
        ["hinge_hole_drop_in",     6.75 / 25.4],
        // Back: the left hinge boss (22 mm) and the hook-shaft bump beside
        // it toward the left end, one relief from 63 to 101 mm; the right
        // hinge boss; the cord connector's narrow end (20 mm, 50 mm from
        // the right end, reaching about 55 mm below the plate)
        ["bed_reliefs", [["back", 82, 38, 25], ["back", 335, 22, 25],
                         ["back", 375, 20, 63]]],
        ["back_trench", [0, 0, 0, 0]],
        ["left_trench", [0, 0, 0, 0]],
        ["base_lid_notch", [0, 0]],
        ["hinge_pin_d_mm",         6],
        ["hinge_pin_engage_mm",    16],
        ["bed_flush",              true],
        ["foot_height_mm",         63],
        // Two lamp cords, 12 x 3 mm together, leave the connector 50 mm
        // below the plate and run straight back
        ["cord_slot",              [375, 14, 60, 5]]
    ]]
];

// The Customizer can't show a list of reliefs, so Custom has six slots.
custom_relief_slots = [
    [custom_relief_1_edge, custom_relief_1], [custom_relief_2_edge, custom_relief_2],
    [custom_relief_3_edge, custom_relief_3], [custom_relief_4_edge, custom_relief_4],
    [custom_relief_5_edge, custom_relief_5], [custom_relief_6_edge, custom_relief_6]];
custom_bed_reliefs = [for (sl = custom_relief_slots)
                         if (sl[0] != "none" && len(sl[1]) == 3)
                             [sl[0], sl[1][0], sl[1][1], sl[1][2]]];
// A trench is used only if its width, length and depth are all positive
function trench_or_none(t) =
    is_list(t) && len(t) == 4 && t[1] > 0 && t[2] > 0 && t[3] > 0 ? t : [];

custom_settings = [
    ["bed_length_in",          custom_bed_length_in],
    ["bed_width_in",           custom_bed_width_in],
    ["bed_plate_thickness_in", custom_bed_plate_thickness_in],
    ["hinge_hole_inset_in",    custom_hinge_hole_inset_in],
    ["hinge_hole_drop_in",     custom_hinge_hole_drop_in],
    ["bed_reliefs",            custom_bed_reliefs],
    ["back_trench",            custom_back_trench],
    ["left_trench",            custom_left_trench],
    ["base_lid_notch",         custom_base_lid_notch],
    ["hinge_pin_d_mm",         custom_hinge_pin_d_mm],
    ["hinge_pin_engage_mm",    custom_hinge_pin_engage_mm],
    ["bed_flush",              custom_bed_flush],
    ["foot_height_mm",         custom_foot_height_mm],
    ["cord_slot",              custom_cord_slot]
];

profile_found = machine == "Custom" || !is_undef(struct_val(profiles, machine));
use_custom    = machine == "Custom" || !profile_found;
active_profile = use_custom ? custom_settings : struct_val(profiles, machine);
function mach(key) =
    let(v = struct_val(active_profile, key))
    is_undef(v) ? struct_val(custom_settings, key) : v;

bed_length_in          = mach("bed_length_in");
bed_width_in           = mach("bed_width_in");
bed_plate_thickness_in = mach("bed_plate_thickness_in");
hinge_hole_inset_in    = mach("hinge_hole_inset_in");
hinge_hole_drop_in     = mach("hinge_hole_drop_in");
bed_reliefs            = mach("bed_reliefs");
hinge_pin_d_mm         = mach("hinge_pin_d_mm");
hinge_pin_engage_mm    = mach("hinge_pin_engage_mm");
bed_flush              = mach("bed_flush");
foot_height            = mach("foot_height_mm");
cord_slot              = mach("cord_slot");
back_trench            = trench_or_none(mach("back_trench"));
left_trench            = trench_or_none(mach("left_trench"));
base_lid_notch         = mach("base_lid_notch");

if (!profile_found)
    if (report) echo(str("WARNING: no profile named \"", machine,
             "\"; using the Custom machine settings"));
if (use_custom) {
    if (report) echo("Machine: Custom (using the Custom machine settings)");
} else {
    if (report) echo(str("Machine: ", machine, " profile. The Custom machine settings are ignored."));
    differs = [for (kv = custom_settings)
                  if (struct_val(active_profile, kv[0]) != kv[1]) kv[0] == "bed_reliefs" ? "custom_relief_1 to 6" : str("custom_", kv[0])];
    if (len(differs) > 0)
        if (report) echo(str("NOTE: these Custom machine settings differ from the profile and are being ignored: ",
                 differs));
    if (report) echo("To start a Custom machine from this profile, copy these lines into the Custom machine settings:");
    for (kv = custom_settings)
        if (kv[0] != "bed_reliefs")
            if (report) echo(str("  custom_", kv[0], " = ", mach(kv[0]), ";"));
    pr = mach("bed_reliefs");
    for (i = [0 : 5])
        if (i < len(pr)) {
            if (report) echo(str("  custom_relief_", i + 1, "_edge = \"", pr[i][0], "\";"));
            if (report) echo(str("  custom_relief_", i + 1, " = ", [pr[i][1], pr[i][2], pr[i][3]], ";"));
        } else
            if (report) echo(str("  custom_relief_", i + 1, "_edge = \"none\";"));
    if (len(pr) > 6)
        if (report) echo("WARNING: this profile has more than six reliefs; Custom holds only six");
}

// ---------------------------------------------------------------------------
// Derived dimensions
// ---------------------------------------------------------------------------

bed_length          = bed_length_in * in;
bed_width           = bed_width_in * in;
bed_plate_thickness = bed_plate_thickness_in * in;
hinge_hole_inset    = hinge_hole_inset_in * in;
hinge_hole_drop     = hinge_hole_drop_in * in;
bed_cushion         = bed_cushion_in * in;
hinge_hole_spacing  = bed_length - 2 * hinge_hole_inset;

seat_length = bed_length + 2 * bed_clearance;
seat_width  = bed_width + 2 * bed_clearance;

// How the bed sits. bed_bot_drop: the plate's underside below the rim.
// Flush: the bed's top level with the rim. On its feet: the ledge sits
// bed_feet_gap under the plate (it only locates the bed), and the floor
// is set by the feet and their pads; otherwise the bed rests on its
// cushions on the ledge, rabbit_depth below the rim.
bed_on_feet   = foot_height > 0;
bed_feet_gap  = 1;
bed_bot_drop  = bed_flush ? bed_plate_thickness
              : bed_on_feet ? rabbit_depth - bed_feet_gap : rabbit_depth - bed_cushion;
seat_depth    = bed_bot_drop + (bed_on_feet ? bed_feet_gap : bed_cushion);
inner_depth_eff = bed_on_feet ? bed_bot_drop + foot_height + bed_cushion : inner_depth;
outer_depth   = bottom_thickness + inner_depth_eff;
top_z         = outer_depth;
floor_z       = bottom_thickness;
seat_floor_z  = top_z - seat_depth;

// Bed seat (rabbet the machine sits in)
has_compartment = compartment_option != "none";

// Rims at each end, so the end walls come out `end_wall` thick
left_rim  = max(rim_width, end_wall - bed_ledge);
right_rim = max(rim_width, end_wall - (has_compartment ? lid_ledge : bed_ledge));
seat_x0 = left_rim;
seat_x1 = seat_x0 + seat_length;
seat_y0 = rim_width;
seat_y1 = seat_y0 + seat_width;

// Machine cavity under the bed
mc_x0 = seat_x0 + bed_ledge;
mc_x1 = seat_x1 - bed_ledge;
mc_y0 = seat_y0 + bed_ledge;
mc_y1 = seat_y1 - bed_ledge;

function ph_updown(d) = str(round(abs(d) * 10) / 10, d >= 0 ? " mm above" : " mm below");
// Printed hinge (hinge-local frame: origin on the pivot axis, -Y toward
// the bed, the arm tilting front-up). The arm is a bar from its front face
// back past the pivot into a tail; the pin enters its front face, short of
// the pivot hole. Tilted back, the tail swings down into a pocket in the
// block and comes to rest on its floor: that is the stop. The block is
// held by a screw from below, through the base's nut trap (the screw's
// head where the nut would be) into a nut pressed into the block's
// underside, under the front of the arm.
ph_pd   = ph_pin_d > 0 ? ph_pin_d : hinge_pin_d_mm;                // pin diameter
ph_pe   = ph_pin_engage > 0 ? ph_pin_engage : hinge_pin_engage_mm;  // into the hole
ph_R    = max(ph_pd, ph_pivot_d) / 2 + ph_wall;         // arm half-height
ph_pin_web = 2.5;                                        // between pin end and pivot hole
ph_Lf   = ph_pin_embed + ph_pin_web + (ph_pivot_d + ph_slip) / 2;  // pivot to arm front
ph_fc   = sqrt(ph_Lf * ph_Lf + ph_R * ph_R) - ph_Lf + ph_clear;    // arm front swing + clearance
ph_bw   = ph_arm_w + 2 * ph_clear + 2 * ph_cheek;        // block width (X) = pivot rod length
ph_stop = ph_stop_angle > 0;
ph_th   = ph_stop ? ph_stop_angle : 150;                 // arm sweep cut into the block
assert(!ph_stop || (ph_stop_angle >= 45 && ph_stop_angle <= 110),
       "ph_stop_angle: 0 (no stop) or 45 to 110");
ph_Lt   = ph_stop ? ph_tail : 0;                         // tail behind the pivot
ph_tr   = sqrt(ph_Lt * ph_Lt + ph_R * ph_R);             // tail corner's radius
// Deepest the tail reaches over the sweep
ph_tdeep = !ph_stop ? ph_R
         : ph_th >= 90 - atan(ph_R / ph_Lt) ? ph_tr
         : ph_Lt * sin(ph_th) + ph_R * cos(ph_th);
ph_nut_w = nut_w(hinge_nut_spec, hinge_nut_width) + 2 * nut_clearance;
ph_nut_t = nut_t(hinge_nut_spec);
ph_bot1 = -max(ph_R, ph_tdeep) - ph_clear - ph_floor;
ph_back = (ph_stop ? ph_tr : ph_R) + ph_clear + 3;       // block back face
ph_front = -(ph_Lf + ph_fc);                             // block front face
ph_sdy  = ph_front + ph_nut_w / 2 / cos(30) + 2;         // screw, under the arm's front
// floor under the arm there: nut pocket plus 2 mm (deepen the block if needed)
ph_bot  = min(ph_bot1, -(ph_R + ph_clear) - ph_nut_t - 0.3 - 2.5);   // block bottom

// Hinge geometry, by type. Each function describes the hinge's footprint
// relative to the hinge center; a new hinge type adds a branch to each and
// a cutter module.
//   hinge_offset_y : hinge center behind the back edge of the bed seat
//   hinge_rear     : hinge footprint's reach behind its center (Y)
//   hinge_half_x   : half the footprint width (X)
//   hinge_pin_z    : pin axis below the top surface
//   hinge_screw_dy : screw hole behind the hinge center (Y)
// "none" keeps the lollipop's footprint for sizing (the back rim), so a
// base without hinges matches one with them and shares its extensions
has_hinges  = hinge_type != "none";
hinge_sized = hinge_type == "none" ? "lollipop" : hinge_type;
function hinge_offset_y() =
    hinge_sized == "lollipop"
        ? hinge_flange_diameter / 2
          + (hinge_pin_square_projection - hinge_pin_allowed_projection)
  : hinge_sized == "printed" ? ph_web + ph_recess_clear - ph_front
        : undef;
function hinge_rear() =
    hinge_sized == "lollipop" ? hinge_flange_diameter / 2
  : hinge_sized == "printed" ? ph_back + ph_recess_clear : undef;
function hinge_half_x() =
    hinge_sized == "lollipop"
        ? max(hinge_flange_diameter,
              1.2 * (nut_w(hinge_nut_spec, hinge_nut_width) + 2 * nut_clearance)) / 2
  : hinge_sized == "printed"
        ? max(ph_bw / 2 + ph_recess_clear,
              1.2 * (nut_w(hinge_nut_spec, hinge_nut_width) + 2 * nut_clearance) / 2) : undef;
// The printed hinge's pin is set at the bed hole's height
function hinge_pin_z() =
    hinge_sized == "lollipop" ? hinge_pin_height / 2
  : hinge_sized == "printed" ? top_z - hole_axis_z : undef;
function hinge_screw_dy() =
    hinge_sized == "lollipop"
        ? hinge_flange_diameter / 2 - hinge_mounting_hole_offset
  : hinge_sized == "printed" ? ph_sdy : undef;


// Attached bay: the base ends at base_len, its own right end wall; the bay
// runs from there to outer_length
attached = has_compartment && compartment_mount == "attached";
assert(!attached || compartment_option == "storage",
       "An attached bay is storage only for now: set compartment_option = \"storage\" or compartment_mount = \"built-in\"");
base_len = attached ? seat_x1 + max(rim_width, end_wall - bed_ledge) : undef;

// Small compartment and its lid rabbet, same Y extent as the bed seat
lid_x0 = attached ? base_len + attach_web : seat_x1 + divider_web;
st_x0  = lid_x0 + lid_ledge;
st_x1  = st_x0 + storage_inner_length;
lid_x1 = st_x1 + lid_ledge;
st_y0  = seat_y0 + lid_ledge;
st_y1  = seat_y1 - lid_ledge;

// Outlet (compartment_option "outlet"), standing on the compartment floor
// against the right end wall, face toward -X
has_outlet = compartment_option == "outlet";
has_knee   = compartment_option == "knee";
ol_L  = outlet_size[0];
ol_W  = outlet_size[1];
ol_T  = outlet_size[2];
ol_yc = (st_y0 + st_y1) / 2 + outlet_y_offset;
ol_x0 = st_x1 - ol_T;                            // outlet face
ol_zc = floor_z + ol_W / 2;                      // screw axis
ol_c  = outlet_clearance;
ol_through = has_outlet && outlet_mount == "through";
ol_cb = ol_through && outlet_screw_cap ? outlet_cap_t : 0;   // cap recess depth
cord_hole_y = has_outlet ? ol_yc : (st_y0 + st_y1) / 2;

outer_length = (has_compartment ? lid_x1 : seat_x1) + right_rim;
base_x1 = attached ? base_len : outer_length;     // the base part's right end
auto_back_rim = hinge_offset_y() + hinge_rear() + hinge_back_skin;
back_rim      = back_rim_width > 0 ? back_rim_width : auto_back_rim;
outer_width   = seat_y1 + back_rim;

// Divider between the machine cavity and the small compartment
divider_x0        = mc_x1;
divider_x1        = st_x0;
divider_thickness = divider_x1 - divider_x0;

// Split line, along Y at the center in X
cut_x = base_x1 / 2;

// Bed edges (the bed is centered in its seat)
bed_x0 = seat_x0 + bed_clearance;
bed_y0 = seat_y0 + bed_clearance;

// Hinge centers
hinge_x1 = bed_x0 + hinge_hole_inset;
hinge_x2 = hinge_x1 + hinge_hole_spacing;
hinge_y  = seat_y1 + hinge_offset_y();
hinge_hole_y = hinge_y + hinge_screw_dy();
hinge_keepout = hinge_half_x() + hinge_tunnel_margin;

// Height checks: bed hinge holes vs hinge pin axis
bed_bottom_z  = top_z - bed_bot_drop;
bed_top_z     = bed_bottom_z + bed_plate_thickness;
hole_axis_z   = bed_top_z - hinge_hole_drop;
pin_axis_z    = top_z - hinge_pin_z();

// Cord slot through the back rim: [center from the bed's left end, width,
// bottom below the bed's top, cord channel height]
has_cord_slot = is_list(cord_slot) && len(cord_slot) >= 3 && cord_slot[1] > 0;
cs_x  = has_cord_slot ? bed_x0 + cord_slot[0] : 0;
cs_w  = has_cord_slot ? cord_slot[1] : 0;
cs_zb = has_cord_slot ? bed_top_z - cord_slot[2] : 0;
cs_ch = has_cord_slot && len(cord_slot) >= 4 ? cord_slot[3] : 5;

// Printed hinge in place (Z). The arm's and cheeks' top: flush with the
// rim where that leaves ph_min_cover over the rods, else as low as that
ph_az   = hole_axis_z;                                   // pivot and pin axis
ph_zb   = ph_az + ph_bot;                                // block bottom = recess floor
ph_atop = min(ph_R, max(top_z - ph_az, max(ph_pd, ph_pivot_d) / 2 + ph_min_cover));
ph_pin_len = ph_pin_embed + (hinge_y - ph_Lf - (seat_y1 - bed_clearance)) + ph_pe;
// The base's trap sits at least 8 mm under the recess floor; the screw's
// head bears where a lollipop's nut would, and its tip stops 1.5 mm short
// of the floor under the arm
ph_trap_depth = max(hinge_nut_depth, top_z - ph_zb + 8);
ph_screw_need = (ph_zb - (top_z - ph_trap_depth)) + ph_nut_t + 0.3 + 0.5;
ph_tip_room   = (-(ph_R + ph_clear) - 1.5) - (ph_bot + ph_nut_t + 0.3);

// Casting reliefs as boxes [edge, [x0,y0,z0], [x1,y1,z1]]: the full ledge
// width, from the seat wall to the cavity, down to below the casting.
relief_boxes = [for (rl = bed_reliefs) let(
        e  = rl[0],
        a0 = rl[1] - rl[2] / 2 - relief_margin,
        a1 = rl[1] + rl[2] / 2 + relief_margin,
        z0 = bed_top_z - rl[3] - relief_clearance,
        z1 = seat_floor_z + overlap)
    e == "back"  ? [e, [bed_x0 + a0, mc_y1 - overlap, z0], [bed_x0 + a1, seat_y1, z1]]
  : e == "front" ? [e, [bed_x0 + a0, seat_y0, z0], [bed_x0 + a1, mc_y0 + overlap, z1]]
  : e == "left"  ? [e, [seat_x0, bed_y0 + a0, z0], [mc_x0 + overlap, bed_y0 + a1, z1]]
  :                [e, [mc_x1 - overlap, bed_y0 + a0, z0], [seat_x1, bed_y0 + a1, z1]]];

// Nut data
function nut_w(spec, override) =
    override > 0 ? override : struct_val(nut_info(spec), "width");
function nut_t(spec) = struct_val(nut_info(spec), "thickness");
function hex_r(w) = w / 2 / cos(30);   // circumradius from width across flats

plate_nut_w = nut_w(plate_nut_spec, plate_nut_width) + 2 * nut_clearance;
hinge_nut_w = nut_w(hinge_nut_spec, hinge_nut_width) + 2 * nut_clearance;

// Mending plate placement, spread across the machine-cavity floor
plate_pocket_depth = plate_thickness + plate_standoff;
plate_y_margin     = plate_width / 2 + plate_pocket_clearance + plate_wall_margin;
plate_ys = !split || plate_count <= 0 ? [] :
           plate_count == 1 ? [(mc_y0 + mc_y1) / 2] :
           [for (i = [0 : plate_count - 1])
               mc_y0 + plate_y_margin
               + i * (mc_y1 - mc_y0 - 2 * plate_y_margin) / (plate_count - 1)];

// Screw length suggestions (flat head length includes the head)
plate_screw_len = (floor_z - plate_nut_trap_depth + nut_t(plate_nut_spec))
                - (plate_pocket_depth - plate_thickness) + 1.5;
hinge_screw_len = hinge_sized == "printed" ? ph_screw_need + 1 : hinge_nut_depth + nut_t(hinge_nut_spec) + 1.5;

// Back-wall tunnels: two runs, hinge1..split and split..hinge2
tunnel_y0     = mc_y1 - overlap;
tunnel_len    = (outer_width - back_skin) - tunnel_y0;
tunnel_peak_z = seat_floor_z - back_top_skin;
// Runs between the hinges, minus the split zone and any back-edge reliefs
function cut_run(r, b) =
    (b[1] <= r[0] || b[0] >= r[1]) ? [r]
    : concat(b[0] > r[0] ? [[r[0], b[0]]] : [],
             b[1] < r[1] ? [[b[1], r[1]]] : []);
function cut_runs(runs, blocks, i = 0) =
    i >= len(blocks) ? runs
    : cut_runs([for (r = runs) each cut_run(r, blocks[i])], blocks, i + 1);
tunnel_blocks = concat(
    [[cut_x - split_keepout, cut_x + split_keepout]],
    [for (rl = relief_boxes) if (rl[0] == "back")
        [rl[1].x - hinge_tunnel_margin, rl[2].x + hinge_tunnel_margin]]);
tunnel_runs = [for (r = cut_runs(has_hinges ? [[hinge_x1 + hinge_keepout, hinge_x2 - hinge_keepout]]
                                            : [[mc_x0 + tunnel_web, mc_x1 - tunnel_web]], tunnel_blocks))
                  if (r[1] - r[0] >= tunnel_width / 2) r];
// Behind the small compartment, clear of the right hinge
st_tunnel_x0  = has_hinges ? max(st_x0, hinge_x2 + hinge_keepout) : st_x0;
st_tunnel_y0  = st_y1 - overlap;
st_tunnel_len = (outer_width - back_skin) - st_tunnel_y0;

// Dovetail keys across the split
auto_floor_keys =
    len(plate_ys) >= 2
        ? [for (i = [0 : len(plate_ys) - 2]) (plate_ys[i] + plate_ys[i + 1]) / 2]
        : [mc_y0 + (mc_y1 - mc_y0) / 3, mc_y0 + 2 * (mc_y1 - mc_y0) / 3];
back_wall_key = (mc_y1 + outer_width) / 2;
keys = len(key_ys) > 0 ? key_ys : concat(auto_floor_keys, [back_wall_key]);

// Closest approach of a key to a plate pocket, in Y
plate_half_band = plate_width / 2 + plate_pocket_clearance;
key_plate_gap = len(plate_ys) == 0 ? 999 :
    min([for (k = keys, p = plate_ys)
            abs(k - p) - plate_half_band - key_head / 2 - split_clearance]);
// Closest approach of a key to an outer face, in Y
key_face_gap = min([for (k = keys)
                       min(k, outer_width - k) - key_head / 2]);

// Handholds and harness rods, along Y, centered on the end
hh_y   = outer_width / 2;
hh_y0  = hh_y - handhold_bottom_len / 2;
hh_y1  = hh_y + handhold_bottom_len / 2;
nt_x1  = rod_x + rod_d / 2 + notch_clear;                 // notch depth from the face
nt_z1  = rod_z + rod_d / 2 + notch_clear;                 // notch height
notch_ys = [[notch_inset, notch_inset + notch_len],
            [outer_width - notch_inset - notch_len, outer_width - notch_inset]];
// Rods run from the outer face to `rod_stop` short of the handhold
rod_runs = [[0, hh_y0 - rod_stop], [hh_y1 + rod_stop, outer_width]];
rod_len  = rod_runs[0][1] - rod_runs[0][0] - max(0, rod_plug_len);

// Attached bay's joint: screws near the corners of the base's right end
// face, clear of the rod notches and the handhold; dowels between them
att_hr   = attach_head_d / 2;
att_ys   = [mc_y0 + attach_screw_inset, mc_y1 - attach_screw_inset];
att_zs   = [max(floor_z + att_hr + 3, nt_z1 + nt_x1 + att_hr + 2), seat_floor_z - att_hr - 4];
att_screws = [for (y = att_ys, z = att_zs) [y, z]];
att_dowels = [[outer_width / 4, (floor_z + seat_floor_z) / 2],
              [3 * outer_width / 4, (floor_z + seat_floor_z) / 2]];
att_screw_len = attach_head_seat + attach_insert_depth - 2;
n_rods = attached ? 6 : 4;                        // harness rods: two per end

// Serrations: ridge start positions along Y in the front wall
serr_wall = mc_y0;                                  // front wall thickness
serr_n    = floor((serr_wall - 2 * serration_setback) / serration_pitch);
serr_y0   = (serr_wall - serr_n * serration_pitch) / 2;
serr_top  = seat_floor_z - serration_top_gap;

// ---------------------------------------------------------------------------
// Extensions (assembly coordinates, same as the base)
// ---------------------------------------------------------------------------

base_peg_hole_d = ext_peg_style == "pin" ? rod_d + 0.2 : peg_hole_d;
ext_top_z  = bed_top_z + ext_top_adjust;      // lids and lips level with the bed
// Lips: on the rim, or recessed into it where the bed doesn't stand high
// enough for lip_min_t (within 0.5 mm, so the 99K's 5.3 mm lips stay put)
lip_nat    = ext_top_z - top_z - lip_clearance;
lip_recessed = ext_peg_holes && lip_nat < lip_min_t - 0.5;
lip_z0     = lip_recessed ? ext_top_z - lip_min_t : top_z + lip_clearance;   // lip underside
lip_t      = ext_top_z - lip_z0;
rim_cut_z  = lip_z0 - lip_clearance;            // floor of the rim cut
back_cut   = lip_recessed && back_ext;
left_cut   = lip_recessed && left_ext;
dt_extra   = ext_dt_depth + ext_dt_clearance; // extra wall where a socket goes
has_back   = back_ext;
has_left   = left_ext;
has_corner = corner_ext && back_ext && left_ext;
// A bay exists when its extension or its freestanding box is made
bay_back   = has_back || make_back_box;
bay_left   = has_left || make_left_box;
bay_corner = has_corner || make_corner_box;

// Back extension body
bk_x0 = 0;
bk_x1 = back_ext_length;
bk_y0 = outer_width + ext_gap;
bk_y1 = bk_y0 + back_ext_depth;

// Left extension body
lf_x0 = -ext_gap - left_ext_width;
lf_x1 = -ext_gap;
lf_y0 = 0;
lf_y1 = outer_width;

// Corner piece body
cn_x0 = lf_x0;
cn_x1 = lf_x1;
cn_y0 = bk_y0;
cn_y1 = bk_y1;

// Lips: from the seat edge over the rim to the body
// The back lip runs on past a short body to the last back peg (never past
// the base's right end)
bk_lip_want = back_lip_extend && len(back_peg_xs) > 0 ? max(back_peg_xs) + back_lip_peg_margin : 0;
bk_lip_x1  = min(outer_length, max(bk_x1, bk_lip_want));
bk_lip_ext = bk_lip_x1 - bk_x1 > 0.01;
bk_lip = [[bk_x0, seat_y1], [bk_lip_x1, bk_y0 + overlap]];
lf_lip = [[lf_x1 - overlap, bed_y0],
          [seat_x0, has_back ? seat_y1 - ext_gap : outer_width]];

peg_back_y = (seat_y1 + outer_width) / 2;
peg_left_x = seat_x0 / 2 + 0.5;
peg_right_x = attached ? base_x1 - (base_x1 - seat_x1) / 2 - 0.5 : outer_length - right_rim / 2 - 0.5;
back_pegs  = [for (x = back_peg_xs) if (x - peg_d >= bk_x0 && x + peg_d <= bk_lip_x1) x];
left_pegs  = [for (y = left_peg_ys) if (y - peg_d >= lf_lip[0].y && y + peg_d <= lf_lip[1].y) y];

// Per-piece wall insets [left, right, front, back] (extra where a socket is)
bk_extra = [has_corner ? dt_extra : 0, 0, 0, 0];
lf_extra = [0, 0, 0, has_corner ? dt_extra : 0];
cn_extra = [0, 0, 0, 0];

// Rabbet opening (lid seat) for a body with given extras
function rabbet_rect(x0, y0, x1, y1, e) =
    [[x0 + ext_frame + e[0], y0 + ext_frame + e[2]],
     [x1 - ext_frame - e[1], y1 - ext_frame - e[3]]];

bk_rab = rabbet_rect(bk_x0, bk_y0, bk_x1, bk_y1, bk_extra);
lf_rab = rabbet_rect(lf_x0, lf_y0, lf_x1, lf_y1, lf_extra);
cn_rab = rabbet_rect(cn_x0, cn_y0, cn_x1, cn_y1, cn_extra);

// ---------------------------------------------------------------------------
// Compartment interface, for organizer inserts.
//
// An insert file includes this one, sets part = "none", and reads bay sizes
// only from `compartments`; it should not use any other name in this file.
// Each entry is [name, [x0, y0, z0], [x1, y1, z1]] in assembly coordinates:
// the usable interior of the bay, z0 its floor and z1 the underside of its
// closed lid (the top of the bay when the lid type is "none"). The outlet
// compartment is left out, since the outlet fills it. An extension bay is
// listed when its extension or its freestanding box is made (an insert file
// can set make_corner_box = true, say). Inserts need their own clearance; an
// open hinged lid reaches lid_hinge_reach past the ledge on its hinge side
// (negative = clear of the bay). Inserts should read that value directly,
// since the console report is off when this file is included with
// part = "none".
// ---------------------------------------------------------------------------

function bay_z1(which, top, t) = lid_info(which)[4] == "none" ? top : top - t;
// Ledge widths [left, right, front, back] inside an extension rabbet: wider
// on a hinged lid's hinge side, and evened out to keep the corner bay square
function hinge_ledge(which) =
    lid_info(which)[4] == "hinged"
        ? max(ext_ledge, ext_lid_clearance + ext_lid_thickness + ext_hinge_margin)
        : ext_ledge;
function bay_ledges(which, rab) =
    let(e  = lid_info(which)[3], h = hinge_ledge(which), d = ext_ledge,
        l0 = [e == "left" ? h : d, e == "right" ? h : d,
              e == "front" ? h : d, e == "back" ? h : d],
        bw = rab[1].x - rab[0].x - l0[0] - l0[1],
        bh = rab[1].y - rab[0].y - l0[2] - l0[3],
        sq = which == "corner" && corner_bay_square)
    sq && bw > bh ? [l0[0] + (bw - bh) / 2, l0[1] + (bw - bh) / 2, l0[2], l0[3]]
  : sq && bh > bw ? [l0[0], l0[1], l0[2] + (bh - bw) / 2, l0[3] + (bh - bw) / 2]
  : l0;
function bay_rect(which, rab) = let(L = bay_ledges(which, rab))
    [[rab[0].x + L[0], rab[0].y + L[2]], [rab[1].x - L[1], rab[1].y - L[3]]];
function ext_bay(which, rab) = let(b = bay_rect(which, rab))
    [[b[0].x, b[0].y, ext_floor],
     [b[1].x, b[1].y, bay_z1(which, ext_top_z, ext_lid_thickness)]];
compartments = concat(
    has_compartment && !has_outlet && !has_knee
        ? [["base", [st_x0, st_y0, floor_z],
                    [st_x1, st_y1, bay_z1("base", top_z, rabbit_depth)]]] : [],
    bay_back   ? [concat(["back"],   ext_bay("back", bk_rab))]   : [],
    bay_left   ? [concat(["left"],   ext_bay("left", lf_rab))]   : [],
    bay_corner ? [concat(["corner"], ext_bay("corner", cn_rab))] : []);
// How far an open hinged lid's pivot edge reaches into the opening, past
// the inner edge of the hinge-side ledge (negative = clear of it)
lid_hinge_reach = ext_lid_clearance + ext_lid_thickness
                - max(ext_ledge, ext_lid_clearance + ext_lid_thickness + ext_hinge_margin);
base_lid_hinge_reach = ext_lid_clearance + rabbit_depth - lid_ledge;

// ---------------------------------------------------------------------------
// Organizer inserts: derived values and report. Bay sizes come only from
// `compartments`. When a bay is missing, its values fall back to zero so
// the base still renders quietly; the insert parts assert on it.
// ---------------------------------------------------------------------------

function ins_in(x, l) = len([for (e = l) if (e == x) e]) > 0;
function ins_bay(name) = [for (b = compartments) if (b[0] == name) b];

// --- Bobbin trays, corner bay ---
bb_parts = ["bobbin_assembly", "bobbin_trays", "bobbin_bottom", "bobbin_upper",
            "bobbin_test"];
bb_cb   = ins_bay("corner");
bb_have = len(bb_cb) == 1;
bb_b0   = bb_have ? bb_cb[0][1] : [0, 0, 0];
bb_b1   = bb_have ? bb_cb[0][2] : [0, 0, 0];
bb_bay  = bb_b1 - bb_b0;
bb_bay_c = [(bb_b0.x + bb_b1.x) / 2, (bb_b0.y + bb_b1.y) / 2, bb_b0.z];
bb_tray   = [bb_bay.x - 2 * bb_wall_clear, bb_bay.y - 2 * bb_wall_clear];
bb_post_h = bobbin_t + bb_bobbin_clear;           // post shoulder above the floor
bb_layer  = bb_floor + bb_post_h;                 // tray-to-tray pitch
bb_fit_n  = floor((bb_bay.z - bb_top_clear - bb_pin_h) / bb_layer);
bb_n      = bb_trays > 0 ? bb_trays : bb_fit_n;
bb_stack_h = bb_n * bb_layer + bb_pin_h;          // to the top tray's pin tips
bb_column_top = bb_bay.z - bb_top_clear;
bb_hole_d = bb_knob_d + 2 * bb_hole_clear;
bb_sock_d = bb_pin_d + 2 * bb_socket_clear;
bb_sock_h = bb_pin_h + bb_socket_extra;
// Post grid, in tray coordinates (origin at the tray center, floor bottom at z = 0)
bb_pitch = [bb_tray.x / bb_grid.x, bb_tray.y / bb_grid.y];
bb_cells = [for (i = [0 : bb_grid.x - 1], j = [0 : bb_grid.y - 1])
               [(i + 0.5) * bb_pitch.x - bb_tray.x / 2, (j + 0.5) * bb_pitch.y - bb_tray.y / 2]];
// A cell is used if its bobbin clears the center hole by 1 mm
bb_posts = [for (q = bb_cells) if (norm(q) >= bobbin_d / 2 + bb_hole_d / 2 + 1) q];
bb_lighten_xy = !bb_lighten ? [] :
    [for (i = [1 : 1 : bb_grid.x - 1], j = [1 : 1 : bb_grid.y - 1])
        let(q = [i * bb_pitch.x - bb_tray.x / 2, j * bb_pitch.y - bb_tray.y / 2])
        if (norm(q) >= bb_hole_d / 2 + bb_lighten_d / 2 + 2) q];

if (report && ins_in(part, bb_parts)) {
    echo("=== Bobbin trays (corner bay) ===");
    if (!bb_have)
        echo("WARNING: no corner bay; turn on back_ext, left_ext and corner_ext, or set make_corner_box");
    else {
    echo(str("Corner bay: ", bb_bay.x, " x ", bb_bay.y, " x ", bb_bay.z,
             " (floor to lid underside, or to the top with no lid)"));
    echo(str("Tray: ", bb_tray.x, " x ", bb_tray.y, ", layer pitch ", bb_layer,
             ", post pitch ", bb_pitch));
    echo(str("Trays: ", bb_n, " (1 bottom + ", bb_n - 1, " upper; ", bb_fit_n,
             " fit), ", len(bb_posts), " bobbins each, ", bb_n * len(bb_posts), " in all"));
    echo(str("Stack height to the top pins: ", bb_stack_h, "; knob top: ", bb_column_top));
    if (bb_n > bb_fit_n)
        echo("WARNING: more trays than fit under the lid");
    if (bb_n < 1)
        echo("WARNING: no tray fits in the bay");
    if (min(bb_pitch) < bobbin_d + 4)
        echo(str("WARNING: post pitch ", min(bb_pitch), " leaves under 4 mm between bobbins"));
    if (len(bb_posts) > 0 && min([for (q = bb_posts) norm(q)]) - bobbin_d / 2 < bb_knob_d / 2 + 1)
        echo("WARNING: the knob crowds the nearest bobbins");
    if (bb_layer * (bb_n - 1) + bb_floor + bb_column_flare > bb_column_top - bb_knob_h)
        echo("NOTE: the knob is below the top tray's floor; check that it can be gripped");
    if (bb_post_d < bb_pin_d + 1.5)
        echo("WARNING: the post shoulder is under 0.75 mm wide");
    if (bb_sock_h > bb_floor - 0.4)
        echo("WARNING: the sockets leave under 0.4 mm of floor");
    if (corner_lid_type == "hinged" && bb_wall_clear < max(0, lid_hinge_reach) + 0.3)
        echo(str("WARNING: the open hinged lid reaches ", lid_hinge_reach,
                 " mm into the bay opening; raise bb_wall_clear to at least ",
                 max(0, lid_hinge_reach) + 0.3, " or use a lift-out lid"));
    echo(str("Print: 1 bobbin_bottom and ", bb_n - 1, " bobbin_upper"));
    echo(str("For a second stack: make_corner_box = true, part corner_box (",
             cn_x1 - cn_x0, " x ", cn_y1 - cn_y0, " x ", ext_top_z, "), lid as part corner_lid"));
    }
    echo("=================================");
}

// --- Notion trays and spool tray, back or left bay ---
ot_parts = ["notion_assembly", "notion_set", "notion_30", "notion_25", "notion_20",
            "notion_15", "notion_10", "notion_custom", "spool_tray", "spool_assembly",
            "notion_test"];
ot_heights = [30, 25, 20, 15, 10];
ot_b    = ins_bay(ot_bay);
ot_have = len(ot_b) == 1;
ot_b0   = ot_have ? ot_b[0][1] : [0, 0, 0];
ot_b1   = ot_have ? ot_b[0][2] : [0, 0, 0];
ot_bsz  = ot_b1 - ot_b0;
// Trays run lengthwise along the bay's long side
ot_along_y = ot_bsz.y > ot_bsz.x;
ot_len  = max(ot_bsz.x, ot_bsz.y) - 2 * ot_wall_clear;
ot_wid  = min(ot_bsz.x, ot_bsz.y) - 2 * ot_wall_clear;
ot_max  = ot_bsz.z - ot_pin_h - ot_top_clear;     // total of the tray heights
ot_sock_d = ot_pin_d + 2 * ot_socket_clear;
ot_sock_h = ot_pin_h + ot_socket_extra;
ot_pin_xy = [for (sx = [-1, 1], sy = [-1, 1])
                [sx * (ot_len / 2 - ot_boss / 2), sy * (ot_wid / 2 - ot_boss / 2)]];
ot_lid_type = ot_bay == "back" ? back_lid_type : left_lid_type;
// Finger-hold lip reach, scaled down to fit a shallow tray
function ot_reach(h) = max(0, min(ot_grip_reach, h - ot_floor - ot_grip_t - 1));

// Compartment grid for the plain trays
ot_in      = [ot_len - 2 * ot_wall, ot_wid - 2 * ot_wall];   // inside of the walls
ot_ncols   = ot_cols > 0 ? ot_cols : max(1, round(ot_in.x / ot_cell));
ot_nrows   = ot_rows > 0 ? ot_rows : max(1, round(ot_in.y / ot_cell));
ot_cell_sz = [(ot_in.x - (ot_ncols - 1) * ot_divider_t) / ot_ncols,
              (ot_in.y - (ot_nrows - 1) * ot_divider_t) / ot_nrows];
// Divider centerlines, from the tray center
function ot_div_pos(n, inside, cell) =
    [for (k = [1 : 1 : n - 1]) -inside / 2 + k * (cell + ot_divider_t) - ot_divider_t / 2];

// Spool tray: height, and the post layout that holds the most spools. Three
// layouts are tried, a square grid and rows or columns staggered by half a
// pitch; positions that would hit a corner boss are dropped.
ot_spool_tray_h = ot_floor + ot_spool_h + bobbin_t + ot_spool_top_clear;
ot_post_h  = ot_spool_h + bobbin_t;               // post top flush with the bobbin top
ot_sp_p    = ot_spool_d + ot_spool_gap;           // spool pitch
ot_sp_hp   = ot_sp_p * sin(60);                   // staggered row pitch
ot_sp_av   = [ot_len - 2 * ot_wall, ot_wid - 2 * ot_wall]
             - 2 * [ot_spool_wall_gap, ot_spool_wall_gap] - [ot_spool_d, ot_spool_d];
function ot_count(avail, off) = avail - off < -1e-6 ? 0 : floor((avail - off) / ot_sp_p + 1e-6) + 1;
function ot_center(pts) = len(pts) == 0 ? [] :
    let(xs = [for (q = pts) q.x], ys = [for (q = pts) q.y],
        c = [(min(xs) + max(xs)) / 2, (min(ys) + max(ys)) / 2])
    [for (q = pts) q - c];
// Rows along X at row pitch rp; odd rows offset half a pitch if staggered
function ot_rows(ax, ay, rp, stagger) =
    let(nr = ay < -1e-6 ? 0 : floor(ay / rp + 1e-6) + 1)
    ot_center([for (j = [0 : 1 : nr - 1])
                  let(off = stagger && j % 2 == 1 ? ot_sp_p / 2 : 0)
                  for (i = [0 : 1 : ot_count(ax, off) - 1]) [off + i * ot_sp_p, j * rp]]);
function ot_clear_of_bosses(q) =
    min([for (c = ot_pin_xy)
            norm([max(abs(q.x - c.x) - ot_boss / 2, 0), max(abs(q.y - c.y) - ot_boss / 2, 0)])])
    >= ot_spool_d / 2 + ot_spool_wall_gap;
ot_layout_names = ["square grid", "staggered rows", "staggered columns"];
ot_layouts = [for (c = [ot_rows(ot_sp_av.x, ot_sp_av.y, ot_sp_p, false),
                        ot_rows(ot_sp_av.x, ot_sp_av.y, ot_sp_hp, true),
                        [for (q = ot_rows(ot_sp_av.y, ot_sp_av.x, ot_sp_hp, true)) [q.y, q.x]]])
                 [for (q = c) if (ot_clear_of_bosses(q)) q]];
ot_layout_n = [for (l = ot_layouts) len(l)];
ot_best   = [for (i = [0 : 2]) if (ot_layout_n[i] == max(ot_layout_n)) i][0];
ot_spools = ot_layouts[ot_best];
// Gussets. Plain trays: evenly along the long walls between the corner
// bosses, or at the middle of each compartment along the wall. Spool tray:
// in the gaps between neighboring spools, where a gusset clears every spool.
ot_g_span = ot_in.x / 2 - ot_boss + ot_wall;                  // clear of the bosses
ot_g_plain = let(n = max(1, round(2 * ot_g_span / ot_gusset_pitch)))
    [for (i = [0 : n - 1]) -ot_g_span + (i + 0.5) * 2 * ot_g_span / n];
ot_g_cells = [for (i = [0 : ot_ncols - 1])
                 let(x = -ot_in.x / 2 + (i + 0.5) * ot_cell_sz.x + i * ot_divider_t)
                 if (abs(x) < ot_g_span) x];
function ot_g_clear(x, sy) =
    let(yi = sy * (ot_wid / 2 - ot_wall))
    min([for (q = ot_spools)
            let(dx = max(abs(q.x - x) - ot_gusset_t / 2, 0),
                dy = sy > 0 ? max(yi - ot_gusset_d - q.y, 0, q.y - yi)
                            : max(q.y - (yi + ot_gusset_d), 0, yi - q.y))
            norm([dx, dy])]) > ot_spool_d / 2 + 0.2;
function ot_sort(v) = len(v) <= 1 ? v :
    let(p = v[0]) concat(ot_sort([for (a = v) if (a < p) a]), [p], ot_sort([for (a = v) if (a > p) a]));
ot_g_ux = ot_sort([for (q = ot_spools) round(q.x * 1000) / 1000]);  // spool columns, unique and sorted
ot_g_xs = len(ot_g_ux) < 2 ? [] : [for (k = [0 : len(ot_g_ux) - 2]) (ot_g_ux[k] + ot_g_ux[k + 1]) / 2];
ot_g_spool = [for (sy = [-1, 1]) [for (x = ot_g_xs) if (abs(x) < ot_g_span && ot_g_clear(x, sy)) x]];
// Room at each end, between the end spools and the end walls, for fingers
ot_spool_end_room = len(ot_spools) == 0 ? 0 :
    ot_len / 2 - ot_wall - max([for (q = ot_spools) abs(q.x)]) - ot_spool_d / 2;

if (report && ins_in(part, ot_parts)) {
    echo(str("=== Notion trays (", ot_bay, " bay) ==="));
    if (!ot_have)
        echo(str("WARNING: no ", ot_bay, " bay; turn on the ", ot_bay, " extension, or set make_", ot_bay, "_box"));
    else {
    echo(str("Bay: ", ot_bay, ", ", ot_bsz.x, " x ", ot_bsz.y, " x ", ot_bsz.z,
             " (floor to lid underside, or to the top with no lid)"));
    echo(str("Trays: ", ot_len, " x ", ot_wid, " outside; heights ", ot_heights,
             " and custom ", ot_custom_h));
    echo(str("STACK: the tray heights may total up to ", floor(ot_max * 10) / 10,
             " mm in this bay"));
    echo(str("Notion_assembly view: ", ot_show, " = ", sum(ot_show), " mm",
             sum(ot_show) > ot_max ? "  WARNING: taller than the bay allows" : ""));
    if (!fits([ot_len, ot_wid, ot_spool_tray_h]) && !fits([ot_wid, ot_len, ot_spool_tray_h]))
        echo("WARNING: the trays don't fit the printer bed inside printer_margin");
    if (ot_lid_type == "hinged" && ot_wall_clear < max(0, lid_hinge_reach) + 0.3)
        echo(str("WARNING: the open hinged lid reaches ", lid_hinge_reach,
                 " mm into the bay opening; raise ot_wall_clear to at least ",
                 max(0, lid_hinge_reach) + 0.3, " or use a lift-out lid"));
    if (ot_custom_h < ot_floor + ot_grip_t + 2)
        echo("WARNING: the custom tray is too shallow for a finger hold");
    if (ot_boss < ot_sock_d + 2 * ot_wall + 2)
        echo("WARNING: the corner bosses are too small for the sockets");
    echo(str("Compartments ", ot_compartments ? "on" : "off", " for the plain trays: ",
             ot_ncols, " x ", ot_nrows, " (length x width), each ",
             round(ot_cell_sz.x * 10) / 10, " x ", round(ot_cell_sz.y * 10) / 10,
             " mm; dividers ", ot_divider_t, " thick, ", ot_divider_frac * 100,
             "% of the tray height"));
    if (ot_compartments && min(ot_cell_sz) < 12)
        echo("WARNING: compartments under 12 mm across are hard to reach into");
    echo(str("Spool tray: ", len(ot_spools), " spools (", ot_layout_names[ot_best], "), ",
             ot_spool_tray_h, " mm tall; other trays with it may total up to ",
             floor((ot_max - ot_spool_tray_h) * 10) / 10, " mm",
             ot_spool_tray_h > ot_max ? "  WARNING: taller than the bay allows" : ""));
    echo(str("Spool tray layouts tried: ", ot_layout_names, " hold ", ot_layout_n,
             "; finger room at each end: ", ot_spool_end_room, " mm"));
    echo(str("Spool tray sides: ", ot_spool_open_sides
             ? str("cut down to a ", ot_spool_curb, " mm curb between the corner bosses")
             : "full height"));
    if (ot_spool_open_sides && ot_spool_curb < 6)
        echo("WARNING: a curb under 6 mm leaves the long floor flexible when the tray is lifted");
    echo(str("Spool posts: ", ot_spool_post_base_d, " mm at the floor, tapering to ",
             ot_spool_post_d, " mm at the spool top, ", ot_post_h, " mm tall"));
    if (ot_spool_post_base_d > ot_spool_bore - 0.3)
        echo("WARNING: the post base leaves under 0.15 mm per side in the spool bore");
    if (ot_spool_tray_h - ot_grip_t - ot_reach(ot_spool_tray_h) < ot_floor + ot_spool_h)
        echo("WARNING: the spool tray's finger holds come down below the spool tops");
    }
    echo("=================================");
}

// Footprints of the printed parts (X, Y, Z)
bk_size = [bk_lip_x1 - bk_x0, bk_y1 - seat_y1, ext_top_z];
lf_size = [seat_x0 - lf_x0, lf_y1 - lf_y0, ext_top_z];
cn_size = [cn_x1 - cn_x0 + ext_dt_depth, cn_y1 - cn_y0 + ext_dt_depth, ext_top_z];
half_x  = max(cut_x + key_depth, base_x1 - cut_x);
base_size = split ? [half_x, outer_width, outer_depth]
                  : [base_x1, outer_width, outer_depth];
function fits(sz) = sz.x <= printer_size.x - 2 * printer_margin
                    && sz.y <= printer_size.y - 2 * printer_margin
                    && sz.z <= printer_size.z;

// Peg holes vs hinges and the split
function near_hinge(x) = has_hinges && (abs(x - hinge_x1) < hinge_keepout
                      || abs(x - hinge_x2) < hinge_keepout);
function near_split(x) = x > cut_x - peg_hole_d && x < cut_x + key_depth + peg_hole_d;

if (report) echo(str("Outer size: ", outer_length, " x ", outer_width, " x ",
         outer_depth));
if (report && attached) {
    echo(str("Attached bay: the base is ", base_x1, " long, the bay ", outer_length - base_x1,
             " (", outer_length, " together); bay inside ", st_x1 - st_x0, " x ", st_y1 - st_y0,
             "; lid ", attached_lid_type));
    echo(str("Joint: 4 x ", attach_screw_spec, " screws at Y ", att_ys, ", Z ", att_zs,
             " (heads in the machine cavity, ", attach_head_seat, " mm of wall under them), into heat-set inserts in the bay; 2 dowels at Y ",
             [for (q = att_dowels) round(q[0] * 10) / 10], ", Z ", att_dowels[0][1]));
    for (rl = relief_boxes) if (rl[0] == "right")
        for (q = att_screws)
            if (q[0] + att_hr > rl[1].y && q[0] - att_hr < rl[2].y && q[1] + att_hr > rl[1].z)
                echo(str("WARNING: the joint screw at Y ", q[0], ", Z ", q[1],
                         " runs into a casting relief on the bed's right edge; change attach_screw_inset"));
    if (att_zs[1] - att_zs[0] < 20)
        echo("WARNING: the joint's screws are under 20 mm apart vertically; the joint will be weak in bending");
}
if (report) echo(str("Bed seat: ", seat_length, " x ", seat_width));
if (report) echo(str("Machine cavity: ", mc_x1 - mc_x0, " x ", mc_y1 - mc_y0));
if (has_compartment) {
    if (report) echo(str("Small compartment: ", st_x1 - st_x0, " x ", st_y1 - st_y0));
    if (report) echo(str("Divider thickness at depth: ", divider_thickness));
} else
    if (report) echo("No side compartment");
if (report) echo(str("Hinge: ", hinge_type, "  back rim: ", back_rim,
         back_rim_width > 0 ? " (set)" : has_hinges ? " (from hinge)" : " (as for a lollipop hinge, so extensions match; set back_rim_width for a narrower rim)"));
if (report && has_hinges) echo(str("Hinge centers X: ", hinge_x1, ", ", hinge_x2,
         "  spacing: ", hinge_hole_spacing, "  Y: ", hinge_y));
if (report && !has_hinges)
    echo("NOTE: no hinges: nothing holds the machine in its seat, so carry the machine and base separately or strap them; reach the cavity by lifting the machine out");
if (report) echo(str("Bed top above base top: ", bed_top_z - top_z));
if (report && has_hinges) echo(str("Bed hole axis Z: ", hole_axis_z, "  pin axis Z: ", pin_axis_z));
if (report) echo(str("Mending plates at Y: ", plate_ys));
if (report) echo(str("Plate screw length (flat head) ~", plate_screw_len, " mm (",
         plate_screw_len / in, " in)"));
if (report && turn_button)
    echo(str("Turn button at X ", tb_x, ": reaches ", turn_button_overlap,
             " mm over the bed edge; pad top ", tb_top - top_z, " above the base top",
             "; wall in front of the nut ", round(tb_nut_wall * 10) / 10, " mm",
             tb_nut_wall < 1.5 ? "  WARNING: under 1.5 mm; increase turn_button_swell" : "",
             (tb_x - tb_Lt / 2 - turn_button_ease < cut_x + key_depth + 3
              && tb_x + tb_Lt / 2 + turn_button_ease > cut_x - 3)
                 ? "  WARNING: the pad crosses the split" : ""));
if (report && has_hinges) echo(str("Hinge coupon (part hinge_coupon): ", hc_x1 - hc_x0, " x ", hc_y1 - hc_y0,
         " x ", hc_t, " mm. In a wooden base, mortise it flush, its front edge on the back wall of the ",
         "bed opening; its top goes ", bed_top_z - top_z, " mm below the bed top, ",
         "hinge centers ", hinge_hole_spacing, " mm apart, pin axis ", top_z - pin_axis_z,
         " mm below the coupon top"));
if (report && has_hinges) echo(str("Hinge screw length ~", hinge_screw_len, " mm (",
         hinge_screw_len / in, " in), measured from ",
         hinge_type == "printed" ? "the head's seat in the block" : "the top surface"));
if (report && lip_recessed)
    echo(str("Lips recessed: the bed stands ", round((ext_top_z - top_z) * 10) / 10,
             " mm above the rim, so the rim is cut ", round((top_z - rim_cut_z) * 10) / 10,
             " mm down under the ", back_cut && left_cut ? "back and left lips" : back_cut ? "back lip" : "left lip",
             " (", lip_t, " mm thick); trims ", back_cut ? "back_trim " : "", left_cut ? "left_trim " : "",
             "fill the cuts with the extensions off"));
if (report && ext_peg_holes && !lip_recessed && lip_nat < lip_min_t)
    echo(str("NOTE: lips are ", round(lip_nat * 100) / 100, " mm thick, a little under lip_min_t; left on the rim"));
if (report && has_cord_slot)
    echo(str("Cord slot: ", cs_w, " mm wide through the back rim at X ", cs_x, ", down to ",
             round((top_z - cs_zb) * 10) / 10, " mm below the rim; part cord_slot_trim fills it above a ",
             cs_ch, " mm channel"));
if (has_cord_slot && back_ext && cs_x - cs_w / 2 < max(bk_x1, bk_lip_x1))
    if (report) echo("WARNING: the cord slot is behind the back extension; shorten back_ext_length or notch the extension");
if (has_cord_slot && len([for (r = tunnel_runs) if (cs_x + cs_w / 2 > r[0] && cs_x - cs_w / 2 < r[1]) r]) > 0)
    if (report) echo("WARNING: the cord slot cuts into a back-wall tunnel");
if (report && bed_on_feet)
    echo(str("Bed on its feet: ", foot_height, " mm under the plate, on ", bed_cushion,
             " mm pads; floor ", round(inner_depth_eff * 10) / 10, " mm below the rim (inner_depth not used); the ledge sits ",
             bed_feet_gap, " mm under the plate"));
if (report && bed_flush) echo("Bed flush with the rim");
if (report && (part == "foot_rig" || part == "foot_rig_left" || part == "foot_rig_right")) {
    echo(str("Foot rig: ", rig_x1 - rig_x0, " x ", rig_y1 - rig_y0, " x ", rig_height,
             " mm, in two halves of about ", rig_sx - rig_x0 + rig_wall, " and ", rig_x1 - rig_sx, " mm; 4 M3 bolts per tab, 8 in all"));
    echo(str("Foot rig marking holes (X from the bed's left end, Y from its front edge, mm): ", rig_marks));
    if (rig_bar_in > 0)
        echo(str("Foot rig: floor bars ", rig_bar_w, " mm wide at X ", rig_bar_in, " and ", rig_L - rig_bar_in,
                 ", with a ", rig_bar_rib, " mm rib; keep them clear of the feet"));
    if (rig_bar_in > 0 && (rig_bar_in + rig_bar_w / 2 > rig_sx))
        echo("WARNING: rig_bar_in puts the bars past the split");
}
if (report && hinge_type == "printed") {
    echo(str("Printed hinge: block ", ph_bw, " x ", ph_back - ph_front, " x ", ph_atop - ph_bot,
             " mm, arm ", ph_arm_w, " x ", ph_Lf + (ph_Lt > 0 ? ph_Lt : ph_R), " x ", ph_R + ph_atop,
             " mm; pivot ", hinge_y - seat_y1, " mm behind the seat, ", top_z - ph_az, " mm below the top"));
    echo(str("Printed hinge: arm and cheeks top ", ph_updown(ph_az + ph_atop - top_z), " the rim; ",
             round((ph_atop - ph_pd / 2) * 10) / 10, " mm of plastic over the pin"));
    echo(str("Printed hinge: steel rod, 2 pins ", ph_pd, " mm x ", round(ph_pin_len * 10) / 10,
             " mm (", ph_pe, " mm into the bed's hole) and 2 pivots ", ph_pivot_d, " mm x ", round(ph_bw * 10) / 10, " mm"));
    echo(str("Printed hinge: screws from below, through the base's traps into ", hinge_nut_spec,
             " nuts pressed into the blocks' undersides"));
    if (ph_stop) echo(str("Printed hinge: the machine stops at about ", ph_stop_angle, " degrees of tilt"));
    else echo("NOTE: printed hinge without a stop: the machine tilts back until something else stops it");
}
if (report) echo(str("Dovetail keys at Y: ", keys, "  head width ", key_head,
         "  pull-apart play ~", key_play, " mm"));
if (report) echo(str("Keys clear of plate pockets by ", key_plate_gap,
         ", of outer faces by ", key_face_gap));

if (report) echo(str("Extension tops / lips at Z ", ext_top_z, " (", ext_top_z - top_z,
                     " above the base top", ext_top_adjust != 0 ? str(", trimmed ", ext_top_adjust) : "",
                     "); lip thickness ", lip_t));
for (b = compartments)
    if (report) echo(str("Bay ", b[0], ": ", b[2].x - b[1].x, " x ", b[2].y - b[1].y, " x ",
                         b[2].z - b[1].z, " mm, from ", b[1], " to ", b[2]));
for (w = ["base", "back", "left", "corner"])
    if (report && lid_on(w) && has_tab(w)) {
        li = lid_info(w);
        if (li[4] == "hinged" && li[7] == li[3])
            echo(str("WARNING: the ", w, " lid's tab is on its hinge edge (", li[7], ")"));
        attached = w == "base" ? has_compartment : w == "back" ? has_back
                 : w == "left" ? has_left : has_corner;
        if (attached && len([for (e = open_edges(w)) if (e == li[7]) e]) == 0)
            echo(str("WARNING: the ", w, " lid's tab (", li[7],
                     ") is on an edge that faces the base or another extension"));
    }
if (report && has_compartment && lid_on("base")
    && ext_lid_clearance + base_lid_notch[0] + 0.3 * base_lid_notch_r > lid_ledge - 0.5)
    echo("WARNING: the base lid's motor-boss notch reaches past the compartment's lid ledge");
if (report && has_compartment && lid_on("base") && base_lid_notch[0] > 0
    && lid_info("base")[3] == "left" && lid_info("base")[4] == "hinged")
    echo("NOTE: the base lid hinges on its left edge, so its motor-boss notch is left off");
lid_bump_tip = lid_bump_d - 2 * (lid_hinge_end_clearance + lid_bump_engage) * tan(lid_bump_angle);
if (report && lid_bump_tip < 0.6)
    echo(str("WARNING: lid hinge bumps come to a point (tip ", lid_bump_tip,
             " mm): reduce lid_bump_engage or lid_bump_angle, or increase lid_bump_d"));
if (report && lid_hinge_reach > -0.5
    && len([for (w = ["back", "left", "corner"]) if (lid_on(w) && lid_info(w)[4] == "hinged") w]) > 0)
    echo(str("NOTE: an open hinged extension lid reaches ", lid_hinge_reach,
             " mm past the ledge on its hinge side; inserts that lift out need at least ",
             max(0, lid_hinge_reach) + 0.3, " mm clearance there"));
if (has_back) if (report) echo(str("Back extension part: ", bk_size, fits(bk_size) ? "" : "  WARNING: exceeds printer"));
if (has_back && report) {
    if (bk_lip_ext)
        echo(str("Back lip: runs ", bk_lip_x1 - bk_x1, " mm past the body, to X ", bk_lip_x1,
                 ", to reach the peg at X ", max(back_peg_xs),
                 " (the extension is now specific to this base's back_peg_xs)"));
    for (x = back_peg_xs) if (len([for (p = back_pegs) if (p == x) p]) == 0)
        echo(str("WARNING: the back peg at X ", x, " is off the back lip; ",
                 back_lip_extend ? "move it with back_peg_xs" : "turn on back_lip_extend or move it with back_peg_xs"));
    if (bk_lip_ext && bk_lip_x1 > lid_x0
        && (has_outlet ? outlet_lid_hinge : base_lid_hinge) == "back" && lid_on("base"))
        echo("WARNING: the back lip runs over the compartment lid's back hinge; the open lid will hit it");
}
if (has_left) if (report) echo(str("Left extension part: ", lf_size, fits(lf_size) ? "" : "  WARNING: exceeds printer"));
if (has_corner) if (report) echo(str("Corner piece part: ", cn_size, fits(cn_size) ? "" : "  WARNING: exceeds printer"));
if (report) echo(str("Base part", split ? " (each half)" : "", ": ", base_size,
         fits(base_size) ? "" : "  WARNING: exceeds printer"));
for (x = back_peg_xs)
    if (near_hinge(x) || near_split(x))
        if (report) echo(str("WARNING: back peg at X ", x, " is near a hinge or the split"));
if (len(back_trench) == 4 && back_trench[3] > lip_t - 2)
    if (report) echo("WARNING: back trench leaves under 2 mm of lip");
if (len(left_trench) == 4 && left_trench[3] > lip_t - 2)
    if (report) echo("WARNING: left trench leaves under 2 mm of lip");
if (has_back || has_left)
    if (report) echo("Print extensions upright; the lips need support underneath.");

for (rl = relief_boxes)
    if (report) echo(str("Relief ", rl[0], ": X ", rl[1].x, "-", rl[2].x, "  Y ", rl[1].y,
             "-", rl[2].y, "  floor at Z ", rl[1].z,
             " (", seat_floor_z - rl[1].z, " below the ledge)"));
if (report) echo(str("Back-wall tunnel runs: ", tunnel_runs));

if (ext_peg_holes && len(right_peg_ys) > 0)
    if (report) echo(str("Right-rim peg holes at X ", peg_right_x, ", Y ", right_peg_ys,
             " (rim ", attached ? base_x1 - seat_x1 : right_rim, " wide", attached ? ", on the base's own right rim; the attached bay doesn't use them" : "", ")"));
if (report) echo(str("End walls: ", end_wall, " (rims L ", left_rim, ", R ", right_rim, ")"));
if (harness_rods)
    if (report) echo(str("Harness rods: ", rod_d, " mm dia, ", rod_len, " mm (",
             rod_len / in, " in) long, ", n_rods, " needed", attached ? " (2 in the base's right end, 2 in the bay)" : "", "; hole ", rod_hole_d));
if (handholds && handhold_depth > end_wall - 2)
    if (report) echo("WARNING: handhold leaves under 2 mm toward the cavity");
if (harness_rods && nt_x1 > end_wall - 2)
    if (report) echo("WARNING: rod notch leaves under 2 mm toward the cavity");
if (harness_rods && notch_ys[0][1] > hh_y0 - rod_stop - 3)
    if (report) echo("WARNING: rod notch runs into the handhold zone");

if (hinge_type == "printed" && ph_trap_depth > hinge_nut_depth)
    if (report) echo(str("NOTE: the printed hinge's recess is deep, so its screw traps are ", ph_trap_depth,
             " mm below the top (hinge_nut_depth is ", hinge_nut_depth, ")"));
if (hinge_type == "printed" && ph_tip_room < 1.5)
    if (report) echo("WARNING: the printed hinge's screw has little room past its nut; increase ph_floor");
if (hinge_type == "printed" && ph_zb < floor_z)
    if (report) echo("WARNING: the printed hinge's recess reaches below the floor's top; the base may be too shallow for it");
if (has_hinges && back_rim < hinge_offset_y() + hinge_rear() + 2)
    if (report) echo("WARNING: back rim leaves under 2 mm behind the hinge");
if (has_hinges && abs(hole_axis_z - pin_axis_z) > 0.25)
    if (report) echo(str("WARNING: hinge pin axis is off the bed hole axis by ",
             pin_axis_z - hole_axis_z, " mm"));
if (split && key_plate_gap < 1)
    if (report) echo("WARNING: a dovetail key overlaps a plate pocket; adjust key_ys");
if (split && key_depth + split_clearance + 3 > split_keepout)
    if (report) echo("WARNING: dovetail keys may reach the back-wall tunnels; increase split_keepout");
if (plate_pocket_depth + plate_nut_trap_depth > floor_z - 3)
    if (report) echo("WARNING: less than 3 mm of floor between plate pocket and nut traps");

// Outlet compartment checks
ol_screw_need = ol_through
    ? (outer_length - st_x1 - ol_cb) + ol_T + nut_t(outlet_screw_spec) + 0.5
    : ol_T + 5;                               // through the outlet, 5 mm into the insert
ol_screw_max  = ol_through ? ol_screw_need + 8 : ol_T + outlet_insert_depth - 0.5;
if (has_outlet) {
    if (report) echo(str("Outlet: ", ol_L, " x ", ol_W, " x ", ol_T, " on the floor against the right wall; ",
             "screw axis at Y ", ol_yc, ", ", ol_W / 2, " above the floor; ",
             st_x1 - st_x0 - ol_T, " mm between the outlet face and the divider for the plugs"));
    if (ol_L + 2 * (ol_c + outlet_curb_w) > st_y1 - st_y0)
        if (report) echo("WARNING: the outlet and its curbs are longer than the compartment");
    if (outlet_labels && report) {
        echo(str("Outlet labels: ", outlet_light_label, " by the ", outlet_light_side, " receptacle, ",
                 outlet_motor_label, " by the ", outlet_light_side == "back" ? "front" : "back",
                 ", ", outlet_label_size, " mm letters recessed ", outlet_label_depth, " mm"));
        if (max(ol_lab_w(outlet_light_label), ol_lab_w(outlet_motor_label)) > ol_lab_x1 - ol_lab_x0)
            echo("WARNING: an outlet label is too long for the floor in front of the outlet; shorten it or lower outlet_label_size");
        if (outlet_label_size > outlet_receptacle_spacing - 3)
            echo("WARNING: the outlet labels are too tall for the receptacle spacing; lower outlet_label_size");
        if (outlet_label_depth > floor_z - 1)
            echo("WARNING: outlet_label_depth leaves under 1 mm of floor");
    }
    if (abs(outlet_y_offset) + ol_L / 2 + ol_c + outlet_curb_w > (st_y1 - st_y0) / 2)
        if (report) echo("WARNING: the outlet's curbs run into the compartment's front or back wall");
    if (ol_zc + outlet_insert_d / 2 > seat_floor_z - 3)
        if (report) echo("WARNING: the outlet insert is too close to the lid ledge");
    if (handholds && ol_zc - outlet_insert_d / 2
                     < handhold_height + (outlet_insert_depth + st_x1 - (outer_length - handhold_depth))
                       + 2)
        if (report) echo("NOTE: check the outlet insert hole against the right handhold");
    if (cord_hole_width < outlet_receptacle_spacing + 8)
        if (report) echo("NOTE: the cord pass-through is narrower than the receptacle spacing; the cords will angle in");
    for (sd = [outlet_slot_1_side, outlet_slot_2_side])
        if (sd == outlet_lid_hinge)
            if (report) echo(str("WARNING: a cord slot is on the lid's hinge edge (", sd, ")"));
}

// ---------------------------------------------------------------------------
// Knee controller (compartment_option "knee"): derived values and report
// ---------------------------------------------------------------------------
//
// The bay's front view is the XZ plane. Angles there are measured from +X
// toward +Z; the knee angle th >= 0 turns the shaft so that a point at
// angle a (at rest) is at a + kn_s * th (kn_s = 1 when the knee pushes
// right: the bar's foot, below the shaft, moves +X).
kn_s   = knee_push == "right" ? 1 : -1;
kn_z0  = floor_z;
kn_z1  = bay_z1("base", top_z, rabbit_depth);
kn_sx  = st_x0 + knee_shaft_x;                          // shaft axis
kn_sz  = knee_shaft_z > 0 ? kn_z0 + knee_shaft_z : (kn_z0 + kn_z1) / 2;
kn_L   = knee_bar_drop;
kn_th_on = atan(knee_travel_on / kn_L);                 // motor starts
kn_th  = atan(knee_travel / kn_L);                      // full speed
kn_thx = atan(knee_travel_max / kn_L);                  // hard stop
// Gears. First stage: the sector on the shaft drives the idler's pinion;
// second stage: the idler's gear (a sector) drives the pot's pinion. The
// idler turns on a stub pin pressed into the bulkhead.
kn_m   = knee_gear_module;
kn_zp  = knee_pinion_teeth;
kn_zs  = knee_pinion_teeth * knee_ratio;
kn_rp  = kn_m * kn_zp / 2;                              // pitch radii, first stage
kn_rs  = kn_m * kn_zs / 2;
kn_cd  = kn_rp + kn_rs + knee_gear_cd_extra;
kn_ix  = kn_sx + kn_cd * cos(knee_idler_angle);         // idler axis
kn_iz  = kn_sz + kn_cd * sin(knee_idler_angle);
kn_z2  = knee_gear2_teeth;
kn_zp2 = knee_pinion2_teeth;
kn_r2  = kn_m * kn_z2 / 2;                              // pitch radii, second stage
kn_rp2 = kn_m * kn_zp2 / 2;
kn_cd2 = kn_r2 + kn_rp2 + knee_gear_cd_extra;
kn_px  = kn_ix + kn_cd2 * cos(knee_pot_angle);          // pot axis
kn_pz  = kn_iz + kn_cd2 * sin(knee_pot_angle);
kn_ratio2 = kn_z2 / kn_zp2;
kn_rt  = knee_ratio * kn_ratio2;                        // overall, pot to shaft
kn_pot_deg  = kn_rt * (kn_th - kn_th_on);               // pot turn over the speed range
kn_pot_degx = kn_rt * kn_thx;                           // rest to the stop
kn_pot_over = kn_rt * (kn_thx - kn_th);                 // full speed to the stop
kn_r_over   = knee_pot_r * kn_pot_deg / knee_pot_travel; // kOhm over the speed range
// Along Y (front to back). Plane B (idler gear, pot pinion) lies just in
// front of the pot's bushing; plane A (sector, idler pinion) in front of it.
kn_yf  = st_y0 + knee_bulkhead_pos;                     // bulkhead front face
kn_yb  = kn_yf + knee_bulkhead_t;                       // its back face (pot mounting face)
kn_ypb = kn_yb - knee_pot_bushing_len - 0.7;            // plane B, back face
kn_ygf = kn_ypb - knee_gear_face;                       // plane B, front face
kn_yab = kn_ygf - 0.5;                                  // plane A, back face
kn_yaf = kn_yab - knee_gear_face;                       // plane A, front face
kn_pin_hub = kn_ygf - 1 - (kn_yb - knee_pot_shaft_len); // pot pinion's hub length on its shaft
kn_hub_back = max(0, kn_yf - knee_bushing_flange[1] - 0.6 - kn_yab); // sector hub behind the sector
kn_bz1 = kn_sz + knee_bulkhead_above;                   // bulkhead top
kn_boss_r = knee_bushing[1] / 2 + 3;
kn_ip_y0 = kn_yaf - 3;                                  // idler pin's front end (push nut in front of the idler)
kn_ip_len = kn_yb - kn_ip_y0;
kn_ib_r  = 5;                                           // idler pin boss on the bulkhead
// Sector: teeth over the swing, two teeth more each way (the shaft turns
// +kn_s th, so the teeth that reach the line of centers come from behind it)
kn_tooth = 360 / kn_zs;
kn_sec_a0 = knee_idler_angle - (kn_s > 0 ? kn_thx : 0) - 2 * kn_tooth;
kn_sec_a1 = knee_idler_angle + (kn_s > 0 ? 0 : kn_thx) + 2 * kn_tooth;
kn_hub_r  = 11;
// Idler gear: the idler turns -kn_s * ratio * th
kn_tooth2 = 360 / kn_z2;
kn_i_swing = knee_ratio * kn_thx;
kn_ig_a0 = knee_pot_angle - (kn_s < 0 ? kn_i_swing : 0) - 2 * kn_tooth2;
kn_ig_a1 = knee_pot_angle + (kn_s > 0 ? kn_i_swing : 0) + 2 * kn_tooth2;
kn_ig_disc = kn_rp + kn_m + 1.5;                        // disc under the idler pinion
// Switch, lying on the bulkhead's front face below the shaft, lever up,
// its free end toward the push. A cam on the sector holds the lever down at
// rest; past a dwell a ramp drops away (about 45 degrees) and the switch
// releases at knee_travel_on.
kn_sw = knee_switch_body;
kn_sw_z0 = kn_z0 + knee_switch_floor;                             // body's bottom edge
kn_sw_hz = kn_sw_z0 + knee_switch_holes[1];                       // hole line
kn_sw_cz = kn_sw_hz + knee_switch_op - knee_switch_press;         // lever's contact line at rest
kn_sw_xf = kn_sx + kn_s * knee_switch_act;                        // lever's free end
kn_sw_x0 = min(kn_sw_xf, kn_sw_xf - kn_s * kn_sw[0]);
kn_sw_x1 = max(kn_sw_xf, kn_sw_xf - kn_s * kn_sw[0]);
kn_sw_hx = [for (d = [-1, 1]) (kn_sw_x0 + kn_sw_x1) / 2 + d * knee_switch_holes[0] / 2];
kn_cam_r = kn_sz - kn_sw_cz;                                      // cam radius on the dwell
kn_cam_drop = 4;
kn_cam_ramp = kn_cam_drop / kn_cam_r * 180 / PI;                  // ramp span, degrees
kn_cam_a = kn_th_on - (knee_switch_press + knee_switch_md) / kn_cam_r * 180 / PI;   // ramp start
kn_cam_b = kn_cam_a + kn_cam_ramp;
kn_release = kn_cam_a + (knee_switch_press + knee_switch_md) / kn_cam_drop * kn_cam_ramp;
kn_sw_sens = kn_L / kn_cam_r;                                     // knee mm per mm of switch height
// Return spring: a compression spring standing in a housing on the front
// face, beside the hub, away from the push. A crank on the hub reaches into
// the housing; a steel pin across its tip bears on a cap on the spring. At
// rest the spring holds the crank up against the rest screw in the roof;
// at the hard stop the pin comes down onto the stop screw standing up
// through the spring. The housing is closed on itself: only the knee's
// push reaches the base, through the housing's tongue in a pocket.
kn_cr = knee_crank_r > 0 ? knee_crank_r : kn_L * sqrt(knee_force_rate / knee_spring_rate);
kn_f0 = knee_force_rest * kn_L / kn_cr;                 // spring force at rest
kn_pre = kn_f0 / knee_spring_rate;                      // preload deflection
kn_stroke = kn_cr * sin(kn_thx);                        // pin's drop at the stop
function kn_fs(th) = kn_f0 + knee_spring_rate * kn_cr * sin(th);           // spring force, N
function kn_fk(th) = kn_fs(th) * kn_cr * cos(th) / kn_L;                   // force at the knee, N
kn_defl_x = kn_pre + kn_stroke;
kn_pin_r = rod_d / 2;
kn_ct  = 10;                                            // crank thickness
kn_hub_y0 = -knee_bushing_flange[1] - 0.5;              // hub's back face
kn_cy0 = kn_hub_y0 - kn_ct;                             // crank's front face
kn_rb  = knee_spring[0] / 2 + 0.5;                      // housing bore radius
kn_hw  = 2.5;                                           // housing walls
kn_hyc = kn_hub_y0 - kn_ct / 2;                         // bore centre (Y), on the crank's plane
kn_hy0 = kn_hyc - kn_rb - kn_hw;                        // housing front face
kn_tg  = 2;                                             // tongue into the front face
kn_hx  = kn_sx - kn_s * kn_cr * (1 + cos(kn_thx)) / 2;  // spring axis
kn_hs  = kn_hx + kn_s * (kn_rb + kn_hw);                // housing's side toward the shaft
kn_cap_t = 4;
kn_arm_top = 14;                                        // crank's top above the pin centre
kn_arm_bot = 1.4;                                       // crank's bottom below it (the pin stands 1 mm proud)
kn_h_ft = kn_sz - kn_pin_r - kn_cap_t - (knee_spring[2] - kn_pre);   // floor's top (spring seat)
kn_h_fb = kn_h_ft - 6;                                  // housing bottom
kn_lift = kn_pre + 0.5;                                 // crank tip raised this much to go in over the cap
kn_h_rb = kn_sz + kn_arm_top + kn_lift + 1.5;           // roof's underside
kn_h_rt = kn_h_rb + 7;                                  // housing top
kn_ear  = [10, 6, 8];                                   // screw ears on the shaft side [out, thickness, height]
kn_ear_z = [kn_h_fb + kn_ear[2] / 2, kn_h_rt - kn_ear[2] / 2];
kn_ear_x = kn_hs + kn_s * kn_ear[0] / 2;
kn_stop_len = (kn_sz - kn_stroke - kn_pin_r) - kn_h_fb + 4.5;   // stop screw, with its jam nut
kn_rest_len = kn_h_rt - (kn_sz + kn_arm_top) + 4.5;             // rest screw, with its jam nut
kn_h_size = [kn_rb * 2 + 2 * kn_hw + kn_ear[0], kn_tg - kn_hy0];  // housing's footprint, printed
kn_hub_boss = [knee_bar_square * sqrt(2) / 2 + 2 * knee_bar_clearance + 4, 26];
kn_shaft_front = kn_cy0 + 1;                            // shaft's front end, inside the hub
kn_shaft_len = kn_yf + knee_bushing[2] - kn_shaft_front;
// Board, in the back of the bay against the divider, its long axis front
// to back; a printed cover over it
kn_bc   = 1.5;                                                  // clearance inside the cover
kn_cw   = 2;                                                    // cover wall
kn_turn = knee_board_turn == 180;
kn_tr   = knee_board_tab_room;
kn_bx0  = st_x0 + 0.5 + kn_cw + kn_bc + (kn_turn ? 0 : kn_tr);  // board's left edge
kn_bx1  = kn_bx0 + knee_board[1];
kn_by0  = st_y1 - 0.5 - kn_cw - kn_bc - knee_board[0];
kn_by1  = kn_by0 + knee_board[0];
// Board point [along from the notched end, across from the edge nearer the
// screw] in the bay. Components up, the across direction is to the right of
// the along direction (as in the board's own enclosure).
function kn_bp(p) = let(c = knee_board_mirror ? knee_board[1] - p[1] : p[1])
    kn_turn ? [kn_bx0 + c, kn_by1 - p[0]] : [kn_bx1 - c, kn_by0 + p[0]];
kn_screw = kn_bp(knee_board_screw);
kn_peg   = kn_bp(knee_board_screw + [-47.3, 5]);
kn_rest  = kn_bp(knee_board_screw + [-4.3, 19.5]);
kn_tabs  = [for (t = knee_board_tabs) kn_bp([t, knee_board[1]])];
kn_tab_y = [min([for (p = kn_tabs) p.y]), max([for (p = kn_tabs) p.y])];
kn_cv0   = [st_x0 + 0.5, kn_by0 - kn_bc - kn_cw];
kn_cv1   = [kn_bx1 + kn_bc + kn_cw + (kn_turn ? kn_tr : 0), kn_by1 + kn_bc + kn_cw];
kn_cv_h  = knee_board_h + knee_board_parts_h + 2 + kn_cw;        // cover height above the floor
kn_cv_ear = 8;                                                    // screw ears on its right side
kn_cv_notch = [kn_tab_y[0] - 7, kn_tab_y[1] + 7];                 // side notch for the leads
kn_cv_ycand = [for (y = [kn_by0 + 6, kn_by0 + 30, kn_by1 - 30, kn_by1 - 6])
                  if (y < kn_cv_notch[0] - kn_cv_ear || y > kn_cv_notch[1] + kn_cv_ear) y];
kn_cv_ys = [kn_cv_ycand[0], kn_cv_ycand[len(kn_cv_ycand) - 1]];
kn_cv_bh = 4;                                                     // floor bosses under the ears
kn_vent  = knee_motor_amps > 1.0;
// Cordset entry or IEC inlet in the right end wall
kn_ent_y = knee_entry_pos > 0 ? st_y1 - knee_entry_pos : (kn_tab_y[0] + kn_tab_y[1]) / 2;
kn_ent_z = kn_z0 + knee_entry_z;
kn_ent_x = outer_length - knee_entry_wall;                        // inner face of the thin wall
kn_clip_top = kn_ent_z + 5.5 / 2 + (knee_entry_clip[1] - 5.3);    // installed clip's top edge
kn_pk_z  = [kn_ent_z - knee_entry_hole[1] / 2 - 1, kn_clip_top + 8];   // clip pocket, bottom and top
kn_pk_w  = knee_entry_clip[0] + 0.8;
kn_lead_reach = norm([kn_ent_x - 3.6 - (kn_turn ? kn_bx1 : kn_bx0), kn_ent_y - kn_tab_y[0]])
              + norm([0, kn_tab_y[1] - kn_tab_y[0]]);
kn_iec_pk = knee_iec_cutout + [6, 6];                              // pocket round the inlet body
kn_iec_z  = kn_z0 + kn_cv_h + 2 + kn_iec_pk[1] / 2;               // above the board cover
kn_iec_in = knee_iec_depth - (end_wall_r() - knee_iec_panel);     // body reaching into the bay
function end_wall_r() = outer_length - st_x1;
// Junction under the bed (iec), on the cavity floor beside the pass-through
kn_wg   = knee_wago + [0.3, 0.3, 0];
kn_wg_w = knee_wago_n * kn_wg.x + (knee_wago_n + 1) * 1.6;        // the row, along X
kn_wg_d = kn_wg.y + 1.6;                                          // across it, along Y
kn_wg_x1 = divider_x0 - 0.5;
kn_wg_x0 = kn_wg_x1 - kn_wg_w;
// behind the pass-through's mouth if there is room, else in front of it;
// wire entries face the mouth
kn_wg_back = cord_hole_y + cord_hole_width / 2 + 3 + kn_wg_d < mc_y1 - 1;
kn_wg_y0 = kn_wg_back ? cord_hole_y + cord_hole_width / 2 + 3 : cord_hole_y - cord_hole_width / 2 - 3 - kn_wg_d;
// Earth post behind the shaft's end
kn_ep_y = kn_yf + knee_bushing[2] + 2.5;
// Mains cord through the right end wall, gripped by a clamp bar
kn_cord_y  = st_y1 - knee_cord_pos;
kn_saddle  = 3;
kn_cord_z  = kn_z0 + kn_saddle + knee_cord[1] / 2;
kn_clamp_x = st_x1 - 10;
kn_clamp_dy = knee_cord[0] / 2 + 6;
kn_clamp_bh = kn_saddle + knee_cord[1] - 0.5;                   // clamp boss height (squeezes the cord)

if (has_knee && report) {
    echo("=== Knee controller ===");
    echo(str("Shaft: ", knee_shaft_d, " mm, axis ", knee_shaft_x, " mm from the divider and ",
             kn_sz - kn_z0, " mm above the bay floor; ", round(kn_shaft_len), " mm long"));
    echo(str("Knee travel at ", kn_L, " mm below the shaft: motor starts at ", knee_travel_on, " mm (shaft ",
             round(kn_th_on * 100) / 100, " deg), full speed at ", knee_travel, " mm (", round(kn_th * 100) / 100,
             " deg), hard stop at ", knee_travel_max, " mm (", round(kn_thx * 100) / 100, " deg)"));
    echo(str("Gears: module ", kn_m, "; sector ", kn_zs, "-tooth (pitch radius ", kn_rs, ") to idler pinion ", kn_zp,
             " teeth, ", knee_ratio, ":1; idler gear ", kn_z2, "-tooth (pitch radius ", kn_r2, ") to pot pinion ", kn_zp2,
             " teeth, ", round(kn_ratio2 * 1000) / 1000, ":1; overall ", round(kn_rt * 100) / 100, ":1"));
    echo(str("Pot turns ", round(kn_pot_deg * 10) / 10, " deg over the speed range: about ", round(kn_r_over),
             " kOhm of its ", knee_pot_r, " kOhm (target ", knee_r_span, "); ", round(kn_pot_degx * 10) / 10,
             " deg from rest to the stop, ", round(kn_pot_over * 10) / 10, " of them past full speed"));
    echo(str("Switch: lever at ", round(kn_cam_r * 10) / 10, " mm below the shaft; the cam's ramp runs ",
             round(kn_cam_a * 100) / 100, " to ", round(kn_cam_b * 100) / 100, " deg, releasing the switch at ",
             round(kn_release * 100) / 100, " deg (", round(tan(kn_release) * kn_L), " mm at the knee); each 0.1 mm the switch is raised moves that about ",
             round(kn_sw_sens * 0.1 * 10) / 10, " mm later"));
    echo(str("Return spring: crank radius ", round(kn_cr * 10) / 10, " mm; spring ", round(kn_f0 * 10) / 10, " N at rest (",
             round(kn_pre * 10) / 10, " mm down) to ", round(kn_fs(kn_thx) * 10) / 10, " N at the stop (", round(kn_defl_x * 10) / 10,
             " mm, ", round(kn_defl_x / knee_spring_max * 100), "% of its rating)"));
    echo(str("Knee force: ", round(kn_fk(0) / 4.448 * 100) / 100, " lb at rest, ", round(kn_fk(kn_th_on) / 4.448 * 100) / 100,
             " at the motor's start, ", round(kn_fk(kn_th) / 4.448 * 100) / 100, " at full speed, ",
             round(kn_fk(kn_thx) / 4.448 * 100) / 100, " at the stop (",
             round(kn_fk(0) * 10) / 10, ", ", round(kn_fk(kn_th_on) * 10) / 10, ", ", round(kn_fk(kn_th) * 10) / 10, ", ",
             round(kn_fk(kn_thx) * 10) / 10, " N)"));
    echo(str("Spring housing: on the front face at X ", round(kn_hx * 10) / 10, ", ", round(kn_h_fb * 10) / 10, " to ",
             round(kn_h_rt * 10) / 10, " mm above the bottom, standing ", round(-kn_hy0 * 10) / 10,
             " mm out from the face; the hub and bar socket stand ", round(-(kn_cy0 - kn_hub_boss[1]) * 10) / 10, " mm out"));
    if (abs(kn_r_over - knee_r_span) > 0.25 * knee_r_span)
        echo("NOTE: the pot's span over the speed range is far from knee_r_span; change the gear teeth or the travel");
    if (kn_pot_degx > knee_pot_travel + (knee_pot_mech - knee_pot_travel) / 2 - 8)
        echo("WARNING: the pot turns too far from rest to the stop; it may reach its mechanical stop");
    if (kn_pot_over > (knee_pot_mech - knee_pot_travel) / 2 - 8)
        echo("WARNING: the overtravel past full speed runs within 8 deg of the pot's mechanical stop");
    if (kn_px + knee_pot_body / 2 > st_x1 - 1 || kn_px - knee_pot_body / 2 < st_x0 + 1
        || kn_pz - knee_pot_body / 2 < kn_z0 + 1 || kn_pz + knee_pot_body / 2 > kn_bz1)
        echo("WARNING: the pot body runs into the bay wall, floor or above the bulkhead; change knee_pot_angle or knee_idler_angle");
    if (norm([kn_px - kn_sx, kn_pz - kn_sz]) < kn_boss_r + knee_pot_body * 0.71 + 0.5)
        echo("WARNING: the pot body may run into the rear bushing's boss");
    if (kn_iz + kn_ib_r > kn_bz1 - 1)
        echo("WARNING: the idler pin's boss stands above the bulkhead; raise knee_bulkhead_above or lower knee_idler_angle");
    for (a = [kn_ig_a0, kn_ig_a1]) if (kn_ix + (kn_r2 + kn_m) * cos(a) > st_x1 - 1 || kn_iz + (kn_r2 + kn_m) * sin(a) < kn_z0 + 1)
        echo("WARNING: the idler gear's teeth reach the bay wall or floor; change knee_pot_angle or knee_idler_angle");
    if (norm([kn_ix - kn_sx, kn_iz - kn_sz]) - (kn_r2 + kn_m) < kn_hub_r + 1)
        echo("WARNING: the idler gear runs into the sector's hub");
    if (kn_sw_x0 < st_x0 + 0.5 || kn_sw_x1 > st_x1 - 0.5)
        echo("WARNING: the switch runs into the bay wall; change knee_shaft_x");
    if (kn_cam_r - kn_cam_drop < kn_hub_r + 1)
        echo("WARNING: the switch sits too high for the cam; lower knee_switch_floor");
    if (kn_cam_a < 0.5)
        echo("WARNING: the cam's ramp starts at rest; the switch may release early. Raise knee_travel_on");
    if (kn_pin_hub < 4)
        echo(str("WARNING: only ", kn_pin_hub, " mm of pot shaft for the pinion's hub"));
    if (kn_hub_back < 3)
        echo("WARNING: little room for the sector's hub behind it; move knee_bulkhead_pos back or shorten the pot bushing");
    if (kn_defl_x > knee_spring_max)
        echo("WARNING: the return spring is compressed past its rated deflection at the stop; use a longer spring");
    if (kn_h_fb < 1)
        echo("WARNING: the spring housing reaches the base's bottom; use a shorter spring or raise knee_shaft_z");
    if (kn_h_rt > top_z - 1)
        echo("WARNING: the spring housing reaches above the base's top");
    if ((kn_s > 0 ? kn_hx - kn_rb - kn_hw : kn_hx + kn_rb + kn_hw) < 1
        || (kn_s > 0 ? kn_hx - kn_rb - kn_hw : kn_hx + kn_rb + kn_hw) > outer_length - 1)
        echo("WARNING: the spring housing runs off the end of the front face; use a stiffer spring (shorter crank)");
    if (kn_bz1 > kn_z1 - 8)
        echo("WARNING: the bulkhead leaves under 8 mm under the lid for wires");
    if (kn_cv0.y < kn_yb + knee_pot_depth)
        echo("WARNING: the board cover runs into the pot; move knee_bulkhead_pos forward");
    if (!has_passthrough)
        echo("WARNING: no cord pass-through in the divider for the motor lead");
    echo(str("Setting up: 1) rest screw (in the housing's roof) so the bar hangs where you want it at rest; 2) stop screw (up through the spring) so the pin meets it at ",
             knee_travel_max, " mm; 3) turn the sector on the shaft so the switch releases at ", knee_travel_on,
             " mm; 4) with the bar held at full speed (", knee_travel, " mm), turn the pot to its pin-1 end (0 ohm) and clamp its pinion. At rest it then reads about ",
             round(knee_pot_r * kn_rt * kn_th / knee_pot_travel), " kOhm"));
    echo(str("Board: notched end ", kn_turn ? "toward the back" : "forward", ", spade tabs on the ",
             kn_turn ? "right" : "left", " at Y ", [for (p = kn_tabs) round(p.y * 10) / 10]));
    if (knee_power == "cordset") {
        echo(str("Power: cordset entry in the right end wall at ", round(st_y1 - kn_ent_y), " mm from the bay's back wall, ",
                 knee_entry_z, " mm above the floor; lead to the farther tab about ", round(kn_lead_reach), " mm of ", knee_entry_lead));
        if (kn_lead_reach > knee_entry_lead - 10)
            echo("WARNING: the cordset's leads won't reach the board's tabs with slack; move the entry (knee_entry_pos)");
        if (handholds && kn_ent_y + kn_pk_w / 2 > hh_y0 && kn_ent_y - kn_pk_w / 2 < hh_y1
            && kn_pk_z[0] < handhold_height + handhold_depth - handhold_lip_flat + 2)
            echo("WARNING: the cordset entry's pocket runs into the right handhold's ceiling; raise knee_entry_z");
    }
    if (knee_power == "iec") {
        echo(str("Power: IEC C14 inlet on its side in the right end wall, ", knee_iec_cutout[0], " x ", knee_iec_cutout[1],
                 " cutout in a ", knee_iec_panel, " mm panel, centre ", round(kn_iec_z - kn_z0), " mm above the floor; body reaches ",
                 round(kn_iec_in), " mm into the bay"));
        echo(str("Junction: ", knee_wago_n, " x Wago 221-413 on the cavity floor beside the pass-through, ",
                 knee_wago[2] + 2, " mm tall (", round(top_z - kn_z0 - knee_wago[2] - 2), " mm below the bed's top); check your machine's mechanism clears it"));
        if (kn_iec_z + kn_iec_pk[1] / 2 > seat_floor_z - 2)
            echo("WARNING: the IEC inlet's pocket runs into the lid rabbet; lower the board cover or the inlet");
        if (kn_wg_y0 < mc_y0 + 1 || kn_wg_y0 + kn_wg_d > mc_y1 - 1)
            echo("WARNING: no room on the cavity floor beside the pass-through for the junction");
        if (kn_ent_y - kn_iec_pk[0] / 2 < kn_yb + 2)
            echo("WARNING: the IEC inlet's body runs into the bulkhead; move it back (knee_entry_pos)");
    }
    if (knee_motor_amps > 1.0)
        echo(str("NOTE: ", knee_motor_amps, " A is over the board's 1.0 A label: fit a small clip-on heatsink to the triac (its tab is live, so the heatsink is too: keep it inside the cover); the cover gets vent slots"));
    echo("DANGER: the board, the pot's pins and the switch's terminals are live at mains voltage. Work on it unplugged; keep the cover on");
    echo("=======================");
}

// ---------------------------------------------------------------------------
// Hardware list
// ---------------------------------------------------------------------------

// Stock screw lengths: inch [inches, label] for "#" and inch specs, metric mm
inch_lengths = [[0.25, "1/4"], [0.3125, "5/16"], [0.375, "3/8"], [0.4375, "7/16"],
                [0.5, "1/2"], [0.625, "5/8"], [0.75, "3/4"], [0.875, "7/8"],
                [1, "1"], [1.25, "1-1/4"], [1.5, "1-1/2"], [1.75, "1-3/4"],
                [2, "2"], [2.5, "2-1/2"], [3, "3"]];
metric_lengths = [6, 8, 10, 12, 14, 16, 18, 20, 22, 25, 30, 35, 40, 45, 50,
                  55, 60, 65, 70, 80];
function is_metric(spec) = spec[0] == "M";
// Shortest stock length at least `need` mm, as a label
function stock_len(spec, need) =
    is_metric(spec)
        ? let(c = [for (l = metric_lengths) if (l >= need) l])
          len(c) > 0 ? str(c[0], " mm") : str(ceil(need), " mm (special)")
        : let(c = [for (l = inch_lengths) if (l[0] * in >= need) l[1]])
          len(c) > 0 ? str(c[0], "\"") : str(need / in, "\" (special)");
// Inches, rounded down to 1/16", as a mixed fraction
function frac16(x_in) =
    let(t = floor(x_in * 16 + 1e-6), w = floor(t / 16), n = t - 16 * w,
        g = n % 8 == 0 ? 8 : n % 4 == 0 ? 4 : n % 2 == 0 ? 2 : 1)
    n == 0 ? str(w, "\"")
           : str(w > 0 ? str(w, " ") : "", n / g, "/", 16 / g, "\"");

// Screw needs: through the nut plus 0.5 mm
hinge_screw_need = hinge_sized == "printed" ? ph_screw_need : hinge_nut_depth + nut_t(hinge_nut_spec) + 0.5;
plate_screw_need = (floor_z - plate_nut_trap_depth + nut_t(plate_nut_spec))
                 - (plate_pocket_depth - plate_thickness) + 0.5;
n_plate_screws   = plate_count * len(plate_holes);
plate_len_label  = is_metric(plate_nut_spec) ? str(plate_length, " mm")
                                             : frac16(plate_length / in + 1 / 32);
plate_w_label    = is_metric(plate_nut_spec) ? str(plate_width, " mm")
                                             : frac16(plate_width / in + 1 / 32);

if (report) echo("=== Hardware for this configuration ===");
if (report && has_hinges) echo(str("Hinges: 2 x ", hinge_type,
         hinge_type == "printed" ? " (part printed_hinges)" : ""));
if (report && hinge_type == "printed")
    echo(str("Hinge rods: steel, 2 x ", ph_pd, " mm x ", round(ph_pin_len * 2) / 2,
             " mm (pins) + 2 x ", ph_pivot_d, " mm x ", round(ph_bw * 2) / 2, " mm (pivots)"));
if (report && has_hinges) echo(str("Hinge screws: 2 x ", hinge_nut_spec, " x ",
         stock_len(hinge_nut_spec, hinge_screw_need),
         " (at least ", round(hinge_screw_need * 10) / 10, " mm), + 2 hex nuts",
         hinge_type == "printed" ? " (pan or socket heads, driven from below)" : ""));
if (split && plate_count > 0) {
    if (report) echo(str("Mending plates: ", plate_count, " x ", plate_len_label, " x ",
             plate_w_label, ", countersunk, hole pattern as plate_holes"));
    if (report) echo(str("Plate screws: ", n_plate_screws, " x ", plate_nut_spec, " x ",
             stock_len(plate_nut_spec, plate_screw_need),
             " flat head (at least ", round(plate_screw_need * 10) / 10,
             " mm), + ", n_plate_screws, " hex nuts"));
}
if (harness_rods)
    if (report) echo(str("Harness rods: ", n_rods, " x ", frac16(rod_d / in + 1 / 32), " (", rod_d,
             " mm) rod, cut to ", round(rod_len * 10) / 10, " mm (",
             frac16(rod_len / in), "); steel, 303 stainless or lead-free brass",
             rod_plug_len > 0 ? str("; + ", n_rods, " printed plugs (part rod_plugs)") : ""));
if (has_outlet) {
    if (report) echo(str("Outlet: 1 x dual sewing-machine outlet, about ", ol_L, " x ", ol_W, " x ", ol_T,
             " mm, center hole drilled through"));
    if (report && !ol_through) echo(str("Outlet screw: 1 x ", outlet_screw_spec, " x ",
             stock_len(outlet_screw_spec, ol_screw_need), " pan head (", round(ol_screw_need),
             " to ", round(ol_screw_max), " mm), + 1 ", outlet_screw_spec,
             " heat-set insert (hole ", outlet_insert_d, " x ", outlet_insert_depth, " mm deep)"));
    if (report && ol_through) echo(str("Outlet screw: 1 x ", outlet_screw_spec, " x ",
             stock_len(outlet_screw_spec, ol_screw_need), " flat head (", round(ol_screw_need),
             " to ", round(ol_screw_max), " mm), in from outside through the end wall, + 1 hex nut and washer on the outlet's face",
             outlet_screw_cap ? "; + printed cap (part outlet_cap)" : ""));
}
if (report && n_ext_pegs > 0 && ext_peg_style == "pin")
    echo(str("Extension pins: ", n_ext_pegs, " x ", frac16(rod_d / in + 1 / 32), " rod, cut to ",
             round(ext_peg_len * 10) / 10, " mm, pressed into the lips flush with the top",
             " (base peg holes ", base_peg_hole_d, " mm)"));
if (report && n_ext_pegs > 0 && ext_peg_style == "insert")
    echo(str("Extension pegs: ", n_ext_pegs, " printed (part ext_pegs, printed lying down), ",
             ext_peg_len, " mm long, pressed into the lips flush with the top; print spares"));
if (report && attached)
    echo(str("Attached bay joint: 4 x ", attach_screw_spec, " x ", stock_len(attach_screw_spec, att_screw_len),
             " socket-head cap screws (heads in the machine cavity) and 4 x ", attach_screw_spec,
             " heat-set inserts (in the bay's inner wall, ", attach_insert_depth, " mm holes); 2 x ",
             frac16(rod_d / in + 1 / 32), " rod dowels, cut to ", 2 * attach_dowel_depth,
             " mm, pressed into the base's right end face"));
if (report && turn_button)
    echo(str("Turn button screw: 1 x ", turn_button_nut_spec, " x ",
             stock_len(turn_button_nut_spec, tb_screw_need), " pan head (at least ",
             round(tb_screw_need * 10) / 10, " mm) + 1 washer + 1 hex nut (slides into its slot from inside the cavity)"));
if (report && has_knee) {
    echo(str("Knee shaft: 1 x ", knee_shaft_d, " mm steel rod (drill rod or ground shaft), ",
             round(kn_shaft_len), " mm long; file two small flats for the set screws"));
    echo(str("Knee bushings: 2 x flanged bronze sleeve bearing, ", knee_bushing[0], " mm bore x ",
             knee_bushing[1], " mm OD x ", knee_bushing[2], " mm long, flange ", knee_bushing_flange[0],
             " x ", knee_bushing_flange[1], " mm"));
    echo(str("Knee pins: 3/16\" rod (", frac16(rod_d / in + 1 / 32), " stock), 1 x ", round(kn_ip_len), " mm (idler pin, pressed into the bulkhead) with a 3/16\" push-on retaining nut; 1 x 14 mm (crank pin, pressed through the crank's tip)"));
    echo(str("Knee bar: steel, ", round(knee_bar_square * 100) / 100, " mm square at the socket end, out from the hub, bent down ",
             knee_bar_drop, " mm"));
    echo(str("Knee return spring: 1 x compression spring, ", round(knee_spring[0] / in * 1000) / 1000, "\" OD, ",
             round(knee_spring[2] / in * 1000) / 1000, "\" long, about ", round(knee_spring_rate / 4.448 * in), " lb/in, rated to ",
             round(knee_spring_max * 10) / 10, " mm (McMaster 9001T46, or one like it: it is compressed ",
             round(kn_defl_x * 10) / 10, " mm at the stop)"));
    echo(str("Knee stops: 1 x M4 x ", stock_len("M4", kn_stop_len), " (hard stop, up through the spring) and 1 x M4 x ",
             stock_len("M4", kn_rest_len), " (rest, down through the roof), each with a captive nut and a jam nut; 2 x M3 x 12 (housing to the front face)"));
    echo("Knee pot: Bourns 91A1A-B28-A25L (1 MOhm linear cermet, 1/4\" plastic slotted shaft, 3/8-32 bushing, lug), with its nut and lockwasher");
    echo("Knee off switch: Omron SS-5GL (hinge lever, SPDT, 5 A 125 VAC); 2 x M2 x 12 or #2-56 x 1/2\" screws, nuts and washers");
    echo(str("Knee screws: 2 x M3 set screw x 6 + 2 M3 nuts (sector, hub); 1 x M3 x 10 + nut (pot pinion clamp); 1 x M3 x 6 + washer (board); 2 x M3 x 30 (cover)",
             knee_power == "bare" ? "; 2 x M3 x 12 (cord clamp)" : "",
             knee_power == "iec" && knee_earth ? "; 1 x M3 x 6 + ring terminal (earth strip)" : ""));
    echo(str("Knee heat-set inserts: ", 5 + (knee_power == "bare" ? 2 : 0) + (knee_power == "iec" && knee_earth ? 1 : 0),
             " x M3 (board boss, 2 cover bosses, 2 in the front face for the spring housing", knee_power == "bare" ? ", 2 cord-clamp bosses" : "",
             knee_power == "iec" && knee_earth ? ", earth post" : "", ")"));
    if (knee_power == "cordset")
        echo("Knee power: a standard pedal controller cordset (molded entry and its steel clip), its two leads to the board's spade tabs, the off switch in one of them");
    if (knee_power == "iec") {
        echo(str("Knee power: fused IEC C14 inlet, Schurter KE series 1-pole snap-in for a ", knee_iec_panel,
                 " mm panel (KE16.5100.107 for 2 mm), with its fuse drawer and a T2A 5 x 20 mm fuse; an IEC C13 mains cord"));
        echo(str("Knee junction: ", knee_wago_n, " x Wago 221-413 lever connectors (line, neutral, switched motor)"));
        if (knee_earth) echo("Knee earth: a strip of brass or phosphor bronze bearing on the shaft's end, with the earth lead's ring terminal");
    }
    echo("Knee wiring: 300 V insulated wire (18 AWG for the motor and line) for the pot, switch and junction leads; 6.3 mm female quick-connects for the board");
}
if (report) echo(str("Bed cushions: ", frac16(bed_cushion_in + 1 / 32), " thick, compressed"));
if (split && serrations && serr_n > 0)
    if (report) echo("Assembly: lower the right half straight down onto the left half (the front-wall serrations engage from below)");
if (report) echo("=======================================");

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

if (part == "assembly") {
    color("SteelBlue") base();
    if (hinge_type == "printed") for (hx = [hinge_x1, hinge_x2]) ph_in_place(hx);
    if (attached) color("CadetBlue") right_bay();
    if (lid_on("base")) color("LightSteelBlue") lid_part("base");
    if (turn_button) color("LightSteelBlue") turn_button_part();
    if (has_knee) knee_in_place();
    if (has_back) {
        color("Peru") back_ext_part();
        color("BurlyWood") lid_part("back");
    }
    if (has_left) {
        color("Peru") left_ext_part();
        color("BurlyWood") lid_part("left");
    }
    if (has_corner) {
        color("Peru") corner_part();
        color("BurlyWood") lid_part("corner");
    }
} else if (part == "all") {
    print_plates();
} else if (part == "exploded") {
    // Base (split if `split` is set) with every other part pulled clear
    color("SteelBlue") base_halves();
    if (attached) color("CadetBlue") translate([explode + (split ? split_spread / 2 : 0), 0, 0]) right_bay();
    if (harness_rods && rod_plug_len > 0)
        color("LightSteelBlue") translate([0, -explode, 0]) rod_plugs();
    if (ol_cb > 0)
        color("LightSteelBlue") translate([outer_length + explode, ol_yc, 0]) outlet_cap();
    up = explode + ext_top_z - top_z;
    if (lid_on("base"))
        color("LightSteelBlue") translate([split ? split_spread / 2 : 0, 0, up])
            lid_part("base");
    if (has_back) translate([0, explode, 0]) {
        color("Peru") back_ext_part();
        color("BurlyWood") translate([0, 0, up]) lid_part("back");
        for (x = back_pegs) peg_exploded(x, peg_back_y, up / 2);
    }
    if (has_left) translate([-explode - (split ? split_spread / 2 : 0), 0, 0]) {
        color("Peru") left_ext_part();
        color("BurlyWood") translate([0, 0, up]) lid_part("left");
        for (y = left_pegs) peg_exploded(peg_left_x, y, up / 2);
    }
    if (has_corner)
        translate([-explode - (split ? split_spread / 2 : 0), explode, 0]) {
            color("Peru") corner_part();
            color("BurlyWood") translate([0, 0, up]) lid_part("corner");
        }
    // Freestanding boxes, in a row in front of the base, lids above
    bxs = [for (w = ["back", "left", "corner"])
              if ((w == "back" && make_back_box) || (w == "left" && make_left_box)
                  || (w == "corner" && make_corner_box)) w];
    bsz = [for (w = bxs) w == "back" ? [bk_x1 - bk_x0, bk_y1 - bk_y0]
                       : w == "left" ? [lf_x1 - lf_x0, lf_y1 - lf_y0]
                       :               [cn_x1 - cn_x0, cn_y1 - cn_y0]];
    bx0 = [for (i = [0 : len(bxs)]) i == 0 ? 0 : sum_x([for (j = [0 : i - 1]) bsz[j].x + explode])];
    for (i = [0 : 1 : len(bxs) - 1]) {
        w  = bxs[i];
        o  = w == "back" ? [bk_x0, bk_y0] : w == "left" ? [lf_x0, lf_y0] : [cn_x0, cn_y0];
        translate([bx0[i] - o.x, -2 * explode - max([for (z = bsz) z.y]) - o.y, 0]) {
            color("Peru") if (w == "back") back_box(); else if (w == "left") left_box(); else corner_box();
            color("BurlyWood") translate([0, 0, up]) lid_part(w);
        }
    }
} else if (part == "base_lid") {
    if (lid_on("base")) lid_print("base");
} else if (part == "back_ext") {
    translate([-bk_x0, -seat_y1, 0]) back_ext_part();
} else if (part == "left_ext") {
    translate([-lf_x0, -lf_y0, 0]) left_ext_part();
} else if (part == "corner_ext") {
    translate([-cn_x0, -cn_y0 + ext_dt_depth, 0]) corner_part();
} else if (part == "back_lid") {
    lid_print("back");
} else if (part == "left_lid") {
    lid_print("left");
} else if (part == "corner_lid") {
    lid_print("corner");
} else if (part == "passthrough_cover") {
    if (has_passthrough) translate([cord_hole_width / 2 + 3, 3, 0]) passthrough_cover_part();
} else if (part == "turn_button") {
    translate([0, 0, turn_button_t + tb_top]) rotate([180, 0, 0])
        translate([-tb_x, -tb_y, 0]) turn_button_part();
} else if (part == "ext_pegs") {
    ext_pegs();
} else if (part == "lid_hinge_test") {
    lid_hinge_test();
} else if (part == "back_box") {
    translate([-bk_x0, -bk_y0, 0]) back_box();
} else if (part == "left_box") {
    translate([-lf_x0, -lf_y0, 0]) left_box();
} else if (part == "corner_box") {
    translate([-cn_x0, -cn_y0, 0]) corner_box();
} else if (part == "hinge_coupon") {
    if (has_hinges) hinge_coupon();
    else if (report) echo("WARNING: hinge_coupon needs a hinge_type other than none");
} else if (part == "outlet_cap") {
    if (ol_cb > 0) outlet_cap();
} else if (part == "rod_plugs") {
    if (harness_rods && rod_plug_len > 0) rod_plugs();
} else if (part == "knee_sector") {
    if (has_knee) knee_sector_part();
} else if (part == "knee_idler") {
    if (has_knee) knee_idler_part();
} else if (part == "knee_pinion") {
    if (has_knee) knee_pinion_part();
} else if (part == "knee_hub") {
    if (has_knee) knee_hub_part();
} else if (part == "knee_spring_housing") {
    if (has_knee) knee_spring_housing_part();
} else if (part == "knee_spring_cap") {
    if (has_knee) knee_spring_cap_part();
} else if (part == "knee_cover") {
    if (has_knee) knee_cover_part();
} else if (part == "knee_cord_clamp") {
    if (has_knee && knee_power == "bare") knee_cord_clamp_part();
} else if (part == "knee_entry_test") {
    knee_entry_test_part();
} else if (part == "knee_assembly") {
    // Cutaway of the right bay with the mechanism, the bar pushed to knee_view
    if (has_knee) {
        color("SteelBlue") intersection() {
            base();
            translate([min(st_x0 - 25, kn_hx - kn_rb - kn_hw - 15), -1, -1])
                cube([outer_length + 1 - min(st_x0 - 25, kn_hx - kn_rb - kn_hw - 15), outer_width + 2, kn_bz1 + 1]);
        }
        knee_in_place(knee_view * kn_thx);
    }
} else if (part == "right_bay") {
    if (attached) translate([-base_x1, 0, 0]) right_bay();
    else if (report) echo("WARNING: right_bay needs compartment_mount = \"attached\"");
} else if (part == "attach_test") {
    if (attached) attach_test();
    else if (report) echo("WARNING: attach_test needs compartment_mount = \"attached\"");
} else if (part == "hinge_nut_tool") {
    hinge_nut_tool();
} else if (part == "printed_hinges") {
    if (hinge_type == "printed") printed_hinges();
    else if (report) echo("WARNING: printed_hinges needs hinge_type = \"printed\"");
} else if (part == "printed_hinge_test") {
    printed_hinge_test();
} else if (part == "foot_rig") {
    color("Peru") foot_rig_half(false);
    color("BurlyWood") foot_rig_half(true);
} else if (part == "foot_rig_left") {
    translate([-rig_x0 + rig_wall, -rig_y0 + rig_wall, 0]) foot_rig_half(false);
} else if (part == "foot_rig_right") {
    translate([-rig_sx, -rig_y0, 0]) foot_rig_half(true);
} else if (part == "back_trim") {
    if (back_cut) rim_trim_print("back");
    else if (report) echo("WARNING: back_trim: no rim cut (the lips aren't recessed, or back_ext is off)");
} else if (part == "left_trim") {
    if (left_cut) rim_trim_print("left");
    else if (report) echo("WARNING: left_trim: no rim cut (the lips aren't recessed, or left_ext is off)");
} else if (part == "cord_slot_trim") {
    if (has_cord_slot) cord_slot_trim_print();
    else if (report) echo("WARNING: cord_slot_trim: this machine profile has no cord slot");
} else if (part == "printed_hinge_view") {
    // Side views, cut through the middle: at rest, and tilted to the stop,
    // with a stub of the bed's back edge on the pin
    yb = seat_y1 - bed_clearance - hinge_y;            // bed's back face
    for (i = [0, 1]) translate([0, i * 95, 0]) {
        a = i * (ph_stop ? ph_stop_angle : 90);
        color("DarkOrange") difference() {
            ph_block();
            translate([0, -100, -100]) cube([200, 200, 200]);
        }
        color("Orange") rotate([-a, 0, 0]) difference() {
            ph_arm();
            translate([ph_arm_w / 4, -100, -100]) cube([200, 200, 200]);
        }
        ph_rods(a);
        color("DimGray", 0.85) rotate([-a, 0, 0]) difference() {
            translate([-ph_bw / 2, yb - 40, -ph_pd / 2 - 4])
                cube([ph_bw, 40, bed_top_z - ph_az + ph_pd / 2 + 4]);
            translate([0, yb + overlap, 0]) rotate([90, 0, 0])
                cylinder(h = ph_pe + 1, d = ph_pd + 0.4, $fn = 32);
        }
    }
} else if (part == "split_test") {
    if (split) split_test();
    else if (report) echo("WARNING: split_test needs split = true");
} else if (part == "test_parts") {
    test_parts();
} else if (ins_in(part, bb_parts)) {
    assert(bb_have, "The bobbin trays need the corner bay: turn on back_ext, left_ext and corner_ext, or set make_corner_box");
    bobbin_insert(part);
} else if (ins_in(part, ot_parts)) {
    assert(ot_have, str("The notion trays need the ", ot_bay, " bay: turn on the ", ot_bay, " extension, or set make_", ot_bay, "_box"));
    notion_insert(part);
} else if (part == "none") {
    // nothing (for use from other files)
} else {
    base_halves();
}

// The base, split into halves if `split` is set.
module base_halves() {
    if (split) {
        if (split_part != "right")
            translate([-split_spread / 2, 0, 0])
                intersection() {
                    base();
                    split_mask(0);
                }
        if (split_part != "left")
            translate([split_spread / 2, 0, 0])
                difference() {
                    base();
                    split_mask(split_clearance);
                }
    } else {
        base();
    }
}

// Everything left of the cut line plus the dovetail keys, grown by `grow`
// on every face. The left half is base() within the mask; the right half
// is base() outside the mask grown by the joint clearance.
module split_mask(grow) {
    big = 2 * max(outer_length, outer_width);
    if (serrations && serr_n > 0) serration_teeth(grow);
    translate([0, 0, -outer_depth])
        linear_extrude(height = 3 * outer_depth)
            offset(delta = grow)
                union() {
                    translate([cut_x - big, -big]) square([big, 2 * big]);
                    for (k = keys)
                        polygon([[cut_x - 1, k - key_neck / 2],
                                 [cut_x + key_depth, k - key_head / 2],
                                 [cut_x + key_depth, k + key_head / 2],
                                 [cut_x - 1, k + key_neck / 2]]);
                }
}

BIGY = 1000;

// Serration ridges on the left half (the mask), from below the bottom face
// up to serr_top, with 45-degree tops so the grooves print without support.
// Grown by `grow` on every face, plus extra clearance at the top.
module serration_teeth(grow) {
    h  = serration_height;
    p  = serration_pitch;
    zt = serr_top + (grow > 0 ? grow + serration_top_clear : 0);
    intersection() {
        translate([0, 0, -outer_depth])
            linear_extrude(height = outer_depth + zt + h + 1)
                offset(delta = grow)
                    for (i = [0 : serr_n - 1])
                        polygon([[cut_x - 1, serr_y0 + i * p],
                                 [cut_x, serr_y0 + i * p],
                                 [cut_x + h, serr_y0 + (i + 0.5) * p],
                                 [cut_x, serr_y0 + (i + 1) * p],
                                 [cut_x - 1, serr_y0 + (i + 1) * p]]);
        // Side profile (XZ): top falls 45 degrees from the cut line outward
        rotate([90, 0, 0]) translate([0, 0, -BIGY / 2])
            linear_extrude(height = BIGY)
                polygon([[cut_x - 2, -outer_depth - 1],
                         [cut_x + h + 2, -outer_depth - 1],
                         [cut_x + h + 2, zt - h - 2],
                         [cut_x - 2, zt + 2]]);
    }
}

// Knock-out walls under the handhold lips (added after the cuts).
module handhold_knockouts() {
    if (handholds && handhold_knockout) {
        x0 = handhold_lip_round + 0.4;
        len = handhold_bottom_len - 2 * handhold_height;   // lip length at its height
        for (side = attached ? [0, 1, 2] : [0, 1])
            translate(side == 0 ? [0, 0, 0] : [side == 1 ? outer_length : base_x1, 0, 0])
                mirror(side == 0 ? [0, 0, 0] : [1, 0, 0])
                    union() {
                        translate([x0, hh_y - len / 2 + 0.5, 0])
                            cube([knockout_t, len - 1, handhold_height - knockout_gap]);
                        // One-layer brim around the foot of the wall,
                        // kept inside the pocket and clear of its walls
                        if (knockout_brim) {
                            bx0 = max(0, x0 - knockout_brim_w);
                            bx1 = min(handhold_depth - 0.5,
                                      x0 + knockout_t + knockout_brim_w);
                            by0 = max(hh_y0 + 0.5, hh_y - len / 2 + 0.5 - knockout_brim_w);
                            by1 = min(hh_y1 - 0.5, hh_y + len / 2 - 0.5 + knockout_brim_w);
                            translate([bx0, by0, 0])
                                cube([bx1 - bx0, by1 - by0, knockout_brim_h]);
                        }
                        // Tab from the wall's front end into the pocket's
                        // sloped end, just below the gap
                        if (knockout_tab) {
                            zt = handhold_height - knockout_gap - knockout_tab_h;
                            y_end = hh_y - len / 2 + 0.5;
                            reach = y_end - (hh_y0 + zt) + 1;   // to the slope, plus 1 mm
                            translate([x0, y_end - reach, zt])
                                cube([knockout_t, reach + overlap, knockout_tab_h]);
                        }
                    }
    }
}

// The base part: the whole body, or with an attached bay, the body left of
// the joint
module base() {
    if (attached)
        intersection() {
            base_body();
            translate([-BIG / 2, -BIG / 2, -BIG / 2]) cube([BIG / 2 + base_x1, BIG, BIG]);
        }
    else base_body();
}
// The attached bay, in place: the body right of the joint
module right_bay() {
    if (attached)
        intersection() {
            base_body();
            translate([base_x1, -BIG / 2, -BIG / 2]) cube([BIG, BIG, BIG]);
        }
}
// Holes for the attached bay's joint: screws (counterbored from the cavity,
// through the base's end wall, into insert holes in the bay's inner wall)
// and dowels (press fit in the base, slip fit in the bay). Horizontal
// holes are teardrops, point up, except the inserts'.
module attach_cuts() {
    for (q = att_screws) {
        teardrop_x(mc_x1 - 1, q[0], q[1], base_x1 - attach_head_seat - mc_x1 + 1, attach_head_d);
        teardrop_x(mc_x1 - 1, q[0], q[1], base_x1 - mc_x1 + 1 + overlap, attach_screw_hole);
        translate([base_x1 - overlap, q[0], q[1]]) rotate([0, 90, 0])
            cylinder(h = attach_insert_depth + overlap, d = attach_insert_d, $fn = 32);
    }
    for (q = att_dowels) {
        teardrop_x(base_x1 - attach_dowel_depth - 0.5, q[0], q[1], attach_dowel_depth + 0.5 + overlap,
                   rod_d - attach_dowel_press);
        teardrop_x(base_x1 - overlap, q[0], q[1], attach_dowel_depth + 0.5 + overlap, rod_d + attach_dowel_slip);
    }
}
module teardrop_x(x0, y, z, len, d) {
    translate([x0, y, z]) rotate([0, 90, 0]) linear_extrude(height = len) rotate(90) teardrop_2d(d);
}

module base_body() {
    handhold_knockouts();
    if (has_outlet) outlet_curbs();
    if (has_knee) knee_base_add();
    if (has_passthrough && passthrough_knockouts) passthrough_knockout_walls();
    difference() {
        union() {
            cuboid([outer_length, outer_width, outer_depth],
                   rounding = outer_rounding, except = BOTTOM,
                   anchor = LEFT + FRONT + BOTTOM);
            if (turn_button) tb_pad();
        }
        if (turn_button) tb_cuts();

        // Bed seat
        translate([seat_x0, seat_y0, seat_floor_z])
            cube([seat_length, seat_width, seat_depth + overlap]);

        // Reliefs under thickened parts of the casting
        for (rl = relief_boxes)
            translate(rl[1]) cube(rl[2] - rl[1]);

        // Machine cavity
        translate([mc_x0, mc_y0, floor_z])
            cube([mc_x1 - mc_x0, mc_y1 - mc_y0, inner_depth_eff + overlap]);

        if (has_compartment) {
            // Lid rabbet over the small compartment
            translate([lid_x0, seat_y0, seat_floor_z])
                cube([lid_x1 - lid_x0, seat_width, rabbit_depth + overlap]);

            // Small compartment
            translate([st_x0, st_y0, floor_z])
                cube([st_x1 - st_x0, st_y1 - st_y0, inner_depth_eff + overlap]);

            // Outlet screw: heat-set insert hole, or a countersunk through hole
            if (has_outlet && outlet_mount == "insert")
                translate([st_x1 - overlap, ol_yc, ol_zc]) rotate([0, 90, 0])
                    cylinder(h = outlet_insert_depth + overlap, d = outlet_insert_d);
            if (has_outlet && outlet_mount == "through")
                outlet_through_hole();
            if (has_outlet && outlet_labels) outlet_label_cuts();
            if (has_knee) knee_base_cuts();

            // Cord pass-through in the divider
            if (compartment_option != "storage")
                translate([(divider_x0 + divider_x1) / 2, cord_hole_y, floor_z])
                    rotate([0, 0, 90])
                        gable_tunnel(cord_hole_width, cord_hole_height,
                                     divider_thickness + 2, center = true);

            // Tunnel behind the small compartment
            if (lighten_back_wall)
                tunnel_run(st_tunnel_x0, st_x1, st_tunnel_y0, st_tunnel_len);
        }

        // Hinge recesses and nut traps
        if (has_hinges)
            for (hx = [hinge_x1, hinge_x2])
                hinge_cutter(hx, hinge_y);

        // Mending plates across the split
        for (py = plate_ys)
            plate_cutter(cut_x, py);

        // Small-compartment lid hinge sockets
        if (has_compartment) lid_frame_cuts("base");

        // Handholds and harness-rod notches under each end (and under the
        // base's own right end, with an attached bay)
        for (side = attached ? [0, 1, 2] : [0, 1]) end_cuts(side);
        if (attached) attach_cuts();

        // Rim cut under recessed lips
        if (back_cut || left_cut)
            translate([0, 0, rim_cut_z]) linear_extrude(height = top_z - rim_cut_z + overlap)
                rim_cut_2d();

        // Cord slot through the back rim
        if (has_cord_slot)
            translate([cs_x - cs_w / 2, mc_y1 - overlap, cs_zb])
                cube([cs_w, outer_width - mc_y1 + 2 * overlap, top_z - cs_zb + overlap]);

        // Peg holes for the extensions (from the rim cut's floor, where cut)
        if (ext_peg_holes) {
            for (x = back_peg_xs) let(zt = back_cut && x <= bk_lip_x1 ? rim_cut_z : top_z)
                translate([x, peg_back_y, zt - peg_hole_depth])
                    cylinder(h = peg_hole_depth + overlap, d = base_peg_hole_d);
            for (y = left_peg_ys) let(zt = left_cut ? rim_cut_z : top_z)
                translate([peg_left_x, y, zt - peg_hole_depth])
                    cylinder(h = peg_hole_depth + overlap, d = base_peg_hole_d);
            for (y = right_peg_ys)
                translate([peg_right_x, y, top_z - peg_hole_depth])
                    cylinder(h = peg_hole_depth + overlap, d = base_peg_hole_d);
        }

        // Back-wall lightening tunnels
        if (lighten_back_wall)
            for (run = tunnel_runs)
                tunnel_run(run[0], run[1], tunnel_y0, tunnel_len);
    }
}

// Full-height islands about the hinges, left standing in a rim cut
module hinge_islands_2d() {
    for (hx = [hinge_x1, hinge_x2])
        translate([hx - hinge_half_x() - 3, seat_y1 - 1])
            square([2 * hinge_half_x() + 6,
                    min(hinge_y + hinge_rear() + 3, outer_width + 1) - seat_y1 + 1]);
}
// Plan of the rim cut: each recessed lip's footprint plus clearance, less
// the hinge islands
module rim_cut_2d(shrink = 0) {
    c = lip_cut_clearance;
    difference() {
        union() {
            if (back_cut) offset(delta = -shrink) {
                if (bk_lip_ext)
                    intersection() {
                        offset(delta = c) back_lip_plan();
                        translate([-1, seat_y1]) square([outer_length + 2, outer_width - seat_y1 + 1]);
                    }
                else
                    translate([-1, seat_y1]) square([bk_lip_x1 + c + 1, outer_width - seat_y1 + 1]);
            }
            if (left_cut) offset(delta = -shrink)
                translate([-1, bed_y0 - c])
                    square([seat_x0 + 1 + overlap,
                            (back_cut ? seat_y1 + overlap : outer_width + 1) - bed_y0 + c]);
        }
        if (has_hinges) offset(delta = shrink) hinge_islands_2d();
    }
}
// Trim strip filling one rim cut, cut floor down, outer edges rounded as
// the base's; peg holes through it, as in the lip
module rim_trim(which) {
    c = lip_cut_clearance;
    intersection() {
        cuboid([outer_length, outer_width, outer_depth],
               rounding = outer_rounding, except = BOTTOM, anchor = LEFT + FRONT + BOTTOM);
        difference() {
            translate([0, 0, rim_cut_z]) linear_extrude(height = top_z - rim_cut_z)
                intersection() {
                    rim_cut_2d(c);
                    if (which == "back")
                        translate([-1, seat_y1 - overlap]) square([outer_length + 2, outer_width]);
                    else
                        translate([-1, -1]) square([seat_x0 + 1 + overlap, seat_y1 - c + 1]);
                }
            if (which == "back")
                for (x = back_peg_xs) if (x <= bk_lip_x1) ext_trim_peg_hole(x, peg_back_y);
            if (which == "left")
                for (y = left_peg_ys) ext_trim_peg_hole(peg_left_x, y);
        }
    }
}
module ext_trim_peg_hole(x, y) {
    translate([x, y, rim_cut_z - overlap])
        cylinder(h = top_z - rim_cut_z + 2 * overlap,
                 d = ext_peg_style == "pin" ? rod_d - pin_lip_interference
                                            : peg_d + peg_lip_clearance, $fn = 32);
}
// Trims in print position (cut floor down, at the origin)
module rim_trim_print(which) {
    b = which == "back" ? [0, seat_y1] : [0, bed_y0];
    translate([-b.x, -b.y, -rim_cut_z]) rim_trim(which);
}

// Cord slot trim: fills the slot through the rim (not the ledge under the
// bed) from just above the cords' channel to the rim's top, a push fit
cs_trim_c = 0.15;
module cord_slot_trim() {
    intersection() {
        cuboid([outer_length, outer_width, outer_depth],
               rounding = outer_rounding, except = BOTTOM, anchor = LEFT + FRONT + BOTTOM);
        translate([cs_x - cs_w / 2 + cs_trim_c, seat_y1 + cs_trim_c, cs_zb + cs_ch])
            cube([cs_w - 2 * cs_trim_c, outer_width - seat_y1, top_z - cs_zb - cs_ch]);
    }
}
module cord_slot_trim_print() {
    translate([-(cs_x - cs_w / 2), -seat_y1, -(cs_zb + cs_ch)]) cord_slot_trim();
}

// Recess for one hinge of the selected type, centered on (x, y).
module hinge_cutter(x, y) {
    if (hinge_sized == "lollipop")
        lollipop_hinge_cutter(x, y);
    else if (hinge_sized == "printed")
        printed_hinge_cutter(x, y);
    else
        assert(false, str("Unknown hinge_type: ", hinge_type));
}

// Recess for one printed hinge block, centered on the pivot (x, y): the
// block's footprint down to its floor, a slot from the recess through the
// web and into the seat for the pin (open at the top, so the pin swings
// up), and the screw's trap and hole from below (the screw's head bears
// on the trap's roof).
module printed_hinge_cutter(x, y) {
    c  = ph_recess_clear;
    trap_top = top_z - ph_trap_depth;
    sw = ph_pd + 2 * ph_clear;
    translate([x, y, 0]) {
        translate([-ph_bw / 2 - c, ph_front - c, ph_zb])
            cube([ph_bw + 2 * c, ph_back - ph_front + 2 * c, top_z - ph_zb + overlap]);
        y_far = seat_y1 - bed_clearance - ph_pe - 1 - y;
        translate([-sw / 2, y_far, ph_az - ph_pd / 2 - ph_clear])
            cube([sw, ph_front - y_far + overlap,
                  top_z - (ph_az - ph_pd / 2 - ph_clear) + overlap]);
    }
    translate([x, y + ph_sdy, trap_top + hinge_nut_bridge])
        cylinder(h = ph_zb - trap_top - hinge_nut_bridge + overlap,
                 d = hinge_mounting_hole_diameter);
    translate([x, y + ph_sdy, -overlap])
        nut_trap_inline(trap_top + overlap, hinge_nut_spec,
                        nutwidth = hinge_nut_width > 0 ? hinge_nut_width : undef,
                        anchor = BOTTOM, $slop = nut_clearance);
}

// Printed hinge parts, in the hinge-local frame (pivot axis on X through
// the origin, bed toward -Y).
// Arm outline in YZ, grown by g: a bar from its front face back to the
// tail (or, with no stop, rounded about the pivot), its top cut to ph_atop
module ph_arm_2d(g = 0) {
    intersection() {
        if (ph_Lt > 0)
            translate([-ph_Lf - g, -ph_R - g]) square([ph_Lf + ph_Lt + 2 * g, 2 * (ph_R + g)]);
        else
            hull() {
                circle(r = ph_R + g, $fn = 64);
                translate([-ph_Lf - g, -ph_R - g]) square([ph_Lf + g, 2 * (ph_R + g)]);
            }
        translate([-100, -100]) square([200, 100 + ph_atop + g]);
    }
}
// YZ outline -> 3D across X (width w, centered)
module ph_yz(w) {
    rotate([90, 0, 90]) linear_extrude(height = w, center = true) children();
}
// Room the arm sweeps from rest (0) to angle a, grown by the clearance
module ph_arm_sweep(a) {
    n = max(1, ceil(a / 5));
    ph_yz(ph_arm_w + 2 * ph_clear)
        for (i = [0 : n - 1])
            hull() {
                rotate(-i * a / n) ph_arm_2d(ph_clear);
                rotate(-(i + 1) * a / n) ph_arm_2d(ph_clear);
            }
}
// Teardrop hole along X, pointing up in print: toward +Z for the block
// (printed upright), toward +Y for the arm (printed on its front face)
module ph_hole_x(d, w, to_y = false) {
    ph_yz(w) rotate(to_y ? -90 : 0) teardrop_2d(d);
}

// The arm: pin hole in from the front face (chamfered), pivot hole across
module ph_arm() {
    pd = ph_pd + ph_press;
    difference() {
        ph_yz(ph_arm_w) ph_arm_2d();
        translate([0, -ph_Lf - overlap, 0]) rotate([-90, 0, 0]) {
            cylinder(h = ph_pin_embed + 0.5 + overlap, d = pd, $fn = 48);
            cylinder(h = 0.6 + overlap, d1 = pd + 1.2 + 2 * overlap, d2 = pd, $fn = 48);
        }
        ph_hole_x(ph_pivot_d + ph_slip, ph_arm_w + 2 * overlap, true);
    }
}

// The block: cheeks holding the pivot rod (press fit), a floor under the
// arm with the tail's pocket behind (whose floor is the stop), and a nut
// pressed into the underside under the front of the arm
module ph_block() {
    w = ph_bw;
    difference() {
        translate([-w / 2, ph_front, ph_bot]) cube([w, ph_back - ph_front, ph_atop - ph_bot]);
        ph_arm_sweep(ph_th);
        // the arm's channel runs out through the front, where the pin leaves
        translate([-ph_arm_w / 2 - ph_clear, ph_front - overlap, -ph_R - ph_clear])
            cube([ph_arm_w + 2 * ph_clear, -ph_front, ph_R + ph_clear + ph_atop + overlap]);
        ph_hole_x(ph_pivot_d + ph_press, w + 2 * overlap);
        // nut pocket from below, and the screw's hole on up (blind)
        translate([0, ph_sdy, ph_bot - overlap]) {
            rotate(30) cylinder(h = ph_nut_t + 0.3 + overlap, r = ph_nut_w / 2 / cos(30), $fn = 6);
            cylinder(h = -(ph_R + ph_clear) - 1.5 - ph_bot + overlap,
                     d = hinge_mounting_hole_diameter, $fn = 32);
        }
        // ease the vertical edges, so the block drops into a square recess
        for (sx = [-1, 1], yy = [ph_front, ph_back])
            translate([sx * w / 2, yy, ph_bot - overlap])
                linear_extrude(height = ph_atop - ph_bot + 2 * overlap)
                    rotate(45) square(1.2, center = true);
    }
}

// Steel rods, for views
module ph_rods(tilt = 0) {
    color("Silver") {
        rotate([-tilt, 0, 0]) translate([0, -ph_Lf + ph_pin_embed, 0]) rotate([90, 0, 0])
            cylinder(h = ph_pin_len, d = ph_pd, $fn = 32);
        rotate([0, 90, 0]) cylinder(h = ph_bw, d = ph_pivot_d, center = true, $fn = 32);
    }
}

// One hinge in place at hinge center x, arm tilted by `tilt`
module ph_in_place(x, tilt = 0) {
    translate([x, hinge_y, ph_az]) {
        color("DarkOrange") ph_block();
        color("Orange") rotate([-tilt, 0, 0]) ph_arm();
        ph_rods(tilt);
    }
}

// Print plate: two blocks upright and two arms standing on their front faces
ph_arm_print_h = ph_Lf + ph_R;
module printed_hinges() {
    g = 6;
    for (i = [0, 1]) {
        translate([ph_bw / 2 + i * (ph_bw + g), -ph_front, -ph_bot]) ph_block();
        translate([ph_arm_w / 2 + i * (ph_arm_w + g), ph_back - ph_front + g + ph_R, ph_Lf])
            rotate([90, 0, 0]) ph_arm();
    }
}

// Foot-locating rig, in bed coordinates: the bed's front-left corner at
// the origin, X along the bed, Y toward the back, Z = 0 on the board. The
// walls stand bed_clearance off the bed's edges; the floor rim reaches
// rig_rim in under the bed's edges, with marking holes rig_mark_in in from
// the bed's edges (so their positions are known exactly), and screw holes
// for the board. Two halves, split at the bed's middle, joined by tabs on
// the left half's front and back walls bolted through the right half's.
rig_c  = bed_clearance;
rig_L  = bed_length; rig_W = bed_width;
rig_sx = rig_L / 2;                                  // split
rig_x0 = -rig_c - rig_wall; rig_x1 = rig_L + rig_c + rig_wall;
rig_y0 = -rig_c - rig_wall; rig_y1 = rig_W + rig_c + rig_wall;
rig_marks = [for (x = [rig_mark_in, rig_sx, rig_L - rig_mark_in],
                  y = [rig_mark_in, rig_W - rig_mark_in]) [x, y]];
rig_screws = [for (x = [rig_L * 0.12, rig_sx - rig_lap - 12, rig_sx + rig_lap + 12, rig_L * 0.88],
                   y = [-rig_c + (rig_rim - rig_c) / 2 - rig_wall / 2, rig_W + rig_c - (rig_rim - rig_c) / 2 + rig_wall / 2]) [x, y]];
rig_bolt_zs = [rig_height * 0.3, rig_height * 0.75];
module foot_rig_whole() {
    difference() {
        union() {
            // walls
            difference() {
                translate([rig_x0, rig_y0, 0]) cube([rig_x1 - rig_x0, rig_y1 - rig_y0, rig_height]);
                translate([-rig_c, -rig_c, -1]) cube([rig_L + 2 * rig_c, rig_W + 2 * rig_c, rig_height + 2]);
            }
            // floor rim
            difference() {
                translate([rig_x0, rig_y0, 0]) cube([rig_x1 - rig_x0, rig_y1 - rig_y0, rig_floor]);
                translate([rig_rim - rig_c, rig_rim - rig_c, -1])
                    cube([rig_L - 2 * (rig_rim - rig_c), rig_W - 2 * (rig_rim - rig_c), rig_floor + 2]);
            }
            // cross bar at the split, so each half keeps its shape
            for (bx = concat(rig_bar_in > 0 ? [rig_bar_in, rig_L - rig_bar_in] : [],
                             rig_crossbar ? [rig_sx] : [])) {
                translate([bx - rig_bar_w / 2, -rig_c, 0]) cube([rig_bar_w, rig_W + 2 * rig_c, rig_floor]);
                if (rig_bar_rib > 0)
                    translate([bx - 1.5, -rig_c, 0]) cube([3, rig_W + 2 * rig_c, rig_floor + rig_bar_rib]);
            }
        }
        for (m = rig_marks) translate([m.x, m.y, -1]) cylinder(h = rig_floor + 2, d = rig_mark_d, $fn = 16);
        // cord notch, where the base has a cord slot
        if (has_cord_slot)
            translate([cord_slot[0] - cs_w / 2, rig_W - 1, foot_height + bed_plate_thickness - cord_slot[2]])
                cube([cs_w, rig_c + rig_wall + 2, rig_height]);
    }
}
module foot_rig_half(right) {
    t = rig_wall;
    difference() {
        union() {
            intersection() {
                foot_rig_whole();
                translate(right ? [rig_sx, -50, -1] : [rig_x0 - 1, -50, -1])
                    cube([right ? rig_x1 - rig_sx + 1 : rig_sx - rig_x0 + 1, rig_W + 100, rig_height + 2]);
            }
            // splice tabs on the left half, outside the front and back walls
            if (!right)
                for (y = [rig_y0 - t, rig_y1])
                    translate([rig_sx - rig_lap, y, 0]) cube([2 * rig_lap, t, rig_height]);
        }
        for (y = [rig_y0 - t - 1, rig_y1 - t - 1], dx = [-rig_lap / 2, rig_lap / 2], z = rig_bolt_zs)
            translate([rig_sx + dx, y, z]) rotate([-90, 0, 0])
                cylinder(h = 2 * t + 2, d = rig_bolt_d, $fn = 20);
        for (sc = rig_screws)
            if (right ? sc.x > rig_sx : sc.x < rig_sx)
                translate([sc.x, sc.y, -1]) cylinder(h = rig_floor + 2, d = rig_screw_d, $fn = 20);
    }
}

// Rod-fit test: a bar with five vertical pin holes (as the arm prints
// them) and five horizontal pivot holes (as the block prints them), at
// ph_press -0.2 .. +0.2 left to right, and a sixth horizontal hole at the
// arm's running fit (marked by a notch on top)
pt_steps = [-0.2, -0.1, 0, 0.1, 0.2];
pt_pitch = max(ph_pd, ph_pivot_d) + 6;
module printed_hinge_test() {
    L = 7 * pt_pitch;
    hz = ph_pivot_d / 2 + 4;                     // pivot-hole row height
    H = ph_pivot_d + 8 + 13;                     // pin holes 12 deep from the top, clear of it
    D = max(ph_pd + 8, 14);
    difference() {
        cube([L, D, H]);
        for (i = [0 : 4]) {
            x = (i + 1) * pt_pitch;
            translate([x, D / 2, H - 12]) cylinder(h = 12 + overlap, d = ph_pd + ph_press + pt_steps[i], $fn = 48);
            translate([x, -overlap, hz]) rotate([-90, 0, 0])
                linear_extrude(height = D + 2 * overlap) rotate(180) teardrop_2d(ph_pivot_d + ph_press + pt_steps[i]);
            // one notch per step on the front top edge: 1 = tightest
            for (k = [0 : i]) translate([x - 4 + 2 * k, -overlap, H - 1]) cube([1, 1.5, 1 + overlap]);
        }
        x6 = 6 * pt_pitch;
        translate([x6, -overlap, hz]) rotate([-90, 0, 0])
            linear_extrude(height = D + 2 * overlap) rotate(180) teardrop_2d(ph_pivot_d + ph_slip);
        translate([x6 - 3, D / 2 - 0.5, H - 1]) cube([6, 1, 1 + overlap]);
    }
}

// Recess for one lollipop hinge, centered on (x, y), flush with the top,
// with a hex nut trap reached from the underside.
module lollipop_hinge_cutter(x, y) {
    pin_length = hinge_pin_extension + hinge_pin_internal_length;
    nut_top_z  = top_z - hinge_nut_depth;

    // Flange recess
    translate([x, y, top_z - hinge_flange_thickness])
        cylinder(h = hinge_flange_thickness + overlap,
                 d = hinge_flange_diameter);

    // Hinge body recess
    translate([x, y, top_z - hinge_thickness])
        cylinder(h = hinge_thickness + overlap, d = hinge_inner_diameter);

    // Pin slot, with sweep relief below the pin
    translate([x - hinge_pin_thickness / 2,
               y - hinge_flange_diameter / 2 - pin_length / 2,
               top_z - hinge_pin_height - hinge_pin_sweep_depth])
        cube([hinge_pin_thickness,
              pin_length,
              hinge_pin_height + hinge_pin_sweep_depth + overlap]);

    // Screw hole, from just above the nut trap (and its bridge) to the top
    translate([x, y + hinge_screw_dy(), nut_top_z + hinge_nut_bridge])
        cylinder(h = hinge_nut_depth - hinge_nut_bridge + overlap,
                 d = hinge_mounting_hole_diameter);

    // Hex nut trap from the underside up to the nut seat
    translate([x, y + hinge_screw_dy(), -overlap])
        nut_trap_inline(nut_top_z + overlap, hinge_nut_spec,
                        nutwidth = hinge_nut_width > 0 ? hinge_nut_width
                                                       : undef,
                        anchor = BOTTOM, $slop = nut_clearance);
}

// Pocket, screw holes, and nut traps for one mending plate centered on
// (x, y), running along X across the split.
module plate_cutter(x, y) {
    pl = plate_length + 2 * plate_pocket_clearance;
    pw = plate_width + 2 * plate_pocket_clearance;

    // Pocket in the underside
    translate([x - pl / 2, y - pw / 2, -overlap])
        cube([pl, pw, plate_pocket_depth + overlap]);

    for (h = plate_holes) {
        // Screw clearance through the floor, above a sacrificial layer
        hz = plate_hole_bridge > 0 ? plate_pocket_depth + plate_hole_bridge : -overlap;
        translate([x + h[0], y + h[1], hz])
            cylinder(h = floor_z - hz + overlap, d = plate_screw_clearance);

        // Nut trap opening onto the cavity floor
        translate([x + h[0], y + h[1], floor_z + overlap])
            nut_trap_inline(plate_nut_trap_depth + overlap, plate_nut_spec,
                            nutwidth = plate_nut_width > 0 ? plate_nut_width
                                                           : undef,
                            anchor = TOP, $slop = nut_clearance);
    }
}

// A row of gabled tunnels filling [xa, xb] in the back wall, running
// from y0 for len in +Y. Tunnel widths are adjusted so the run fills evenly.
module tunnel_run(xa, xb, y0, len) {
    span = xb - xa;
    n = max(1, round((span + tunnel_web) / (tunnel_width + tunnel_web)));
    w = (span - (n - 1) * tunnel_web) / n;
    h = tunnel_peak_z - floor_z - w / 2;
    if (span > 0 && h > 0)
        for (i = [0 : n - 1])
            translate([xa + w / 2 + i * (w + tunnel_web), y0, floor_z])
                gable_tunnel(w, h, len);
}

// Gabled opening, support-free when printed upright: width w, straight
// sides of height h, 45-degree roof. Bottom edge on the local XY plane,
// centered in X, extruded along +Y from y=0 (or centered if center=true).
module gable_tunnel(w, h, len, center = false) {
    translate([0, center ? -len / 2 : 0, 0])
        rotate([-90, 0, 0])
            mirror([0, 1, 0])
                linear_extrude(height = len)
                    polygon([[-w / 2, 0], [w / 2, 0], [w / 2, h],
                             [0, h + w / 2], [-w / 2, h]]);
}

// ---------------------------------------------------------------------------
// Extensions
// ---------------------------------------------------------------------------

// Rounded box from (x0,y0,0) to (x1,y1,ext_top_z), rounding the listed edges.
module ext_shell(x0, y0, x1, y1, edges) {
    translate([x0, y0, 0])
        if (len(edges) > 0)
            cuboid([x1 - x0, y1 - y0, ext_top_z], rounding = ext_rounding,
                   edges = edges, anchor = LEFT + FRONT + BOTTOM);
        else
            cube([x1 - x0, y1 - y0, ext_top_z]);
}

// Lid rabbet and compartment cut for a body with rabbet opening `rab`.
module ext_hollow(which, rab) {
    b = bay_rect(which, rab);
    // Lid rabbet
    translate([rab[0].x, rab[0].y, ext_top_z - ext_lid_thickness])
        cube([rab[1].x - rab[0].x, rab[1].y - rab[0].y,
              ext_lid_thickness + overlap]);
    // Compartment, inside the ledge
    translate([b[0].x, b[0].y, ext_floor])
        cube([b[1].x - b[0].x, b[1].y - b[0].y, ext_top_z]);
}

// Lip slab over the base rim, from corner a to corner b in XY.
module ext_lip(a, b) {
    translate([a.x, a.y, lip_z0])
        cube([b.x - a.x, b.y - a.y, lip_t]);
}

// Peg hanging from a lip underside at (x, y).
module ext_peg(x, y) {
    translate([x, y, lip_z0 - peg_len]) {
        cylinder(h = peg_len + overlap, d = peg_d);
    }
}

// Through hole in the lip for a separate peg or pin
module ext_peg_hole(x, y) {
    if (ext_peg_style != "molded")
        translate([x, y, lip_z0 - overlap])
            cylinder(h = lip_t + 2 * overlap,
                     d = ext_peg_style == "pin" ? rod_d - pin_lip_interference
                                                : peg_d + peg_lip_clearance, $fn = 32);
}
// A separate peg or pin shown above its lip hole, for the exploded view
module peg_exploded(x, y, lift) {
    if (ext_peg_style != "molded")
        color(ext_peg_style == "pin" ? "Silver" : "LightSteelBlue")
            translate([x, y, ext_top_z - ext_peg_len + lift])
                cylinder(h = ext_peg_len, d = ext_peg_style == "pin" ? rod_d : peg_d, $fn = 24);
}
// Separate peg: through the lip, flush with its top, and peg_len below it.
// Printed lying on its side (a small flat along one side), so its layers
// run along it and it is strong in bending; crush ribs grip the lip.
ext_peg_len = lip_t + lip_clearance + peg_len;
module ext_peg_print() {
    r   = peg_d / 2;
    fl  = 0.3;                                 // flat to sit on the bed
    rib = (peg_d + peg_lip_clearance) / 2 + 0.15;
    translate([0, 0, r - fl]) rotate([0, 90, 0])
        difference() {
            union() {
                cylinder(h = ext_peg_len, r = r, $fn = 32);
                // ribs along the part that sits in the lip
                for (a = [60, 180, 300])
                    rotate(a) translate([rib - 0.35, 0, 0])
                        cylinder(h = lip_t - 0.5, r = 0.35, $fn = 12);
            }
            // flat along the side that lies on the bed (local +X is down after the rotation)
            translate([r - fl, -r - 1, -1]) cube([2 * r, 2 * r + 2, ext_peg_len + 2]);
            // chamfer the leading end
            translate([0, 0, ext_peg_len - 0.6])
                difference() {
                    cylinder(h = 1, r = r + 1);
                    cylinder(h = 0.6, r1 = r, r2 = r - 0.6, $fn = 32);
                }
        }
}
n_ext_pegs = (has_back ? len(back_pegs) : 0) + (has_left ? len(left_pegs) : 0);
module ext_pegs(n = max(n_ext_pegs, 1)) {
    for (i = [0 : 1 : n - 1])
        translate([0, i * (peg_d + 4), 0]) ext_peg_print();
}

// Dovetail profile in XY: neck on the line `at` (x or y), pointing in
// direction dir (+1/-1) along axis ("x" or "y"), centered on c.
module dt_profile(axis, at, dir, c, grow) {
    offset(delta = grow)
        if (axis == "x")
            polygon([[at - dir, c - ext_dt_neck / 2],
                     [at + dir * ext_dt_depth, c - ext_dt_head / 2],
                     [at + dir * ext_dt_depth, c + ext_dt_head / 2],
                     [at - dir, c + ext_dt_neck / 2]]);
        else
            polygon([[c - ext_dt_neck / 2, at - dir],
                     [c - ext_dt_head / 2, at + dir * ext_dt_depth],
                     [c + ext_dt_head / 2, at + dir * ext_dt_depth],
                     [c + ext_dt_neck / 2, at - dir]]);
}

// Corner dovetails: tongue into the back extension's left end, and into
// the left extension's back end.
cn_dt_y = (cn_y0 + cn_y1) / 2;
cn_dt_x = (cn_x0 + cn_x1) / 2;

module corner_tongues(grow, z0, h) {
    translate([0, 0, z0])
        linear_extrude(height = h) {
            // into the back extension, whose left face is at x = 0
            dt_profile("x", cn_x1, 1, cn_dt_y, grow);
            // into the left extension, whose back face is at y = outer_width
            dt_profile("y", cn_y0, -1, cn_dt_x, grow);
        }
}

// Bobbin-plate trenches, measured from the bed's edges
module back_trench_cut() {
    if (len(back_trench) == 4)
        translate([bed_x0 + back_trench[0] - back_trench[1] / 2,
                   seat_y1 - bed_clearance - overlap,
                   ext_top_z - back_trench[3]])
            cube([back_trench[1], back_trench[2] + overlap,
                  back_trench[3] + overlap]);
}

module left_trench_cut() {
    if (len(left_trench) == 4)
        translate([bed_x0 - left_trench[2],
                   bed_y0 + left_trench[0] - left_trench[1] / 2,
                   ext_top_z - left_trench[3]])
            cube([left_trench[2] + overlap, left_trench[1],
                  left_trench[3] + overlap]);
}

module back_ext_part() {
    edges = concat([TOP + BACK, BACK + RIGHT, TOP + RIGHT],
                   has_corner ? [] : [TOP + LEFT, BACK + LEFT]);
    difference() {
        union() {
            ext_shell(bk_x0, bk_y0, bk_x1, bk_y1, edges);
            back_lip();
            if (ext_peg_style == "molded") for (x = back_pegs) ext_peg(x, peg_back_y);
        }
        ext_hollow("back", bk_rab);
        lid_frame_cuts("back");
        for (x = back_pegs) ext_peg_hole(x, peg_back_y);
        if (has_corner)
            corner_tongues(ext_dt_clearance, -overlap, ext_top_z + 2 * overlap);
        back_trench_cut();
        // Printed hinges stand above the rim, and a recessed lip goes round
        // the full-height islands left about the hinges: notch the lip
        if (has_hinges && (hinge_type == "printed" || lip_recessed))
            translate([0, 0, lip_z0 - 1]) linear_extrude(height = lip_t + 2)
                offset(delta = lip_cut_clearance) hinge_islands_2d();
    }
}

// Back lip: a plain slab over the base's back rim, or, when it runs on past
// a short body (bk_lip_ext), a slab whose free end is rounded in plan, with
// its free top edges rounded, its edge on the seat line kept square, and a
// plan fillet where its back edge meets the body's right wall. No gusset
// underneath: the base rim is lip_clearance below.
// Plan outline of an extended back lip: the lip under the body, run on to
// the left and front (so those stay square), the run-on strip with its end
// rounded, and a stand-in for the body's right wall so the closing makes
// the fillet
module back_lip_plan() {
    R   = lip_fillet;
    y0  = seat_y1;
    y1  = bk_y0;
    big = 50;
    re  = max(0.01, min(R, (y1 - y0) / 2 - 0.01));
    offset(r = -R) offset(delta = R)
        union() {
            translate([bk_x0 - big, y0 - big])
                square([bk_x1 - bk_x0 + big, y1 - y0 + big + overlap]);
            translate([bk_x0 - big, y1]) square([bk_x1 - bk_x0 + big, big]);
            translate([bk_x1 - 25, y0])
                offset(r = re) offset(delta = -re)
                    square([bk_lip_x1 - bk_x1 + 25, y1 - y0]);
        }
}

module back_lip() {
    r  = lip_recessed ? 0 : lip_edge_round;
    R  = lip_fillet;
    y0 = seat_y1;
    y1 = bk_y0;
    if (!bk_lip_ext) ext_lip(bk_lip[0], bk_lip[1]);
    else
        intersection() {
            union() {
                translate([0, 0, lip_z0]) linear_extrude(height = lip_t - r) back_lip_plan();
                if (r > 0) {
                    minkowski() {
                        translate([0, 0, lip_z0 + lip_t - r - 0.01])
                            linear_extrude(height = 0.01) offset(delta = -r) back_lip_plan();
                        sphere(r = r, $fn = 24);
                    }
                    // keep the top edge on the seat line square
                    translate([0, 0, lip_z0]) linear_extrude(height = lip_t)
                        intersection() {
                            back_lip_plan();
                            translate([bk_x0 - 1, y0 - 1]) square([bk_lip_x1 - bk_x0 + 2, r + 1]);
                        }
                }
            }
            // the lip itself, plus the fillet beside the body (not over it)
            union() {
                translate([bk_x0, y0, lip_z0]) cube([bk_x1 - bk_x0, y1 - y0 + overlap, lip_t]);
                translate([bk_x1 - overlap, y0, lip_z0])
                    cube([bk_lip_x1 - bk_x1 + 1, y1 - y0 + R + 1, lip_t]);
            }
        }
}

// Left lip: starts at the bed's front edge, its front top edge rounded and
// its inside corner with the body filleted in plan.
module left_lip() {
    r  = lip_edge_round;
    R  = lip_fillet;
    a  = lf_lip[0];
    b  = lf_lip[1];
    big = 50;
    // plan outline: body plus a lip that runs on past its right and back
    // ends (so only the front and the fillet get rounded), with the
    // inside corner closed to radius R
    module plan()
        offset(r = -R) offset(delta = R)
            union() {
                translate([lf_x0, lf_y0]) square([lf_x1 - lf_x0, lf_y1 - lf_y0]);
                translate([a.x, a.y]) square([b.x - a.x + big, b.y - a.y + big]);
            }
    intersection() {
        union() {
            translate([0, 0, lip_z0])
                linear_extrude(height = lip_t - r) plan();
            minkowski() {
                translate([0, 0, lip_z0 + lip_t - r - 0.01])
                    linear_extrude(height = 0.01) offset(delta = -r) plan();
                sphere(r = r, $fn = 24);
            }
        }
        translate([a.x, a.y - R - 0.5, lip_z0])
            cube([b.x - a.x, b.y - a.y + R + 0.5, lip_t]);
    }
}

module left_ext_part() {
    edges = concat([TOP + LEFT, TOP + FRONT, FRONT + LEFT, FRONT + RIGHT],
                   has_corner ? [] : [TOP + BACK, BACK + LEFT]);
    difference() {
        union() {
            ext_shell(lf_x0, lf_y0, lf_x1, lf_y1, edges);
            left_lip();
            if (ext_peg_style == "molded") for (y = left_pegs) ext_peg(peg_left_x, y);
        }
        ext_hollow("left", lf_rab);
        lid_frame_cuts("left");
        for (y = left_pegs) ext_peg_hole(peg_left_x, y);
        if (has_corner)
            corner_tongues(ext_dt_clearance, -overlap, ext_top_z + 2 * overlap);
        left_trench_cut();
    }
}

module corner_part() {
    difference() {
        union() {
            ext_shell(cn_x0, cn_y0, cn_x1, cn_y1,
                      [TOP + LEFT, TOP + BACK, BACK + LEFT]);
            corner_tongues(0, 0, ext_top_z);
        }
        ext_hollow("corner", cn_rab);
        lid_frame_cuts("corner");
    }
}

// Lid hinge test: a short frame with its rabbet, hinge recesses and
// lean-back chamfer, and a 40 mm strip of hinged lid, to tune the hinge
// settings in a few minutes. The frame prints upright, the lid top down.
module lid_hinge_test() {
    A = 40;
    B = 30;
    t = ext_lid_thickness;
    w = ext_frame;
    hl = max(ext_ledge, ext_lid_clearance + t + ext_hinge_margin);
    fz = 3;                                       // frame below the rabbet
    translate([w, B + w, t + fz])
        difference() {
            translate([-w, -B - w, -t - fz]) cube([A + 2 * w, B + 2 * w, t + fz]);
            translate([0, -B, -t]) cube([A, B, t + overlap]);
            translate([ext_ledge, -B + ext_ledge, -t - fz - overlap])
                cube([A - 2 * ext_ledge, B - ext_ledge - hl, t + fz + 2 * overlap]);
            lid_frame_canon(A, B, t);
        }
    translate([A + 2 * w + 10, 0, 0]) rotate([180, 0, 0])
        lid_canon(A, B, t, fhole = false);
}

// ---------------------------------------------------------------------------
// Turn button
// ---------------------------------------------------------------------------
// A raised pad on the front rim, its top just above the bed top, eased into
// the rim and the front face. The button turns on a vertical #8 screw at
// the middle of the rim: turned toward the back it reaches over the bed's
// front edge; turned toward +X it lies along the pad. A nub under the button
// clicks into a dimple at each position. The screw's nut sits in a slot in
// the front wall below the ledge, entered from inside the machine cavity.
tb_x   = turn_button_x > 0 ? turn_button_x : (cut_x + key_depth + seat_x1) / 2;
tb_y   = seat_y0 / 2 + 0.5;                             // pivot, just behind mid-rim
tb_top = bed_top_z + turn_button_gap;                   // pad top, button underside
tb_R   = seat_y0 + bed_clearance + turn_button_overlap - tb_y;   // pivot to tip
tb_Lt  = 2 * (tb_R + 2);                                // pad top length
tb_det = tb_R * 0.55;                                   // detent radius
tb_nut_w = nut_w(turn_button_nut_spec, 0) + 2 * nut_clearance;          // across flats
tb_nut_c = tb_nut_w / cos(30);                                           // across corners
tb_nut_t = nut_t(turn_button_nut_spec) + 0.3;
tb_nut_z = seat_floor_z - 2 - tb_nut_t;                 // slot floor
tb_screw_need = (tb_top + turn_button_t) - tb_nut_z + 0.5;
// Wall left in front of the nut: the swelling's depth at the nut's height
tb_nut_wall = tb_y - tb_nut_w / 2 + turn_button_swell;
function tb_ss(t) = let(u = max(0, min(1, t))) u * u * (3 - 2 * u);
// Bump amplitude along the rim: 1 on the plateau, easing smoothly to 0
function tb_a(x) = let(d = abs(x - tb_x) - tb_Lt / 2)
    d <= 0 ? 1 : 1 - tb_ss(d / turn_button_ease);
// Cross-section of the pad (in YZ) at x: back face on the seat line, flat
// top, rounded front-top edge blending from the base's own edge rounding,
// the front swelling held down past the nut and then easing into the face.
// Where the amplitude is 0 it lies just inside the base's own surface.
function tb_sec(x) =
    let(a  = tb_a(x), dl = 0.05 * (1 - a), K = 8, J = 3, T = 6,
        zt = top_z + a * (tb_top - top_z) - dl,
        yf = -a * turn_button_swell + dl,
        R  = outer_rounding + (2 - outer_rounding) * a,
        zh = tb_nut_z - 1,
        zb = zh - turn_button_swell_taper)
    concat([[x, seat_y0 - dl, top_z - outer_rounding - 1]],
           [[x, seat_y0 - dl, zt]],
           [for (k = [0 : K]) let(t = 90 + 90 * k / K)
               [x, yf + R + R * cos(t), zt - R + R * sin(t)]],
           [for (j = [1 : J]) [x, yf, (zt - R) - j * ((zt - R) - zh) / J]],
           [for (j = [1 : T]) let(u = j / T)
               [x, yf * (1 - tb_ss(u)) + dl * tb_ss(u), zh - u * turn_button_swell_taper]],
           [[x, 4, zb]]);
module tb_pad() {
    n  = 80;
    x0 = tb_x - tb_Lt / 2 - turn_button_ease;
    x1 = tb_x + tb_Lt / 2 + turn_button_ease;
    secs = [for (i = [0 : n]) tb_sec(x0 + (x1 - x0) * i / n)];
    m  = len(secs[0]);
    pts = [for (sc = secs) each sc];
    faces = concat(
        [for (i = [0 : n - 1], k = [0 : m - 1])
            [i * m + k, i * m + (k + 1) % m, (i + 1) * m + (k + 1) % m, (i + 1) * m + k]],
        [[for (k = [m - 1 : -1 : 0]) k]],
        [[for (k = [0 : m - 1]) n * m + k]]);
    polyhedron(points = pts, faces = faces, convexity = 4);
}
module tb_cuts() {
    // screw hole from the pad top down past the nut
    translate([tb_x, tb_y, tb_nut_z - 6])
        cylinder(h = tb_top - tb_nut_z + 6 + overlap, d = 4.6);
    // nut slot: flats facing front and back, entered from the cavity side
    translate([tb_x - tb_nut_c / 2, tb_y - tb_nut_w / 2, tb_nut_z])
        cube([tb_nut_c, mc_y0 - (tb_y - tb_nut_w / 2) + overlap, tb_nut_t]);
    // detent dimples, closed (toward the back) and open (toward +X)
    for (v = [[0, tb_det], [tb_det, 0]])
        translate([tb_x + v.x, tb_y + v.y, tb_top - 0.8]) cylinder(h = 1, d = 2.4, $fn = 16);
}
// The button, in place (closed); printed top face down by part turn_button
module turn_button_part() {
    w = turn_button_w;
    translate([tb_x, tb_y, tb_top])
        difference() {
            union() {
                linear_extrude(height = turn_button_t)
                    hull() {
                        circle(d = w);
                        translate([0, tb_R - w / 2]) circle(d = w);
                    }
                // detent nub under the button
                translate([0, tb_det, 0]) rotate([180, 0, 0])
                    cylinder(h = 0.6, d1 = 2, d2 = 1.2, $fn = 16);
            }
            translate([0, 0, -1]) cylinder(h = turn_button_t + 2, d = 4.6);
            // ease the top edges
        }
}

// Freestanding boxes: an extension's body, bay, rabbet and lid frame, with
// every top and vertical edge rounded and no lip, pegs or dovetails. Same
// place and bay as the extension, so the same lid and inserts fit.
module ext_box(which, b0, b1, rab) {
    difference() {
        ext_shell(b0.x, b0.y, b1.x, b1.y, [TOP, "Z"]);
        ext_hollow(which, rab);
        lid_frame_cuts(which);
    }
}
module back_box()   ext_box("back",   [bk_x0, bk_y0], [bk_x1, bk_y1], bk_rab);
module left_box()   ext_box("left",   [lf_x0, lf_y0], [lf_x1, lf_y1], lf_rab);
module corner_box() ext_box("corner", [cn_x0, cn_y0], [cn_x1, cn_y1], cn_rab);

// ---------------------------------------------------------------------------
// Lids with snap-in dimple hinges
// ---------------------------------------------------------------------------
//
// Each lid pivots on two cone-shaped bumps, one on each end face at the
// hinge edge, that click into matching recesses in the rabbet walls. Each
// bump sits on a flex tab freed by a slot, so the lid snaps in without
// forcing the walls. The hinge edge is rounded about the pivot so it turns
// in place, and an optional chamfer behind it lets the open lid lean back
// to about 135 degrees and stay there.
//
// Lids are built in a canonical frame: the rabbet runs from x = 0 to A
// along the hinge wall, the hinge wall is at y = 0 and the rabbet extends
// to y = -B, and z = 0 is the top surface.

// Lid record: [rabbet [[x0,y0],[x1,y1]], top z, thickness, hinge edge]
// Hinge coupon: the left hinge's recess in a block whose front edge is the
// back wall of the bed seat, with countersunk corner holes for wood screws.
// It tests the hinge fit, and doubles as a hinge insert for a wooden base.
hc_half = hinge_sized == "lollipop" ? hinge_flange_diameter / 2 : hinge_half_x();
hc_x0 = hinge_x1 - hc_half - hinge_coupon_margin;
hc_x1 = hinge_x1 + hc_half + hinge_coupon_margin;
hc_y0 = seat_y1;
hc_y1 = hinge_y + hinge_rear() + hinge_coupon_margin;
hc_t  = (hinge_sized == "printed" ? top_z - ph_zb
         : max(hinge_thickness, hinge_pin_height + hinge_pin_sweep_depth)) + hinge_coupon_floor;
hc_z0 = top_z - hc_t;
module hinge_coupon() {
    ins = hinge_coupon_margin / 2;
    hd  = hinge_coupon_head_d;
    sd  = hinge_coupon_screw_d;
    ck  = (hd - sd) / 2 / tan(41);
    translate([-hc_x0, -hc_y0, -hc_z0])
        difference() {
            translate([hc_x0, hc_y0, hc_z0]) cube([hc_x1 - hc_x0, hc_y1 - hc_y0, hc_t]);
            hinge_cutter(hinge_x1, hinge_y);
            for (x = [hc_x0 + ins, hc_x1 - ins], y = [hc_y0 + ins, hc_y1 - ins])
                translate([x, y, hc_z0 - overlap]) {
                    cylinder(h = hc_t + 2 * overlap, d = sd);
                    translate([0, 0, hc_t + overlap - ck])
                        cylinder(h = ck + overlap, d1 = sd, d2 = hd + 2 * overlap);
                }
        }
}

// Through mount: clearance hole through the right end wall, countersunk
// for a flat head at the outer face, under a cap recess if wanted.
module outlet_through_hole() {
    hd = outlet_screw_head_d;
    sd = outlet_screw_hole_d;
    ck = (hd - sd) / 2 / tan(41);                // 82-degree countersink depth
    translate([0, ol_yc, ol_zc]) rotate([0, 90, 0]) {
        translate([0, 0, st_x1 - overlap])
            cylinder(h = outer_length - st_x1 + 2 * overlap, d = sd);
        translate([0, 0, outer_length - ol_cb - ck])
            cylinder(h = ck + 0.01, d1 = sd, d2 = hd);
        if (ol_cb > 0)
            translate([0, 0, outer_length - ol_cb])
                cylinder(h = ol_cb + overlap, d = outlet_cap_d + 0.4);
    }
}
// The cap, printed on its outer face: a disc with three crush ribs.
module outlet_cap() {
    d = outlet_cap_d + 0.4 - 2 * rod_plug_clearance;
    linear_extrude(height = outlet_cap_t)
        union() {
            circle(d = d);
            for (a = [0, 120, 240])
                rotate(a) translate([(outlet_cap_d + 0.4) / 2 + rod_plug_rib - 0.35, 0])
                    circle(r = 0.35, $fn = 16);
        }
}

// Cord pass-through: its cross-section (Y across, Z up, from the tunnel's
// floor centre), knock-out walls at both ends, and a removable cover.
has_passthrough = has_compartment && compartment_option != "storage" && !attached;
module pt_profile(grow = 0) {
    w = cord_hole_width;
    h = cord_hole_height;
    offset(delta = grow)
        polygon([[-w / 2, 0], [w / 2, 0], [w / 2, h], [0, h + w / 2], [-w / 2, h]]);
}
// Place a YZ profile at x, extruded t along +X (dir 1) or -X (dir -1)
module pt_slab(x, t, dir) {
    translate([x, cord_hole_y, floor_z]) rotate([90, 0, dir > 0 ? 90 : -90])
        linear_extrude(height = t) children();
}
module passthrough_knockout_walls() {
    t  = passthrough_knockout_t;
    sd = passthrough_score_depth;
    sw = passthrough_score_w;
    for (e = [[divider_x0, 1], [divider_x1, -1]])
        difference() {
            // the wall, overlapping the tunnel's sides a little so it fuses
            pt_slab(e[0], t, e[1]) pt_profile(0.3);
            // score groove around its edge, on the tunnel side
            pt_slab(e[0] + e[1] * (t - sd), sd + overlap, e[1])
                difference() { pt_profile(0.01); pt_profile(-sw); }
        }
}
// Cover: a plug that pushes into the compartment end of the tunnel, held
// by crush ribs, with a flange against the divider face. Printed flange down.
module passthrough_cover_part() {
    c  = 0.15;
    fl = 1.5;
    linear_extrude(height = fl) pt_profile(2.5);
    translate([0, 0, fl - 0.01])
        linear_extrude(height = passthrough_cover_depth)
            union() {
                pt_profile(-c);
                for (sg = [-1, 1], f = [0.3, 0.7])
                    translate([sg * (cord_hole_width / 2 - c), f * cord_hole_height])
                        circle(r = c + 0.15 + 0.2, $fn = 12);
            }
}

// Low curbs on the compartment floor around the outlet's face and ends.
module outlet_curbs() {
    w  = outlet_curb_w;
    x0 = ol_x0 - ol_c - w;
    y0 = ol_yc - ol_L / 2 - ol_c - w;
    y1 = ol_yc + ol_L / 2 + ol_c;
    translate([0, 0, floor_z - overlap]) {
        translate([x0, y0, 0]) cube([w, y1 + w - y0, outlet_curb_h + overlap]);
        translate([x0, y0, 0]) cube([st_x1 - x0 + overlap, w, outlet_curb_h + overlap]);
        translate([x0, y1, 0]) cube([st_x1 - x0 + overlap, w, outlet_curb_h + overlap]);
    }
}

// Receptacle names recessed into the floor between the divider and the
// outlet's front curb, each centered on its receptacle and set toward the
// outlet face, reading from the front
ol_lab_x1 = ol_x0 - ol_c - outlet_curb_w - 2;    // right end of the words
ol_lab_x0 = st_x0 + 2;                            // farthest left they may reach
ol_lab_light_y = ol_yc + (outlet_light_side == "back" ? 1 : -1) * outlet_receptacle_spacing / 2;
ol_lab_motor_y = ol_yc - (outlet_light_side == "back" ? 1 : -1) * outlet_receptacle_spacing / 2;
// rough width of a word in bold sans capitals
function ol_lab_w(t) = 0.72 * outlet_label_size * len(t);
module outlet_label_cuts() {
    for (l = [[outlet_light_label, ol_lab_light_y], [outlet_motor_label, ol_lab_motor_y]])
        if (len(l[0]) > 0)
            translate([ol_lab_x1, l[1], floor_z - outlet_label_depth])
                linear_extrude(height = outlet_label_depth + overlap)
                    text(l[0], size = outlet_label_size, font = "Liberation Sans:style=Bold",
                         halign = "right", valign = "center");
}

// Cord slots in the outlet-compartment lid. Each is open at its lid edge,
// round at its inner end, with chamfered top edges.
function ol_slot_auto(side, i) =
    side == "right" ? (i == 1 ? ol_yc - ol_L / 2 : ol_yc + ol_L / 2) - seat_y0
    : (st_x1 - ol_T / 2 - lid_x0)
      - (i == 2 && outlet_slot_1_side == outlet_slot_2_side ? outlet_slot_w + 12 : 0);
module outlet_slot_2d(pos) {
    // local frame: X along the edge, Y inward from the edge
    r = outlet_slot_w / 2;
    hull() {
        translate([pos - r, -10]) square([outlet_slot_w, 10]);
        translate([pos, outlet_slot_depth - r]) circle(r = r);
    }
}
module outlet_slot_cut(side, pos) {
    ch = outlet_slot_chamfer;
    module local() {
        hull() {
            translate([0, 0, top_z - rabbit_depth - 1])
                linear_extrude(height = rabbit_depth + 1 - ch) outlet_slot_2d(pos);
            translate([0, 0, top_z])
                linear_extrude(height = 1) offset(delta = ch) outlet_slot_2d(pos);
        }
    }
    if (side == "front")
        translate([lid_x0, seat_y0, 0]) local();
    else if (side == "back")
        translate([lid_x0, seat_y1, 0]) mirror([0, 1, 0]) local();
    else if (side == "right")
        translate([lid_x1, seat_y0, 0]) rotate(90) local();
}
module outlet_slots() {
    sides = [outlet_slot_1_side, outlet_slot_2_side];
    poss  = [outlet_slot_1_pos, outlet_slot_2_pos];
    for (i = [0, 1])
        if (sides[i] != "none")
            outlet_slot_cut(sides[i], poss[i] > 0 ? poss[i] : ol_slot_auto(sides[i], i + 1));
}

function lid_info(which) =
    which == "base"   ? [[[lid_x0, seat_y0], [lid_x1, seat_y1]], top_z,
                         rabbit_depth, has_outlet ? outlet_lid_hinge : base_lid_hinge,
                         attached ? attached_lid_type : base_lid_type,
                         base_lid_style, base_lid_grip, base_lid_tab_edge]
  : which == "back"   ? [bk_rab, ext_top_z, ext_lid_thickness, back_lid_hinge,
                         back_lid_type, back_lid_style, back_lid_grip, back_lid_tab_edge]
  : which == "left"   ? [lf_rab, ext_top_z, ext_lid_thickness, left_lid_hinge,
                         left_lid_type, left_lid_style, left_lid_grip, left_lid_tab_edge]
  :                     [cn_rab, ext_top_z, ext_lid_thickness, corner_lid_hinge,
                         corner_lid_type, corner_lid_style, corner_lid_grip,
                         corner_lid_tab_edge];
// Outer faces around a lid's compartment: [[x0, y0], [x1, y1]]
function lid_body(which) =
    which == "base" ? [[attached ? base_x1 : 0, 0], [outer_length, outer_width]]
  : which == "back" ? [[bk_x0, bk_y0], [bk_x1, bk_y1]]
  : which == "left" ? [[lf_x0, lf_y0], [lf_x1, lf_y1]]
  :                   [[cn_x0, cn_y0], [cn_x1, cn_y1]];
// Edges that face open air when the extension is attached
function open_edges(which) =
    which == "base" ? ["front"]
  : which == "back" ? concat(["back", "right"], has_corner ? [] : ["left"])
  : which == "left" ? concat(["front", "left"], has_corner ? [] : ["back"])
  :                   ["left", "back"];
function has_tab(which) = lid_info(which)[6] == "tab";

// Thumb-tab grip, in a frame at the middle of the lid edge `e` on the rabbet
// line: local +X points out through the wall, local Y runs along the edge.
// D is the wall thickness out to the outer face.
module grip_frame(which) {
    li = lid_info(which);
    r  = li[0];
    bd = lid_body(which);
    e  = li[7];
    xc = (r[0].x + r[1].x) / 2;
    yc = (r[0].y + r[1].y) / 2;
    if (e == "front")      translate([xc, r[0].y]) rotate(-90) children();
    else if (e == "back")  translate([xc, r[1].y]) rotate(90) children();
    else if (e == "left")  translate([r[0].x, yc]) rotate(180) children();
    else                   translate([r[1].x, yc]) children();
}
function grip_D(which) =
    let(li = lid_info(which), r = li[0], bd = lid_body(which), e = li[7])
    e == "front" ? r[0].y - bd[0].y : e == "back" ? bd[1].y - r[1].y
  : e == "left"  ? r[0].x - bd[0].x : bd[1].x - r[1].x;
// The tab on the lid: from inside the lid edge out past the outer face
module grip_tab(which) {
    li = lid_info(which);
    D  = grip_D(which);
    c  = ext_lid_clearance;
    w  = grip_tab_w;
    rr = grip_tab_r;
    translate([0, 0, li[1] - li[2]])
        linear_extrude(height = li[2])
            grip_frame(which)
                hull() {
                    translate([-c - 2, -w / 2]) square([0.01, w]);
                    for (sgn = [-1, 1])
                        translate([D + grip_tab_over - rr, sgn * (w / 2 - rr)]) circle(r = rr);
                }
}
// The notch in the wall for the tab, and the thumb scoop below it
module grip_cuts(which) {
    li  = lid_info(which);
    D   = grip_D(which);
    top = li[1];
    t   = li[2];
    nw  = grip_tab_w + 2 * ext_lid_clearance;
    z0  = top - t;
    grip_frame(which) {
        translate([-overlap, -nw / 2, z0]) cube([D + 2 * overlap, nw, t + overlap]);
        translate([0, nw / 2, 0]) rotate([90, 0, 0])
            linear_extrude(height = nw)
                polygon([[D + overlap, z0 - grip_scoop_h], [D, z0 - grip_scoop_h],
                         [D - grip_scoop_d, z0 - grip_scoop_h + grip_scoop_d],
                         [D - grip_scoop_d, z0 + overlap], [D + overlap, z0 + overlap]]);
    }
}

// Base lid notch on its left edge, clearing the motor boss as the lid
// opens: base_lid_notch = [depth, width] from the lid edge, with rounded
// inner corners and a flare into the edge. Not cut when the lid hinges on
// its left edge.
module base_lid_notch_cut() {
    d  = base_lid_notch[0];
    w  = base_lid_notch[1];
    c  = ext_lid_clearance;
    yc = (seat_y0 + seat_y1) / 2 + base_lid_notch_offset;
    ri = min(base_lid_notch_r, w / 2 - 0.01, d / 2 - 0.01);
    ro = base_lid_notch_flare;
    if (d > 0 && w > 0)
        translate([lid_x0, 0, top_z - rabbit_depth - 1])
            linear_extrude(height = rabbit_depth + 2)
                offset(r = -ro) offset(r = ro)
                    offset(r = ri) offset(delta = -ri)
                        // grown so the rounded corners stay outside the d x w clearance
                        let(g = ri * (1 - 1 / sqrt(2)))
                        union() {
                            translate([-30, yc - w / 2 - g]) square([30 + c + d + g, w + 2 * g]);
                            translate([-30, yc - 300]) square([30, 600]);
                        }
}
// Whether a lid is made for a compartment
function lid_on(which) =
    (which == "base"   ? has_compartment
   : which == "back"   ? bay_back
   : which == "left"   ? bay_left
   :                     bay_corner) && lid_info(which)[4] != "none";

// Canonical sizes: A along the hinge, B across it
function lid_AB(r, e) =
    (e == "back" || e == "front") ? [r[1].x - r[0].x, r[1].y - r[0].y]
                                  : [r[1].y - r[0].y, r[1].x - r[0].x];

// Place children from the canonical frame into the world.
module lid_place(r, top, e) {
    if (e == "back")       translate([r[0].x, r[1].y, top]) children();
    else if (e == "front") translate([r[1].x, r[0].y, top]) rotate(180) children();
    else if (e == "right") translate([r[1].x, r[1].y, top]) rotate(-90) children();
    else                   translate([r[0].x, r[0].y, top]) rotate(90) children();
}

// Lid in the canonical frame: hinge edge along X at Y = 0, lid toward -Y,
// top face at Z = 0. `type` is "hinged" or "lift-out"; `perf` perforates it,
// keeping `pm` clear of the free edges.
module lid_canon(A, B, t, fpos = 0.75, type = "hinged", perf = false, pm = 0, fhole = true) {
    c  = ext_lid_clearance;
    ce = type == "hinged" ? lid_hinge_end_clearance : c;   // at the hinge ends
    ya = -c - t / 2;                     // pivot axis
    bh = ce + lid_bump_engage;           // bump height off the end face
    bt = lid_bump_d - 2 * bh * tan(lid_bump_angle);       // bump tip diameter
    fh = [fpos * A, -(B - c) + 0.9 * ext_finger_hole];
    difference() {
        if (type == "hinged")
            union() {
                translate([ce, -(B - c), -t])
                    cube([A - 2 * ce, B - c - c - t / 2, t]);
                translate([ce, ya, -t / 2]) rotate([0, 90, 0])
                    cylinder(h = A - 2 * ce, r = t / 2);
                // bumps
                translate([ce + overlap, ya, -t / 2]) rotate([0, -90, 0])
                    cylinder(h = bh + overlap, d1 = lid_bump_d + 2 * overlap * tan(lid_bump_angle),
                             d2 = max(0.2, bt));
                translate([A - ce - overlap, ya, -t / 2]) rotate([0, 90, 0])
                    cylinder(h = bh + overlap, d1 = lid_bump_d + 2 * overlap * tan(lid_bump_angle),
                             d2 = max(0.2, bt));
            }
        else
            translate([c, -(B - c), -t]) cube([A - 2 * c, B - 2 * c, t]);
        // flex-tab slots, open at the hinge edge
        if (type == "hinged")
            for (x = [ce + lid_tab_w, A - ce - lid_tab_w - lid_slot_w])
                translate([x, ya - lid_tab_len, -t - overlap])
                    cube([lid_slot_w, lid_tab_len + t, t + 2 * overlap]);
        // finger hole, near the free edge
        if (fhole)
            translate([fh.x, fh.y, -t - overlap])
                cylinder(h = t + 2 * overlap, d = ext_finger_hole);
        // ventilation holes on a hex grid
        if (perf) {
            m  = max(lid_perf_margin, pm);
            xm = lid_perf_margin + (type == "hinged" ? lid_tab_w + lid_slot_w : 0);
            x0 = c + max(m, xm);
            x1 = A - c - max(m, xm);
            y0 = -(B - c) + m;
            y1 = -c - t - lid_perf_margin;
            dy = lid_perf_pitch * sin(60);
            translate([0, 0, -t - overlap])
                linear_extrude(height = t + 2 * overlap)
                    for (j = [0 : floor((y1 - y0) / dy)],
                         i = [0 : floor((x1 - x0) / lid_perf_pitch)])
                        let(x = x0 + i * lid_perf_pitch + (j % 2) * lid_perf_pitch / 2,
                            y = y0 + j * dy)
                        if (x <= x1 && (!fhole || norm([x, y] - fh) > ext_finger_hole / 2 + lid_perf_margin))
                            translate([x, y]) circle(d = lid_perf_d, $fn = 16);
        }
    }
}

// Cuts in the frame for a lid: bump recesses and the lean-back chamfer.
module lid_frame_canon(A, B, t) {
    c  = ext_lid_clearance;
    ya = -c - t / 2;
    sd = lid_bump_d + 2 * lid_recess_clearance;
    sh = lid_bump_engage + 0.3;          // a little deeper than the bump reaches
    ta = tan(lid_bump_angle);
    for (m = [[0, -1], [A, 1]])
        translate([m[0] - m[1] * overlap, ya, -t / 2])
            rotate([0, m[1] * 90, 0])
                cylinder(h = sh + overlap, d1 = sd + 2 * overlap * ta,
                         d2 = max(0.4, sd - 2 * sh * ta));
    if (lid_open_stop) {
        k  = 0.7071 * t + 0.3;           // top face of a lid at 135 degrees
        yw = c + t / 2;                  // hinge wall, from the axis
        rotate([90, 0, 90])
            linear_extrude(height = A)
                translate([ya, -t / 2])
                    polygon([[yw - overlap, yw - k], [yw - overlap, t / 2 + overlap],
                             [k + t / 2 + overlap, t / 2 + overlap]]);
    }
}

module lid_frame_cuts(which) {
    li = lid_info(which);
    ab = lid_AB(li[0], li[3]);
    if (li[4] == "hinged")
        lid_place(li[0], li[1], li[3]) lid_frame_canon(ab[0], ab[1], li[2]);
    if (li[4] != "none" && has_tab(which))
        grip_cuts(which);
}

// Lid in assembly position, with any trench or cord slots cut through it.
// Nothing for a lid of type "none".
module lid_part(which) {
    li = lid_info(which);
    ab = lid_AB(li[0], li[3]);
    outlet_lid = which == "base" && has_outlet;
    if (li[4] != "none")
        difference() {
            union() {
                lid_place(li[0], li[1], li[3])
                    lid_canon(ab[0], ab[1], li[2], outlet_lid ? 0.5 : 0.75, li[4],
                              li[5] == "perforated",
                              outlet_lid ? outlet_slot_depth + lid_perf_margin : 0,
                              !has_tab(which));
                if (has_tab(which)) grip_tab(which);
            }
            if (which == "back") back_trench_cut();
            if (which == "left") left_trench_cut();
            if (outlet_lid) outlet_slots();
            if (which == "base" && !(li[3] == "left" && li[4] == "hinged"))
                base_lid_notch_cut();
        }
}

// Turn children over (180 degrees about X) and move the box [mn, mx] to
// start at the origin.
module flip_to_origin(mn, mx) {
    translate([-mn.x, mx.y, mx.z]) rotate([180, 0, 0]) children();
}

// Lid moved to the origin, top face down so the visible face prints on the bed.
module lid_print(which) {
    li = lid_info(which);
    flip_to_origin([li[0][0].x, li[0][0].y, li[1] - li[2]],
                   [li[0][1].x, li[0][1].y, li[1]])
        lid_part(which);
}

// Size of a lid's footprint in print position
function lid_size(which) = let(li = lid_info(which))
    [li[0][1].x - li[0][0].x, li[0][1].y - li[0][0].y];


// ---------------------------------------------------------------------------
// Print plates (part "all")
// ---------------------------------------------------------------------------
// Every part the configuration needs, in print orientation, packed onto
// printer-sized plates. A plate holds parts of one kind (base, extensions,
// lids, small parts) and one support class: unsupported, or supported with
// the support interface at one height. Plates with supported parts keep a
// corner clear for a purge tower. Packing is a simple shelf layout, tallest
// parts first, inside printer_margin of the bed's edges.

// Extra spare pegs printed with the set
peg_spares = 2;

tb_sw = turn_button ? turn_button_swell : 0;     // pad swelling past the front face
// Supported layer heights of each extension (in print orientation)
function ext_support(w) =
    w == "back" || w == "left"
        ? concat([lip_z0], ext_peg_style == "molded" ? [lip_z0 - peg_len] : [])
        : [];
function lid_support(w) =
    let(tr = w == "back" ? back_trench : w == "left" ? left_trench : [])
    len(tr) == 4 ? [tr[3]] : [];
// Room around a lid in print position for its hinge bumps and any tab
function tab_pad(w) = (lid_on(w) && has_tab(w) ? 2 * (grip_D(w) + grip_tab_over + 1) : 0)
                    + 2 * (lid_bump_engage + 1);

// [id, kind, [w, h], support layers]
build_parts = concat(
    split ? [["base_left",  "base", [cut_x + key_depth + 0.5, outer_width + tb_sw], []],
             ["base_right", "base", [base_x1 - cut_x, outer_width + tb_sw], []]]
          : [["base_whole", "base", [base_x1, outer_width + tb_sw], []]],
    attached ? [["right_bay", "extension", [outer_length - base_x1, outer_width], []]] : [],
    has_back   ? [["back_ext",   "extension", [bk_size.x, bk_size.y], ext_support("back")]] : [],
    has_left   ? [["left_ext",   "extension", [lf_size.x, lf_size.y], ext_support("left")]] : [],
    has_corner ? [["corner_ext", "extension", [cn_size.x, cn_size.y], []]] : [],
    make_back_box   ? [["back_box",   "extension", [bk_x1 - bk_x0, bk_y1 - bk_y0], []]] : [],
    make_left_box   ? [["left_box",   "extension", [lf_x1 - lf_x0, lf_y1 - lf_y0], []]] : [],
    make_corner_box ? [["corner_box", "extension", [cn_x1 - cn_x0, cn_y1 - cn_y0], []]] : [],
    [for (w = ["base", "back", "left", "corner"]) if (lid_on(w))
        [str("lid_", w), "lid", lid_size(w) + [tab_pad(w), tab_pad(w)], lid_support(w)]],
    harness_rods && rod_plug_len > 0
        ? [["rod_plugs", "small", [n_rods * (rod_hole_d + 5), rod_hole_d + 2], []]] : [],
    ol_cb > 0 ? [["outlet_cap", "small", [outlet_cap_d + 1.4, outlet_cap_d + 1.4], []]] : [],
    ext_peg_style == "insert" && n_ext_pegs > 0
        ? [["ext_pegs", "small",
            [ext_peg_len, (n_ext_pegs + peg_spares) * (peg_d + 4)], []]] : [],
    hinge_type == "lollipop" ? [["hinge_nut_tool", "small", [22, 22], []]] : [],
    back_cut ? [["back_trim", "small", [bk_lip_x1 + 2, outer_width - seat_y1 + 1], []]] : [],
    left_cut ? [["left_trim", "small", [seat_x0 + 2, seat_y1 - bed_y0 + 1], []]] : [],
    has_cord_slot ? [["cord_slot_trim", "small", [cs_w, outer_width - seat_y1], []]] : [],
    hinge_type == "printed"
        ? [["printed_hinges", "small",
            [2 * ph_bw + 6, ph_back - ph_front + 6 + 2 * ph_R], []]] : [],
    turn_button ? [["turn_button", "small", [turn_button_w + 1, tb_R + turn_button_w], []]] : [],
    has_knee ? [["knee_sector", "small", [kn_hub_r + 2 + kn_rs + 2 * kn_m, kn_cam_r + 2 + kn_rs + 2 * kn_m], []],
                ["knee_idler", "small", [2 * (kn_r2 + 2 * kn_m), 2 * (kn_r2 + 2 * kn_m)], []],
                ["knee_pinion", "small", [kn_rp2 * 2 + 4, kn_rp2 * 2 + 4], []],
                ["knee_hub", "small", [kn_cr + 4 + 13 + 2, 2 * 14 + 2], []],
                ["knee_spring_housing", "small", kn_h_size, []],
                ["knee_spring_cap", "small", [2 * kn_rb + 1, 2 * kn_rb + 1], []],
                ["knee_cover", "small", [kn_cv1.x - kn_cv0.x + kn_cv_ear, kn_cv1.y - kn_cv0.y], []],
                if (knee_power == "bare") ["knee_cord_clamp", "small", [8, 2 * kn_clamp_dy + 8], []]] : [],
    has_passthrough && passthrough_cover
        ? [["passthrough_cover", "small",
            [cord_hole_width + 6, cord_hole_height + cord_hole_width / 2 + 6], []]] : []);

// Each part at the origin, in print orientation, inside [0, w] x [0, h]
module place_part(id) {
    if (id == "base_left")
        intersection() { base(); split_mask(0); }
    else if (id == "base_right")
        translate([-cut_x, tb_sw, 0]) difference() { base(); split_mask(split_clearance); }
    else if (id == "base_whole")
        translate([0, tb_sw, 0]) base();
    else if (id == "right_bay")  translate([-base_x1, 0, 0]) right_bay();
    else if (id == "hinge_nut_tool") translate([11, 11, 0]) hinge_nut_tool();
    else if (id == "printed_hinges") printed_hinges();
    else if (id == "back_trim") rim_trim_print("back");
    else if (id == "left_trim") rim_trim_print("left");
    else if (id == "cord_slot_trim") cord_slot_trim_print();
    else if (id == "back_ext")   translate([-bk_x0, -seat_y1, 0]) back_ext_part();
    else if (id == "left_ext")   translate([-lf_x0, -lf_y0, 0]) left_ext_part();
    else if (id == "corner_ext") translate([-cn_x0, -cn_y0 + ext_dt_depth, 0]) corner_part();
    else if (id == "back_box")   translate([-bk_x0, -bk_y0, 0]) back_box();
    else if (id == "left_box")   translate([-lf_x0, -lf_y0, 0]) left_box();
    else if (id == "corner_box") translate([-cn_x0, -cn_y0, 0]) corner_box();
    else if (id == "lid_base")   translate([tab_pad("base") / 2, tab_pad("base") / 2, 0]) lid_print("base");
    else if (id == "lid_back")   translate([tab_pad("back") / 2, tab_pad("back") / 2, 0]) lid_print("back");
    else if (id == "lid_left")   translate([tab_pad("left") / 2, tab_pad("left") / 2, 0]) lid_print("left");
    else if (id == "lid_corner") translate([tab_pad("corner") / 2, tab_pad("corner") / 2, 0]) lid_print("corner");
    else if (id == "rod_plugs")  translate([rod_hole_d / 2 + 1, rod_hole_d / 2 + 1, 0]) rod_plugs();
    else if (id == "outlet_cap") translate([outlet_cap_d / 2 + 0.7, outlet_cap_d / 2 + 0.7, 0]) outlet_cap();
    else if (id == "ext_pegs")   translate([0, peg_d / 2 + 2, 0]) ext_pegs(n_ext_pegs + peg_spares);
    else if (id == "passthrough_cover")
        translate([cord_hole_width / 2 + 3, 3, 0]) passthrough_cover_part();
    else if (id == "knee_sector")
        translate([kn_hub_r + 1, kn_cam_r + 1, 0]) knee_sector_part();
    else if (id == "knee_idler")   translate([kn_r2 + 2 * kn_m, kn_r2 + 2 * kn_m, 0]) knee_idler_part();
    else if (id == "knee_pinion")  translate([kn_rp2 + 2, kn_rp2 + 2, 0]) knee_pinion_part();
    else if (id == "knee_hub")     translate([kn_s > 0 ? kn_cr + 5 : 14, 15, 0]) knee_hub_part();
    else if (id == "knee_spring_housing") knee_spring_housing_part();
    else if (id == "knee_spring_cap") translate([kn_rb + 0.5, kn_rb + 0.5, 0]) knee_spring_cap_part();
    else if (id == "knee_cover")   knee_cover_part();
    else if (id == "knee_cord_clamp") translate([4, kn_clamp_dy + 4, 0]) knee_cord_clamp_part();
    else if (id == "turn_button")
        translate([turn_button_w / 2 + 0.5, tb_R, turn_button_t + tb_top]) rotate([180, 0, 0])
            translate([-tb_x, -tb_y, 0]) turn_button_part();
}

pl_W = printer_size.x - 2 * printer_margin;
pl_H = printer_size.y - 2 * printer_margin;
pl_kinds = ["base", "extension", "lid", "small"];
function pl_key(sl) = len(sl) == 0 ? -1 : round(sl[0] * 100) / 100;
function pl_uniq(v, i = 0, acc = []) =
    i >= len(v) ? acc
  : pl_uniq(v, i + 1, len([for (a = acc) if (a == v[i]) a]) > 0 ? acc : concat(acc, [v[i]]));
// Groups: [kind, support key], unsupported first within each kind
pl_groups = [for (k = pl_kinds)
                 let(keys = pl_uniq([for (p = build_parts) if (p[1] == k) pl_key(p[3])]))
                 for (z = [for (q = keys) if (q < 0) q, for (q = keys) if (q >= 0) q]) [k, z]];
// Indices of a group's parts, tallest first
function pl_sort(v) = len(v) <= 1 ? v
  : let(pv = v[0], h = build_parts[pv][2].y)
    concat(pl_sort([for (i = v) if (i != pv && build_parts[i][2].y > h) i]), [pv],
           pl_sort([for (i = v) if (i != pv && build_parts[i][2].y <= h) i]));
function pl_items(g) = pl_sort([for (i = [0 : len(build_parts) - 1])
                                    if (build_parts[i][1] == g[0] && pl_key(build_parts[i][3]) == g[1]) i]);
// Can a w x h part go at (x, y), keeping clear of the purge tower corner?
function pl_fits(x, y, w, h, tw) =
    x + w <= pl_W + 0.01 && y + h <= pl_H + 0.01
    && !(tw > 0 && x + w > pl_W - tw - plate_gap && y + h > pl_H - tw - plate_gap);
// Shelf packing: returns [[part index, plate, x, y, rotated], ...]. Each part
// goes in the current row as it is or turned 90 degrees, else starts a new
// row, else a new plate.
function pl_pack(items, tw, i = 0, cx = 0, cy = 0, rowh = 0, pl = 0, acc = []) =
    i >= len(items) ? acc
  : let(s0 = build_parts[items[i]][2], s1 = [s0.y, s0.x], ny = cy + rowh + plate_gap)
    pl_fits(cx, cy, s0.x, s0.y, tw)
        ? pl_pack(items, tw, i + 1, cx + s0.x + plate_gap, cy, max(rowh, s0.y), pl,
                  concat(acc, [[items[i], pl, cx, cy, false]]))
  : pl_fits(cx, cy, s1.x, s1.y, tw)
        ? pl_pack(items, tw, i + 1, cx + s1.x + plate_gap, cy, max(rowh, s1.y), pl,
                  concat(acc, [[items[i], pl, cx, cy, true]]))
  : cx > 0 && pl_fits(0, ny, s0.x, s0.y, tw)
        ? pl_pack(items, tw, i + 1, s0.x + plate_gap, ny, s0.y, pl,
                  concat(acc, [[items[i], pl, 0, ny, false]]))
  : cx > 0 && pl_fits(0, ny, s1.x, s1.y, tw)
        ? pl_pack(items, tw, i + 1, s1.x + plate_gap, ny, s1.y, pl,
                  concat(acc, [[items[i], pl, 0, ny, true]]))
  : cx == 0 && cy == 0
        // too big even for an empty plate: give it a plate of its own
        ? pl_pack(items, tw, i + 1, 0, 0, 0, pl + 1, concat(acc, [[items[i], pl, 0, 0, false]]))
  : pl_pack(items, tw, i, 0, 0, 0, pl + 1, acc);
function pl_count(pk) = len(pk) == 0 ? 0 : max([for (q = pk) q[1]]) + 1;
// All groups, numbered consecutively from plate 1: [[part, plate, x, y, group]]
function pl_all(gi = 0, base = 1, acc = []) =
    gi >= len(pl_groups) ? acc
  : let(g  = pl_groups[gi],
        tw = g[1] >= 0 ? purge_tower_size : 0,
        pk = pl_pack(pl_items(g), tw))
    pl_all(gi + 1, base + pl_count(pk),
           concat(acc, [for (q = pk) [q[0], base + q[1], q[2], q[3], gi, q[4]]]));
plates = pl_all();
n_plates = len(plates) == 0 ? 0 : max([for (q = plates) q[1]]);

module print_plates() {
    for (q = plates)
        if (print_plate == 0 || q[1] == print_plate) {
            off = print_plate == 0 ? [(q[1] - 1) * (printer_size.x + 40), 0, 0] : [0, 0, 0];
            translate(off + [printer_margin + q[2], printer_margin + q[3], 0])
                if (q[5]) translate([build_parts[q[0]][2].y, 0, 0]) rotate(90)
                              place_part(build_parts[q[0]][0]);
                else place_part(build_parts[q[0]][0]);
        }
}

// Report: the plates, what is on each, and the support layer
if (report) {
    echo(str("=== Print plates (", n_plates, " on a ", printer_size.x, " x ", printer_size.y,
             " bed, ", printer_margin, " mm margin; part all, print_plate 1 to ", n_plates, ") ==="));
    for (pn = [1 : 1 : n_plates]) {
        on = [for (q = plates) if (q[1] == pn) q];
        g  = pl_groups[on[0][4]];
        echo(str("Plate ", pn, " (", g[0], g[1] >= 0
                 ? str(", supports with the interface at Z ", g[1], ", purge tower corner kept clear")
                 : ", no supports", "): ",
                 [for (q = on) build_parts[q[0]][0]]));
    }
    for (p = build_parts) {
        if (p[2].x > pl_W || p[2].y > pl_H)
            echo(str("WARNING: ", p[0], " (", p[2], ") is larger than the bed inside the margin"));
        if (len(p[3]) > 1)
            echo(str("WARNING: ", p[0], " needs supports on ", len(p[3]),
                     " layers (Z ", p[3], "): more filament changes; ",
                     p[1] == "extension" ? "use ext_peg_style insert or pin" : "check the design"));
    }
    if (split && fits([base_x1, outer_width + tb_sw, outer_depth]))
        echo("NOTE: the whole base fits this bed inside the margin; split = false would print it in one piece, with no mending plates, screws or nut traps");
}

// ---------------------------------------------------------------------------
// Test parts
// ---------------------------------------------------------------------------

BIG = 2000;

// The base cut to a box, as one piece or as two halves `test_split_gap` apart.
// The base cut to the shape of its children, whole or as two halves.
module base_masked(halves) {
    if (halves) {
        intersection() { base(); split_mask(0); children(); }
        translate([test_split_gap, 0, 0])
            intersection() {
                difference() { base(); split_mask(split_clearance); }
                children();
            }
    } else {
        intersection() { base(); children(); }
    }
}

module base_box(mn, mx, halves) {
    if (halves) {
        intersection() {
            base(); split_mask(0);
            translate(mn) cube(mx - mn);
        }
        translate([test_split_gap, 0, 0])
            intersection() {
                difference() { base(); split_mask(split_clearance); }
                translate(mn) cube(mx - mn);
            }
    } else {
        intersection() { base(); translate(mn) cube(mx - mn); }
    }
}

// Split test: the front of the joint, both halves, for trying the front-wall
// serrations and the first dovetail key. Each piece prints upright, as in
// the base; lower the right piece onto the left.
split_test_y1 = min(keys) + key_head / 2 + 6;
split_test_z1 = split_test_h > 0 ? max(split_test_h, floor_z + 2) : outer_depth + 1;
// Hinge nut tool: a nut pushed onto the tip rides up the nut trap from
// the underside and is held at its seat while the screw is started from
// above; once the screw has caught, the tool comes out. A handle at the
// bottom; the shaft, round, passes the hex trap; the shoulder pushes the
// nut, and the tapered tip holds it by its bore. The shaft is long enough to
// seat a nut 3 mm thick or more. Printed standing on the handle.
ntool_af = nut_w(hinge_nut_spec, hinge_nut_width);
ntool_d  = ntool_af - 1.2;                         // shaft
ntool_l  = top_z - hinge_nut_depth - 3;            // shaft length, handle to shoulder
module hinge_nut_tool() {
    hd = 20; hh = 16;                              // handle
    tp = hinge_nut_tool_tip;
    difference() {
        cylinder(h = hh, d = hd, $fn = 48);
        for (a = [0 : 30 : 359]) rotate(a) translate([hd / 2 + 0.6, 0, -1]) cylinder(h = hh + 2, d = 3, $fn = 16);
    }
    translate([0, 0, hh]) cyl(h = ntool_l, d = ntool_d, chamfer2 = 0.6, anchor = BOTTOM, $fn = 40);
    // tip: tapered so the bore grips it, pointed so it finds the bore
    translate([0, 0, hh + ntool_l - overlap]) {
        cylinder(h = 3 + overlap, d1 = tp + 0.3, d2 = tp - 0.3, $fn = 24);
        translate([0, 0, 3]) cylinder(h = 1, d1 = tp - 0.3, d2 = tp - 1.2, $fn = 24);
    }
}

// Attached-bay joint test: the base's end wall and the bay's inner wall
// around the front lower screw and the front dowel, each printed upright as
// in its part, side by side. Fit an insert, a dowel and a screw.
att_t_y = [att_ys[0] - att_hr - 6, att_dowels[0][0] + rod_d / 2 + 6];
att_t_z = [att_zs[0] - att_hr - 5, att_dowels[0][1] + rod_d / 2 + 5];
module attach_test() {
    lo = [mc_x1 - 1, att_t_y[0], att_t_z[0]];
    hi = [st_x0, att_t_y[1], att_t_z[1]];
    translate([-lo.x, -lo.y, -lo.z]) intersection() {
        base();
        translate(lo) cube([base_x1 - lo.x, hi.y - lo.y, hi.z - lo.z]);
    }
    translate([base_x1 - lo.x + 10 - base_x1, -lo.y, -lo.z]) intersection() {
        right_bay();
        translate([base_x1, lo.y, lo.z]) cube([hi.x - base_x1, hi.y - lo.y, hi.z - lo.z]);
    }
}

module split_test() {
    x0 = cut_x - split_test_w;
    translate([-x0, 1, 0])
        base_box([x0, -1, -1], [cut_x + split_test_w, split_test_y1, split_test_z1], true);
}

module test_parts() {
    g   = explode;
    W   = outer_width;
    gap = split ? test_split_gap : 0;
    bw  = outer_length + gap;                       // base slice width
    th  = test_top_h;
    fh  = floor_z + test_floor_extra;
    row1 = W + g;
    row2 = 2 * (W + g);
    row3 = row2 + max(has_back ? bk_y1 - seat_y1 : 0,
                      has_left || make_left_box ? lf_y1 - lf_y0 : 0,
                      has_corner ? cn_size.y : 0,
                      make_back_box ? bk_y1 - bk_y0 : 0,
                      make_corner_box ? cn_y1 - cn_y0 : 0) + g;
    row4 = row3 + W + g;

    // Row 0: top of the base
    translate([0, 0, -(top_z - th)])
        base_box([-1, -1, top_z - th], [outer_length + 1, W + 1, top_z + 1], split);

    // Row 1: bottom of the base, a little way up into the cavity
    translate([0, row1, 0])
        base_box([-1, -1, -1], [outer_length + 1, W + 1, fh], split);

    // Row 2: tops of the extensions, upright as they print, lips overhanging
    x_bk = 0;
    x_lf = x_bk + (has_back ? bk_size.x + g : 0);
    x_cn = x_lf + (has_left ? seat_x0 - lf_x0 + g : 0);
    zt = ext_top_z - th;
    module top_slice() {
        intersection() {
            children();
            translate([-BIG / 2, -BIG / 2, zt]) cube([BIG, BIG, th + 1]);
        }
    }
    if (has_back)
        translate([x_bk - bk_x0, row2 - seat_y1, -zt]) top_slice() back_ext_part();
    if (has_left)
        translate([x_lf - lf_x0, row2 - lf_y0, -zt]) top_slice() left_ext_part();
    if (has_corner)
        translate([x_cn - cn_x0, row2 - cn_y0 + ext_dt_depth, -zt])
            top_slice() corner_part();
    // Freestanding boxes, after the extensions
    x_b0 = x_cn + (has_corner ? cn_size.x + g : 0);
    x_b1 = x_b0 + (make_back_box ? bk_x1 - bk_x0 + g : 0);
    x_b2 = x_b1 + (make_left_box ? lf_x1 - lf_x0 + g : 0);
    if (make_back_box)
        translate([x_b0 - bk_x0, row2 - bk_y0, -zt]) top_slice() back_box();
    if (make_left_box)
        translate([x_b1 - lf_x0, row2 - lf_y0, -zt]) top_slice() left_box();
    if (make_corner_box)
        translate([x_b2 - cn_x0, row2 - cn_y0, -zt]) top_slice() corner_box();
    // Two separate pegs, to try in the slices' lip holes and the base's peg holes
    x_b3 = x_b2 + (make_corner_box ? cn_x1 - cn_x0 + g : 0);
    if (ext_peg_style == "insert" && n_ext_pegs > 0)
        for (i = [0, 1]) translate([x_b3, row2 + i * (peg_d + 4), 0]) ext_peg_print();

    // Row 3: dovetail coupon, center slice, hinge block
    cy0 = keys[0] - 15;
    cy1 = (len(keys) > 1 ? keys[1] : keys[0]) + 15;
    cx0 = cut_x - test_coupon_w / 2;
    translate([-cx0, row3 - cy0, 0])
        base_box([cx0, cy0, -1], [cut_x + test_coupon_w / 2, cy1, floor_z], true);

    // Center slice: the floor (all three plates) plus full-height wall
    // stubs either side of the joint (all three dovetails, the seam, and
    // the inside profile)
    sx0 = cut_x - test_slice_w / 2;
    x_sl = test_coupon_w + test_split_gap + g;
    translate([x_sl - sx0, row3, 0])
        base_masked(true) union() {
            translate([sx0, -1, -1]) cube([test_slice_w, W + 2, floor_z + 1]);
            translate([cut_x - test_stub_w, -1, -1])
                cube([2 * test_stub_w, W + 2, outer_depth + 2]);
        }

    hx0 = hinge_x1 - test_hinge_w / 2;
    hy0 = seat_y1 - 15;
    x_hg = x_sl + test_slice_w + test_split_gap + g;
    if (has_hinges)
    translate([x_hg - hx0, row3 - hy0, 0])
        base_box([hx0, hy0, -1], [hinge_x1 + test_hinge_w / 2, W + 1, outer_depth + 1],
                 false);

    // Left end strip: handhold, rod notches and rod holes
    x_en = x_hg + test_hinge_w + g;
    translate([x_en, row3, 0])
        base_box([-1, -1, -1], [end_wall + 3, W + 1, max(nt_z1, handhold_height) + 6],
                 false);
    // Rod plugs, to try in the end strip's rod holes
    if (harness_rods && rod_plug_len > 0)
        translate([x_en + end_wall + 3 + g, row3 + 10, 0]) rod_plugs();

    // Outlet block: right end wall, compartment floor, curbs and insert hole
    if (has_outlet) {
        ob0 = [ol_x0 - ol_c - outlet_curb_w - 6, ol_yc - ol_L / 2 - ol_c - outlet_curb_w - 6,
               floor_z - 3];
        ob1 = [outer_length + 1, ol_yc + ol_L / 2 + ol_c + outlet_curb_w + 6,
               floor_z + ol_W + 6];
        x_ob = x_en + end_wall + 3 + g + 4 * (rod_hole_d + 5) + g;
        translate([x_ob - ob0.x, row3 - ob0.y, -ob0.z]) base_box(ob0, ob1, false);
        if (ol_cb > 0) translate([x_ob + ob1.x - ob0.x + g, row3 + 10, 0]) outlet_cap();
    }

    // Pass-through slice: the divider with its tunnel (and knock-out walls), and the cover
    if (has_passthrough) {
        p0 = [divider_x0 - 3, cord_hole_y - cord_hole_width / 2 - 6, floor_z - 3];
        p1 = [divider_x1 + 3, cord_hole_y + cord_hole_width / 2 + 6,
              floor_z + cord_hole_height + cord_hole_width / 2 + 5];
        x_pt = x_en + end_wall + 3 + g + 4 * (rod_hole_d + 5) + g + (has_outlet ? 110 : 0);
        translate([x_pt - p0.x, row3 - p0.y, -p0.z]) rotate([0, 0, 0])
            base_box(p0, p1, false);
        if (passthrough_cover)
            translate([x_pt + (p1.x - p0.x) + g + cord_hole_width / 2 + 3, row3, 0])
                passthrough_cover_part();
    }

    // Hinge coupon, above the plugs
    if (has_hinges) translate([x_en + end_wall + 3 + g, row3 + 30, 0]) hinge_coupon();

    // Turn button: a slice of the front rim with the pad and nut slot, and the button
    if (turn_button) {
        t0 = [tb_x - tb_Lt / 2 - turn_button_ease - 4, -turn_button_swell - 1, tb_nut_z - 8];
        t1 = [tb_x + tb_Lt / 2 + turn_button_ease + 4, mc_y0 + 4, tb_top + 1];
        x_tb = x_en + end_wall + 3 + g;
        y_tb = row3 + 30 + (hc_y1 - hc_y0) + 10;          // above the hinge coupon
        translate([x_tb - t0.x, y_tb - t0.y, -t0.z]) base_box(t0, t1, false);
        translate([x_tb + t1.x - t0.x + 10 + turn_button_w / 2, y_tb + turn_button_w / 2,
                   turn_button_t]) rotate([180, 0, 0])
            translate([-tb_x, -tb_y, -tb_top]) turn_button_part();
    }

    // Row 4: lids
    lids = [for (w = ["base", "back", "left", "corner"]) if (lid_on(w)) w];
    lx = [for (i = [0 : len(lids)])
             i == 0 ? 0
             : sum_x([for (j = [0 : i - 1]) lid_size(lids[j]).x + g])];
    for (i = [0 : 1 : len(lids) - 1])
        translate([lx[i], row4, 0]) lid_print(lids[i]);
}

function sum_x(v, i = 0) = i >= len(v) ? 0 : v[i] + sum_x(v, i + 1);

// ---------------------------------------------------------------------------
// Handholds and harness rods
// ---------------------------------------------------------------------------

// Teardrop hole along +Y from y0 for len, axis at (x, z), point up.
module teardrop_y(x, z, y0, len, d) {
    translate([x, y0, z]) rotate([-90, 0, 0])
        linear_extrude(height = len)
            union() {
                circle(d = d);
                // point up (local -Y after the rotation is world +Z)
                polygon([[-d / 2 * cos(45), -d / 2 * sin(45)],
                         [0, -d / 2 / cos(45)],
                         [d / 2 * cos(45), -d / 2 * sin(45)]]);
            }
}

// Rod-hole profile (2D): circle with a 45-degree point toward +Y.
module teardrop_2d(d) {
    union() {
        circle(d = d);
        polygon([[-d / 2 * cos(45), d / 2 * sin(45)], [0, d / 2 / cos(45)],
                 [d / 2 * cos(45), d / 2 * sin(45)]]);
    }
}

// One plug, printed on its outer face (Z = 0); point of the teardrop
// toward +Y, which goes up in the hole. Three crush ribs, and a chamfered
// leading end.
module rod_plug() {
    d  = rod_hole_d - 2 * rod_plug_clearance;
    r0 = rod_hole_d / 2 + rod_plug_rib;            // rib reach
    rr = 0.35;                                     // rib radius
    ch = 0.5;
    linear_extrude(height = rod_plug_len - ch)
        union() {
            teardrop_2d(d);
            for (a = [0, 180, 270])
                rotate(a) translate([r0 - rr, 0]) circle(r = rr, $fn = 16);
        }
    translate([0, 0, rod_plug_len - ch - 0.01])
        linear_extrude(height = ch + 0.01, scale = (d - 2 * ch) / d)
            teardrop_2d(d);
}

module rod_plugs() {
    sp = rod_hole_d + 5;
    for (i = [0 : n_rods - 1]) translate([i * sp, 0, 0]) rod_plug();
}

// Cuts in one end (side 0 = left, 1 = right), built for the left end and
// mirrored for the right.
module end_cuts(side) {
    module place() {
        if (side == 0) children();
        else if (side == 1) translate([outer_length, 0, 0]) mirror([1, 0, 0]) children();
        else intersection() {            // the base's own right end: keep out of the bay
            translate([base_x1, 0, 0]) mirror([1, 0, 0]) children();
            translate([-BIG / 2, -BIG / 2, -BIG / 2]) cube([BIG / 2 + base_x1, BIG, BIG]);
        }
    }
    place() {
        if (handholds) {
            h  = handhold_height;
            f  = handhold_lip_flat;
            d  = handhold_depth;
            r  = handhold_lip_round;
            zt = h + d - f;                     // ceiling height at the back
            intersection() {
                // Side profile (XZ): open face, flat lip underside, then a
                // ceiling climbing 45 degrees to the back of the pocket
                rotate([90, 0, 0]) translate([0, 0, -BIGY / 2])
                    linear_extrude(height = BIGY)
                        union() {
                            polygon([[-overlap, -overlap], [d, -overlap], [d, zt],
                                     [f, h], [-overlap, h]]);
                            // round the lip's outer edge
                            difference() {
                                translate([-overlap, h - overlap])
                                    square([r + overlap, r + overlap]);
                                translate([r, h + r]) circle(r = r);
                            }
                        }
                // End profile (YZ): 3" at the bottom narrowing at 45 degrees
                translate([-1, 0, 0]) rotate([90, 0, 90])
                    linear_extrude(height = d + 2)
                        polygon([[hh_y0, -overlap], [hh_y1, -overlap],
                                 [hh_y1 - zt - overlap, zt + overlap],
                                 [hh_y0 + zt + overlap, zt + overlap]]);
            }
        }
        if (harness_rods) {
            // Notches: open to the bottom and the face; the ceiling climbs
            // 45 degrees toward the face so it prints without support
            for (n = notch_ys)
                translate([0, n[1], 0]) rotate([90, 0, 0])
                    linear_extrude(height = n[1] - n[0])
                        polygon([[-overlap, -overlap], [nt_x1, -overlap],
                                 [nt_x1, nt_z1], [-overlap, nt_z1 + nt_x1 + overlap]]);
            for (r = rod_runs)
                teardrop_y(rod_x, rod_z, r[0] - overlap, r[1] - r[0] + 2 * overlap,
                           rod_hole_d);
        }
    }
}

// ---------------------------------------------------------------------------
// Organizer inserts: bobbin trays (a second stack goes in part corner_box)
// ---------------------------------------------------------------------------

module bobbin_insert(p) {
    if (p == "bobbin_assembly") {
        // Stack in the corner bay, the corner piece shown for context
        translate(bb_bay_c) bb_stack();
        %corner_part();
    } else if (p == "bobbin_trays") {
        translate([bb_tray.x / 2, bb_tray.y / 2, 0]) bb_bottom_tray();
        translate([1.5 * bb_tray.x + ins_spacing, bb_tray.y / 2, 0]) bb_upper_tray();
    } else if (p == "bobbin_bottom") {
        bb_bottom_tray();
    } else if (p == "bobbin_upper") {
        bb_upper_tray();
    } else if (p == "bobbin_test") {
        bb_test_cells();
    }
}

// The whole stack, from the bay floor
module bb_stack() {
    color("SteelBlue") bb_bottom_tray();
    for (k = [1 : 1 : bb_n - 1])
        translate([0, 0, k * bb_layer]) color("LightSteelBlue") bb_upper_tray();
}

// Floor plate, with lightening holes
module bb_tray_plate() {
    difference() {
        linear_extrude(height = bb_floor) rect(bb_tray, rounding = bb_corner_r);
        for (q = bb_lighten_xy)
            translate([q.x, q.y, -overlap])
                cylinder(h = bb_floor + 2 * overlap, d = bb_lighten_d);
    }
}

// Bobbin posts, each with a pin on its tip
module bb_post_grid() {
    for (q = bb_posts) translate([q.x, q.y, 0]) {
        translate([0, 0, bb_floor])
            cyl(h = bb_post_h, d = bb_post_d, chamfer2 = 0.4, anchor = BOTTOM);
        translate([0, 0, bb_floor + bb_post_h - overlap])
            cyl(h = bb_pin_h + overlap, d = bb_pin_d, chamfer2 = 0.5, anchor = BOTTOM);
    }
}

// Bottom tray: plate, posts, and the center column with its knob just under
// the lid; lifting the knob lifts the whole stack
module bb_bottom_tray() {
    bb_tray_plate();
    bb_post_grid();
    k0 = bb_column_top - bb_knob_h;
    translate([0, 0, bb_floor])
        cyl(h = k0 - bb_floor + overlap, d = bb_column_d,
            rounding1 = -bb_column_flare, anchor = BOTTOM);
    translate([0, 0, k0])
        cyl(h = bb_knob_h, d = bb_knob_d, chamfer1 = (bb_knob_d - bb_column_d) / 2,
            rounding2 = 2, anchor = BOTTOM);
}

// Upper tray: plate and posts, a center hole that clears the knob, and a
// socket under each post for the pin below; it rests on the post shoulders
module bb_upper_tray() {
    difference() {
        union() {
            bb_tray_plate();
            bb_post_grid();
        }
        translate([0, 0, -overlap]) cylinder(h = bb_floor + 2 * overlap, d = bb_hole_d);
        for (q = bb_posts) translate([q.x, q.y, -overlap]) {
            cylinder(h = bb_sock_h + overlap, d = bb_sock_d);
            cylinder(h = bb_socket_chamfer + overlap,
                     d1 = bb_sock_d + 2 * (bb_socket_chamfer + overlap), d2 = bb_sock_d);
        }
    }
}

// Test parts: one corner cell of each tray, to try a bobbin on the post and
// the pin in the socket. The upper piece stacks on the bottom piece.
module bb_test_cells() {
    q  = bb_posts[0];
    lo = [q.x - bb_pitch.x / 2 - 1, q.y - bb_pitch.y / 2 - 1, -1];
    sz = [bb_pitch.x + 2, bb_pitch.y + 2, bb_layer + bb_pin_h + 2];
    translate([-lo.x, -lo.y, 0])
        intersection() { bb_bottom_tray(); translate(lo) cube(sz); }
    translate([-lo.x + bb_pitch.x + ins_spacing, -lo.y, 0])
        intersection() { bb_upper_tray(); translate(lo) cube(sz); }
}

// ---------------------------------------------------------------------------
// Organizer inserts: notion trays and the spool tray
// ---------------------------------------------------------------------------

module notion_insert(p) {
    if (p == "notion_assembly") {
        // Stack in the bay, the extension shown for context
        ot_in_bay()
            for (i = [0 : len(ot_show) - 1])
                translate([0, 0, sum([for (j = [0 : i]) ot_show[j]]) - ot_show[i]])
                    color(i % 2 == 0 ? "SteelBlue" : "LightSteelBlue")
                        ot_tray(ot_show[i], ot_compartments);
        if (ot_bay == "back") %back_ext_part(); else %left_ext_part();
    } else if (p == "spool_assembly") {
        // Spool tray in the bay with spools and bobbins (display only)
        ot_in_bay() {
            color("SteelBlue") ot_spool_tray();
            for (q = ot_spools) translate([q.x, q.y, ot_floor]) {
                %difference() {
                    cylinder(h = ot_spool_h, d = ot_spool_d);
                    translate([0, 0, -overlap]) cylinder(h = ot_spool_h + 2 * overlap, d = ot_spool_bore);
                }
                color("Silver") translate([0, 0, ot_spool_h]) difference() {
                    cylinder(h = bobbin_t, d = bobbin_d);
                    translate([0, 0, -overlap]) cylinder(h = bobbin_t + 2 * overlap, d = 6.2);
                }
            }
        }
        if (ot_bay == "back") %back_ext_part(); else %left_ext_part();
    } else if (p == "notion_set") {
        hs = concat(ot_heights, [ot_custom_h]);
        for (i = [0 : len(hs) - 1])
            translate([0, i * (ot_wid + ins_spacing), 0]) ot_tray(hs[i], ot_compartments);
        translate([0, len(hs) * (ot_wid + ins_spacing), 0]) ot_spool_tray();
    } else if (p == "notion_30") {
        ot_tray(30, ot_compartments);
    } else if (p == "notion_25") {
        ot_tray(25, ot_compartments);
    } else if (p == "notion_20") {
        ot_tray(20, ot_compartments);
    } else if (p == "notion_15") {
        ot_tray(15, ot_compartments);
    } else if (p == "notion_10") {
        ot_tray(10, ot_compartments);
    } else if (p == "notion_custom") {
        ot_tray(ot_custom_h, ot_compartments);
    } else if (p == "spool_tray") {
        ot_spool_tray();
    } else if (p == "notion_test") {
        ot_test_corners();
    }
}

// Children placed in the bay: tray center at the bay center, on its floor,
// tray length along the bay's long side
module ot_in_bay() {
    translate([(ot_b0.x + ot_b1.x) / 2, (ot_b0.y + ot_b1.y) / 2, ot_b0.z])
        rotate(ot_along_y ? 90 : 0) children();
}

// One tray of height h: origin at its center, floor bottom at z = 0, length
// along X; with grid, divided into compartments. A square boss in each
// corner carries a pin on top and a socket underneath; a tray rests on the
// wall tops of the one below. A lip with a 45-degree underside at the
// middle of each end wall gives a finger hold.
module ot_tray(h, grid = false, gussets = true) {
    L = ot_len;
    W = ot_wid;
    w = ot_wall;
    r = ot_grip_reach > 0 ? ot_reach(h) : 0;
    if (grid) ot_dividers(h);
    if (ot_gussets && gussets)
        for (sy = [-1, 1]) ot_gusset_row(grid ? ot_g_cells : ot_g_plain, sy, h);
    difference() {
        union() {
            // Shell
            difference() {
                linear_extrude(height = h) rect([L, W], rounding = ot_corner_r);
                translate([0, 0, ot_floor])
                    linear_extrude(height = h)
                        rect([L - 2 * w, W - 2 * w], rounding = max(0.5, ot_corner_r - w));
            }
            // Corner bosses, with a rounded inner corner
            for (q = ot_pin_xy) {
                s = [sign(q.x), sign(q.y)];
                translate([q.x, q.y, 0])
                    linear_extrude(height = h)
                        intersection() {
                            square(ot_boss, center = true);
                            translate([s.x * ot_boss / 2, s.y * ot_boss / 2])
                                circle(r = ot_boss * 1.25);
                        }
            }
            // Pins
            for (q = ot_pin_xy)
                translate([q.x, q.y, h - overlap])
                    cyl(h = ot_pin_h + overlap, d = ot_pin_d, chamfer2 = 0.5, anchor = BOTTOM);
            // Finger-hold lips at the middle of each end wall
            if (r > 0)
                for (sx = [-1, 1])
                    translate([sx * (L / 2 - w), 0, 0])
                        mirror([sx > 0 ? 1 : 0, 0, 0])
                            ot_grip_lip(h, r);
        }
        // Sockets under the pins
        for (q = ot_pin_xy) translate([q.x, q.y, -overlap]) {
            cylinder(h = ot_sock_h + overlap, d = ot_sock_d);
            cylinder(h = ot_socket_chamfer + overlap,
                     d1 = ot_sock_d + 2 * (ot_socket_chamfer + overlap), d2 = ot_sock_d);
        }
    }
}

// Gussets along the long wall on side sy (+1 = +Y), at positions xs along
// it, for a tray of height h: triangles from the wall's foot, ot_gusset_d
// along the floor and up to ot_gusset_h up the wall
module ot_gusset_row(xs, sy, h) {
    gh = min(ot_gusset_h, 0.6 * (h - ot_floor));
    yi = sy * (ot_wid / 2 - ot_wall);
    for (x = xs)
        translate([x - ot_gusset_t / 2, yi, ot_floor - overlap])
            mirror([0, sy > 0 ? 1 : 0, 0])
                rotate([90, 0, 90]) linear_extrude(height = ot_gusset_t)
                    polygon([[-overlap, 0], [ot_gusset_d, 0], [-overlap, gh + overlap]]);
}

// Divider grid for a tray of height h, from the floor to ot_divider_frac of
// the tray height
module ot_dividers(h) {
    dh = ot_divider_frac * h - ot_floor + overlap;
    translate([0, 0, ot_floor - overlap]) {
        for (x = ot_div_pos(ot_ncols, ot_in.x, ot_cell_sz.x))
            translate([x - ot_divider_t / 2, -ot_in.y / 2 - overlap, 0])
                cube([ot_divider_t, ot_in.y + 2 * overlap, dh]);
        for (y = ot_div_pos(ot_nrows, ot_in.y, ot_cell_sz.y))
            translate([-ot_in.x / 2 - overlap, y - ot_divider_t / 2, 0])
                cube([ot_in.x + 2 * overlap, ot_divider_t, dh]);
    }
}

// Spool tray: a tray with a post for each spool, tapering from the base
// diameter at the floor to the top diameter at the spool top, then straight
// through the bobbin; the long sides cut down to a curb between the bosses
module ot_spool_tray() {
    H  = ot_spool_tray_h;
    x1 = ot_len / 2 - ot_boss;
    r  = min(ot_spool_cut_r, x1, (H - ot_spool_curb) / 2);
    if (ot_gussets)
        for (i = [0 : 1]) ot_gusset_row(ot_g_spool[i], i == 0 ? -1 : 1, H);
    difference() {
        ot_tray(H, false, false);
        if (ot_spool_open_sides)
            rotate([90, 0, 0])
                linear_extrude(height = ot_wid + 2, center = true)
                    hull() {
                        for (sx = [-1, 1])
                            translate([sx * (x1 - r), ot_spool_curb + r]) circle(r = r);
                        translate([-x1, ot_spool_curb + r]) square([2 * x1, H]);
                    }
    }
    for (q = ot_spools)
        translate([q.x, q.y, ot_floor - overlap]) {
            cylinder(h = ot_spool_h + overlap, d1 = ot_spool_post_base_d, d2 = ot_spool_post_d);
            translate([0, 0, ot_spool_h])
                cyl(h = ot_post_h - ot_spool_h + overlap, d = ot_spool_post_d,
                    chamfer2 = 0.6, anchor = BOTTOM);
        }
}

// Lip on the inside of the -X end wall (wall inner face at x = 0), reaching
// +X: flat top flush with the wall top, 45-degree underside
module ot_grip_lip(h, r) {
    t = ot_grip_t;
    translate([0, ot_grip_w / 2, 0]) rotate([90, 0, 0])
        linear_extrude(height = ot_grip_w)
            polygon([[-overlap, h - t - r - overlap], [0, h - t - r],
                     [r, h - t], [r, h], [-overlap, h]]);
}

// Test parts: one corner of two 10 mm trays, to try the pin in the socket.
// The second piece stacks on the first.
module ot_test_corners() {
    h  = 10;
    lo = [-ot_len / 2 - 1, -ot_wid / 2 - 1, -1];
    sz = [30, 30, h + ot_pin_h + 2];
    for (i = [0, 1])
        translate([-lo.x + i * (sz.x + ins_spacing), -lo.y, 0])
            intersection() { ot_tray(h); translate(lo) cube(sz); }
}

// ---------------------------------------------------------------------------
// Knee controller: geometry
// ---------------------------------------------------------------------------

// Involute spur gear outline, teeth centred at angles a0 + k * 360 / z.
// Teeth are thinned by bl at the pitch circle for backlash.
function kn_inv(a) = tan(a) - a * PI / 180;
module kn_gear2d(m, z, a0 = 0, bl = 0, pa = 20, add = 1) {
    r  = m * z / 2;
    rb = r * cos(pa);
    ra = r + add * m;
    rf = r - 1.25 * m;
    r0 = max(rb, rf);
    beta = (PI * m / 2 - bl) / (2 * r);                 // half tooth at the pitch circle, rad
    function hw(rr) = (beta + kn_inv(pa) - kn_inv(acos(min(1, rb / rr)))) * 180 / PI;
    n  = 6;
    rs = [for (i = [0 : n]) r0 + (ra - r0) * i / n];
    pts = [for (k = [0 : z - 1])
              let(c = a0 + k * 360 / z)
              each concat(
                  [[rf * cos(c - hw(r0)), rf * sin(c - hw(r0))]],
                  [for (q = rs) [q * cos(c - hw(q)), q * sin(c - hw(q))]],
                  [for (i = [n : -1 : 0]) let(q = rs[i]) [q * cos(c + hw(q)), q * sin(c + hw(q))]],
                  [[rf * cos(c + hw(r0)), rf * sin(c + hw(r0))],
                   [rf * cos(c + 180 / z), rf * sin(c + 180 / z)]])];
    polygon(pts);
}

// Pinion outline generated by rolling it against its gear (made slightly
// fat, for backlash, and long in the tooth, for root clearance): the
// conjugate profile, with the undercut a small pinion needs. The gear is
// children(), in its own frame, its centre at cd in direction cs from the
// pinion; the pinion turns ratio times as fast.
module kn_rolled2d(zp, ratio, cs, cd) {
    ra = kn_m * zp / 2 + kn_m;
    sp = cd * [cos(cs), sin(cs)];
    steps = 90;
    difference() {
        circle(r = ra, $fn = 4 * zp);
        for (i = [-steps : steps]) {
            ph = i * 180 / (steps * ratio);              // gear turn; the pinion's frame turns by ph * ratio
            rotate(ph * ratio) translate(sp) rotate(ph)
                intersection() {
                    children();
                    rotate(cs + 180 - ph) polygon([[0, 0], [1.5 * cd, -0.3 * cd], [1.5 * cd, 0.3 * cd]]);   // fixed on the line of centers
                }
        }
    }
}
// The gears as cutters: thickened by the backlash, teeth long by the root
// clearance
module kn_sector_cut() kn_gear2d(kn_m, kn_zs, knee_idler_angle, -knee_gear_backlash, 20, 1.25);
module kn_idler_cut()  kn_gear2d(kn_m, kn_z2, knee_pot_angle, -knee_gear_backlash, 20, 1.25);
module kn_idler_pinion2d() kn_rolled2d(kn_zp, knee_ratio, knee_idler_angle + 180, kn_cd) kn_sector_cut();
module kn_pot_pinion2d()   kn_rolled2d(kn_zp2, kn_ratio2, knee_pot_angle + 180, kn_cd2) kn_idler_cut();

// A fan from the centre out to r, from angle a0 to a1
module kn_fan(a0, a1, r)
    polygon(concat([[0, 0]], [for (i = [0 : 12]) let(a = a0 + (a1 - a0) * i / 12) r * [cos(a), sin(a)]]));

// Arc slot of width w at radius r from angle a0 to a1
module kn_arc_slot(r, a0, a1, w) {
    n = max(2, ceil(abs(a1 - a0) / 2));
    for (i = [0 : n - 1])
        hull() for (a = [a0 + (a1 - a0) * i / n, a0 + (a1 - a0) * (i + 1) / n])
            translate([r * cos(a), r * sin(a)]) circle(d = w, $fn = 24);
}

// Place a part built in its print frame (u, v across, w up) on an axis
// running front to back: (u, v) -> (X, Z) about it, w -> +Y from y (back)
// or -Y.
module kn_on_axis(x, y, z, back = true) {
    multmatrix(back ? [[1, 0, 0, x], [0, 0, 1, y], [0, 1, 0, z], [0, 0, 0, 1]]
                    : [[1, 0, 0, x], [0, 0, -1, y], [0, 1, 0, z], [0, 0, 0, 1]])
        children();
}

// The switch cam's radius at knee angle th: a dwell holding the lever down,
// then a ramp at about 45 degrees
function kn_cam_rad(th) =
    th <= kn_cam_a ? kn_cam_r
  : th >= kn_cam_b ? kn_cam_r - kn_cam_drop
  : kn_cam_r - kn_cam_drop * (th - kn_cam_a) / (kn_cam_b - kn_cam_a);
// The cam in the sector's frame: at knee angle th the lever, straight below
// the shaft, meets the cam where it was at -90 - kn_s * th at rest
module kn_cam2d() {
    n = 60;
    th0 = -3;
    th1 = kn_cam_b + 1.5;
    polygon(concat(
        [for (i = [0 : n]) let(th = th0 + (th1 - th0) * i / n, f = -90 - kn_s * th) kn_cam_rad(th) * [cos(f), sin(f)]],
        [for (i = [n : -1 : 0]) let(th = th0 + (th1 - th0) * i / n, f = -90 - kn_s * th) (kn_hub_r - 1) * [cos(f), sin(f)]]));
}

// Sector: hub, toothed sector and the switch cam, in its print frame
// (front face down). The hub and the cam stand up from it, toward the
// bulkhead. Set screw through a nut slot in the hub, pointing up.
module knee_sector_part() {
    t   = knee_gear_face;
    hb  = kn_hub_back;
    lug = kn_yf - 0.8 - kn_yaf;                         // cam, to just short of the bulkhead
    difference() {
        union() {
            linear_extrude(height = t) {
                intersection() {
                    kn_gear2d(kn_m, kn_zs, knee_idler_angle, knee_gear_backlash);
                    kn_fan(kn_sec_a0, kn_sec_a1, kn_rs + 2 * kn_m);
                }
                // web from the hub to the teeth
                intersection() {
                    circle(r = kn_rs - 1.25 * kn_m + 0.01, $fn = 120);
                    kn_fan(kn_sec_a0 + 1, kn_sec_a1 - 1, kn_rs + 2 * kn_m);
                }
                circle(r = kn_hub_r, $fn = 48);
            }
            // hub behind the sector
            cylinder(r = kn_hub_r, h = t + hb, $fn = 48);
            // the switch cam, below the shaft, reaching back to the lever
            linear_extrude(height = lug) kn_cam2d();
        }
        translate([0, 0, -1]) cylinder(d = knee_shaft_d + 0.15, h = t + hb + 2, $fn = 40);
        // set screw (M3) and its nut slot, from the top of the hub
        rotate(90) {
            translate([0, 0, (t + hb) / 2]) rotate([0, 90, 0]) cylinder(d = 3.4, h = kn_hub_r + 1, $fn = 20);
            translate([knee_shaft_d / 2 + 1.2, -3.1, (t + hb) / 2 - 2.9]) cube([2.6, 6.2, t + hb]);
        }
    }
}

// Idler: its gear (a sector) on a disc, and its pinion standing on the
// disc; in its print frame, the gear down (toward the bulkhead in place).
// It turns freely on its pin.
module knee_idler_part() {
    t = knee_gear_face;
    difference() {
        union() {
            linear_extrude(height = t) {
                intersection() {
                    kn_gear2d(kn_m, kn_z2, knee_pot_angle, knee_gear_backlash);
                    kn_fan(kn_ig_a0, kn_ig_a1, kn_r2 + 2 * kn_m);
                }
                intersection() {
                    circle(r = kn_r2 - 1.25 * kn_m + 0.01, $fn = 120);
                    kn_fan(kn_ig_a0 + 1, kn_ig_a1 - 1, kn_r2 + 2 * kn_m);
                }
                circle(r = kn_ig_disc, $fn = 48);
            }
            translate([0, 0, t - 0.01]) linear_extrude(height = t + 0.5 + 0.01) kn_idler_pinion2d();
        }
        translate([0, 0, -1]) cylinder(d = rod_d + 0.25, h = 2 * t + 3, $fn = 24);
    }
}

// Pot pinion with a split clamp hub, in its print frame (gear face down, hub up)
module knee_pinion_part() {
    t  = knee_gear_face + 1;                            // 1 mm proud of the idler gear's front face
    hl = max(4, kn_pin_hub);
    hr = 8.5;
    difference() {
        union() {
            linear_extrude(height = t) kn_pot_pinion2d();
            translate([0, 0, t]) cylinder(r = hr, h = hl, $fn = 48);
        }
        translate([0, 0, -1]) cylinder(d = knee_pot_shaft_d + 0.15, h = t + hl + 2, $fn = 40);
        // clamp: a slit through the hub, and an M3 screw across it
        translate([0, -0.6, t + 0.6]) cube([hr + 1, 1.2, hl]);
        translate([5, hr + 1, t + hl / 2 + 0.5]) rotate([90, 0, 0]) cylinder(d = 3.4, h = 2 * hr + 2, $fn = 20);
        hull() for (dz = [0, hl]) translate([5, -4, t + hl / 2 + 0.5 + dz]) rotate([90, 0, 0])
            cylinder(d = 6.4, h = 6, $fn = 6);                              // nut, dropped in from the top
        translate([5, hr + 2, t + hl / 2 + 0.5]) rotate([90, 0, 0])
            cylinder(d = 6, h = hr + 2 - 4, $fn = 32);                      // head
    }
}

// The crank, seen from the front, about the shaft: from the hub out to the
// pin, away from the push, flat-bottomed where it runs in the housing
module kn_crank2d() mirror([kn_s > 0 ? 0 : 1, 0, 0]) {
    xt = kn_s * (kn_hs - kn_sx) + 2;                    // flat bottom to 2 mm past the housing's side
    offset(r = 1) offset(delta = -1)
        polygon([[-kn_cr - 4, -kn_arm_bot], [xt, -kn_arm_bot], [-10, -12], [-10, 12], [-kn_cr - 4, kn_arm_top]]);
    circle(r = 13, $fn = 64);
}

// Knee hub, outside the front face: the crank, and a boss with the bar's
// square socket. In its print frame (back face down). The bar's torque goes
// from the socket through the crank to the spring and the stops; the set
// screw only turns the shaft for the sector.
module knee_hub_part() {
    bl = kn_hub_boss[1];
    sq = knee_bar_square + 2 * knee_bar_clearance;
    sd = kn_hub_y0 - kn_shaft_front;                    // shaft depth into the hub
    difference() {
        union() {
            linear_extrude(height = kn_ct) kn_crank2d();
            cylinder(r = kn_hub_boss[0], h = kn_ct + bl, $fn = 64);
        }
        // crank pin, standing 1 mm proud of the crank's bottom edge
        translate([-kn_s * kn_cr, 0, -1]) cylinder(d = rod_d - 0.1, h = kn_ct + 2, $fn = 24);
        // shaft bore and set screw (M3) with a nut slot, toward the push
        translate([0, 0, -1]) cylinder(d = knee_shaft_d + 0.15, h = sd + 1, $fn = 40);
        rotate(kn_s > 0 ? 0 : 180) {
            translate([0, 0, sd - 3]) rotate([0, 90, 0]) cylinder(d = 3.4, h = 14, $fn = 20);
            translate([knee_shaft_d / 2 + 1.5, -3.1, sd - 3 - 2.9]) cube([2.6, 6.2, 10]);
        }
        // bar socket
        translate([-sq / 2, -sq / 2, sd + 1]) cube([sq, sq, bl + kn_ct]);
        translate([0, 0, kn_ct + bl - 1]) rotate(45)
            cylinder(d1 = sq * sqrt(2), d2 = (sq + 2) * sqrt(2), h = 1.01, $fn = 4);
    }
}

// Spring housing, as it sits on the front face: a block with the spring's
// bore, a slot in its side for the crank, the stop screw's captive nut in
// the floor and the rest screw's in the roof, screw ears on the shaft side,
// and a tongue on its back that sits in a pocket in the face.
module knee_spring_housing_raw() {
    x0 = kn_hx - kn_rb - kn_hw;
    x1 = kn_hx + kn_rb + kn_hw;
    sz0 = kn_sz - kn_stroke - kn_arm_bot - 1.5;         // slot's bottom: the crank's lowest, less a margin
    id = knee_spring[0] - 2 * knee_spring[1];
    difference() {
        union() {
            difference() {
                union() {
                    translate([x0, kn_hy0, kn_h_fb]) cube([x1 - x0, kn_tg - kn_hy0, kn_h_rt - kn_h_fb]);
                    for (z = kn_ear_z)
                        translate([kn_s > 0 ? kn_hs - 0.01 : kn_hs - kn_ear[0] + 0.01, -kn_ear[1], z - kn_ear[2] / 2])
                            cube([kn_ear[0], kn_ear[1], kn_ear[2]]);
                }
                translate([kn_hx, kn_hyc, kn_h_ft]) cylinder(r = kn_rb, h = kn_h_rb - kn_h_ft, $fn = 64);
                // slot for the crank, through the side toward the shaft
                translate([kn_s > 0 ? kn_hx : x0 - 1, kn_cy0 - 0.5, sz0])
                    cube([kn_rb + kn_hw + 1, kn_ct + 1, kn_h_rb - sz0 + 0.01]);
                // opening at the front, for the crank going in (raised by
                // kn_lift, over the cap at the spring's free length) when the
                // hub goes onto the shaft
                translate([kn_s > 0 ? kn_sx - kn_cr - 4.5 : x0 - 1, kn_hy0 - 1, kn_sz + kn_lift - kn_pin_r - 0.5])
                    cube([kn_rb + kn_hw + 1 + (kn_s > 0 ? kn_hx - (kn_sx - kn_cr - 4.5) : (kn_sx + kn_cr + 4.5) - kn_hx),
                          kn_cy0 - 0.5 - kn_hy0 + 1 + 0.01, kn_h_rb - (kn_sz + kn_lift - kn_pin_r - 0.5) + 0.01]);
            }
            // spigot centring the spring on the floor
            translate([kn_hx, kn_hyc, kn_h_ft - 0.01]) cylinder(d = id - 0.6, h = 2, $fn = 48);
        }
        // stop screw (M4) up through the floor, its nut captive from below
        translate([kn_hx, kn_hyc, kn_h_fb - 1]) cylinder(d = 4.5, h = kn_h_ft - kn_h_fb + 4, $fn = 24);
        translate([kn_hx, kn_hyc, kn_h_fb - 0.01]) cylinder(d = 8.1, h = 3.6, $fn = 6);
        // rest screw (M4) down through the roof onto the crank, over the pin; nut captive from above
        translate([kn_sx - kn_s * kn_cr, kn_hyc, kn_h_rb - 1]) cylinder(d = 4.5, h = kn_h_rt - kn_h_rb + 2, $fn = 24);
        translate([kn_sx - kn_s * kn_cr, kn_hyc, kn_h_rt - 3.6]) cylinder(d = 8.1, h = 3.61, $fn = 6);
        // ear screws (M3) into heat-set inserts in the face
        for (z = kn_ear_z)
            translate([kn_ear_x, 1, z]) rotate([90, 0, 0]) cylinder(d = 3.4, h = kn_ear[1] + 2, $fn = 20);
    }
}
// In its print frame: standing on its floor
module knee_spring_housing_part()
    translate([-(kn_s > 0 ? kn_hx - kn_rb - kn_hw : kn_hs - kn_ear[0]), -kn_hy0, -kn_h_fb]) knee_spring_housing_raw();

// Spring cap: a disc sliding in the bore under the crank pin, with a
// spigot into the spring and a hole for the stop screw; printed top down
module knee_spring_cap_part() {
    id = knee_spring[0] - 2 * knee_spring[1];
    difference() {
        union() {
            cylinder(d = 2 * kn_rb - 0.6, h = kn_cap_t, $fn = 64);
            cylinder(d = id - 0.6, h = kn_cap_t + 2.5, $fn = 48);
        }
        translate([0, 0, -1]) cylinder(d = 5.2, h = kn_cap_t + 4.5, $fn = 24);
    }
}

// Board cover: a box over the board, open below, with screw ears on its
// right side and wire notches; printed top down.
module knee_cover_part() mirror([0, 0, 1]) translate([0, 0, -kn_cv_h]) knee_cover_raw();
// The cover as it sits in the bay, origin at its front left corner on the floor
module knee_cover_raw() {
    L = kn_cv1 - kn_cv0;
    h = kn_cv_h;
    eh = h - kn_cv_bh;                                  // ears stand on the floor bosses
    difference() {
        union() {
            cube([L.x, L.y, h]);
            for (y = kn_cv_ys)
                translate([L.x - 0.01, y - kn_cv0.y - kn_cv_ear / 2, kn_cv_bh])
                    cube([kn_cv_ear, kn_cv_ear, eh]);
        }
        translate([kn_cw, kn_cw, -1]) cube([L.x - 2 * kn_cw, L.y - 2 * kn_cw, h - kn_cw + 1]);
        for (y = kn_cv_ys)
            translate([L.x + kn_cv_ear / 2, y - kn_cv0.y, -1]) cylinder(d = 3.4, h = h + 2, $fn = 20);
        // wire notches: front end by the divider (pot, switch and motor
        // leads), right side by the spade tabs (power leads)
        translate([kn_cw + 1, -1, -1]) cube([14, kn_cw + 2, 10]);
        translate([L.x - kn_cw - 1, kn_cv_notch[0] - kn_cv0.y, -1])
            cube([kn_cw + 2, kn_cv_notch[1] - kn_cv_notch[0], 12]);
        if (knee_power == "bare")
            translate([L.x - kn_cw - 1, kn_cord_y - kn_cv0.y - 6, -1]) cube([kn_cw + 2, 12, knee_cord[1] + kn_saddle + 3]);
        // vent slots over the board, for motors over 1 A
        if (kn_vent)
            for (i = [0 : 5])
                translate([kn_bx0 - kn_cv0.x + 4, kn_by0 - kn_cv0.y + 8 + i * 10, h - kn_cw - 1])
                    cube([knee_board[1] - 8, 3, kn_cw + 2]);
    }
}

// Cord clamp bar, with a ridge under the cord; in its print frame (flat top down)
module knee_cord_clamp_part() {
    l = 2 * kn_clamp_dy + 8;
    difference() {
        union() {
            translate([-4, -l / 2, 0]) cube([8, l, 4]);
            translate([0, 0, 4]) rotate([90, 0, 0])
                linear_extrude(height = knee_cord[0] + 2, center = true)
                    polygon([[-2, 0], [2, 0], [0, 0.8]]);
        }
        for (s = [-1, 1]) translate([0, s * kn_clamp_dy, -1]) cylinder(d = 3.4, h = 8, $fn = 20);
    }
}

// Solids added to the base: bulkhead, board posts, floor bosses, cord saddle,
// spring post
module knee_base_add() {
    // Bulkhead across the bay, with the rear bushing's boss, the idler pin's
    // boss, the pot's hole and lug hole, and the switch's adjusting slots
    difference() {
        union() {
            translate([st_x0 - overlap, kn_yf, kn_z0 - overlap])
                cube([st_x1 - st_x0 + 2 * overlap, knee_bulkhead_t, kn_bz1 - kn_z0 + overlap]);
            translate([kn_sx, kn_yf, kn_sz]) rotate([-90, 0, 0])
                cylinder(r = kn_boss_r, h = knee_bushing[2], $fn = 48);
            translate([kn_ix, kn_ypb + 0.5, kn_iz]) rotate([-90, 0, 0])
                cylinder(r = kn_ib_r, h = kn_yf - kn_ypb - 0.5 + overlap, $fn = 32);
        }
        translate([kn_sx, kn_yf - 1, kn_sz]) rotate([-90, 0, 0])
            cylinder(d = knee_bushing_hole, h = knee_bushing[2] + 2, $fn = 48);
        translate([kn_ix, kn_ypb, kn_iz]) rotate([-90, 0, 0])
            cylinder(d = rod_d - 0.1, h = kn_yb - kn_ypb + 1, $fn = 24);
        translate([kn_px, kn_yf - 1, kn_pz]) rotate([-90, 0, 0])
            cylinder(d = knee_pot_hole, h = knee_bulkhead_t + 2, $fn = 40);
        translate([kn_px + knee_pot_lug_r * cos(knee_pot_lug_angle), kn_yf - 1,
                   kn_pz + knee_pot_lug_r * sin(knee_pot_lug_angle)]) rotate([-90, 0, 0])
            cylinder(d = knee_pot_lug_hole, h = knee_bulkhead_t + 2, $fn = 16);
        for (x = kn_sw_hx)
            hull() for (dz = [-knee_switch_adjust, knee_switch_adjust])
                translate([x, kn_yf - 1, kn_sw_hz + dz]) rotate([-90, 0, 0])
                    cylinder(d = knee_switch_screw, h = knee_bulkhead_t + 2, $fn = 16);
    }
    // Board posts: screw boss (M3 heat-set), alignment peg, rest post
    translate([kn_screw.x, kn_screw.y, kn_z0 - overlap]) difference() {
        cylinder(d = 9, h = knee_board_h + overlap, $fn = 40);
        translate([0, 0, 2]) cylinder(d = knee_insert_d, h = knee_board_h + 1, $fn = 30);
    }
    translate([kn_peg.x, kn_peg.y, kn_z0 - overlap]) {
        cylinder(d = 4, h = knee_board_h + overlap, $fn = 24);
        cylinder(d = 2, h = knee_board_h + overlap + 3, $fn = 16);
        translate([0, 0, knee_board_h + overlap + 3]) cylinder(d1 = 2, d2 = 0.8, h = 1, $fn = 16);
    }
    translate([kn_rest.x, kn_rest.y, kn_z0 - overlap])
        cylinder(d = 4, h = knee_board_h + overlap, $fn = 24);
    // Floor bosses for the cover's ears and the cord clamp (M3 heat-set)
    for (p = concat([for (y = kn_cv_ys) [kn_cv1.x + kn_cv_ear / 2, y, kn_cv_bh]],
                    knee_power == "bare"
                        ? [for (s = [-1, 1]) [kn_clamp_x, kn_cord_y + s * kn_clamp_dy, kn_clamp_bh]] : []))
        translate([p.x, p.y, kn_z0 - overlap]) difference() {
            cylinder(d = 8, h = p.z + overlap, $fn = 32);
            translate([0, 0, overlap + p.z - 6]) cylinder(d = knee_insert_d, h = 7, $fn = 30);
        }
    // Cord saddle, ridged, from the end wall in past the clamp
    if (knee_power == "bare")
    translate([kn_clamp_x - 8, kn_cord_y - knee_cord[0] / 2 - 1, kn_z0 - overlap]) {
        cube([st_x1 - kn_clamp_x + 8 + overlap, knee_cord[0] + 2, kn_saddle + overlap]);
        for (dx = [3, 8, 13]) translate([dx, 0, kn_saddle + overlap]) rotate([-90, 0, 0])
            linear_extrude(height = knee_cord[0] + 2) polygon([[-1.2, 0], [1.2, 0], [0, -1]]);
    }
    // Earth post behind the shaft's end: an M3 insert in its front face, 6 mm
    // above the shaft, for a spring strip that bears on the shaft's end
    if (knee_power == "iec" && knee_earth)
        translate([kn_sx - 5, kn_ep_y, kn_z0 - overlap]) difference() {
            cube([10, 7, kn_sz + 10 - kn_z0 + overlap]);
            translate([5, -1, kn_sz + 6 - kn_z0 + overlap]) rotate([-90, 0, 0])
                cylinder(d = knee_insert_d, h = 7, $fn = 30);
        }
    // Junction under the bed: a cradle for the Wago connectors on the cavity
    // floor beside the pass-through, wire entries toward the cavity
    if (knee_power == "iec")
        translate([kn_wg_x0, kn_wg_y0, floor_z - overlap]) difference() {
            cube([kn_wg_w, kn_wg_d, 6 + overlap]);
            for (i = [0 : knee_wago_n - 1])
                translate([1.6 + i * (kn_wg.x + 1.6), kn_wg_back ? -1 : 1.6, 1 + overlap])
                    cube([kn_wg.x, kn_wg.y + 1, 7]);
        }
}

// The cordset entry's pocket and hole, and the IEC inlet's pocket and
// cutout, cut into the right end wall
module knee_power_cuts() {
    if (knee_power == "cordset") {
        // pocket from inside, leaving the thin wall; the clip drops in from above
        translate([st_x1 - overlap, kn_ent_y - kn_pk_w / 2, kn_pk_z[0]])
            cube([kn_ent_x - st_x1 + overlap, kn_pk_w, kn_pk_z[1] - kn_pk_z[0]]);
        // the hole
        translate([kn_ent_x - 1, kn_ent_y - knee_entry_hole[0] / 2, kn_ent_z - knee_entry_hole[1] / 2])
            cube([knee_entry_wall + 2, knee_entry_hole[0], knee_entry_hole[1]]);
        // dimple for the clip's bump, at the top of the hole, from the inside
        translate([kn_ent_x - 1, kn_ent_y - knee_entry_dimple[0] / 2, kn_ent_z + knee_entry_hole[1] / 2 - 0.5])
            cube([knee_entry_dimple[2] + 1, knee_entry_dimple[0], knee_entry_dimple[1] + 0.5]);
    }
    if (knee_power == "iec") {
        px = outer_length - knee_iec_panel;
        translate([st_x1 - overlap, kn_ent_y - kn_iec_pk[0] / 2, kn_iec_z - kn_iec_pk[1] / 2])
            cube([px - st_x1 + overlap, kn_iec_pk[0], kn_iec_pk[1]]);
        translate([px - 1, kn_ent_y, kn_iec_z]) rotate([0, 90, 0])
            linear_extrude(height = knee_iec_panel + 2)
                offset(r = knee_iec_radius) offset(delta = -knee_iec_radius)
                    square([knee_iec_cutout[1], knee_iec_cutout[0]], center = true);
    }
}

// Test part: the cordset entry's thin wall with its hole and dimple, and
// the pocket's side walls that guide the clip; printed outside face down
module knee_entry_test_part() {
    W = kn_pk_w + 8;
    H = kn_pk_z[1] - kn_pk_z[0] + 4;
    D = knee_entry_wall + 8;
    zc = kn_ent_z - kn_pk_z[0] + 2;                     // hole centre above the part's bottom
    difference() {
        cube([W, H, D]);
        // pocket (open at the back and the top)
        translate([4, 2, knee_entry_wall]) cube([kn_pk_w, H, D]);
        translate([W / 2 - knee_entry_hole[0] / 2, zc - knee_entry_hole[1] / 2, -1])
            cube([knee_entry_hole[0], knee_entry_hole[1], knee_entry_wall + 2]);
        translate([W / 2 - knee_entry_dimple[0] / 2, zc + knee_entry_hole[1] / 2 - 0.5,
                   knee_entry_wall - knee_entry_dimple[2]])
            cube([knee_entry_dimple[0], knee_entry_dimple[1] + 0.5, knee_entry_dimple[2] + 1]);
    }
}

// Holes cut into the base: front-wall bushing, the spring housing's pocket
// and insert holes, mains cord
module knee_base_cuts() {
    translate([kn_sx, -1, kn_sz]) rotate([-90, 0, 0])
        cylinder(d = knee_bushing_hole, h = st_y0 + 2, $fn = 48);
    translate([kn_hx - kn_rb - kn_hw - 0.3, -1, kn_h_fb - 0.3])
        cube([2 * (kn_rb + kn_hw) + 0.6, kn_tg + 1.3, kn_h_rt - kn_h_fb + 0.6]);
    for (z = kn_ear_z)
        translate([kn_ear_x, -1, z]) rotate([-90, 0, 0]) cylinder(d = knee_insert_d, h = 8, $fn = 30);
    knee_power_cuts();
    // bare cord: a rounded slot through the end wall
    if (knee_power == "bare")
    translate([st_x1 - 1, kn_cord_y, kn_cord_z]) rotate([0, 90, 0])
        linear_extrude(height = outer_length - st_x1 + 2)
            hull() for (s = [-1, 1])
                translate([0, s * (knee_cord[0] - knee_cord[1]) / 2])
                    circle(d = knee_cord[1] + 0.8, $fn = 24);
}

// Parts in place, for the assembly views; hardware as stand-ins
module knee_in_place(th = 0) {
    a = kn_s * th;
    ac = (kn_s > 0 ? 180 : 0) + a;                      // crank's direction
    pin = [kn_sx + kn_cr * cos(ac), kn_sz + kn_cr * sin(ac)];
    color("DarkSlateGray") {
        kn_on_axis(kn_sx, kn_yaf, kn_sz, true) rotate(a) knee_sector_part();
        kn_on_axis(kn_ix, kn_ypb, kn_iz, false) rotate(-a * knee_ratio) knee_idler_part();
        kn_on_axis(kn_px, kn_ypb, kn_pz, false) rotate(a * kn_rt) knee_pinion_part();
        kn_on_axis(kn_sx, kn_hub_y0, kn_sz, false) rotate(a) knee_hub_part();
        knee_spring_housing_raw();
        translate([kn_hx, kn_hyc, pin.y - kn_pin_r]) mirror([0, 0, 1]) knee_spring_cap_part();
        translate([kn_cv0.x, kn_cv0.y, kn_z0]) knee_cover_raw();
        if (knee_power == "bare")
            translate([kn_clamp_x, kn_cord_y, kn_z0 + kn_clamp_bh + 4]) mirror([0, 0, 1]) knee_cord_clamp_part();
    }
    // hardware
    color("Silver") {
        translate([kn_sx, kn_shaft_front, kn_sz]) rotate([-90, 0, 0])
            cylinder(d = knee_shaft_d, h = kn_shaft_len, $fn = 32);
        translate([pin.x, kn_hyc - 7, pin.y]) rotate([-90, 0, 0]) cylinder(d = rod_d, h = 14, $fn = 24);
        translate([kn_ix, kn_ip_y0, kn_iz]) rotate([-90, 0, 0]) cylinder(d = rod_d, h = kn_ip_len, $fn = 24);
        // spring, cut away at the front
        sb = pin.y - kn_pin_r - kn_cap_t;
        translate([kn_hx, kn_hyc, kn_h_ft]) difference() {
            cylinder(d = knee_spring[0], h = sb - kn_h_ft, $fn = 32);
            translate([0, 0, -1]) cylinder(d = knee_spring[0] - 2 * knee_spring[1], h = sb, $fn = 32);
            translate([-knee_spring[0], -knee_spring[0], -1]) cube([2 * knee_spring[0], knee_spring[0], sb]);
        }
        // stop and rest screws
        translate([kn_hx, kn_hyc, kn_h_fb - 4]) cylinder(d = 4, h = kn_sz - kn_stroke - kn_pin_r - kn_h_fb + 4, $fn = 16);
        translate([kn_sx - kn_s * kn_cr, kn_hyc, kn_sz + kn_arm_top]) cylinder(d = 4, h = kn_h_rt - kn_sz - kn_arm_top + 4, $fn = 16);
    }
    color("Goldenrod") for (y = [0, kn_yf]) {
        translate([kn_sx, y, kn_sz]) rotate([-90, 0, 0]) difference() {
            union() {
                cylinder(d = knee_bushing[1], h = knee_bushing[2], $fn = 32);
                translate([0, 0, -knee_bushing_flange[1]]) cylinder(d = knee_bushing_flange[0], h = knee_bushing_flange[1], $fn = 32);
            }
            translate([0, 0, -5]) cylinder(d = knee_bushing[0], h = 30, $fn = 24);
        }
    }
    color("DimGray") {
        // pot body behind the bulkhead, its bushing and shaft through it
        translate([kn_px, kn_yb + 15.3 / 2, kn_pz]) cube([knee_pot_body, 15.3, knee_pot_body], center = true);
        translate([kn_px, kn_yb, kn_pz]) rotate([90, 0, 0]) cylinder(d = 9.5, h = knee_pot_bushing_len, $fn = 24);
        translate([kn_px, kn_yb, kn_pz]) rotate([90, 0, 0]) cylinder(d = knee_pot_shaft_d, h = knee_pot_shaft_len, $fn = 24);
        // switch body against the bulkhead, lying under the shaft
        translate([kn_sw_x0, kn_yf - kn_sw[2], kn_sw_z0]) cube([kn_sw[0], kn_sw[2], kn_sw[1]]);
    }
    color("DarkGreen") translate([kn_bx0, kn_by0, kn_z0 + knee_board_h]) cube([knee_board[1], knee_board[0], 1.6]);
    color("DimGray") {
        if (knee_power == "iec")
            translate([outer_length - knee_iec_panel - knee_iec_depth, kn_ent_y - knee_iec_cutout[0] / 2,
                       kn_iec_z - knee_iec_cutout[1] / 2])
                cube([knee_iec_depth, knee_iec_cutout[0], knee_iec_cutout[1]]);
        if (knee_power == "cordset")
            translate([kn_ent_x - 3.6, kn_ent_y - 13.3 / 2, kn_ent_z - 8.5 / 2]) cube([outer_length - kn_ent_x + 3.6 + 8, 13.3, 8.5]);
        if (knee_power == "iec")
            for (i = [0 : knee_wago_n - 1])
                translate([kn_wg_x0 + 1.6 + i * (kn_wg.x + 1.6) + 0.15, kn_wg_y0 + (kn_wg_back ? 0 : 1.6) + 0.15, floor_z + 1])
                    cube([knee_wago[0], knee_wago[1], knee_wago[2]]);
    }
}
