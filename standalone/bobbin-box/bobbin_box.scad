// SPDX-License-Identifier: MIT
// Bobbin box: a stack of bobbin trays in a lidded box, v4
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// A copy of this file is also kept in the Sewing Notions repository
// (github.com/bobdrzyzgula/Sewing-Notions), at bobbin-box/bobbin_box.scad.
// When either copy changes, ask Bob whether to make the same change in
// the other.
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
// v3: SVG images centered on any of the six faces, the lid and bottom
//     included: raised, engraved, or inlaid (engraved and filled flush).
//     Raised and inlaid images are color-tagged, each face its own random
//     color and the body another, so a 3MF export opens in Bambu Studio or
//     Orca as a multi-color part.
// v4: the hinge brought into line with the VSM Base's hinged lids (its
//     v20 hinge, which this box had missed): bumps that are cones bump_d
//     across at the lid's end face with flanks bump_angle (35 degrees) from
//     their axis, so they end in a blunt tip instead of a point; recesses
//     that are matching cones, 0.075 mm clear; 0.15 mm end float at the
//     hinge ends; 4 mm flex tabs and 1.0 mm engagement. The old bumps came
//     to a point and held weakly in PETG. A new lid needs a new box.
//     Each face's image now has its own relief (img_front_relief and so
//     on) in place of the one img_relief for all six.
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
// Lid clearance in its rabbet, per side (the hinged lid's two hinge ends use hinge_end_clear)
lid_clear = 0.3;
// Ledge the lid rests on, inside the lip
ledge = 2.5;

/* [Hinge] */
// (The same hinge as the VSM Base's hinged lids, with the same defaults.)
// Bump diameter at its base, on the lid's end face
bump_d = 3; // [1.5 : 0.1 : 6]
// How far each bump reaches into its recess in the end wall
bump_engage = 1.0;
// Bump flank angle from its axis: smaller is steeper and holds better (45 is a plain 45-degree cone)
bump_angle = 35; // [15 : 1 : 60]
// Clearance at the lid's two hinge ends (less end float keeps both bumps engaged)
hinge_end_clear = 0.15;
// Clearance between bump and recess, per side (the recess is a cone matching the bump)
recess_clear = 0.075;
// Recess depth beyond the bump's reach
recess_extra_depth = 0.3;
// Flex tab carrying each bump: length (longer: softer snap)
flex_len = 15;
// Flex tab width (narrower: softer snap)
flex_w = 4; // [1.5 : 0.1 : 8]
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

/* [Images on the faces] */
// An SVG for each face: a path relative to this file, or "" for none. Each is centered on its face and stretched to its size, width and height (set that to the image's own proportions). Each face's relief is raised from the face, engraved into it, or inlaid (engraved and filled flush); raised and inlaid images are color-tagged for a second filament
img_front = "";
img_front_size = [50, 30];
img_front_relief = "raised"; // [raised, engraved, inlaid]
img_back = "";
img_back_size = [50, 30];
img_back_relief = "raised"; // [raised, engraved, inlaid]
// The left end, seen from the left
img_left = "";
img_left_size = [50, 30];
img_left_relief = "raised"; // [raised, engraved, inlaid]
img_right = "";
img_right_size = [50, 30];
img_right_relief = "raised"; // [raised, engraved, inlaid]
// The bottom reads with the box tipped over backward, its front edge at the top
img_bottom = "";
img_bottom_size = [50, 30];
// (The box prints standing on its bottom, so a raised bottom image would keep it off the bed; engraved or inlaid suits it)
img_bottom_relief = "engraved"; // [raised, engraved, inlaid]
img_lid = "";
img_lid_size = [50, 30];
// (The lid prints top face down, so engraved or inlaid suits it best)
img_lid_relief = "engraved"; // [raised, engraved, inlaid]
// Height or depth of the relief
img_depth = 0.6; // [0.2 : 0.1 : 2]
// Change it for another set of random colors
color_seed = 7; // [0 : 1 : 999]

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
ce     = hinged ? hinge_end_clear : lid_clear;     // the lid's clearance at its two ends
bump_tip = bump_d - 2 * (ce + bump_engage) * tan(bump_angle);

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

