// Motor test rig: sewing-machine motor and triac-board study platform
// Written by Claude at Bob Drzyzgula's direction, 2026-10-19.
//
// A plywood board carrying printed modules, each screwed down with #8 wood
// screws (4.5 mm clearance holes):
//   - motor cradle (motor_cradle.scad) with the motor's axis along X,
//     pulley end to the right
//   - prony brake (prony_brake.scad) on the motor pulley, arm pointing to
//     the front, onto a digital scale held in a corner fence
//   - belt load stand behind the pulley: a V-groove load pulley on two 608
//     bearings, on a carriage that slides in a dovetail rail with a screw
//     to tension the belt, and a felt drag plunger for a steady load
//   - triac board (KB3151C) on its three posts under a vented cover
//   - Wago 221-413 lever connectors in a labelled holder under a lid
//   - a 400-point breadboard in a tray under a lid
//   - IEC C14 fused inlet in a closed box at the back edge
//   - a front jack panel of 4 mm shrouded sockets: the rig is configured
//     with safety banana leads here (DC supply, motor, triac MT2/MT1,
//     decade box, line, neutral, earth); the Wago blocks are fixed junctions
//   - a holder and strap for a corded isolation transformer (Hammond 171B,
//     200 VA) at the back left; patch it in by plugging the rig's IEC cord
//     into its output receptacle
//
// See RIG_GUIDE.md for building, wiring and test procedures.
//
// part = "layout" shows everything on the board; "template" is the 2D top
// view for marking the screw holes (export as SVG, print 1:1). Every other
// part name renders that part alone, oriented for printing.
//
// Units: mm. Plain OpenSCAD; needs motor_cradle.scad and prony_brake.scad
// in the same folder. Labels use Liberation Sans.
//
// SAFETY: with the AC side wired, the triac board, the Wago blocks, the
// breadboard (if wired into the timing network), the decade box and the
// R-TIMING, MOTOR and LINE sockets are all at mains potential. Keep the lids
// on, change connections unplugged, and put the scope on the AC side only
// through an isolation transformer (or with a differential probe).

use <motor_cradle.scad>
use <prony_brake.scad>

/* [What to render] */
part = "layout"; // [layout, template, iso_holder, board_plate, board_cover, wago_holder, wago_lid, bb_tray, bb_lid, jack_panel, iec_box, load_rail, load_carriage, load_pulley, load_spacer, drag_plunger, scale_fence]

/* [Plywood] */
ply = [450, 300];
ply_t = 18;

/* [Motor and cradle (match motor_cradle.scad)] */
// Motor axis height above the plywood (cradle floor + half the lined pocket)
motor_axis_z = 32.9;
// Motor axis position on the board (Y)
motor_y = 142;
// Cradle centre (X)
cradle_x = 110;
// Motor body length, and the pulley's centre beyond the body's end
motor_len = 114.3;
pulley_out = 14;
// Motor pulley diameter (match prony_brake.scad)
motor_pulley_d = 19;

/* [Scale] */
// Brake arm length (match prony_brake.scad)
arm_len = 100;
// Scale footprint [X, Y] the fence is sized to
scale_size = [75, 80];

/* [Load stand] */
// Load pulley outside diameter
load_d = 60;
// V-groove: top width, depth, included angle
groove_w = 6.5;
groove_depth = 5;
groove_angle = 40;
// Load axle height above the plywood
load_axis_z = 56;
// Rail length (Y) and carriage length
rail_len = 100;
carriage_len = 46;
// Drag pad radius on the pulley's face
drag_r = 21;
// Compression spring in the drag bore [OD, free length] (0 = none)
drag_spring = [8, 12];

/* [Triac board (KB3151C)] */
board = [75, 35];
board_t = 1.5;
board_h = 8;          // underside above the plate
board_parts_h = 13.6; // tallest part above the underside
// Posts, in board coordinates [along from the notched end, across from the screw-side long edge]
board_screw = [49.6, 12.5];
board_peg = board_screw + [-47.3, 5];
board_rest = board_screw + [-4.3, 19.5];
tab_room = 16;        // in front of the tab edge for the spade connectors

