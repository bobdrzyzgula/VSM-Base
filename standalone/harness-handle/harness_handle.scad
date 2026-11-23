// SPDX-License-Identifier: MIT
// Harness handle: a grip for the VSM Base's carrying harness
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// The harness is two lengths of webbing, each from a front corner's harness
// rod to the opposite back corner's (see "Carrying" in the User's Guide).
// Here they cross in a handle: both lengths run through a tunnel along the
// grip, one on top of the other, and are sewn together just outside each
// end. Your hand lifts the webbing through the grip's floor, so the plastic
// is in compression; the webbing carries the load.
//
// The tunnel's ends are rounded where the webbing turns down toward the
// corners, top and bottom (so the handle works either way up) and at the
// sides (the lengths leave each end toward the front and the back). A
// ridge at each end keeps the hand off those turns.
//
// Prints on its side, with no supports: the tunnel stands on edge, so its
// roof is a short bridge, and the hand's load lies in the layers.
// Self-contained: no libraries needed.
//
// Drawn by Claude at Robert Drzyzgula's direction. Spun off from the
// VSM Base (https://github.com/bobdrzyzgula/VSM-Base). Experimental: not
// printed, not load-tested, and not for carrying a machine until the
// complete harness has passed a proof-load test (see the README). The
// checks below are geometry only; nothing here rates it for a load.

/* [Webbing] */
// Webbing width (1" = 25.4)
webbing_w = 25.4; // [15 : 0.1 : 51]
// Thickness of one layer of webbing (measure yours; 1" nylon or polyester is about 1.2 to 2 mm)
webbing_t = 2; // [0.8 : 0.1 : 4]
// Layers through the tunnel (two lengths of webbing)
layers = 2; // [1 : 1 : 4]
// Clearance added to the tunnel's width and to its height
tunnel_clear = 1; // [0 : 0.1 : 3]

/* [Grip] */
// Length for the hand, between the end ridges (generous: about a hand's width plus 25 mm)
grip_length = 130; // [80 : 1 : 200]
// Grip height, top to bottom as carried
grip_h = 34; // [20 : 0.5 : 60]
// Grip width, front to back as carried (at least the tunnel plus two side walls)
grip_w = 40; // [25 : 0.5 : 70]
// Radius of the grip's long edges
grip_r = 10; // [2 : 0.5 : 25]

/* [Ends] */
// End ridges: how far each rises above and below the grip
ridge = 5; // [0 : 0.5 : 15]
// Length of each end ridge
ridge_len = 12; // [6 : 0.5 : 30]
// Radius the webbing turns over at the tunnel's top and bottom edges
lip_r = 6; // [1 : 0.5 : 15]
// Radius at the tunnel's side edges
side_r = 3; // [0 : 0.5 : 10]
// Chamfer on the outer edges of the end faces
end_chamfer = 1.5; // [0 : 0.1 : 4]

/* [Output] */
// Lay it on its side for printing, or show it as carried
orientation = "print"; // [print, carried]

/* [Hidden] */
$fn = 64;
e = 0.01;

tw   = webbing_w + tunnel_clear;               // tunnel width (y)
th   = layers * webbing_t + tunnel_clear;      // tunnel height (z)
L    = grip_length + 2 * ridge_len;            // overall length (x)
gh2  = grip_h + 2 * ridge;                     // height at the ridges
wall = (grip_w - tw) / 2;                      // side wall beside the tunnel
roof = (grip_h - th) / 2;                      // wall above and below it

echo("Harness handle: EXPERIMENTAL, not load-tested; geometry checks only, no load rating");
echo(str("Harness handle: ", L, " x ", grip_w, " x ", gh2, " mm overall; tunnel ",
         tw, " x ", th, " mm; side walls ", wall, " mm, top and bottom ", roof, " mm"));
assert(wall >= 2.5, "grip_w leaves side walls under 2.5 mm beside the tunnel: widen the grip");
assert(roof >= lip_r + 1, "grip_h leaves too little above and below the tunnel for lip_r");
assert(wall - side_r >= 2, "side_r leaves under 2 mm of side wall at the ends");
if (wall < 4) echo("WARNING: side walls under 4 mm; consider a wider grip");

// Cross-section, as carried: y across (front to back), z up. Rounded long
// edges on the front; on the side that prints on the bed (y < 0), 45°
// chamfers instead, so they print without drooping.
module section(w, h, r, inset = 0) {
    w1 = w - 2 * inset; h1 = h - 2 * inset; r1 = max(r - inset, 0.5);
    c = r1 * (2 - sqrt(2));          // chamfer that cuts about as deep as the round
    hull() {
        for (z = [-1, 1]) translate([w1 / 2 - r1, z * (h1 / 2 - r1)]) circle(r = r1);
        polygon([[-w1 / 2 + c, -h1 / 2], [-w1 / 2, -h1 / 2 + c], [-w1 / 2, h1 / 2 - c], [-w1 / 2 + c, h1 / 2]]);
    }
}

// A thin slice of a section at station x
module slice(x, h, inset = 0)
    translate([x, 0, 0]) rotate([90, 0, 90]) linear_extrude(height = e, center = true)
        section(grip_w, h, grip_r, inset);

// The body: grip, 45° steps up to the ridges, chamfered ends
module body() {
    xs = [-L / 2, -L / 2 + end_chamfer, -grip_length / 2 - ridge, -grip_length / 2,
          grip_length / 2, grip_length / 2 + ridge, L / 2 - end_chamfer, L / 2];
    hs = [gh2, gh2, gh2, grip_h, grip_h, gh2, gh2, gh2];
    ins = [end_chamfer, 0, 0, 0, 0, 0, 0, end_chamfer];
    for (i = [0 : len(xs) - 2]) hull() {
        slice(xs[i], hs[i], ins[i]);
        slice(xs[i + 1], hs[i + 1], ins[i + 1]);
    }
}

// Tunnel profile in one plane: a slot of half-width a along x, its edges
// rounded with radius r where they meet the end faces (a horn at each end)
module horn(a, r) {
    square([L + 2, 2 * a], center = true);
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * L / 2, sy * a]) mirror([sx < 0 ? 1 : 0, 0]) mirror([0, sy < 0 ? 1 : 0])
            difference() {
                translate([-r, 0]) square([r + 1, r]);
                translate([-r, r]) circle(r = r);
            }
    }
}

module tunnel() {
    intersection() {
        // top and bottom lips: profile in x-z, run across y
        rotate([90, 0, 0]) linear_extrude(height = grip_w + 2, center = true) horn(th / 2, lip_r);
        // side edges: profile in x-y, run up and down z
        linear_extrude(height = gh2 + 2, center = true) horn(tw / 2, max(side_r, e));
    }
}

module handle() difference() { body(); tunnel(); }

// Print on its side, the chamfered side down; or as carried
if (orientation == "print") translate([0, 0, grip_w / 2]) rotate([90, 0, 0]) handle();
else handle();
