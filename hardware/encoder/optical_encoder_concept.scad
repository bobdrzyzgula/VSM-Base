// Optical shaft encoder: a concept to look at, not a finished design
// Written by Claude at Bob Drzyzgula's direction, 2026-10-24.
//
// A split slotted ring that clamps onto a sewing machine's arm shaft (sized
// for the Kenmore 158's shaft: 12.25 mm measured, its underside 20 mm above
// the casting floor, so the axis is about 26.1 mm up), read by two slotted photo-IC
// interrupters ("forks") a quarter-slot apart, which gives quadrature: the
// count and the direction. One magnet in the ring and a Hall switch on the
// bracket give the index, once a turn. The bracket holds the forks and the
// Hall switch and is fixed to some anchor on the casting by one screw in a
// slotted hole, for adjustment.
//
// Frame: the shaft runs along X; Z is up; the forks sit below the shaft.
// part = "assembly" shows it in place; "exploded" pulls it apart;
// "ring_half" and "bracket" are the printed parts, in print orientation.
//
// Things this concept does not settle: the fork part (sizes here are
// generic: check yours), the anchor on the casting, the lead path, and
// the axial room at the rim (the forks are longer along the shaft than
// the ring is thick).

part = "assembly"; // [assembly, exploded, ring_half, bracket]

/* [Shaft and ring] */
shaft_d = 12.25;      // Kenmore 158, measured (Oct 2026); bore it to suit the real shaft
// Ring outside diameter (the tips of the teeth)
ring_od = 40;
// Slots in the ring (even, so the split falls in a slot)
slots = 36;
// Tooth length (radial), and the slots' share of the pitch
tooth_len = 4;
slot_share = 0.5;
// Web (the disc) thickness
web_t = 1.4;
// Hub: outside diameter and length along the shaft (on one side of the web)
hub_od = 22;
hub_len = 5.8;
// Clamp screws (M2) through the hub, across the split
clamp_screw = 2.3;
clamp_head = 4.2;
clamp_nut = 4.4;      // across corners-ish, for the nut trap
split_gap = 0.4;      // left open so the screws can clamp

/* [Index magnet] */
magnet = [3, 2];      // diameter, thickness
magnet_r = 12;        // radius of the magnet's centre (inside the forks' arms)

/* [Forks (generic slotted photo-IC interrupter)] */
fork_len = 10;        // along the shaft
fork_w = 4.5;         // across (tangential)
fork_gap = 3;         // slot width
fork_depth = 6;       // slot depth
fork_base = 3;        // body behind the slot
aperture_from_tip = 2;// aperture centre, from the tooth tips inward

/* [Bracket] */
plate_t = 3;
anchor_drop = 14;     // from the plate down to the anchor tab

$fn = 96;
eps = 0.01;

R = ring_od / 2;
root_r = R - tooth_len;
pitch = 360 / slots;
// fork angles (from straight down, toward +Y): (k + 1/4) pitches apart
fork_sep = (round(42 / pitch) + 0.25) * pitch;
fork_angles = [-fork_sep / 2, fork_sep / 2];
fork_out = R + 1 + fork_base;                     // body's outer face (1 mm past the tooth tips)
fork_in = fork_out - fork_base - fork_depth;      // arms' inner end (radius)
// quadrature: each slot-and-tooth is one cycle on each channel, four edges in all
echo(str("Counts per turn: ", 4 * slots, " (", 360 / (4 * slots), " deg); forks ", fork_sep, " deg apart"));

// ---------------------------------------------------------------- 2D helpers
// angle phi from straight down (-Z) toward +Y; a 2D shape drawn in XY maps
// onto the YZ plane by yz(), with 2D +X pointing down
module yz() rotate([0, 90, 0]) children();
function pol(r, a) = [r * cos(a), r * sin(a)];
module wedge(r0, r1, a0, a1, n = 8) {
    polygon(concat([for (i = [0 : n]) pol(r0, a0 + (a1 - a0) * i / n)],
                   [for (i = [n : -1 : 0]) pol(r1, a0 + (a1 - a0) * i / n)]));
}
// the disc: web to the tooth roots, then the comb of teeth (slots open at the rim, for cleaning)
module disc2d() {
    difference() {
        union() {
            circle(r = root_r + eps);
            for (k = [0 : slots - 1]) {
                a = k * pitch + pitch / 2;                 // tooth centres between the slots
                wedge(root_r, R, a - pitch * (1 - slot_share) / 2, a + pitch * (1 - slot_share) / 2, 4);
            }
        }
        circle(d = shaft_d + 0.2);
    }
}