/* [Wago] */
wago = [18.8, 18.8, 8.6]; // 221-413 [width, depth (wire entry face to back), height]
wago_labels = ["L", "N", "PE", "MOT A", "MOT B", "AUX"];

/* [Breadboard] */
// 400-point half breadboard [length, width, height]; measure yours
breadboard = [82.5, 54.6, 8.5];

/* [IEC inlet (as the base's iec mode)] */
iec_cut = [52.5, 27.5];
iec_r = 3;
iec_panel = 2;
iec_depth = 40;

/* [Isolation transformer (Hammond 171B: 200 VA, 115 V : 115 V, corded)] */
// Footprint [X, Y] and height of the transformer's case
iso_size = [141.2, 96.5, 118.9];
// Holder wall height
iso_wall_h = 18;

/* [Jack panel] */
// Panel hole for your 4 mm shrouded sockets
jack_hole = 12.2;
jack_pitch = 18.5;
jack_labels = ["DC+", "DC-", "MOT A", "MOT B", "MT2", "MT1", "R TIM", "R TIM", "LINE", "NEUT", "PE"];
panel_h = 42;

/* [Hardware] */
wood_screw = 4.5;     // #8 clearance
m3_insert = 4.6;
m5 = 5.4;
m8 = 8.4;
b608 = [22.15, 7];    // bearing OD (press), width

$fn = 64;
eps = 0.01;
font = "Liberation Sans:style=Bold";

// ---------------------------------------------------------------- layout
pulley_x = cradle_x + motor_len / 2 + pulley_out;   // belt / brake plane
cradle_footprint = [102.5, 70];                      // from motor_cradle.scad defaults

jp_w = len(jack_labels) * jack_pitch + 16;
pos = [
    // name,          [x, y] of the part's local origin on the board, rotation
    ["jack_panel",    [ply[0] - jp_w - 5, 4], 0],
    ["scale_fence",   [pulley_x - scale_size[0] / 2 - 3, 3], 0],
    ["load_rail",     [pulley_x, ply[1] - rail_len - 16], 0],
    ["bb_tray",       [255, 52], 0],
    ["wago_holder",   [262, 135], 0],
    ["board_plate",   [262, 188], 0],
    ["iec_box",       [ply[0] - 88, ply[1] - 50], 0],
    ["iso_holder",    [12, ply[1] - iso_size.y - 9], 0],
];
function P(n) = [for (p = pos) if (p[0] == n) p][0];

// ---------------------------------------------------------------- helpers
module rrect(s, r) { offset(r) offset(-r) square(s); }
module screw_hole(h = 20) { translate([0, 0, -1]) cylinder(d = wood_screw, h = h + 2); }
module countersunk(z) { translate([0, 0, z - 2.2]) cylinder(d1 = wood_screw, d2 = 9, h = 2.21); }
module label(t, s = 5) { text(t, size = s, font = font, halign = "center", valign = "center"); }
module flange_plate(s, t, holes) {
    difference() {
        linear_extrude(t) rrect(s, 3);
        for (h = holes) translate(h) { screw_hole(t); countersunk(t); }
    }
}

// ---------------------------------------------------------------- triac board
bm = 5;                                   // margin round the board inside the cover
bw = 2;                                   // cover wall
bp = [board[0] + 2 * bm, board[1] + tab_room + 2 * bm];          // cover inside
bpl = bp + [2 * bw, 2 * bw];                                      // cover outside = plate size
b0 = [bw + bm, bw + bm + tab_room + board[1]];                    // board point (along 0, across 0)
function bpt(p) = [b0.x + p[0], b0.y - p[1]];                     // across runs to -Y (tabs to the front)
plate_t = 4;
cover_h = board_h + board_t + board_parts_h + 4;
cover_ear = 12;

