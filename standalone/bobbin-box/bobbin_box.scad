// SPDX-License-Identifier: MIT
// Bobbin box: a stack of bobbin trays in a lidded box, v2
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// Holds class 15 / class 66 bobbins (or any round bobbin, set below) on
// posts, eight to a tray in a 3 x 3 grid with the center left for the
// handle. The bottom tray carries a center column with a knob just under
// the lid; lifting it lifts the whole stack, and every bobbin on every
// tray can be seen from the side. The upper trays are all alike: each has
// a center hole that clears the knob, rests on the shoulders of the posts
// below, and has sockets in its underside that take the pins on the post
// tips, so the stack stays registered when lifted.
//
// The lid sits flush in a rabbet. A tab on its front edge reaches over a
// notch in the front wall, with a thumb scoop below it, so the lid can be
// caught and lifted without a finger hole. The hinged lid pivots on two
// snap-in dimple hinges at the back; the back ledge is widened so the open
// lid stays clear of the opening. The lift-out lid is a plain plate.
//
// Everything is sized from the bobbin and the number of trays. Print the
// box upright, the lid top face down, and the trays floor down, all
// without supports: one bottom tray and (trays - 1) upper trays.
//
// The hinge, lid fit and thumb tab can be tuned in their own sections; the
// hinge_test part prints just the back of the box and a strip of the lid,
// to try the hinge before committing to a full print.
//
// v2: hinge, lid-fit and thumb-tab settings exposed; hinge_test part.
//
// Needs BOSL2 (https://github.com/BelfrySCAD/BOSL2).

include <BOSL2/std.scad>

/* [Part] */
// What to render
part = "assembly"; // [assembly, all, box, lid, bottom_tray, upper_tray, test, hinge_test]

/* [Size] */
// Number of trays, bottom included (each holds 8 bobbins)
trays = 5;
// Lid type
lid_type = "hinged"; // [hinged, lift-out]

/* [Bobbin] */
// Bobbin diameter (class 15 and 66: 13/16")
bobbin_d = 20.6375;
// Bobbin thickness (class 15 and 66: 7/16")
bobbin_t = 11.1125;
// Post diameter (must pass the bobbin bore; class 15 and 66 bores are a little over 6 mm)
post_d = 5;
// Space between neighboring bobbins, for fingers
bobbin_gap = 6.9;

/* [Walls] */
// Side wall thickness (front and ends; the back is thicker on the hinged box)
wall = 5.5;
// Lid thickness
lid_t = 4;

/* [Lid fit] */
// Lid clearance in its rabbet, per side (also the gap at the hinge ends)
lid_clear = 0.3;
// Ledge the lid rests on, inside the lip
ledge = 2.5;

/* [Hinge] */
// Bump diameter at its base
bump_d = 3;
// How far each bump reaches into its recess in the end wall
bump_engage = 0.8;
// Recess diameter beyond the bump's (looser recess: easier to snap in, less firm)
recess_extra_d = 0.3;
// Recess depth beyond the bump's reach
recess_extra_depth = 0.6;
// Flex tab carrying each bump: length (longer: softer snap)
flex_len = 15;
// Flex tab width (narrower: softer snap)
flex_w = 2.5;
// Slot freeing each flex tab
flex_slot = 1;
// Lean-back stop: chamfer the back rabbet wall so the open lid rests at about 135 degrees
open_stop = true;
// Extra clearance in the lean-back chamfer
open_stop_extra = 0.3;
// Open lid's clearance past the back ledge (sets the back ledge width)
hinge_margin = 0.5;
// Hinge test: depth of the box slice and the lid strip, from the back
hinge_test_depth = 25;
// Hinge test: height of the box slice below the lid
hinge_test_height = 10;

/* [Thumb tab] */
// Tab width
tab_w = 25;
// Tab overhang past the front face
tab_over = 1.5;
// Tab corner radius
tab_r = 2;
// Thumb scoop depth into the front face
scoop_d = 2.5;
// Thumb scoop height below the lid
scoop_h = 6;

/* [Hidden] */
// Box
box_floor   = 3;       // box floor
box_round   = 2;       // rounding of the box's top and vertical edges
// Trays
tray_floor  = 3;       // tray floor thickness
bobbin_clear = 1;      // bobbin top to the tray above
wall_clear  = 0.75;    // trays to the box walls, per side
tray_round  = 2;       // tray corner radius
lighten_d   = 12;      // lightening holes where four cells meet
// Pins and sockets
pin_d       = 3;
pin_h       = 2;
socket_clear = 0.2;    // per side
socket_extra = 0.4;    // socket depth beyond the pin
socket_chamfer = 0.6;  // chamfer at the socket mouth
// Handle
column_d    = 12;
column_flare = 2;
knob_d      = 18;
knob_h      = 8;
knob_rise   = 4.5;     // knob top above the top tray's post shoulders
hole_clear  = 0.5;     // knob to the upper trays' center holes, per side
top_clear   = 1;       // knob top to the lid's underside
// Layout
spacing     = 10;
printer_size = [256, 256, 256];
overlap     = 0.5;
$fa = 2;
$fs = 0.4;

