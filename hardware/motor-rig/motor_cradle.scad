// Test cradle for a sewing-machine motor (Matsushita SC-L1 class)
// Written by Claude at Bob Drzyzgula's direction, 2026-10-19.
//
// A foam-lined saddle that holds the motor body still on the bench for
// characterization runs. It wraps the lower part of the body only, so both
// end bells (fan vents, pulley, cord grommet) stay clear and the pulley end
// is open for a laser tach. A strap slot through both cheeks takes a
// hook-and-loop strap over the top: the motor's reaction torque at start-up
// would otherwise roll it in a rounded, foam-lined cradle.
//
// Units: mm. Plain OpenSCAD, no libraries.
// Print flat on its base, no supports needed. PETG or PLA.

/* [Motor body] */
// Body width across (the face that sits down), mm
motor_w = 63.5;   // 2.5 in
// Body height, mm
motor_h = 50.8;   // 2.0 in
// Corner radius of the body's cross-section, mm (measure; ~12-16 by photo)
corner_r = 14;

/* [Cradle] */
// Foam liner thickness (compressed), mm
foam_t = 3;
// Extra clearance around foam, mm
clear = 0.5;
// Cradle length along the motor, mm (body is ~114; keep the end bells free)
cradle_len = 70;
// How far up the body the cheeks reach, as a fraction of motor height
wrap = 0.55;
// Wall thickness of the cheeks and floor, mm
wall = 4;
// Floor thickness under the lowest point of the motor, mm
floor_t = 4;
// Extra base width each side for stability, mm
flange = 12;
// Base flange thickness, mm
flange_t = 4;

/* [Strap slot] */
// Strap width (hook-and-loop), mm
strap_w = 25;
// Slot height, mm
strap_slot_h = 4;

/* [Bench screws] */
// Hole diameter in the flanges for clamping to a board (0 = none)
screw_d = 4.5;

$fn = 96;

eps = 0.01;
in_w = motor_w + 2 * (foam_t + clear);
in_h = motor_h + 2 * (foam_t + clear);
in_r = corner_r + foam_t + clear;
out_w = in_w + 2 * wall;
cheek_h = floor_t + wrap * in_h;      // top of the cheeks above the base
base_w = out_w + 2 * flange;

// Rounded rectangle centred on the origin, in XY
module rrect(w, h, r) {
    offset(r = r) square([w - 2 * r, h - 2 * r], center = true);
}

// Cross-section of the cradle (X across, Y up), base at Y = 0
module section() {
    difference() {
        union() {
            // body around the motor, cut flat at cheek height
            intersection() {
                translate([0, floor_t + in_h / 2]) rrect(out_w, in_h + 2 * wall, in_r + wall);
                translate([-out_w / 2, 0]) square([out_w, cheek_h]);
            }
            // fill under the rounded corners down to the base
            translate([-out_w / 2, 0]) square([out_w, floor_t + in_r]);
            // flanges
            translate([-base_w / 2, 0]) square([base_w, flange_t]);
        }
        // the foam-lined pocket
        translate([0, floor_t + in_h / 2]) rrect(in_w, in_h, in_r);
    }
}

module cradle() {
    difference() {
        // extrude the section along the motor axis (Y in the final part)
        rotate([90, 0, 0]) linear_extrude(cradle_len, center = true) section();

        // strap slot straight through both cheeks, centred on the length
        translate([0, 0, floor_t + in_r + strap_slot_h / 2 + 2])
            cube([out_w + 2, strap_w, strap_slot_h], center = true);

        // bench screw holes, two per flange
        if (screw_d > 0)
            for (sx = [-1, 1], sy = [-1, 1])
                translate([sx * (out_w / 2 + flange / 2), sy * (cradle_len / 2 - 10), -eps])
                    cylinder(d = screw_d, h = flange_t + 2 * eps);
    }
}

cradle();

echo(str("Cradle footprint ", base_w, " x ", cradle_len, " mm, height ", cheek_h, " mm"));