// rim the cover sits over: a raised frame inside the cover wall
module board_rim() {
    translate([bw + 0.3, bw + 0.3, 0]) linear_extrude(plate_t + 3) difference() {
        rrect(bp - [0.6, 0.6], 2); offset(-1.6) rrect(bp - [0.6, 0.6], 2);
    }
}
function plate_holes() = [[bpl.x / 2, -7], [bpl.x / 2, bpl.y + 7]];
function cover_holes() = [[-cover_ear / 2 + 2, bpl.y / 2], [bpl.x + cover_ear / 2 - 2, bpl.y / 2]];

module board_plate_full() {
    difference() {
        union() {
            linear_extrude(plate_t) rrect(bpl, 3);
            // ears for the plate screws (front and back) and under the cover's ears (ends)
            for (h = plate_holes()) translate([h.x - 8, h.y < 0 ? -12 : bpl.y - 3, 0]) linear_extrude(plate_t) rrect([16, 15], 3);
            for (h = cover_holes()) translate([h.x - cover_ear / 2, h.y - 9, 0]) linear_extrude(plate_t) rrect([cover_ear, 18], 3);
            translate(bpt(board_screw)) cylinder(d = 9, h = plate_t + board_h);
            translate(bpt(board_peg)) {
                cylinder(d = 4, h = plate_t + board_h);
                cylinder(d = 2, h = plate_t + board_h + 3.4);
                translate([0, 0, plate_t + board_h + 3.4]) cylinder(d1 = 2, d2 = 0.8, h = 0.8);
            }
            translate(bpt(board_rest)) cylinder(d = 4, h = plate_t + board_h);
            board_rim();
        }
        translate(bpt(board_screw)) translate([0, 0, plate_t + board_h - 7]) cylinder(d = m3_insert, h = 8);
        for (h = plate_holes()) translate(h) { screw_hole(plate_t); countersunk(plate_t); }
        for (h = cover_holes()) translate(h) screw_hole(plate_t);
        translate([0, 0, plate_t - 0.5]) linear_extrude(1) translate([b0.x, b0.y - board[1]]) difference() {
            square(board); offset(-0.8) square(board);
        }
    }
}

module board_cover() {
    // built open side down (rim at z = 0); printed roof down (part = "board_cover")
    difference() {
        union() {
            linear_extrude(cover_h) rrect(bpl, 3);
            // full-height ears at the two ends: a long #8 screw goes down through ear and plate into the wood
            for (h = cover_holes()) translate([h.x - cover_ear / 2, h.y - 9, 0]) linear_extrude(cover_h) rrect([cover_ear, 18], 3);
        }
        translate([bw, bw, -eps]) linear_extrude(cover_h - bw + eps) rrect(bp, 2);
        for (h = cover_holes()) translate(h) {
            screw_hole(cover_h);
            translate([0, 0, 6]) cylinder(d = 9.5, h = cover_h);   // counterbore: the head sits 6 mm above the plate
        }
        // vents in the roof, over the triac end
        for (i = [0 : 5]) translate([bw + 8 + i * 6, bw + 8, cover_h - bw - 1]) cube([2.5, bp.y - 16, bw + 2]);
        // wire exits at the bottom edge, front corners (spade leads) and back-left (R-timing leads)
        for (x = [bw + 6, bpl.x - bw - 20]) translate([x, -1, -eps]) cube([14, bw + 2, 8]);
        translate([bw + 6, bpl.y - bw - 1, -eps]) cube([14, bw + 2, 8]);
        // label
        translate([bpl.x / 2, bpl.y / 2, cover_h - 0.6]) linear_extrude(1) label("LIVE  KB3151C", 5);
    }
}

// ---------------------------------------------------------------- Wago holder
wn = len(wago_labels);
wg = [wago.x + 0.4, wago.y + 0.4];
ww = 1.6;
wh_size = [wn * wg.x + (wn + 1) * ww, wg.y + ww + 9];   // the front 9 mm is open: wire entries face front
wh_h = 2 + 6;
wl_h = wago.z + 2 + 10;                                   // lid height above the holder floor