// ---------------------------------------------------------------------------
// Derived dimensions
// ---------------------------------------------------------------------------

hinged = lid_type == "hinged";
c      = lid_clear;

// Trays
pitch    = bobbin_d + bobbin_gap;
tray     = 3 * pitch;
post_h   = bobbin_t + bobbin_clear;            // shoulder above the tray floor
layer    = tray_floor + post_h;                 // tray-to-tray pitch
hole_d   = knob_d + 2 * hole_clear;
sock_d   = pin_d + 2 * socket_clear;
sock_h   = pin_h + socket_extra;
posts    = [for (i = [-1 : 1], j = [-1 : 1]) if (i != 0 || j != 0) [i * pitch, j * pitch]];
lighten_xy = [for (i = [-0.5, 0.5], j = [-0.5, 0.5]) [i * pitch, j * pitch]];
column_top = trays * layer + knob_rise;        // above the bay floor

// Box (origin at the outer front-left-bottom corner; hinge at the back)
lip      = wall - ledge;
ledge_bk = hinged ? max(ledge, c + lid_t + hinge_margin) : ledge;
bay      = [tray + 2 * wall_clear, tray + 2 * wall_clear, column_top + top_clear];
bay_x0   = lip + ledge;
bay_y0   = lip + ledge;
rx0 = lip;
ry0 = lip;
rx1 = bay_x0 + bay.x + ledge;
ry1 = bay_y0 + bay.y + ledge_bk;
outer    = [rx1 + lip, ry1 + lip, box_floor + bay.z + lid_t];
top      = outer.z;
z0       = top - lid_t;                         // lid underside, rabbet floor
bay_c    = [bay_x0 + bay.x / 2, bay_y0 + bay.y / 2, box_floor];
cx       = outer.x / 2;
notch_w  = tab_w + 2 * c;

function fits(sz) = sz.x <= printer_size.x && sz.y <= printer_size.y
                    && sz.z <= printer_size.z;

// ---------------------------------------------------------------------------
// Report
// ---------------------------------------------------------------------------

echo("=== Bobbin box ===");
echo(str("Box: ", outer.x, " x ", outer.y, " x ", outer.z, " mm (",
         round(outer.x / 25.4 * 100) / 100, " x ", round(outer.y / 25.4 * 100) / 100,
         " x ", round(outer.z / 25.4 * 100) / 100, " in)",
         fits(outer) ? "" : "  WARNING: exceeds printer"));
echo(str("Bay: ", bay.x, " x ", bay.y, " x ", bay.z, "; lid: ", lid_type, ", ", lid_t, " thick"));
echo(str("Trays: ", trays, " x ", tray, " square, ", len(posts), " bobbins each, ",
         trays * len(posts), " in all; layer pitch ", layer));
echo(str("Print: 1 box, 1 lid, 1 bottom tray, ", trays - 1, " upper trays"));
if (bobbin_gap < 4)
    echo("WARNING: under 4 mm between bobbins leaves little room for fingers");
if (pitch - bobbin_d / 2 < knob_d / 2 + 1)
    echo("WARNING: the knob crowds the nearest bobbins");
if (pitch < bobbin_d / 2 + hole_d / 2 + 1)
    echo("WARNING: the upper trays' center hole runs under the nearest bobbins");
if (post_d < pin_d + 1.5)
    echo("WARNING: the post shoulder is under 0.75 mm wide");
if (lip < bump_engage + 1.6)
    echo("WARNING: thin lip behind the hinge bump recesses; increase wall");
if (scoop_d > lip - 0.4)
    echo("WARNING: the thumb scoop cuts through the lip");
if (hinged) {
    echo(str("Hinge: bumps ", bump_d, " mm engaging ", bump_engage, " mm; recesses ",
             bump_d + recess_extra_d, " mm, ", bump_engage + recess_extra_depth,
             " deep; flex tabs ", flex_len, " x ", flex_w, " mm; open stop ",
             open_stop ? "on" : "off"));
    if (bump_d - 2 * (c + bump_engage) < 0.4)
        echo("WARNING: the bumps come to a point; reduce bump_engage or raise bump_d");
    if (bump_d > lid_t - 0.8)
        echo("WARNING: the bumps are nearly as large as the lid is thick");
    if (flex_len > (ry1 - ry0) / 2)
        echo("WARNING: the flex tabs run more than halfway across the lid");
}
if (tab_w > outer.x - 2 * wall - 2 * box_round)
    echo("WARNING: the thumb tab is wider than the front wall allows");