// ---------------------------------------------------------------- the ring
// the whole ring, then halved by the split plane (z = 0); slots sit at
// phi = 90 and 270 so the split falls in a slot
module ring_whole() {
    difference() {
        union() {
            yz() translate([0, 0, -web_t / 2]) linear_extrude(web_t) disc2d();
            // hub, on the -X side of the web
            translate([-web_t / 2 - hub_len, 0, 0]) rotate([0, 90, 0]) cylinder(d = hub_od, h = hub_len + eps);
            // index magnet boss on the +X face (clear of the forks' arms)
            translate([web_t / 2 - eps, 0, 0]) yz_at(magnet_r, 0) rotate([0, 90, 0]) cylinder(d = magnet[0] + 2.4, h = magnet[1] + 0.6);
        }
        translate([-50, 0, 0]) rotate([0, 90, 0]) cylinder(d = shaft_d, h = 100);
        // magnet pocket, open on the boss's face
        translate([web_t / 2 + 0.6, 0, 0]) yz_at(magnet_r, 0) rotate([0, 90, 0]) cylinder(d = magnet[0] + 0.15, h = 10);
        // clamp screws along Z, through the hub beside the bore
        for (sy = [-1, 1]) translate([-web_t / 2 - hub_len / 2, sy * (shaft_d / 2 + 2.5), 0]) {
            cylinder(d = clamp_screw, h = 40, center = true);
            translate([0, 0, hub_od / 2 - 2.2]) cylinder(d = clamp_head, h = 10);               // head, top half
            translate([0, 0, -hub_od / 2 - 10 + 2.2]) cylinder(d = clamp_nut, h = 10, $fn = 6); // nut, bottom half
        }
    }
}
// place at radius r, angle phi (from straight down toward +Y), in the YZ plane
module yz_at(r, phi) translate([0, r * sin(phi), -r * cos(phi)]) children();

module ring_half(top = true) {
    intersection() {
        ring_whole();
        translate([-50, -50, top ? split_gap / 2 : -100 - split_gap / 2]) cube([100, 100, 100]);
    }
}

// ---------------------------------------------------------------- bought parts (stand-ins)
// a slotted interrupter in its own frame: slot along X, arms pointing up
// (+Z, toward the shaft), the body below; leads out of the bottom
module fork_model() {
    a = (fork_len - fork_gap) / 2;
    color("dimgray") {
        translate([-fork_len / 2, -fork_w / 2, 0]) cube([fork_len, fork_w, fork_base]);
        for (sx = [-1, 1]) translate([sx > 0 ? fork_gap / 2 : -fork_len / 2, -fork_w / 2, fork_base - eps])
            cube([a, fork_w, fork_depth]);
    }
    // aperture marks on the arms' inner faces
    color("red") for (sx = [-1, 1]) translate([sx * (fork_gap / 2 + 0.05), 0, fork_out - (R - aperture_from_tip)])
        cube([0.1, 0.8, 1.2], center = true);
    color("silver") for (y = [-1.27, 0, 1.27]) translate([0, y, -6]) cylinder(d = 0.5, h = 6, $fn = 8);
}
// placed: body outermost, arms reaching in to fork_in
module fork_at(phi) rotate([phi, 0, 0]) translate([0, 0, -fork_out]) fork_model();

module hall_model() {   // TO-92-ish, flat face toward -X
    color("black") translate([0, -2, -1.5]) cube([1.5, 4, 3]);
    color("silver") for (y = [-1.27, 0, 1.27]) translate([1.5, y, 0]) rotate([0, 90, 0]) cylinder(d = 0.45, h = 5, $fn = 8);
}
hall_x = web_t / 2 + magnet[1] + 0.6 + 1.0;      // 1 mm from the boss's face
module hall_at() translate([hall_x, 0, -magnet_r]) hall_model();

module magnet_model() color("orange") translate([web_t / 2 + 0.6, 0, 0]) yz_at(magnet_r, 0) rotate([0, 90, 0]) cylinder(d = magnet[0], h = magnet[1]);