module wago_holder() {
    difference() {
        union() {
            linear_extrude(wh_h) rrect(wh_size, 2);
            for (sx = [0, 1]) translate([sx ? wh_size.x - 3 : -11, wh_size.y / 2 - 8, 0]) linear_extrude(3) rrect([14, 16], 3);
        }
        for (i = [0 : wn - 1]) {
            translate([ww + i * (wg.x + ww), 9 - eps, 2]) cube([wg.x, wg.y + eps, wh_h]);
            translate([ww + i * (wg.x + ww) + wg.x / 2, 4.5, wh_h - 0.6]) linear_extrude(1) label(wago_labels[i], 4);
        }
        // open the front in front of each block so the wires lie flat
        translate([ww, -eps, 2]) cube([wh_size.x - 2 * ww, 9 + 2 * eps, wh_h]);
        for (sx = [0, 1]) translate([sx ? wh_size.x + 4 : -4, wh_size.y / 2, 0]) { screw_hole(3); countersunk(3); }
    }
    // put the labels back on a ledge at the front
    difference() {
        translate([ww, 0, 0]) cube([wh_size.x - 2 * ww, 9, 3]);
        for (i = [0 : wn - 1]) translate([ww + i * (wg.x + ww) + wg.x / 2, 4.5, 3 - 0.6]) linear_extrude(1) label(wago_labels[i], 4);
    }
}

// clearance in a lid's end walls for the 14 x 16 x 3 screw ears of the part under it
module ear_notches(s, off, inner) {
    for (x = [-1, s.x - off - 1]) translate([x, off + inner.y / 2 - 9, -eps]) cube([off + 2, 18, 3.6]);
}

module wago_lid() {
    // slips over the holder; a slot along the front lets the wires out. Printed roof down.
    t = 1.8; c = 0.3;
    s = wh_size + [2 * (t + c), 2 * (t + c)];
    difference() {
        linear_extrude(wl_h) rrect(s, 3);
        translate([t, t, -eps]) linear_extrude(wl_h - t + eps) rrect(wh_size + [2 * c, 2 * c], 2);
        translate([t + 4, -1, -eps]) cube([s.x - 2 * t - 8, t + 2, 9]);
        translate([s.x / 2, s.y / 2, wl_h - 0.6]) linear_extrude(1) label("LIVE", 6);
        ear_notches(s, t + c, wh_size);
    }
}

// ---------------------------------------------------------------- breadboard
bbw = 2.4;
bb_size = [breadboard.x + 0.6 + 2 * bbw, breadboard.y + 0.6 + 2 * bbw];
bb_h = 2 + breadboard.z - 2;     // walls stop 2 mm below the board's top
bb_lid_h = breadboard.z + 22;

module bb_tray() {
    difference() {
        union() {
            linear_extrude(bb_h) rrect(bb_size, 3);
            for (sx = [0, 1]) translate([sx ? bb_size.x - 3 : -11, bb_size.y / 2 - 8, 0]) linear_extrude(3) rrect([14, 16], 3);
        }
        translate([bbw, bbw, 2]) cube([breadboard.x + 0.6, breadboard.y + 0.6, bb_h]);
        // finger notches to lift the board out
        for (sx = [0, 1]) translate([sx * bb_size.x, bb_size.y / 2, bb_h]) rotate([90, 0, 0]) cylinder(d = 14, h = 20, center = true);
        for (sx = [0, 1]) translate([sx ? bb_size.x + 4 : -4, bb_size.y / 2, 0]) { screw_hole(3); countersunk(3); }
    }
}

