// Force-sensing foot pedal (low voltage), a draft
// Drawn by Claude at Bob Drzyzgula's direction, November 2026. A concept
// to print and try; it has not been built.
//
// A heel-hinged tread over a rigid pedestal. The pedestal carries an
// Interlink FSR 406 (UX series) flat on its top, and beside it, on the
// same plane so the sensor's tail lies flat, a small board where the tail
// is soldered and the cable lands. A puck under the tread, faced with a
// thin rubber pad, presses the sensor's center. Two springs near the toe
// hold the tread up, carry a resting foot, and return it; two stop posts
// beside the pedestal take the load once the tread has moved stop_travel
// at the puck, so a stamp can't crush the sensor.
//
// Electrically the pedal is passive and low voltage: the FSR with a
// 470 ohm resistor in series, on a two-conductor shielded cable to a jack
// on the base (the analog controller paper, "Adding a foot pedal").
//
// Frame: X runs heel (0) to toe, Y across, Z up. The tread rotates about
// the hinge axis, which runs along Y at the heel. "Tread frame" below is
// the tread's own frame at rest: x' along it from the hinge, z' up from
// its underside.
//
// part = "assembly" shows it put together (the tread can be shown
// pressed with press = stop_travel); "base", "tread" are the printed
// parts in print orientation.

part = "assembly"; // [assembly, base, tread]
// Assembly view: how far the tread is pressed at the puck, mm
press = 0; // [0 : 0.1 : 5]

/* [Size] */
// Length, heel to toe
len_x = 190;
// Width
wid_y = 115;
// Height of the tread's underside at the hinge, above the floor's underside
h_heel = 22;
// Height of the tread's underside at the toe
h_toe = 50;

/* [Sensor] */
// FSR 406 pad, outside size (Interlink: 43.69 mm square)
fsr_pad = 43.7;
// Sensor's tail: width, and length from the pad's edge to the end of its tabs
fsr_tail = [7.6, 39.5];
// Depth of the sensor's seat in the pedestal (the sensor is about 0.45 mm thick)
fsr_seat = 0.3;
// Sensor center, from the hinge along the tread (where the ball of the foot falls)
sensor_x = 128;
// Puck diameter (sets the loaded area; at least 20 mm for the current limit)
puck_d = 22;
// Rubber pad on the puck's face, thickness
pad_t = 1.5;
// Gap between the pad and the sensor at rest
gap = 0.8;
// Travel at the puck before the stops take the load
stop_travel = 2.0;

/* [Board] */
// The board in the pedal: length (along X) and width; perfboard, 1.6 mm
board = [35, 25];
// Board thickness
board_t = 1.6;
// Tallest part on the board, above its top
board_parts_h = 5;
// Board screws: M3 into heat-set inserts (hole diameter, depth)
insert_d = 4.0;
insert_depth = 5;

/* [Springs] */
// Return springs: outside diameter, free length, preload compression
spring_od = 9.5;
spring_free = 19;
spring_preload = 4;
// Springs' position along the tread, from the hinge
spring_x = 165;

/* [Hinge] */
// Hinge pin: an M4 bolt or a 4 mm rod (hole diameter)
pin_d = 4.3;
// Knuckle outer radius
knuckle_r = 7;

/* [Cable] */
// Cable diameter (two-conductor shielded)
cable_d = 5;

/* [Shell] */
wall = 3;
floor_t = 3;
tread_t = 5;
// Tread skirt: how far it hangs below the tread's underside, and its clearance outside the walls
skirt_h = 10;
skirt_clear = 1.0;
// Rubber feet: recess diameter and depth
foot_d = 12.5;
foot_depth = 1.5;

/* [Hidden] */
$fn = 64;
eps = 0.01;
ang = atan((h_toe - h_heel) / len_x);       // tread slope at rest
hx = knuckle_r;                              // hinge axis, from the heel
hz = h_heel;
koff = max(0, knuckle_r - tread_t);          // tread's underside above the hinge axis, so the knuckle prints flat
puck_h = 6;                                  // puck below the tread's underside, pad included
plane = -(puck_h + gap);                     // sensor plane in the tread frame (z')
tl = (len_x - hx) / cos(ang);                // the base's length, along the tread from the hinge
// Board placement: the tail runs heel-ward from the pad; the board starts
// under the tail's last 5 mm
b_x1 = sensor_x - fsr_pad / 2 - fsr_tail[1] + 5;
b_x0 = b_x1 - board[0];
ped_x0 = b_x0 - 4;
ped_x1 = sensor_x + fsr_pad / 2 + 4;
ped_w = max(fsr_pad, board[1]) + 8;
wall_top = -(stop_travel * tl / sensor_x) - 1.5; // walls stay clear of the pressed tread's skirt line