if (trays < 1)
    echo("WARNING: no trays");
echo("==================");

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

if (part == "assembly") {
    color("Peru") box();
    translate(bay_c) {
        color("SteelBlue") bottom_tray();
        for (k = [1 : trays - 1])
            translate([0, 0, k * layer]) color("LightSteelBlue") upper_tray();
    }
    color("BurlyWood", 0.5) lid();
} else if (part == "all") {
    box();
    translate([outer.x + spacing, 0, 0]) lid_print();
    translate([2 * outer.x + 2 * spacing + tray / 2, tray / 2, 0]) bottom_tray();
    translate([2 * outer.x + 3 * spacing + 1.5 * tray, tray / 2, 0]) upper_tray();
} else if (part == "box") {
    box();
} else if (part == "lid") {
    lid_print();
} else if (part == "bottom_tray") {
    bottom_tray();
} else if (part == "upper_tray") {
    upper_tray();
} else if (part == "test") {
    test_cells();
} else if (part == "hinge_test") {
    hinge_test();
}

// ---------------------------------------------------------------------------
// Box
// ---------------------------------------------------------------------------

module box() {
    difference() {
        cuboid(outer, rounding = box_round, edges = [TOP, "Z"],
               anchor = LEFT + FRONT + BOTTOM);
        // Lid rabbet
        translate([rx0, ry0, z0]) cube([rx1 - rx0, ry1 - ry0, lid_t + overlap]);
        // Bay
        translate([bay_x0, bay_y0, box_floor]) cube([bay.x, bay.y, bay.z + overlap]);
        // Notch in the front lip for the lid's tab
        translate([cx - notch_w / 2, -overlap, z0])
            cube([notch_w, ry0 + 2 * overlap, lid_t + overlap]);
        // Thumb scoop under the tab: open at the top, 45-degree floor
        translate([cx - notch_w / 2, 0, 0]) rotate([90, 0, 90])
            linear_extrude(height = notch_w)
                polygon([[-overlap, z0 - scoop_h], [0, z0 - scoop_h],
                         [scoop_d, z0 - scoop_h + scoop_d],
                         [scoop_d, z0 + overlap], [-overlap, z0 + overlap]]);
        // Hinge: bump recesses and the lean-back chamfer
        if (hinged)
            translate([rx0, ry1, top]) hinge_frame_cuts(rx1 - rx0, lid_t);
    }
}

// Cuts in the rabbet walls for the hinge, in the hinge frame: the rabbet
// runs from x = 0 to A, the hinge wall is at y = 0, z = 0 is the top.
module hinge_frame_cuts(A, t) {
    ya = -c - t / 2;                     // pivot axis
    sd = bump_d + recess_extra_d;
    sh = bump_engage + recess_extra_depth;
    for (m = [[0, -1], [A, 1]])
        translate([m[0] - m[1] * overlap, ya, -t / 2])
            rotate([0, m[1] * 90, 0])
                cylinder(h = sh + overlap, d1 = sd, d2 = max(0.4, sd - 2 * sh));
    // Lean-back chamfer: the open lid leans to about 135 degrees and stays
    k  = 0.7071 * t + open_stop_extra;
    yw = c + t / 2;
    if (open_stop)
        rotate([90, 0, 90])
            linear_extrude(height = A)
                translate([ya, -t / 2])
                    polygon([[yw - overlap, yw - k], [yw - overlap, t / 2 + overlap],
                             [k + t / 2 + overlap, t / 2 + overlap]]);
}

// ---------------------------------------------------------------------------
// Lid
// ---------------------------------------------------------------------------

// Lid in its closed position
module lid() {
    A = rx1 - rx0;
    B = ry1 - ry0;
    t = lid_t;
    union() {
        translate([rx0, ry1, top]) lid_plate(A, B, t);
        // Thumb tab over the front notch, past the front face
        translate([0, 0, z0]) linear_extrude(height = t)
            hull() {
                translate([cx - tab_w / 2, ry0 + c + 2]) square([tab_w, 0.01]);
                for (s = [-1, 1])
                    translate([cx + s * (tab_w / 2 - tab_r), -tab_over + tab_r])
                        circle(r = tab_r);
            }
    }
}