module bb_lid() {
    t = 1.8; c = 0.3;
    s = bb_size + [2 * (t + c), 2 * (t + c)];
    difference() {
        linear_extrude(bb_lid_h) rrect(s, 3);
        translate([t, t, -eps]) linear_extrude(bb_lid_h - t + eps) rrect(bb_size + [2 * c, 2 * c], 2);
        // lead slots on both long sides
        for (y = [-1, s.y - t - 1]) translate([t + 8, y, -eps]) cube([s.x - 2 * t - 16, t + 2, 10]);
        ear_notches(s, t + c, bb_size);
        translate([s.x / 2, s.y / 2, bb_lid_h - 0.6]) linear_extrude(1) label("LIVE WHEN WIRED", 5);
    }
}

// ---------------------------------------------------------------- IEC inlet box
ib_wall = 2.4;
ib_out = [iec_cut.x + 16, iec_depth + 6];        // X, Y (panel at +Y, the board's back edge)
ib_h = iec_cut.y + 16;

module iec_box() {
    difference() {
        union() {
            // shell: open bottom, panel at the back (+Y)
            difference() {
                cube([ib_out.x, ib_out.y, ib_h]);
                translate([ib_wall, ib_wall, -eps]) cube([ib_out.x - 2 * ib_wall, ib_out.y - ib_wall - iec_panel, ib_h - ib_wall + eps]);
            }
            for (sx = [0, 1]) translate([sx ? ib_out.x - 3 : -11, ib_out.y / 2 - 8, 0]) linear_extrude(3) rrect([14, 16], 3);
        }
        // inlet cutout through the panel
        translate([ib_out.x / 2, ib_out.y + 1, ib_h / 2]) rotate([90, 0, 0])
            linear_extrude(iec_panel + 2) offset(iec_r) offset(-iec_r) square(iec_cut, center = true);
        // wire exit to the Wago blocks, front wall, low
        translate([ib_out.x / 2, -1, 9]) rotate([-90, 0, 0]) cylinder(d = 11, h = ib_wall + 2);
        for (sx = [0, 1]) translate([sx ? ib_out.x + 4 : -4, ib_out.y / 2, 0]) { screw_hole(3); countersunk(3); }
    }
}

// ---------------------------------------------------------------- jack panel
jp_t = 3;
jp_base = 30;
module jack_panel() {
    difference() {
        union() {
            cube([jp_w, jp_t, panel_h]);                       // the panel, facing -Y
            cube([jp_w, jp_base, 4]);                          // base
            for (x = [0, jp_w / 2 - 2, jp_w - 4]) translate([x, 0, 0])
                hull() { cube([4, jp_t, panel_h - 4]); cube([4, jp_base - 2, 4]); }
        }
        for (i = [0 : len(jack_labels) - 1]) {
            x = 8 + jack_pitch / 2 + i * jack_pitch;
            translate([x, -1, panel_h - 15]) rotate([-90, 0, 0]) cylinder(d = jack_hole, h = jp_t + 2);
            translate([x, 0.6, 7.5]) rotate([90, 0, 0]) linear_extrude(1) label(jack_labels[i], 3.6);
        }
        // group dividers engraved on the face
        for (i = [2, 4, 6, 8]) translate([8 + i * jack_pitch - 0.4, -eps, 4]) cube([0.8, 0.6, panel_h - 6]);
        for (x = [jp_w * 0.25, jp_w * 0.75]) translate([x, jp_base - 9, 0]) { screw_hole(4); countersunk(4); }
    }
}

// ---------------------------------------------------------------- load stand
// Everything here is in the stand's own frame: X = 0 is the belt plane (the
// motor pulley's groove), the rail runs along Y, the screw block at the back.
rail_w = 50;
rail_t = 10;
dt_top = 22;           // dovetail channel width at the rail's top face (narrow)
dt_bot = 30;           // and at the channel floor (wide)
dt_h = 6;
dt_c = 0.2;            // sliding clearance each side
blk_h = 6;             // carriage block above the rail
up_t = 12;             // upright thickness (X)
pulley_w = 2 * b608[1];
spacer_t = 6;
up_x0 = pulley_w / 2 + spacer_t;               // upright's inner face
cx = up_x0 + up_t / 2;                         // carriage and rail centre line (under the upright)
cg_top = rail_t + 0.3 + blk_h;
ten_z = rail_t + 0.3 + blk_h / 2 + 1;          // tension screw height