// ---------------------------------------------------------------- bracket
// an arc plate under the forks (they sit in pockets on its inner face, leads
// through), a finger beside the ring carrying the Hall switch, and an arm
// down to a tab with a slotted hole for the anchor screw
pl_r0 = fork_out;               // plate's inner face
pl_r1 = fork_out + plate_t;
span = fork_sep / 2 + 14;       // plate's half-angle
fx0 = -fork_len / 2 - 1; fx1 = hall_x + 1.5 + 2.5;   // plate's X extent
module bracket() {
    difference() {
        union() {
            // arc plate
            translate([fx0, 0, 0]) rotate([0, 90, 0]) rotate([0, 0, 0]) linear_extrude(fx1 - fx0)
                wedge(pl_r0, pl_r1, -span, span, 24);
            // pocket walls round each fork
            for (a = fork_angles) rotate([a, 0, 0]) translate([-fork_len / 2 - 1, -fork_w / 2 - 1, -pl_r0 - eps])
                difference() { cube([fork_len + 2, fork_w + 2, fork_base + 0.5]); }
            // finger for the Hall switch
            translate([hall_x + 1.5, -3, -pl_r1]) cube([2.5, 6, pl_r1 - magnet_r + 3]);
            // arm down, and a tab facing -X for the anchor screw
            translate([fx0, -5, -pl_r1 - anchor_drop]) cube([fx1 - fx0, 10, anchor_drop + 1]);
            translate([fx0 - 3, -8, -pl_r1 - anchor_drop]) cube([3 + eps, 16, 18]);
        }
        // fork pockets and lead holes
        for (a = fork_angles) rotate([a, 0, 0]) {
            translate([-fork_len / 2 - 0.15, -fork_w / 2 - 0.15, -pl_r0 - 1]) cube([fork_len + 0.3, fork_w + 0.3, fork_base + 2]);
            translate([-2, -2.2, -pl_r1 - 1]) cube([4, 4.4, plate_t + 2]);
        }
        // Hall leads along the finger
        translate([hall_x + 1.5 - eps, -2.2, -pl_r1 - 1]) cube([1.2, 4.4, pl_r1 - magnet_r + 2]);
        // the ring must turn freely: clear its whole envelope, plus a margin
        translate([-web_t / 2 - hub_len - 1, 0, 0]) rotate([0, 90, 0]) cylinder(r = R + 0.8, h = hub_len + web_t + magnet[1] + 2.2);
        // slotted hole for the anchor screw (along X): sliding it sets the
        // forks' depth over the teeth; turning it about the screw trims the angle
        hull() for (dz = [-3, 3]) translate([fx0 - 5, 0, -pl_r1 - anchor_drop + 9 + dz]) rotate([0, 90, 0]) cylinder(d = 3.4, h = 6 + fx1 - fx0);
    }
}

// a stand-in for whatever on the casting the bracket screws to
module anchor_model() {
    // e.g. a face of a web in the casting, square to the shaft, with a tapped hole
    color("gainsboro", 0.6) translate([fx0 - 3 - 8, -14, -pl_r1 - anchor_drop - 6]) cube([8, 28, 30]);
    color("silver") translate([fx0 - 3 - eps, 0, -pl_r1 - anchor_drop + 9]) rotate([0, 90, 0]) { cylinder(d = 3, h = 3.2); translate([0, 0, 3.2]) cylinder(d = 5.5, h = 2); }
}

module shaft_model() color("lightsteelblue") translate([-30, 0, 0]) rotate([0, 90, 0]) cylinder(d = shaft_d, h = 60);

// ---------------------------------------------------------------- views
module assembly(ex = 0) {
    shaft_model();
    color("goldenrod") translate([0, 0, ex]) ring_half(true);
    color("goldenrod") translate([0, 0, -ex]) ring_half(false);
    translate([0, 0, -ex]) magnet_model();
    translate([0, 0, -2.5 * ex]) {
        for (a = fork_angles) fork_at(a);
        hall_at();
        color("teal") bracket();
    }
    translate([0, 0, -3 * ex]) anchor_model();
}

if (part == "assembly") assembly(0);
else if (part == "exploded") assembly(12);
else if (part == "ring_half") translate([0, 0, 0]) rotate([0, 0, 0]) translate([0, 0, -split_gap / 2]) ring_half(true);   // prints on its split face
else if (part == "bracket") bracket();
