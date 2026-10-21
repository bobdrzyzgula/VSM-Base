// SPDX-License-Identifier: MIT
// Tilt prop: a stand that holds a sewing machine tipped back in its base
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// Stand it on the table behind the base and tip the machine back onto it:
// its top catches the machine's arm (or some other solid part), so the
// machine stays put for oiling and adjusting, with both hands free, and its
// weight goes into the table instead of tipping the base up.
//
// The top is a cradle, for a round arm (a radius, and a width along the
// arm), or flat (a width and a length). Either can slope, to meet a part
// that comes to rest at an angle: the top turns about the width axis (the
// cradle's axis), rising toward the back. The foot is sized for stability:
// the line of a load on the top, square to it, can lean a further
// `stability_angle` either way before it passes the foot's edge, so a
// knock or a sloping top won't tip the prop over.
//
// Two tapered legs, front and back, rise from the foot to the top, with a
// gabled opening between them; it prints upright without supports.
// Self-contained: no libraries needed.
//
// Spun off from the VSM Base (https://github.com/bobdrzyzgula/VSM-Base).

/* [Top] */
// Height of the top above the table: the cradle's bottom, or the flat top's surface at its middle
height = 152.4; // [40 : 0.5 : 400]
// Top: a cradle for a round arm, or flat
top = "cradle"; // [cradle, flat]
// Cradle: radius (the arm's radius plus a little)
cradle_r = 25.4; // [5 : 0.5 : 80]
// Width along the arm (the cradle's length, or the flat top's width)
width = 38.1; // [15 : 0.5 : 150]
// Flat top: length, front to back
flat_length = 50; // [15 : 0.5 : 200]
// Slope of the top, degrees from level, rising toward the back (negative: toward the front)
slope = 0; // [-45 : 1 : 45]

/* [Foot and legs] */
// How far a load on the top may lean past square to it, either way, before the prop would tip (sets the foot's size)
stability_angle = 15; // [5 : 1 : 35]
// Foot thickness
foot_t = 5; // [3 : 0.5 : 12]
// Leg thickness, front and back
leg_t = 10; // [5 : 0.5 : 25]
// Clearance added to the cradle's radius
cradle_clear = 1; // [0 : 0.1 : 3]

/* [Hidden] */
$fn = 96;
// Head: depth front to back, its underside below the top, the cradle's lips
head_d  = top == "flat" ? flat_length : 2 * cradle_r + 8;
head_dz = 8;
lip_h   = top == "flat" ? 0 : 0.6 * cradle_r;
// Foot: the load's line from the top's middle, leaning up to slope +
// stability_angle (front and back) or stability_angle (sideways), must
// stay inside the foot, plus a margin
reach_y = height * tan(min(abs(slope) + stability_angle, 60));
reach_x = height * tan(stability_angle);
foot_y  = max(head_d + 20, 2 * (reach_y + 6));
foot_x  = max(width + 20, 2 * (reach_x + 6));
head_cy = 0;                                  // the top's middle, over the foot's centre

echo(str("Tilt prop: ", top == "flat" ? str("flat top ", width, " x ", flat_length, " mm")
                                      : str("cradle ", cradle_r, " mm radius, ", width, " mm wide"),
         ", ", height, " mm high", slope != 0 ? str(", sloping ", slope, " degrees") : "",
         "; foot ", round(foot_x), " x ", round(foot_y), " mm"));

// The head in its own frame: the top's middle at the origin, level
module head() {
    difference() {
        translate([-width / 2, -head_d / 2, -head_dz]) cube([width, head_d, head_dz + lip_h]);
        if (top == "cradle")
            translate([-width / 2 - 1, 0, cradle_r]) rotate([0, 90, 0])
                cylinder(h = width + 2, r = cradle_r + cradle_clear);
    }
}
// Placed: up to the height, turned by the slope about the width axis
module placed() {
    translate([0, head_cy, height]) rotate([slope, 0, 0]) children();
}

module tilt_prop() {
    difference() {
        union() {
            // foot, corners rounded
            linear_extrude(height = foot_t)
                offset(r = 6) offset(delta = -6) square([foot_x, foot_y], center = true);
            // legs: a post tapering from the foot to the head's underside
            hull() {
                translate([-width / 2, -(foot_y - 20) / 2, 0]) cube([width, foot_y - 20, foot_t]);
                placed() translate([-width / 2, -head_d / 2, -head_dz]) cube([width, head_d, 1]);
            }
            placed() head();
        }
        // the cradle again, through the post's top where the slope tips it
        if (top == "cradle")
            placed() translate([-width / 2 - 1, 0, cradle_r]) rotate([0, 90, 0])
                cylinder(h = width + 2, r = cradle_r + cradle_clear);
        // the opening between the legs, gabled so it prints without a bridge
        let(yb = (foot_y - 20) / 2 - leg_t,
            yt = head_d / 2 - leg_t,
            zt = height - head_dz - abs(sin(slope)) * head_d / 2 - 6 - yt)
            if (yt > 2 && zt > foot_t + 10)
                rotate([90, 0, 90]) linear_extrude(height = width + 2, center = true)
                    polygon([[-yb, foot_t], [yb, foot_t], [yt, zt], [0, zt + yt], [-yt, zt]]);
    }
}

translate([foot_x / 2, foot_y / 2, 0]) tilt_prop();
