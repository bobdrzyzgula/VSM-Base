// Reflective hand-wheel encoder: the sensor head and the label's centering jig
// Written by Claude at Bob Drzyzgula's direction, 2026-11-17. A concept to
// print and try; it has not been built.
//
// A printed annulus of black and white stripes, stuck to the flat back face
// of the hand wheel, is read by two reflective sensors (Pololu QTR-1A
// boards: a QRE1113-class infrared LED and phototransistor, with their
// resistors) a quarter-cycle apart along the track, which gives quadrature:
// the count and the direction. The label comes from make_label.py. The
// index comes from elsewhere: a magnet on the hook-drive link under the bed
// and a Hall switch (see the README).
//
// This file models the business end only: the head that carries the two
// boards and faces the label, and the jig that centers the label on the
// wheel. How the head is held in place is left to a bracket designed
// later; it attaches to the head's back face by two heat-set inserts.
//
// Frame: the wheel's axis is Z; its back face (with the label) is the plane
// Z = 0, facing -Z, toward the head. The head's sensors sit on the +X axis
// side, at radius sensor_r.
//
// part = "assembly" shows the head under a stand-in wheel; "head" and "jig"
// are the printed parts, in print orientation.

part = "assembly"; // [assembly, head, jig]

/* [Wheel and label] */
// The flat annulus on the wheel's back face, as measured (Singer 99K, Nov 2026)
annulus_id = 45;
annulus_od = 65;
// Stripe cycles (one black and one white stripe each) a turn; four counts each
cycles = 48; // [24 : 4 : 120]
// Radius the sensors read at (default: the middle of the annulus)
sensor_r = 0; // [0 : 0.5 : 35]

/* [Sensor boards] */
// Board outline: length, width, PCB thickness (Pololu QTR-1A: 12.7 x 7.62 x 1.6)
board = [12.7, 7.62, 1.6];
// Height of the board with its sensor, from the PCB's back to the sensor's face (QTR-1A: 2.54)
board_h = 2.54;
// Sensor center from the board's end, along its length (check your boards)
sensor_off = 3.8;
// Clearance around each board in its pocket
board_clear = 0.2;
// Gap from the sensor's face to the label (the boards' best range, set on the test card)
sensor_gap = 1.5; // [0.5 : 0.1 : 5]
// Gap from the head's face to the label: the hood that keeps room light out
face_clear = 0.5; // [0.2 : 0.1 : 2]
// Least distance between the two sensors along the track (sets the quadrature spacing)
min_spacing = 9;

/* [Head body] */
// Wall around the boards
wall = 1.6;
// Where the head reaches past the annulus, its face steps back this much more, to clear the hub and rim
outside_relief = 1.5;
// Thickness behind the boards' pockets, for the inserts and the bracket
back_t = 6;
// Heat-set inserts in the back face, for the bracket: hole diameter, depth, spacing
insert_d = 4.0;
insert_depth = 5;
insert_spacing = 16;
// Lead slot through the floor at each board's outer end: length along the board, width
lead_slot = [3.5, 5];

/* [Centering jig] */
// The wheel's bore (taken off the shaft): the jig's spigot fits it
wheel_bore = 12.7;
// A hub boss standing up from the back face inside the annulus, if any: diameter, height (0 = none)
hub_boss = [0, 0];
// Clearance on the spigot and around the label's hole
jig_clear = 0.15;

/* [Hidden] */
$fn = 96;
eps = 0.01;
r_s = sensor_r > 0 ? sensor_r : (annulus_id + annulus_od) / 4;
pitch_deg = 360 / cycles;
pitch_mm = 2 * PI * r_s / cycles;
// The sensors are a whole number of cycles and a quarter apart: the least such that clears min_spacing
k = max(0, ceil(min_spacing / pitch_mm - 0.25));
sep_deg = (k + 0.25) * pitch_deg;
sep_mm = 2 * r_s * sin(sep_deg / 2);
recess = sensor_gap - face_clear;            // sensor face below the head's face
pocket_d = board_h + recess;                 // pocket depth from the head's face
head_t = pocket_d + back_t;
label_id = annulus_id + 1;                   // as make_label.py draws it
label_od = annulus_od - 1;
// The pockets' reach across the track, inner and outer radius (corners of the turned boards)
function rot2(p, a) = [p[0] * cos(a) - p[1] * sin(a), p[0] * sin(a) + p[1] * cos(a)];
pk_r = [for (x = [-1, 1], y = [-sensor_off - board_clear, board[0] - sensor_off + board_clear])
        let (q = rot2([x * (board[1] / 2 + board_clear), y], atan((board[0] / 2 - sensor_off) / r_s)))
        norm([r_s + q[0], q[1]])];

echo(str("Encoder: ", cycles, " cycles, ", 4 * cycles, " counts a turn (",
         360 / (4 * cycles), " deg each); pitch ", pitch_mm, " mm at r = ", r_s,
         " mm (stripes ", pitch_mm / 2, " mm)"));
echo(str("Sensors ", k, " 1/4 cycles apart: ", sep_deg, " deg, ", sep_mm,
         " mm between centers; head ", head_t, " mm thick, face ", face_clear,
         " mm from the label, sensors ", sensor_gap, " mm"));
echo(str("Pockets reach from r = ", min(pk_r), " to ", max(pk_r), " mm; the annulus is ",
         annulus_id / 2, " to ", annulus_od / 2));
