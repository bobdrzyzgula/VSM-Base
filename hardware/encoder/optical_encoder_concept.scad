// Optical shaft encoder: a concept to look at, not a finished design
// Written by Claude at Bob Drzyzgula's direction, 2026-10-24.
//
// A split slotted ring that clamps onto a sewing machine's arm shaft (sized
// for the Kenmore 158's shaft: 12.25 mm measured, its underside 20 mm above
// the casting floor, so the axis is about 26.1 mm up), read by two slotted photo-IC
// interrupters ("forks") a quarter-slot apart, which gives quadrature: the
// count and the direction. One magnet in the ring and a Hall switch on the
// saddle give the index, once a turn. The saddle sits on the casting floor
// under the ring, holds the forks and the Hall switch, and is set by eye
// with the ring turning, then glued or taped down.
//
// Frame: the shaft runs along X; Z is up; the forks sit below the shaft.
// part = "assembly" shows it in place; "exploded" pulls it apart;
// Print the ring halves with fine layers (0.12 mm has worked): their screw
// and insert holes run across the layers, and come out round only when thin.
// "ring_half" (the top half: screw heads), "ring_half_bottom" (inserts or nut
// traps, and the magnet), "insert_cradle" (holds the bottom half split face up,
// level, for pressing in the heat-set inserts) and "saddle" are the printed
// parts, in print orientation.
//
// Things this concept does not settle: the fork part (sizes here are
// generic: check yours), the floor's ribs and the spring (cut them out with
// "keepouts" once measured), the lead path beyond the saddle, and the axial
// room at the rim (the forks are longer along the shaft than the ring is
// thick).

part = "assembly"; // [assembly, exploded, ring_half, ring_half_bottom, insert_cradle, saddle]

/* [Shaft and ring] */
shaft_d = 12.25;      // Kenmore 158, as measured by calipers (Oct 2026); for the views
// Ring bore, as printed: found with standalone/shaft-fit-collars (12.25 snug and
// turnable, 12.5 loose, 12.0 tight), for PETG printed flat; the clamp does the holding
ring_bore = 12.25;
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
hub_od = 25;          // room round the heat-set inserts
hub_len = 5.8;
// Clamp screws: M2 socket-head cap screws through the top half, into M2
// heat-set inserts in the bottom half (pressed in on the bench, before the
// ring goes near the machine), or into M2 hex nuts in traps
clamp_fastener = "insert"; // [insert, nut]
insert = [3.5, 4];    // heat-set insert: outside diameter, length (M2 x 4 x 3.5)
insert_hole = 3.2;    // hole for the insert (about 0.3 under its diameter)
clamp_screw = 2.3;    // clearance hole
clamp_head = 4.2;     // counterbore for the head (M2 SHCS head 3.8)
clamp_nut = 4.3;      // nut trap across flats (M2 nut 4.0)
clamp_seat = 1.0;     // head and nut seats this far in from the hub's surface at the screw
split_gap = 0.4;      // left open so the screws can clamp

/* [Index magnet] */
magnet = [3, 2];      // diameter, thickness
magnet_r = 12;        // radius of the magnet's centre (inside the forks' arms)

/* [Insert cradle] */
// Clearance round the hub and the teeth, at the sides
cradle_clear = 0.3;
// Under the hub: the half sinks this far, and the top is set down to match (raise it if the half sits low)
cradle_seat = 0.1;
// Anti-roll rib, width (the slots are about 1.4 mm wide at the tooth roots)
key_w = 0.6;
// Lead-in: the rib narrows to a point over this length at its inner end
key_lead = 1.5;
// Which slots get a rib, in pitches from straight down. Keep to [0]: a rib
// off the vertical meets its slot at an angle as the half drops in, and
// bends the teeth (the first print broke them with ribs at -2, 0 and 2)
key_slots = [0];

/* [Forks (generic slotted photo-IC interrupter)] */
fork_len = 10;        // along the shaft
fork_w = 4.5;         // across (tangential)
fork_gap = 3;         // slot width
fork_depth = 6;       // slot depth
fork_base = 3;        // body behind the slot
aperture_from_tip = 2;// aperture centre, from the tooth tips inward

/* [Saddle (Kenmore 158: it sits on the casting floor under the ring)] */
// Height of the shaft's axis above the casting floor (20 mm to the shaft's underside, plus half the shaft)
axis_h = 26.1;
// The saddle's underside above the floor: foam tape's thickness if it's taped down; 0 if it sits on the floor and is glued at its edges
mount_gap = 0;
// Saddle width, across the shaft, and the most it rises above the floor at its sides
saddle_w = 30;
saddle_h = 10;
// Keep-outs cut from the saddle (floor ribs, the spring, anything in the way): [x, y, z, dx, dy, dz] each, a box's lower corner and size, x along the shaft from the disc's centre, y across it, z up from the floor
keepouts = [];
// Underside channels for the leads: width, and floor left under the fork bodies
lead_ch_w = 4.4;
lead_ch_skin = 0.6;