echo(str("FSR pedal: tread at ", ang, " deg; sensor plane ", hz + sensor_x * sin(ang) + (plane + koff) * cos(ang),
         " mm above the floor's underside at the sensor; board ", board, " mm from x' = ", b_x0, " to ", b_x1));
echo(str("Springs: ", spring_free - spring_preload, " mm long at rest; the stops take over after ",
         stop_travel, " mm at the puck (", stop_travel - gap, " mm of pad compression)"));

module tframe(p = 0) {
    // the tread frame, pressed p mm at the puck
    translate([hx, 0, hz]) rotate([0, -(ang - atan(p / sensor_x)), 0]) translate([0, 0, koff]) children();
}

module rbox(s, r = 4) {
    // box with rounded vertical edges, from the origin
    hull() for (x = [r, s[0] - r], y = [r, s[1] - r]) translate([x, y, 0]) cylinder(r = r, h = s[2]);
}

// ------------------------------------------------------------------ base
module base_shell() {
    difference() {
        intersection() {
            translate([0, -wid_y / 2, 0]) rbox([len_x, wid_y, 200]);
            // below the walls' top line
            tframe() translate([-50, -wid_y, wall_top - 300]) cube([len_x + 100, 2 * wid_y, 300]);
        }
        intersection() {
            translate([wall, -wid_y / 2 + wall, floor_t]) rbox([len_x - 2 * wall, wid_y - 2 * wall, 300], 2);
            translate([0, -wid_y, 0]) cube([len_x * 2, wid_y * 2, 300]);
        }
        // rubber feet
        for (x = [18, len_x - 18], y = [-wid_y / 2 + 18, wid_y / 2 - 18])
            translate([x, y, -eps]) cylinder(d = foot_d, h = foot_depth + eps);
        // cable exit through the heel wall, below the hinge
        translate([-1, -wid_y / 4, floor_t + cable_d / 2 + 1]) rotate([0, 90, 0]) cylinder(d = cable_d + 0.6, h = wall + 2);
    }
}

module pedestal() {
    difference() {
        intersection() {
            tframe() translate([ped_x0, -ped_w / 2, plane - 200]) cube([ped_x1 - ped_x0, ped_w, 200]);
            translate([0, -wid_y, floor_t - eps]) cube([len_x, 2 * wid_y, 200]);
        }
        tframe() {
            // sensor seat, tail channel, board pocket
            translate([sensor_x - fsr_pad / 2 - 0.3, -fsr_pad / 2 - 0.3, plane - fsr_seat])
                cube([fsr_pad + 0.6, fsr_pad + 0.6, 1]);
            translate([b_x1 - 6, -fsr_tail[0] / 2 - 0.4, plane - fsr_seat])
                cube([sensor_x - fsr_pad / 2 - b_x1 + 7, fsr_tail[0] + 0.8, 1]);
            translate([b_x0 - 0.3, -board[1] / 2 - 0.3, plane - board_t])
                cube([board[0] + 0.6, board[1] + 0.6, board_t + 1]);
            // board inserts at two corners
            for (p = [[b_x0 + 4, -board[1] / 2 + 4], [b_x0 + 4, board[1] / 2 - 4]])
                translate([p[0], p[1], plane - board_t - insert_depth]) cylinder(d = insert_d, h = insert_depth + 1);
            // cable slot from the board's heel end down the pedestal's heel face
            translate([ped_x0 - 1, board[1] / 2 - 4 - cable_d / 2 - 1, plane - board_t - cable_d - 1])
                cube([b_x0 - ped_x0 + 2, cable_d + 2, cable_d + 2]);
        }
    }
}

module spring_posts() {
    for (s = [-1, 1]) {
        difference() {
            intersection() {
                tframe() translate([spring_x, s * (wid_y / 2 - wall - spring_od), -(spring_free - spring_preload) - 200])
                    cylinder(d = spring_od + 6, h = 200);
                translate([0, -wid_y, floor_t - eps]) cube([len_x, 2 * wid_y, 200]);
            }
            // cup for the spring
            tframe() translate([spring_x, s * (wid_y / 2 - wall - spring_od), -(spring_free - spring_preload) - 3])
                cylinder(d = spring_od + 0.8, h = 10);
        }
    }
}