// Images: each face as [name, file, size, center, right, up, outward normal,
// relief].
// right x up = normal, so an image reads correctly seen from outside.
img_faces = [
    ["front",  img_front,  img_front_size,  [cx, 0, top / 2],       [1, 0, 0],  [0, 0, 1],  [0, -1, 0], img_front_relief],
    ["back",   img_back,   img_back_size,   [cx, outer.y, top / 2], [-1, 0, 0], [0, 0, 1],  [0, 1, 0], img_back_relief],
    ["left",   img_left,   img_left_size,   [0, outer.y / 2, top / 2],       [0, -1, 0], [0, 0, 1], [-1, 0, 0], img_left_relief],
    ["right",  img_right,  img_right_size,  [outer.x, outer.y / 2, top / 2], [0, 1, 0],  [0, 0, 1], [1, 0, 0], img_right_relief],
    ["bottom", img_bottom, img_bottom_size, [cx, outer.y / 2, 0],   [1, 0, 0],  [0, -1, 0], [0, 0, -1], img_bottom_relief]
];
lid_face = ["lid", img_lid, img_lid_size, [cx, (ry0 + ry1) / 2, top], [1, 0, 0], [0, 1, 0], [0, 0, 1], img_lid_relief];
box_imgs = [for (f = img_faces) if (f[1] != "") 1];
any_img  = len(box_imgs) > 0 || img_lid != "";
// raised and inlaid images are separate, color-tagged parts
function tagged(f) = f[1] != "" && f[7] != "engraved";
any_tagged = len([for (f = concat(img_faces, [lid_face])) if (tagged(f)) 1]) > 0;

// Random colors, evenly spaced in hue so no two are alike: the body (box
// and lid), then the front, back, left, right, bottom and lid images
function hsv(h, s, v) =
    let (k = v * s, hp = h / 60, x = k * (1 - abs(hp % 2 - 1)), m = v - k,
         rgb = hp < 1 ? [k, x, 0] : hp < 2 ? [x, k, 0] : hp < 3 ? [0, k, x]
             : hp < 4 ? [0, x, k] : hp < 5 ? [x, 0, k] : [k, 0, x])
        rgb + [m, m, m];
function hx(v) = let (n = round(v * 255)) str("0123456789ABCDEF"[floor(n / 16)], "0123456789ABCDEF"[n % 16]);
function hexc(c) = str("#", hx(c[0]), hx(c[1]), hx(c[2]));
function relief_list(i) = let (fs = concat(img_faces, [lid_face])) i > 5 ? ""
    : str(fs[i][1] != "" ? str(" ", fs[i][0], " ", fs[i][7]) : "", relief_list(i + 1));
function face_cols(i) = i > 4 ? "" : str(tagged(img_faces[i]) ? str(", ", img_faces[i][0], " ", hexc(cols[i + 1])) : "", face_cols(i + 1));
hue0  = rands(0, 360, 1, color_seed)[0];
cols  = [for (i = [0 : 6]) hsv((hue0 + i * 360 / 7) % 360, 0.6, 0.9)];
box_col = any_tagged ? cols[0] : "Peru";
lid_col = any_tagged ? cols[0] : "BurlyWood";

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
    echo(str("Hinge: bumps ", bump_d, " mm, flanks ", bump_angle, " degrees from the axis, tips ",
             round(bump_tip * 100) / 100, " mm across, engaging ", bump_engage,
             " mm; end clearance ", hinge_end_clear, " mm; recesses ", recess_clear,
             " mm clear, ", bump_engage + recess_extra_depth,
             " deep; flex tabs ", flex_len, " x ", flex_w, " mm; open stop ",
             open_stop ? "on" : "off"));
    if (bump_tip < 0.6)
        echo(str("WARNING: the hinge bumps come to a point (tip ", bump_tip,
                 " mm): reduce bump_engage or bump_angle, or increase bump_d"));
    if (bump_d > lid_t - 0.8)
        echo("WARNING: the bumps are nearly as large as the lid is thick");
    if (flex_len > (ry1 - ry0) / 2)
        echo("WARNING: the flex tabs run more than halfway across the lid");
}
if (tab_w > outer.x - 2 * wall - 2 * box_round)
    echo("WARNING: the thumb tab is wider than the front wall allows");