$fn = 96;
eps = 0.01;
clamp_y = ring_bore / 2 + 3.0;                                    // screw axis, beside the bore
seat_z = sqrt(pow(hub_od / 2, 2) - pow(clamp_y, 2)) - clamp_seat; // head and nut seats
if (clamp_fastener == "nut")
    echo(str("Clamp: seats ", 2 * seat_z, " mm apart; an M2 x ", ceil(2 * seat_z + 1.6 + 0.5), " or longer reaches through the nut"));
else
    echo(str("Clamp: head seat ", seat_z + split_gap / 2, " mm above the split; M2 x ", ceil(seat_z + split_gap / 2 + 3),
             " to M2 x ", floor(2 * seat_z + split_gap / 2 + 1), " screws (the hole runs on through below the insert)"));

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
        circle(d = ring_bore + 0.2);
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
            // index magnet: flush in the +X face (which prints on the bed), backed by
            // a short boss on the hub side, inside the radius the forks' arms reach
            translate([-web_t / 2 + eps, 0, 0]) yz_at(magnet_r, 0) rotate([0, -90, 0]) cylinder(d = magnet[0] + 1.6, h = magnet[1] + 0.6 - web_t);
        }
        translate([-50, 0, 0]) rotate([0, 90, 0]) cylinder(d = ring_bore, h = 100);
        // magnet pocket, open on the +X face
        translate([web_t / 2 - magnet[1], 0, 0]) yz_at(magnet_r, 0) rotate([0, 90, 0]) cylinder(d = magnet[0] + 0.15, h = 10);
        // clamp screws along Z, through the hub beside the bore
        // (the hub's surface at the screw is lower than its top, so the seats
        // are set from the chord there: flat seats clamp_seat below it)
        for (sy = [-1, 1]) translate([-web_t / 2 - hub_len / 2, sy * clamp_y, 0]) {
            cylinder(d = clamp_screw, h = 40, center = true);
            translate([0, 0, seat_z]) cylinder(d = clamp_head, h = 20);                      // head, top half
            if (clamp_fastener == "nut")
                translate([0, 0, -seat_z - 20]) rotate([0, 0, 30])                          // nut, bottom half,
                    cylinder(d = clamp_nut / cos(30), h = 20, $fn = 6);                     // flats along the shaft
            else {
                // insert, from the bottom half's split face, with a small lead-in
                translate([0, 0, -split_gap / 2 - insert[1] - 0.5]) cylinder(d = insert_hole, h = insert[1] + 0.5 + split_gap);
                translate([0, 0, -split_gap / 2 - 0.4]) cylinder(d1 = insert_hole, d2 = insert_hole + 0.8, h = 0.4 + eps);
            }
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

// the insert cradle: holds the bottom half split face up and level with the
// cradle's top, supported under the hub where the iron presses; built in the
// ring's frame, then turned to print pocket up.
// The half rests on the hub (its pocket is set up so it bottoms first, with
// cradle_seat under it); the teeth hang clear. A rib in the slot straight
// below stops the half rolling in its round pocket when one insert is pressed.
module insert_cradle() {
    top = -split_gap / 2 - cradle_seat;
    hub_lift = cradle_clear - cradle_seat;   // raise the hub pocket so the hub bottoms before the teeth
    difference() {
        translate([-web_t / 2 - hub_len - 4, -R - 4, -R - 4]) cube([hub_len + web_t + 9, 2 * R + 8, R + 4 + top]);
        // disc and teeth: a round pocket, with ribs left standing in a few slots
        difference() {
            translate([-web_t / 2 - 0.3, 0, 0]) rotate([0, 90, 0]) cylinder(r = R + 0.4, h = web_t + 0.6);
            for (k = key_slots) rotate([k * pitch, 0, 0]) {
                r_in = root_r + 0.5;
                translate([-web_t / 2 - 0.4, -key_w / 2, -R - 1]) cube([web_t + 0.8, key_w, R + 1 - r_in - key_lead]);
                hull() {     // the lead-in, pointed toward the axis
                    translate([-web_t / 2 - 0.4, -key_w / 2, -r_in - key_lead - eps]) cube([web_t + 0.8, key_w, eps]);
                    translate([-web_t / 2 - 0.4, -0.1, -r_in - eps]) cube([web_t + 0.8, 0.2, eps]);
                }
            }
        }
        // magnet boss
        translate([-web_t / 2 - 1.6, 0, 0]) rotate([0, 90, 0]) cylinder(r = magnet_r + magnet[0] / 2 + 0.8 + 0.4, h = 1.6 + eps);
        // hub
        translate([-web_t / 2 - hub_len - 0.3, 0, hub_lift]) rotate([0, 90, 0]) cylinder(r = hub_od / 2 + cradle_clear, h = hub_len + 0.3 + eps);
        // finger room to lift the half out
        translate([-web_t / 2 - hub_len - 5, -6, -6]) cube([4, 12, 10]);
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
hall_x = web_t / 2 + 1.0;                        // 1 mm from the disc's +X face
module hall_at() translate([hall_x, 0, -magnet_r]) hall_model();

module magnet_model() color("orange") translate([web_t / 2 - magnet[1], 0, 0]) yz_at(magnet_r, 0) rotate([0, 90, 0]) cylinder(d = magnet[0], h = magnet[1]);

// ---------------------------------------------------------------- saddle
// A low block on the casting floor under the ring. Its top is an arc
// tip_gap (1 mm) outside the tooth tips; the forks sit in pockets in it,
// their bodies sunk in and their arms standing up round the rim. A finger
// rises beside the disc to carry the Hall switch. The leads leave through
// channels in the underside, toward +X. There is no screw and no slot: the
// saddle is set by eye with the ring fitted and turning (the disc centred
// in both forks' slots), then fixed with beads of hot glue or RTV along its
// edges, or with foam tape (set mount_gap to the tape's thickness).
zf = -axis_h;                              // the floor
zb = zf + mount_gap;                       // the saddle's underside
s_r = fork_out - fork_base;                // its top surface (R + 1)
fx0 = -fork_len / 2 - 1.2; fx1 = max(hall_x + 1.5 + 2.5, fork_len / 2 + 1.2);   // its extent along X
// room under each fork body for the leads to bend, at its lowest corner
lead_room = axis_h - mount_gap - (fork_out * cos(fork_sep / 2) + (fork_w / 2 + 0.15) * sin(fork_sep / 2));
echo(str("Saddle: ", fx1 - fx0, " x ", saddle_w, " mm, ", -s_r - zb, " mm thick under the disc; ",
         lead_room, " mm under the fork bodies for their leads", lead_room < 2.0 ? " (TIGHT: check the fork's lead bend)" : ""));
module saddle() {
    difference() {
        union() {
            intersection() {
                translate([fx0, -saddle_w / 2, zb]) cube([fx1 - fx0, saddle_w, zf + saddle_h - zb]);
                difference() {
                    translate([fx0 - 1, -saddle_w, zb - 1]) cube([fx1 - fx0 + 2, 2 * saddle_w, axis_h + 2]);
                    translate([fx0 - 2, 0, 0]) rotate([0, 90, 0]) cylinder(r = s_r, h = fx1 - fx0 + 4, $fn = 192);
                }
            }
            // finger for the Hall switch
            translate([hall_x + 1.5, -3, zb]) cube([2.5, 6, -magnet_r + 3 - zb]);
        }
        // fork pockets (open to the top), and their lead holes out through the underside
        for (a = fork_angles) rotate([a, 0, 0]) {
            translate([-fork_len / 2 - 0.15, -fork_w / 2 - 0.15, -fork_out - 0.15]) cube([fork_len + 0.3, fork_w + 0.3, fork_base + 3]);
            translate([-2, -2.2, -axis_h / cos(a) - 6]) cube([4, 4.4, axis_h / cos(a) + 6 - fork_out]);
        }
        // lead channels in the underside, from under each fork to the +X end
        for (a = fork_angles) {
            yc = (fork_out + 1) * sin(a);
            translate([-2, yc - lead_ch_w / 2, zb - 1]) cube([fx1 - fx0 + 8, lead_ch_w, 1 + max(lead_room - lead_ch_skin, 1)]);
        }
        // Hall leads: a groove up the finger's inner face, and a channel out
        translate([hall_x + 1.5 - eps, -2.2, zb - 1]) cube([1.2, 4.4, -magnet_r + 2 - zb + 1]);
        translate([hall_x + 1.5 - eps, -2.2, zb - 1]) cube([fx1 - hall_x + 8, 4.4, 2.5]);
        // keep-outs (ribs, the spring...), measured from the floor
        for (k = keepouts) translate([k[0], k[1], zf + k[2]]) cube([k[3], k[4], k[5]]);
    }
}

// the casting floor, and the keep-outs, for the views
module floor_model() {
    color("gainsboro", 0.6) translate([-30, -30, zf - 3]) cube([60, 60, 3]);
    for (k = keepouts) color("red", 0.4) translate([k[0], k[1], zf + k[2]]) cube([k[3], k[4], k[5]]);
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
        color("teal") saddle();
    }
    translate([0, 0, -3 * ex]) floor_model();
}

if (part == "assembly") assembly(0);
else if (part == "exploded") assembly(12);
else if (part == "ring_half") translate([0, 0, web_t / 2]) rotate([0, 90, 0]) ring_half(true);   // prints flat, +X face on the bed, bore vertical
else if (part == "ring_half_bottom") translate([0, 0, web_t / 2]) rotate([0, 90, 0]) ring_half(false);
else if (part == "insert_cradle") translate([0, 0, R + 4]) insert_cradle();   // pocket up
else if (part == "saddle") translate([0, 0, -zb]) saddle();   // underside on the bed