if (min(pk_r) < annulus_id / 2 || max(pk_r) > annulus_od / 2)
    echo("WARNING: a board reaches past the annulus; check sensor_r and the board size");
if (sep_mm < 2 * sensor_off + 2 * board_clear + 0.8)
    echo("WARNING: the boards' pockets overlap; raise min_spacing");

// The two boards: board a's sensor at -sep/2, board b's at +sep/2, each
// board running outward from its sensor end (so the leads leave at the
// head's two ends). Each board is turned a little off the tangent, so the
// track's curve falls evenly on its two ends and the whole board stays over
// the annulus.
function sang(i) = (i == 0 ? -1 : 1) * sep_deg / 2;
chord_yaw = atan((board[0] / 2 - sensor_off) / r_s);
module at_sensor(i) {
    rotate(sang(i)) translate([r_s, 0, 0])
        mirror([0, i == 0 ? 1 : 0, 0]) rotate(chord_yaw) children();
}
// In a board's frame: the sensor at the origin, the board running +Y from
// it (sensor_off from its near end), across the track along X.
module board_outline(c = 0) {
    translate([-board[1] / 2 - c, -sensor_off - c])
        square([board[1] + 2 * c, board[0] + 2 * c]);
}

// The head, in place: face at Z = -face_clear, body below it.
module head_placed() {
    z0 = -face_clear;
    difference() {
        // Body: the hull of the two pockets plus walls
        translate([0, 0, z0 - head_t])
            linear_extrude(height = head_t)
                hull() for (i = [0, 1]) at_sensor(i) board_outline(board_clear + wall);
        // Its face stepped back outside the annulus
        translate([0, 0, z0 - outside_relief]) difference() {
            cylinder(h = outside_relief + 1, r = annulus_od);
            translate([0, 0, -1]) difference() {
                cylinder(h = outside_relief + 3, d = annulus_od);
                cylinder(h = outside_relief + 3, d = annulus_id);
            }
        }
        for (i = [0, 1]) at_sensor(i) {
            // Pocket for the board, open to the face
            translate([0, 0, z0 - pocket_d])
                linear_extrude(height = pocket_d + eps) board_outline(board_clear);
            // Lead slot through the floor at the board's outer end
            translate([-lead_slot[1] / 2, board[0] - sensor_off - lead_slot[0], z0 - head_t - eps])
                cube([lead_slot[1], lead_slot[0] + board_clear, head_t + 2 * eps]);
        }
        // Inserts in the back face, either side of the middle along the track
        for (s = [-1, 1])
            rotate(s * min(sep_deg / 2, asin(insert_spacing / 2 / r_s))) translate([r_s, 0, z0 - head_t - eps])
                cylinder(h = insert_depth + eps, d = insert_d);
    }
}

// Stand-ins for the boards, to see them in place
module boards_placed() {
    for (i = [0, 1]) at_sensor(i) translate([0, 0, -sensor_gap - board_h]) {
        color("darkgreen") linear_extrude(height = board[2]) board_outline();
        color("black") translate([-1.8, -1.45, 0]) cube([3.6, 2.9, board_h]);
    }
}

// The label, drawn as make_label.py prints it (for the assembly view)
module label_placed() {
    translate([0, 0, 0]) {
        color("white") difference() {
            cylinder(h = 0.1, d = label_od);
            translate([0, 0, -eps]) cylinder(h = 0.2, d = label_id);
        }
        color("black") translate([0, 0, -0.01])
            for (j = [0 : cycles - 1]) rotate(j * pitch_deg)
                linear_extrude(height = 0.12)
                    intersection() {
                        difference() { circle(d = label_od); circle(d = label_id); }
                        polygon([[0, 0], [100, 0], [100 * cos(pitch_deg / 2), 100 * sin(pitch_deg / 2)]]);
                    }
    }
}

// The jig: a spigot that fits the wheel's bore, under a disc that fits the
// label's hole. With the wheel off the machine, back face up: seat the jig,
// drop the label over the disc, press it down from the jig outward, lift
// the jig out. Printed disc-down.
jig_disc_h = 4;
jig_spigot_h = 8;
module jig() {
    difference() {
        union() {
            cylinder(h = jig_disc_h + hub_boss[1], d = label_id - 2 * jig_clear);
            translate([0, 0, jig_disc_h + hub_boss[1] - eps])
                cylinder(h = jig_spigot_h, d = wheel_bore - 2 * jig_clear);
            // A knob to lift it by
            translate([0, 0, -6]) cylinder(h = 6 + eps, d1 = 14, d2 = 18);
        }
        if (hub_boss[0] > 0)
            translate([0, 0, jig_disc_h]) difference() {
                cylinder(h = hub_boss[1] + eps, d = hub_boss[0] + 2 * jig_clear);
                cylinder(h = hub_boss[1] + 2 * eps, d = wheel_bore - 2 * jig_clear);
            }
    }
}

if (part == "assembly") {
    // Stand-in wheel face, cut away to show the head
    color("dimgray", 0.35) difference() {
        cylinder(h = 6, d = annulus_od + 12);
        translate([0, 0, -1]) cylinder(h = 8, d = wheel_bore);
    }
    label_placed();
    color("orange") head_placed();
    boards_placed();
} else if (part == "head") {
    // Face down on the bed: the pockets print as clean openings
    rotate([180, 0, 0]) translate([-r_s, 0, face_clear]) head_placed();
} else if (part == "jig") {
    translate([0, 0, 6]) jig();
}