if (trays < 1)
    echo("WARNING: no trays");
if (any_img) {
    echo(str("Images, ", img_depth, " mm:", relief_list(0),
             any_tagged ? str("; colors: body ", hexc(cols[0]),
                 face_cols(0),
                 tagged(lid_face) ? str(", lid ", hexc(cols[6])) : "") : ""));
    // room on each face, inside the round-overs, with 1 mm to spare
    room = [[outer.x, top], [outer.x, top], [outer.y, top], [outer.y, top], [outer.x, outer.y]]
         - [for (i = [0 : 4]) [2 * box_round + 2, 2 * box_round + 2]];
    for (i = [0 : 4]) let (f = img_faces[i])
        if (f[1] != "" && (f[2].x > room[i].x || f[2].y > room[i].y))
            echo(str("WARNING: the ", f[0], " image is larger than its face allows (",
                     room[i].x, " x ", room[i].y, " mm)"));
    if (img_front != "" && top / 2 + img_front_size.y / 2 > z0 - scoop_h - 1)
        echo(str("WARNING: the front image runs into the thumb scoop; keep img_front_size's height under ",
                 2 * (z0 - scoop_h - 1) - top, " mm"));
    lid_room = [rx1 - rx0 - 2 * ce - (hinged ? 2 * (flex_w + flex_slot) : 0) - 2,
                ry1 - ry0 - 2 * c - (hinged ? lid_t : 0) - 2];
    if (img_lid != "" && (img_lid_size.x > lid_room.x || img_lid_size.y > lid_room.y))
        echo(str("WARNING: the lid image is larger than the lid allows (", lid_room.x, " x ",
                 lid_room.y, " mm)", hinged ? ", between the hinge's flex slots" : ""));
    if (len([for (f = concat(img_faces, [lid_face])) if (f[1] != "" && f[7] != "raised") 1]) > 0
        && img_depth > min(box_floor, lid_t, wall) - 1.2)
        echo("WARNING: the images cut deep into the floor, lid or walls; reduce img_depth");
    if ((img_bottom != "" && img_bottom_relief == "raised") || (img_lid != "" && img_lid_relief == "raised"))
        echo("NOTE: the bottom and the lid print face down, so a raised image there lands on the bed (and on the bottom it stops the box sitting flat); engraved or inlaid suits those faces");
}
echo("==================");

// ---------------------------------------------------------------------------
// Model
// ---------------------------------------------------------------------------

if (part == "assembly") {
    box_full();
    translate(bay_c) {
        color("SteelBlue") bottom_tray();
        for (k = [1 : trays - 1])
            translate([0, 0, k * layer]) color("LightSteelBlue") upper_tray();
    }
    lid_full(0.5);
} else if (part == "all") {
    box_full();
    translate([outer.x + spacing, 0, 0]) lid_print();
    translate([2 * outer.x + 2 * spacing + tray / 2, tray / 2, 0]) bottom_tray();
    translate([2 * outer.x + 3 * spacing + 1.5 * tray, tray / 2, 0]) upper_tray();
} else if (part == "box") {
    box_full();
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
        // Engraved and inlaid images
        for (f = img_faces) if (f[1] != "" && f[7] != "raised") img_solid(f, "cut");
    }
}

// The box with its raised or inlaid images, each color-tagged
module box_full() {
    color(box_col) box();
    for (i = [0 : 4]) let (f = img_faces[i])
        if (tagged(f)) color(cols[i + 1]) img_solid(f, f[7]);
}