module dt_profile(top, bot, h) { polygon([[-bot / 2, 0], [bot / 2, 0], [top / 2, h], [-top / 2, h]]); }

module load_rail_part() {
    difference() {
        union() {
            translate([cx - rail_w / 2, 0, 0]) cube([rail_w, rail_len, rail_t]);
            translate([cx - rail_w / 2, rail_len, 0]) cube([rail_w, 14, cg_top + 6]);   // screw block
        }
        // channel, wide at its floor, open at the front end
        translate([cx, -1, rail_t - dt_h]) rotate([-90, 0, 0]) mirror([0, 1, 0])
            linear_extrude(rail_len + 1) dt_profile(dt_top, dt_bot, dt_h + eps);
        translate([cx, rail_len - 1, ten_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = 20);
        for (x = [cx - rail_w / 2 + 6, cx + rail_w / 2 - 6], y = [8, rail_len - 8]) translate([x, y, 0]) {
            screw_hole(rail_t);
            translate([0, 0, rail_t - 3]) cylinder(d = 9, h = 4);
        }
    }
}

module load_carriage() {
    // tongue in the channel, a block as wide as the channel's mouth (so it
    // prints without overhangs), and the upright carrying the axle
    tw = dt_top - 2 * dt_c;
    difference() {
        union() {
            translate([cx, 0, rail_t - dt_h]) rotate([-90, 0, 0]) mirror([0, 1, 0])
                linear_extrude(carriage_len) dt_profile(tw, dt_bot - 2 * dt_c, dt_h + 0.3);
            translate([cx - tw / 2, 0, rail_t + 0.3 - eps]) cube([tw, carriage_len, blk_h]);
            translate([up_x0, 0, rail_t]) cube([up_t, carriage_len, load_axis_z + 16 - rail_t]);
        }
        // axle: M8 bolt, nut in a hex pocket on the outer face
        translate([up_x0 - 1, carriage_len / 2, load_axis_z]) rotate([0, 90, 0]) cylinder(d = m8, h = up_t + 2);
        translate([up_x0 + up_t - 6.5, carriage_len / 2, load_axis_z]) rotate([0, 90, 0]) cylinder(d = 15.2, h = 7, $fn = 6);
        // drag: square plunger bore from the inner face, M6 screw from the outer face with its nut
        translate([up_x0 - eps, carriage_len / 2 - 6.2, load_axis_z - drag_r - 6.2]) cube([up_t - 4, 12.4, 12.4]);
        translate([up_x0, carriage_len / 2, load_axis_z - drag_r]) rotate([0, 90, 0]) cylinder(d = 6.4, h = up_t + 1);
        translate([up_x0 + up_t - 5, carriage_len / 2, load_axis_z - drag_r]) rotate([0, 90, 0]) cylinder(d = 11.6, h = 6, $fn = 6);
        // tension screw from the back, nut dropped into a pocket from the inner (-X) side
        translate([cx, carriage_len - 14, ten_z]) rotate([-90, 0, 0]) cylinder(d = m5, h = 20);
        translate([cx - 15, carriage_len - 11, ten_z - 4.7]) cube([15, 4.4, 9.4]);
    }
}

module load_pulley() {
    // V-groove pulley on two 608 bearings pressed into its bore; flat faces for the drag pad
    r = load_d / 2;
    half = groove_w / 2;
    flank = groove_depth * tan(groove_angle / 2);
    difference() {
        rotate_extrude($fn = 120) polygon([
            [b608[0] / 2 - 1, -pulley_w / 2], [r, -pulley_w / 2], [r, -half],
            [r - groove_depth, -half + flank], [r - groove_depth, half - flank], [r, half],
            [r, pulley_w / 2], [b608[0] / 2 - 1, pulley_w / 2]]);
        translate([0, 0, -pulley_w / 2 - 1]) cylinder(d = b608[0], h = pulley_w + 2);
    }
}

module load_spacer() {
    // between the upright and the inner bearing's inner race
    difference() { cylinder(d = 12, h = spacer_t - 0.5); translate([0, 0, -1]) cylinder(d = m8, h = spacer_t + 2); }
}

module drag_plunger() {
    // square plunger; stick felt on the end that meets the pulley (the top as printed)
    difference() {
        translate([-6, -6, 0]) cube([12, 12, up_t - 4 + spacer_t - 1.5]);
        if (drag_spring[0] > 0) translate([0, 0, -eps]) cylinder(d = drag_spring[0] + 0.6, h = drag_spring[1] - 4);
    }
}

// ---------------------------------------------------------------- scale fence
module scale_fence() {
    s = scale_size + [6, 6];
    difference() {
        union() {
            cube([s.x, 3, 12]);           // front rail
            cube([3, s.y, 12]);           // left rail
            cube([s.x, 14, 3]);
            cube([14, s.y, 3]);
        }
        for (h = [[s.x - 10, 8], [8, s.y - 10]]) translate(h) { screw_hole(3); countersunk(3); }
    }
}

// ---------------------------------------------------------------- isolation transformer holder
// Low walls on three sides (the back is the board's edge or open), two slots
// in each side wall for a hook-and-loop strap over the case, and a notch in
// the front wall for the cords.
iso_c = 1;          // clearance round the case
iso_t = 3;
module iso_holder() {
    s = [iso_size.x + 2 * (iso_c + iso_t), iso_size.y + iso_c + iso_t];
    difference() {
        union() {
            linear_extrude(3) rrect(s + [0, 4], 3);                       // floor rim
            linear_extrude(iso_wall_h) difference() {
                square(s);
                translate([iso_t, iso_t]) square([iso_size.x + 2 * iso_c, s.y]);
            }
            for (x = [-11, s.x - 3]) translate([x, s.y / 2 - 8, 0]) linear_extrude(3) rrect([14, 16], 3);
        }
        // open the floor inside: the case sits on the plywood
        translate([iso_t + 8, iso_t + 8, -1]) cube([iso_size.x + 2 * iso_c - 16, iso_size.y - 16, 5]);
        // strap slots through the side walls, 30 mm wide
        for (x = [-1, s.x - iso_t - 1], y = [s.y * 0.3, s.y * 0.7]) translate([x, y - 15, 6]) cube([iso_t + 2, 30, 4]);
        // cord notch in the front wall
        translate([s.x / 2 - 15, -1, 6]) cube([30, iso_t + 2, iso_wall_h]);
        for (x = [-4, s.x + 4]) translate([x, s.y / 2, 0]) { screw_hole(3); countersunk(3); }
    }
}

// ---------------------------------------------------------------- the board
module place(n) {
    p = P(n);
    translate([p[1].x, p[1].y, 0]) rotate([0, 0, p[2]]) children();
}

module ghost_motor() {
    // body and pulley, for the layout only
    color("ivory", 0.5) translate([cradle_x, motor_y, motor_axis_z]) rotate([0, 90, 0])
        linear_extrude(motor_len, center = true) offset(14) offset(-14) square([50.8, 63.5], center = true);
    color("silver") translate([pulley_x, motor_y, motor_axis_z]) rotate([0, 90, 0]) cylinder(d = motor_pulley_d, h = 10, center = true);
}

module layout() {
    color("burlywood") translate([0, 0, -ply_t]) cube([ply[0], ply[1], ply_t]);
    color("orange") translate([cradle_x, motor_y, 0]) rotate([0, 0, 90]) cradle();
    ghost_motor();
    // brake on the pulley, arm to the front (-Y)
    color("steelblue") translate([pulley_x, motor_y, motor_axis_z]) rotate([0, 0, -90]) { upper_jaw(); lower_jaw(); }
    color("gray", 0.6) place("scale_fence") translate([3, 3, 0]) cube([scale_size.x, scale_size.y, 22]);
    color("orange") place("scale_fence") scale_fence();
    // load stand: the belt plane is pulley_x
    color("orange") translate([pulley_x, P("load_rail")[1].y, 0]) load_rail_part();
    color("tomato") translate([pulley_x, P("load_rail")[1].y + rail_len - carriage_len - 14, 0]) {
        load_carriage();
        translate([0, carriage_len / 2, load_axis_z]) rotate([0, 90, 0]) load_pulley();
    }
    color("orange") place("jack_panel") jack_panel();
    color("orange") place("bb_tray") bb_tray();
    color("white", 0.9) place("bb_tray") translate([bbw + 0.3, bbw + 0.3, 2]) cube(breadboard);
    color("orange") place("wago_holder") wago_holder();
    color("darkorange", 0.35) place("wago_holder") translate([-2.1, -2.1, 0]) wago_lid_placed();
    color("orange") place("board_plate") board_plate_full();
    color("olive") place("board_plate") translate([b0.x, b0.y - board[1], plate_t + board_h]) cube([board[0], board[1], board_t]);
    color("darkorange", 0.35) place("board_plate") board_cover_placed();
    color("orange") place("iec_box") iec_box();
    color("orange") place("iso_holder") iso_holder();
    color("slategray", 0.7) place("iso_holder") translate([iso_t + iso_c, iso_t + iso_c, 0]) cube(iso_size);
}
module wago_lid_placed() { wago_lid(); }
module board_cover_placed() { translate([0, 0, plate_t + 0.01]) board_cover(); }

module template() {
    // the board's top view: outlines and screw centres, 1:1
    difference() {
        square(ply);
        offset(-0.5) square(ply);
    }
    projection() layout_footprints();
}
module layout_footprints() {
    translate([cradle_x, motor_y, 0]) rotate([0, 0, 90]) cradle();
    place("scale_fence") scale_fence();
    translate([pulley_x, P("load_rail")[1].y, 0]) load_rail_part();
    place("jack_panel") jack_panel();
    place("bb_tray") bb_tray();
    place("wago_holder") wago_holder();
    place("board_plate") board_plate_full();
    place("iec_box") iec_box();
    place("iso_holder") iso_holder();
}

// ---------------------------------------------------------------- dispatch
if (part == "layout") layout();
else if (part == "template") template();
else if (part == "board_plate") board_plate_full();
else if (part == "board_cover") translate([0, 0, cover_h]) mirror([0, 0, 1]) board_cover();   // roof down
else if (part == "wago_holder") wago_holder();
else if (part == "wago_lid") translate([0, 0, wl_h]) mirror([0, 0, 1]) wago_lid();
else if (part == "bb_tray") bb_tray();
else if (part == "bb_lid") translate([0, 0, bb_lid_h]) mirror([0, 0, 1]) bb_lid();
else if (part == "jack_panel") rotate([90, 0, 0]) jack_panel();   // panel face down
else if (part == "iec_box") translate([0, 0, ib_out.y]) rotate([-90, 0, 0]) iec_box();      // panel face down
else if (part == "load_rail") translate([-cx, 0, 0]) load_rail_part();
else if (part == "load_carriage") translate([-cx, 0, -(rail_t - dt_h)]) load_carriage();
else if (part == "load_pulley") translate([0, 0, pulley_w / 2]) load_pulley();
else if (part == "load_spacer") load_spacer();
else if (part == "drag_plunger") drag_plunger();
else if (part == "scale_fence") scale_fence();
else if (part == "iso_holder") iso_holder();

echo(str("Belt plane (motor pulley) at X = ", pulley_x, "; brake arm tip at Y = ", motor_y - arm_len));
echo(str("Load axle to motor axis: ", load_axis_z - motor_axis_z, " mm up; Y from ",
         P("load_rail")[1].y + carriage_len / 2 - motor_y, " to ", P("load_rail")[1].y + rail_len - carriage_len / 2 - 14 - motor_y, " mm back"));
