// Prony brake for a sewing-machine motor pulley
// Written by Claude at Bob Drzyzgula's direction, 2026-10-19.
//
// Two felt-lined jaws clamp the motor pulley; two M4 bolts with springs and
// wing nuts set the drag. The upper jaw carries a lever arm whose tip rests,
// through an adjustable M5 screw, on a digital kitchen scale.
//
//   torque (N*m) = scale reading (kg) * 9.81 * arm_len (m)
//
// Zero the scale with the motor stopped and the arm resting on it, so the
// arm's own weight drops out. The brake floats on the pulley: only the
// pulley and the scale hold it. Put the arm on the side where the pulley
// surface moves DOWN (the drag pushes the arm onto the scale). To change
// sides, lift it off and turn it end for end; the jaws are symmetric.
//
// Units: mm. Plain OpenSCAD. Both parts print lying on their broad face
// (part = "plate"), so the pulley bore and all holes need no supports.

/* [What to render] */
part = "plate"; // [plate, assembly, upper, lower]

/* [Pulley (measure yours)] */
// Pulley outside diameter, mm (photo estimate ~19)
pulley_d = 19;
// Pulley face width the jaws bear on, mm
pulley_w = 10;

/* [Brake] */
// Felt or leather pad thickness, mm (stick-on felt is ~1.5-3)
pad_t = 2;
// Gap between jaws when the pads first touch, mm (room to tighten)
split_gap = 2;
// Jaw thickness along the shaft (keep <= the free length of shaft/pulley)
jaw_y = 10;
// Lever arm length, shaft axis to the scale contact screw, mm
arm_len = 100;
// Arm height (stiffness), mm
arm_h = 12;

/* [Hardware] */
// Clamp bolt clearance (M4), mm
bolt_d = 4.5;
// Hex head across flats (M4 = 7), mm
bolt_hex = 7.2;
// Contact screw clearance (M5), mm
tip_d = 5.3;
// Contact screw nut across flats (M5 = 8), mm
tip_nut = 8.2;

$fn = 96;
eps = 0.01;

r_in = pulley_d / 2 + pad_t;          // bore radius, pads included
bolt_x = r_in + 5.5;                  // bolt centres either side of the pulley
blk_w = 2 * (bolt_x + 6);             // jaw block width
blk_h = r_in + 5;                     // jaw block height above the split
z0 = split_gap / 2;

module jaw_block() {
    // one jaw (upper), split face at z = z0, bore centred on the origin
    difference() {
        translate([-blk_w / 2, -jaw_y / 2, z0]) cube([blk_w, jaw_y, blk_h - z0]);
        rotate([90, 0, 0]) cylinder(r = r_in, h = jaw_y + 2, center = true);
        for (sx = [-1, 1])
            translate([sx * bolt_x, 0, 0]) cylinder(d = bolt_d, h = 3 * blk_h, center = true);
    }
}

module upper_jaw() {
    difference() {
        union() {
            jaw_block();
            // lever arm
            translate([blk_w / 2 - eps, -jaw_y / 2, z0]) cube([arm_len - blk_w / 2 + eps, jaw_y, arm_h]);
            // tip boss for the contact screw
            translate([arm_len, 0, z0]) scale([1, jaw_y / 14, 1]) cylinder(d = 14, h = arm_h);
        }
        // contact screw, vertical, with a nut trap at the top
        translate([arm_len, 0, 0]) cylinder(d = tip_d, h = 4 * arm_h, center = true);
        translate([arm_len, 0, z0 + arm_h - 4]) cylinder(d = tip_nut / cos(30), h = 5, $fn = 6);
        // keep the bolt holes clear through the arm root
        for (sx = [-1, 1])
            translate([sx * bolt_x, 0, 0]) cylinder(d = bolt_d, h = 3 * blk_h, center = true);
        // arm-length mark on the top face
        translate([arm_len, 0, z0 + arm_h - 0.6]) cube([0.8, jaw_y + 2, 2], center = true);
    }
}

module lower_jaw() {
    difference() {
        mirror([0, 0, 1]) jaw_block();
        // hex pockets so the bolt heads don't turn
        for (sx = [-1, 1])
            translate([sx * bolt_x, 0, -blk_h - eps]) cylinder(d = bolt_hex / cos(30), h = 3.5, $fn = 6);
    }
}

module pulley_ghost() {
    %rotate([90, 0, 0]) cylinder(d = pulley_d, h = pulley_w, center = true);
}

if (part == "assembly") {
    upper_jaw(); lower_jaw(); pulley_ghost();
} else if (part == "upper") {
    upper_jaw();
} else if (part == "lower") {
    lower_jaw();
} else {
    // print plate: both parts lying on their broad face (y = -jaw_y/2 down)
    rotate([90, 0, 0]) translate([0, jaw_y / 2, 0]) upper_jaw();
    translate([0, blk_h + 12, 0]) rotate([90, 0, 0]) translate([0, jaw_y / 2, 0]) lower_jaw();
}

echo(str("Bore ", 2 * r_in, " mm; bolts ", 2 * bolt_x, " mm apart; arm ", arm_len, " mm"));
echo(str("Clamp bolts: M4 x ", ceil((2 * blk_h + 15) / 5) * 5, " or longer"));