// ---------------------------------------------------------------------------
// Images
// ---------------------------------------------------------------------------

// An image in its face's frame: x right, y up, z out of the face, the face
// at z = 0 and the image centered on it
module face_frame(f)
    multmatrix([[f[4].x, f[5].x, f[6].x, f[3].x],
                [f[4].y, f[5].y, f[6].y, f[3].y],
                [f[4].z, f[5].z, f[6].z, f[3].z],
                [0, 0, 0, 1]]) children();

// "raised": stands img_depth proud of the face; "inlaid": fills the recess
// flush; "cut": the recess, run out past the face
module img_solid(f, kind) face_frame(f)
    if (kind == "raised")
        translate([0, 0, -0.01]) linear_extrude(img_depth + 0.01) img_2d(f);
    else if (kind == "inlaid")
        translate([0, 0, -img_depth]) linear_extrude(img_depth) img_2d(f);
    else
        translate([0, 0, -img_depth]) linear_extrude(img_depth + overlap) img_2d(f);

module img_2d(f) resize(f[2]) import(f[1], center = true);

// Cuts in the rabbet walls for the hinge, in the hinge frame: the rabbet
// runs from x = 0 to A, the hinge wall is at y = 0, z = 0 is the top.
module hinge_frame_cuts(A, t) {
    ya = -c - t / 2;                     // pivot axis
    sd = bump_d + 2 * recess_clear;      // a cone matching the bump, just clear of it
    sh = bump_engage + recess_extra_depth;
    ta = tan(bump_angle);
    for (m = [[0, -1], [A, 1]])
        translate([m[0] - m[1] * overlap, ya, -t / 2])
            rotate([0, m[1] * 90, 0])
                cylinder(h = sh + overlap, d1 = sd + 2 * overlap * ta,
                         d2 = max(0.4, sd - 2 * sh * ta));
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
    difference() {
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
        if (img_lid != "" && img_lid_relief != "raised") img_solid(lid_face, "cut");
    }
}

// The lid with its raised or inlaid image, color-tagged
module lid_full(alpha = 1) {
    color(lid_col, alpha) lid();
    if (tagged(lid_face)) color(cols[6]) img_solid(lid_face, img_lid_relief);
}

// Lid plate in the hinge frame (see hinge_frame_cuts)
// A bump: a cone bump_d across at the lid's end face, its flanks bump_angle
// from its axis, continued a little into the lid to root it
module bump(h) {
    ta = tan(bump_angle);
    translate([0, 0, -overlap])
        cylinder(h = h + overlap, d1 = bump_d + 2 * overlap * ta, d2 = max(0.2, bump_tip));
}

module lid_plate(A, B, t) {
    ya = -c - t / 2;
    bh = ce + bump_engage;               // bump height off the end face
    if (hinged)
        difference() {
            union() {
                translate([ce, -(B - c), -t]) cube([A - 2 * ce, B - 2 * c - t / 2, t]);
                // rounded hinge edge, turning about the pivot
                translate([ce, ya, -t / 2]) rotate([0, 90, 0])
                    cylinder(h = A - 2 * ce, r = t / 2);
                // bumps, one on each end face
                translate([ce, ya, -t / 2]) rotate([0, -90, 0]) bump(bh);
                translate([A - ce, ya, -t / 2]) rotate([0, 90, 0]) bump(bh);
            }
            // slots freeing the flex tabs that carry the bumps
            for (x = [ce + flex_w, A - ce - flex_w - flex_slot])
                translate([x, ya - flex_len, -t - overlap])
                    cube([flex_slot, flex_len + t, t + 2 * overlap]);
        }
    else
        translate([c, -(B - c), -t]) cube([A - 2 * c, B - 2 * c, t]);
}

// Lid turned top face down at the origin, for printing
module lid_print() {
    translate([-rx0 + bump_engage + c, ry1, top]) rotate([180, 0, 0]) lid_full();
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
