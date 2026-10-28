// Shaft height gauge: measures from a casting's floor up to the underside of
// a shaft, in a space too cramped for calipers.
// Written by Claude at Bob Drzyzgula's direction, 2026-10-26.
//
// Two printed parts:
//   base   - a foot that stands on the casting floor, with an upright rail
//            engraved with a millimetre scale on both broad faces
//   slider - rides the rail and carries a flat arm that reaches sideways
//            under the shaft; a sprung pad in its wall holds it by friction
//
// Use: set the gauge on the floor beside the shaft, with the slider down and
// the arm pointing under the shaft. Push the slider up (by its tab, with a
// pick) until the arm's top face just touches the underside of the shaft.
// The friction pad holds it there. READING: the scale mark level with the top
// edge of the slider, which is level with the arm's top face, is the height
// from the floor to the shaft. Read it in place with a mirror, or lift the
// gauge out without disturbing the slider and measure foot-bottom to arm-top
// with calipers, which is the more accurate number.
//
// Print: base standing up (foot on the bed). Slider as "slider" gives it:
// upright, sleeve on the bed, with tree supports under the arm (and support
// interface material if your printer has it). Upside down, the friction
// tongue would be an island in mid-air for most of its height; no
// orientation avoids some unsupported cantilever. (Bob Drzyzgula's print,
// October 2026, came out perfectly this way.)
// part = "assembly" shows the two together at the reading set by "show_at".

part = "assembly"; // [assembly, base, slider]

/* [Size] */
foot = [16, 12, 2];   // foot: along the arm, across, thickness (fits between floor ribs?)
rail = [8, 5];        // rail: scale face width, depth
rail_h = 34;          // rail height above the floor
slider_len = 10;      // slider length; the smallest reading is foot thickness + this
arm_len = 15;         // arm reach past the slider, toward the shaft
arm_w = 5;            // arm width (along the shaft)
arm_t = 2.5;          // arm thickness
wall = 1.6;           // slider wall
clr = 0.25;           // slider clearance each side
grip = 0.35;          // the friction pad's interference

/* [Scale] */
scale_from = 12;      // first mark (mm above the floor)
scale_to = 32;        // last mark
mark_depth = 0.45;

/* [Show] */
show_at = 20;         // the reading shown in the assembly view

$fn = 32;
eps = 0.01;
font = "Liberation Sans:style=Bold";

// Frame: the floor is z = 0; the rail's scale faces look along -Y and +Y;
// the arm reaches along +X.
ry = rail[1];
rx = rail[0];

module scale_face() {
    // engraved into the -Y face of the rail (mirrored copy for the +Y face)
    for (mm = [scale_from : scale_to]) {
        five = mm % 5 == 0;
        len = five ? 3.4 : (mm % 1 == 0 ? 2.0 : 0);
        translate([rx - len, -eps, mm - 0.2]) cube([len + eps, mark_depth, 0.4]);
        if (mm % 5 == 0)
            translate([0.6, -eps + mark_depth, mm]) rotate([90, 0, 0])
                linear_extrude(mark_depth + eps) text(str(mm), size = 2.6, font = font, halign = "left", valign = "center");
    }
}

module base() {
    difference() {
        union() {
            // foot, centred under the rail, reaching toward the arm
            translate([-(foot[0] - rx) / 2 + 2, -(foot[1] - ry) / 2, 0]) cube(foot);
            cube([rx, ry, rail_h]);
        }
        scale_face();
        translate([rx, ry, 0]) rotate([0, 0, 180]) scale_face();   // turned, not mirrored, so it reads from +Y
        // a small chamfer at the rail's top so the slider starts easily
        translate([-1, -1, rail_h - 0.6]) difference() {
            cube([rx + 2, ry + 2, 2]);
            translate([1.6, 1.6, 0]) cube([rx - 1.2, ry - 1.2, 2]);
        }
    }
}

// slider, in its own frame: its top edge (= the arm's top face) at z = 0,
// hanging down; the rail passes through it
sx0 = -clr - wall; sx1 = rx + clr + wall;
sy0 = -clr - wall; sy1 = ry + clr + wall;
module slider() {
    difference() {
        union() {
            // the sleeve
            translate([sx0, sy0, -slider_len]) cube([sx1 - sx0, sy1 - sy0, slider_len]);
            // the arm, its top face flush with the sleeve's top
            translate([sx1 - eps, (ry - arm_w) / 2, -arm_t]) cube([arm_len, arm_w, arm_t]);
            // gusset under the arm
            hull() {
                translate([sx1 - eps, (ry - 2) / 2, -arm_t]) cube([eps, 2, eps]);
                translate([sx1 - eps, (ry - 2) / 2, -slider_len + 1]) cube([eps, 2, eps]);
                translate([sx1 + 5, (ry - 2) / 2, -arm_t]) cube([eps, 2, eps]);
            }
            // push tab at the back, low down
            translate([sx0 - 3, (ry - 4) / 2, -slider_len]) cube([3 + eps, 4, 2]);
        }
        // the bore
        translate([-clr, -clr, -slider_len - 1]) cube([rx + 2 * clr, ry + 2 * clr, slider_len + 2]);
        // the friction pad: a tongue cut free in the back wall (x = sx0 side)
        translate([sx0 - 1, (ry - 3.6) / 2 - 0.5, -slider_len + 1.5]) cube([wall + 2, 0.5, slider_len - 3]);
        translate([sx0 - 1, (ry + 3.6) / 2, -slider_len + 1.5]) cube([wall + 2, 0.5, slider_len - 3]);
        translate([sx0 - 1, (ry - 3.6) / 2 - 0.5, -1.5 - 0.5]) cube([wall + 2, 3.6 + 1, 0.5]);
    }
    // the pad's bump, pressing on the rail's back face
    // (on the tongue's free end, reaching grip past the rail's face)
    translate([-clr - eps, (ry - 2.4) / 2, -5.4]) cube([clr + grip + eps, 2.4, 2.4]);
}

if (part == "assembly") {
    color("goldenrod") base();
    color("teal") translate([0, 0, show_at]) slider();
    // the shaft (11 mm) resting on the arm, for scale
    color("lightsteelblue", 0.6) translate([sx1 + arm_len / 2 + 1, -15, show_at + 5.5]) rotate([-90, 0, 0]) cylinder(d = 11, h = 35);
} else if (part == "base") base();
else if (part == "slider") translate([0, 0, slider_len]) slider();   // upright: support the arm
echo(str("Reads ", foot[2] + slider_len, " to ", rail_h - 6 + slider_len, " mm (slider kept 6 mm on the rail)"));