// Lid plate in the hinge frame (see hinge_frame_cuts)
module lid_plate(A, B, t) {
    ya = -c - t / 2;
    bh = c + bump_engage;
    if (hinged)
        difference() {
            union() {
                translate([c, -(B - c), -t]) cube([A - 2 * c, B - 2 * c - t / 2, t]);
                // rounded hinge edge, turning about the pivot
                translate([c, ya, -t / 2]) rotate([0, 90, 0])
                    cylinder(h = A - 2 * c, r = t / 2);
                // bumps
                translate([c + overlap, ya, -t / 2]) rotate([0, -90, 0])
                    cylinder(h = bh + overlap, d1 = bump_d, d2 = bump_d - 2 * bh);
                translate([A - c - overlap, ya, -t / 2]) rotate([0, 90, 0])
                    cylinder(h = bh + overlap, d1 = bump_d, d2 = bump_d - 2 * bh);
            }
            // slots freeing the flex tabs that carry the bumps
            for (x = [c + flex_w, A - c - flex_w - flex_slot])
                translate([x, ya - flex_len, -t - overlap])
                    cube([flex_slot, flex_len + t, t + 2 * overlap]);
        }
    else
        translate([c, -(B - c), -t]) cube([A - 2 * c, B - 2 * c, t]);
}

// Lid turned top face down at the origin, for printing
module lid_print() {
    translate([-rx0 + bump_engage + c, ry1, top]) rotate([180, 0, 0]) lid();
}

// ---------------------------------------------------------------------------
// Trays (origin at the tray center, floor bottom at z = 0)
// ---------------------------------------------------------------------------

module tray_plate() {
    difference() {
        linear_extrude(height = tray_floor) rect([tray, tray], rounding = tray_round);
        for (p = lighten_xy)
            translate([p.x, p.y, -overlap])
                cylinder(h = tray_floor + 2 * overlap, d = lighten_d);
    }
}

// Bobbin posts, each with a pin on its tip
module post_grid() {
    for (p = posts) translate([p.x, p.y, 0]) {
        translate([0, 0, tray_floor])
            cyl(h = post_h, d = post_d, chamfer2 = 0.4, anchor = BOTTOM);
        translate([0, 0, tray_floor + post_h - overlap])
            cyl(h = pin_h + overlap, d = pin_d, chamfer2 = 0.5, anchor = BOTTOM);
    }
}

// Bottom tray: plate, posts, and the center column with its knob
module bottom_tray() {
    tray_plate();
    post_grid();
    k0 = column_top - knob_h;
    translate([0, 0, tray_floor])
        cyl(h = k0 - tray_floor + overlap, d = column_d,
            rounding1 = -column_flare, anchor = BOTTOM);
    translate([0, 0, k0])
        cyl(h = knob_h, d = knob_d, chamfer1 = (knob_d - column_d) / 2,
            rounding2 = 2, anchor = BOTTOM);
}

// Upper tray: plate and posts, a center hole that clears the knob, and a
// socket under each post for the pin below
module upper_tray() {
    difference() {
        union() {
            tray_plate();
            post_grid();
        }
        translate([0, 0, -overlap]) cylinder(h = tray_floor + 2 * overlap, d = hole_d);
        for (p = posts) translate([p.x, p.y, -overlap]) {
            cylinder(h = sock_h + overlap, d = sock_d);
            cylinder(h = socket_chamfer + overlap,
                     d1 = sock_d + 2 * (socket_chamfer + overlap), d2 = sock_d);
        }
    }
}

// Hinge test: the back of the box, a short slice down from the top, and a
// strip of the lid across the hinge, laid out for printing side by side.
// The slice prints upright; the strip prints top face down, as the lid does.
module hinge_test() {
    d  = hinge_test_depth;
    zb = z0 - hinge_test_height;
    // Box slice
    translate([0, -(outer.y - d), -zb])
        intersection() {
            box();
            translate([-1, outer.y - d, zb]) cube([outer.x + 2, d + 1, top - zb + 1]);
        }
    // Lid strip, turned as in lid_print
    translate([outer.x + spacing - rx0 + bump_engage + c, d + spacing + d, top])
        rotate([180, 0, 0])
            intersection() {
                if (hinged) lid(); else translate([rx0, ry1, top]) lid_plate(rx1 - rx0, ry1 - ry0, lid_t);
                translate([-1, ry1 - d + c, z0 - 1]) cube([outer.x + 2, d + 1, lid_t + 2]);
            }
}

// Test parts: one corner cell of each tray, to try a bobbin on the post and
// the pin in the socket. The upper piece stacks on the bottom piece.
module test_cells() {
    p  = posts[0];
    lo = [p.x - pitch / 2 - 1, p.y - pitch / 2 - 1, -1];
    sz = [pitch + 2, pitch + 2, layer + pin_h + 2];
    module cell() intersection() { children(); translate(lo) cube(sz); }
    translate([-lo.x, -lo.y, 0]) cell() bottom_tray();
    translate([-lo.x + pitch + spacing, -lo.y, 0]) cell() upper_tray();
}