module stop_posts() {
    for (s = [-1, 1])
        intersection() {
            tframe() translate([sensor_x - 6, s * (ped_w / 2 + 9) - 6, -stop_travel - 200]) cube([12, 12, 200]);
            translate([0, -wid_y, floor_t - eps]) cube([len_x, 2 * wid_y, 200]);
        }
}

module hinge_base() {
    kw = 14;                                      // each base knuckle's width
    for (s = [-1, 1])
        difference() {
            hull() {
                translate([hx, s * (wid_y / 2 - kw / 2), hz]) rotate([90, 0, 0]) cylinder(r = knuckle_r, h = kw, center = true);
                translate([0, s * (wid_y / 2 - kw / 2) - kw / 2, 0]) cube([hx + knuckle_r, kw, 1]);
            }
            translate([hx, 0, hz]) rotate([90, 0, 0]) cylinder(d = pin_d, h = wid_y + 2, center = true);
        }
}

module base() {
    difference() {
        union() {
            base_shell();
            pedestal();
            spring_posts();
            stop_posts();
            hinge_base();
        }
        // room for the tread's centre knuckle, swinging, in the heel wall
        translate([hx, 0, hz]) rotate([90, 0, 0]) cylinder(r = knuckle_r + 0.8, h = wid_y - 28, center = true);
        // pin hole through the side walls too
        translate([hx, 0, hz]) rotate([90, 0, 0]) cylinder(d = pin_d, h = wid_y + 2, center = true);
    }
}

// ------------------------------------------------------------------ tread
module tread_body() {
    kw = 14;
    ow = wid_y + 2 * (skirt_clear + wall);         // over the skirt
    difference() {
        union() {
            // plate
            translate([0, -ow / 2, 0]) rbox([tl + skirt_clear + wall, ow, tread_t], 4);
            // skirt, sides and toe
            difference() {
                translate([0, -ow / 2, -skirt_h]) rbox([tl + skirt_clear + wall, ow, skirt_h + eps], 4);
                translate([-1, -ow / 2 + wall, -skirt_h - 1]) cube([tl + skirt_clear + 1, ow - 2 * wall, skirt_h + 2]);
            }
            // centre knuckle
            translate([0, 0, -koff]) rotate([90, 0, 0]) cylinder(r = knuckle_r, h = wid_y - 2 * kw - 1.2, center = true);
            // puck (its rubber pad, pad_t, is glued to its face)
            translate([sensor_x, 0, -(puck_h - pad_t)]) cylinder(d = puck_d, h = puck_h - pad_t + eps);
            // spring bosses
            for (s = [-1, 1]) translate([spring_x, s * (wid_y / 2 - wall - spring_od), -3])
                difference() {
                    cylinder(d = spring_od + 5, h = 3 + eps);
                    translate([0, 0, -1]) cylinder(d = spring_od + 0.8, h = 2.5);
                }
        }
        translate([0, 0, -koff]) rotate([90, 0, 0]) cylinder(d = pin_d, h = wid_y + 20, center = true);
        // notches for the base's knuckles
        for (s = [-1, 1]) translate([-knuckle_r - 2, s > 0 ? wid_y / 2 - kw - 0.6 : -ow / 2 - 1, -skirt_h - koff - 1])
            cube([2 * knuckle_r + 3.5, kw + 0.6 + (ow - wid_y) / 2 + 1, skirt_h + tread_t + koff + 2]);
        // grip grooves across the top
        for (x = [30 : 9 : tl - 10]) translate([x, -wid_y / 2 + 6, tread_t - 1]) cube([3, wid_y - 12, 2]);
    }
}

module tread() { tframe(press) tread_body(); }

// ------------------------------------------------------------------ parts
module sensor_stand_in() {
    tframe() {
        color("goldenrod") translate([sensor_x - fsr_pad / 2, -fsr_pad / 2, plane - fsr_seat]) cube([fsr_pad, fsr_pad, 0.45]);
        color("goldenrod") translate([sensor_x - fsr_pad / 2 - fsr_tail[1], -fsr_tail[0] / 2, plane - fsr_seat]) cube([fsr_tail[1], fsr_tail[0], 0.3]);
        color("darkgreen") translate([b_x0, -board[1] / 2, plane - board_t]) cube([board[0], board[1], board_t]);
        color("black") translate([sensor_x, 0, -puck_h]) cylinder(d = puck_d, h = pad_t);
    }
}

if (part == "assembly") {
    color("lightsteelblue") base();
    sensor_stand_in();
    color("slategray", 0.85) tread();
} else if (part == "base") {
    base();
} else if (part == "tread") {
    // top face down on the bed
    rotate([180, 0, 0]) translate([0, 0, -tread_t]) tread_body();
}
