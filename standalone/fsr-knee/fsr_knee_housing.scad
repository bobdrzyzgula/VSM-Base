// Force-sensing knee controller: spring housing with a force sensor, a draft
// Drawn by Claude at Bob Drzyzgula's direction, November 2026. A concept to
// print and try; it has not been printed, fitted or tested.
//
// The VSM Base's knee controller turns a pot through two gear stages. This
// draft replaces the gears and the pot with a force sensor beside the return
// spring, for the analog controller in the design study "An Analog
// Force-Sensing Knee Controller" (docs/analog-knee/, sections 5 and 6).
//
// The return-spring side is the main model's, at its defaults: the hub and
// its crank and pin, the compression spring and its cap, the rest screw in
// the roof and the stop screw in the floor. What is new is a sensor tower
// joined to the housing on the shaft side, under the crank:
//
//   - A plunger stands up through a guide bushing at the tower's top. Its
//     domed head sits just under the crank's flat bottom; the crank meets it
//     at contact_travel at the knee, just before the motor's start point,
//     and pushes it down from there to the hard stop.
//   - Under the guide, the plunger's flange bears on a two-spring stack: a
//     soft spring from contact on, and a stiff spring nested inside it that
//     joins after stiff_gap. The force on the sensor rises progressively
//     with travel, which spreads the speed over the knee's travel (the
//     paper's section 5) instead of crowding it into the first millimetres.
//   - The springs press a puck, faced with a thin rubber pad, onto an
//     Interlink FSR 402 lying on the tower's floor. Its tail leaves through
//     a slot in the back wall, through the tongue, into the base.
//   - The return spring keeps its job: the knee's preload, its return, and
//     most of its feel. The sensor sees only the stack's force.
//
// The sensor sits nearer the shaft than the crank pin (sensor_r), so it moves
// less than the pin and adds less to the force at the knee.
//
// The rest switch stays, as the motor's mechanical cutoff (section 3), but
// its cam was on the sector gear, which goes; it needs a cam of its own on
// the shaft, not drawn here.
//
// Frame: the crank pin's centre at rest is the origin; X runs toward the
// shaft (for a knee that pushes right), Z up, Y from the crank's plane back
// toward the base's front face. The draft is the housing alone, to be folded
// into the main model once it has been tried.
//
// part = "assembly" (section view; knee = travel at the knee, mm), or one of
// the printed parts.

part = "assembly"; // [assembly, housing, cap, guide, plunger, puck]
// Assembly: knee travel to show, mm from rest
knee = 0; // [0 : 0.5 : 57.15]

/* [Knee, as the main model's defaults] */
// Knee bar's length below the shaft
bar_drop = 317.5;
// Crank radius, shaft to pin (the main model works out 58 mm at its defaults)
crank_r = 58;
// Knee travel where the motor starts, reaches full speed, and meets the stop (mm)
travel_on = 25.4;
travel_full = 50.8;
travel_max = 57.15;
// Crank pin diameter (3/16" rod), crank thickness, crank top and bottom about the pin
pin_d = 4.7625;
crank_t = 10;
arm_top = 14;
arm_bot = 1.4;
// From the crank's plane back to the base's front face, and the tongue into its pocket
face_y = 7.5;
tongue = 2;

/* [Return spring, as the main model's] */
// Outside diameter, wire, free length (McMaster 9001T46)
spring = [15.24, 1.83, 31.75];
spring_rate = 7.88;
// Preload at rest, mm (24 N)
spring_pre = 3.1;

/* [Sensor] */
// Sensor's distance from the shaft (the pin is at crank_r)
sensor_r = 38;
// Sensor's axis in front of the crank's plane (keeps the bore out of the face)
sensor_dy = -2.5;
// Where the crank first touches the plunger, knee travel (mm)
contact_travel = 24;
// Soft spring: outside diameter, free length, rate N/mm, preload mm
soft = [12, 12, 4.7];
soft_pre = 0.2;
// Stiff spring: outside diameter, rate N/mm; plunger travel before it joins
stiff_od = 7.5;
stiff_rate = 21;
stiff_gap = 1.45;
// FSR 402: pad diameter and thickness (Interlink: 18.29 mm)
fsr_d = 18.3;
fsr_t = 0.45;
// Its tail's slot through the back wall [width, height]; room for a connector
tail_slot = [10, 4];
// Puck (covers the 402's 12.7 mm active area) and its rubber pad
puck_d = 14;
puck_t = 3;
pad_t = 1;
// Plunger: rod and head diameter, flange [diameter, thickness]
rod_d = 5;
flange = [11, 2.5];
// Guide bushing's thickness
guide_t = 4;

/* [Housing] */
bore_clear = 0.5;
hw = 2.5;
cap_t = 4;
// Sensor bore's wall
tw = 2.5;

/* [Hidden] */
$fn = 64;
eps = 0.01;
function th(t) = atan(t / bar_drop);                        // crank angle at knee travel t
function crank_bot(r, t) = -r * sin(th(t)) - arm_bot * cos(th(t));   // crank's bottom at radius r
// Top of a domed head of radius rh at radius r, touching the crank's tilted bottom
function head_top(r, t, rh) = (-arm_bot - rh - r * sin(th(t))) / cos(th(t)) + rh;
pin_r = pin_d / 2;
rb = spring[0] / 2 + bore_clear;
sid = spring[0] - 2 * spring[1];
sp_rest = spring[2] - spring_pre;
stroke = crank_r * sin(th(travel_max));                     // the pin's drop at the stop
// Return-spring side, as the main model
z_ft = -pin_r - cap_t - sp_rest;                            // floor's top (spring seat)
z_fb = z_ft - 6;                                            // housing's bottom
lift = spring_pre + 0.5;
z_rb = arm_top + lift + 1.5;                                // roof's underside
z_rt = z_rb + 7;
x_hs = rb + hw;                                             // spring box's side toward the shaft
y_back = face_y + tongue;
// Sensor tower
xs = crank_r - sensor_r;                                    // its axis
sb = fsr_d / 2 + 0.35;                                      // bore radius
tr = sb + tw;                                               // tower's outside radius
z_g = crank_bot(sensor_r + tr, travel_max) - 1.5;           // tower's top: under the crank's lowest
z_h0 = head_top(sensor_r, contact_travel, rod_d / 2);                 // plunger head's top at rest
function px(t) = max(0, z_h0 - head_top(sensor_r, t, rod_d / 2));     // plunger travel at knee travel t
z_fl = z_g - guide_t;                                       // flange's top at rest
z_pt = z_fl - flange[1] - (soft[1] - soft_pre);             // puck's top at rest
z_seat = z_pt - puck_t - pad_t - fsr_t;                     // the sensor's seat
stiff_free = z_fl - flange[1] - z_pt + 1 - stiff_gap;       // +1: its seat in the puck
function f_s(x) = soft[2] * (x + soft_pre) + stiff_rate * max(0, x - stiff_gap);
function f_t(t) = f_s(px(t));
function knee_at(f) = let(ts = [for (i = [0 : 600]) i * travel_max / 600], hit = [for (t = ts) if (f_t(t) >= f) t])
    len(hit) > 0 ? hit[0] : -1;
// The return spring's force at the knee, and the sensor stack's addition
function f_knee_ret(t) = (spring_rate * (spring_pre + crank_r * sin(th(t)))) * crank_r * cos(th(t)) / bar_drop;
function f_knee_sen(t) = f_t(t) * sensor_r * cos(th(t)) / bar_drop;

echo(str("FSR knee: plunger travel at the motor's start ", px(travel_on), " mm, at full speed ", px(travel_full),
         " mm, at the stop ", px(travel_max), " mm"));
echo(str("FSR knee: sensor force at the motor's start ", f_t(travel_on), " N, at full speed ", f_t(travel_full),
         " N, at the stop ", f_t(travel_max), " N"));
echo(str("FSR knee: knee travel at 2.8 N (start, RM 10k) ", knee_at(2.8), " mm; at 12 N (50%) ", knee_at(12),
         " mm; at 50 N (90%) ", knee_at(50), " mm"));
echo(str("FSR knee: force at the knee at full speed ", f_knee_ret(travel_full), " N (return spring) + ",
         f_knee_sen(travel_full), " N (sensor); at the stop ", f_knee_ret(travel_max), " + ", f_knee_sen(travel_max), " N"));
echo(str("FSR knee: stiff spring's free length ", stiff_free, " mm; sensor floor ", z_seat - z_fb,
         " mm thick; tower top ", z_g, " mm, plunger head ", z_h0, " mm about the pin"));

// ------------------------------------------------------------------ parts
module housing() {
    difference() {
        union() {
            // spring box, as the main model
            translate([-x_hs, -rb - hw, z_fb]) cube([2 * x_hs, y_back + rb + hw, z_rt - z_fb]);
            // ears, on the outboard side now (the shaft side is the tower)
            for (z = [z_fb + 4, z_rt - 4]) translate([-x_hs - 10 + eps, face_y - 6, z - 4]) cube([10, 6, 8]);
            // sensor tower, joined to the box, cut off at the tongue's back
            intersection() {
                hull() {
                    translate([xs, sensor_dy, z_fb]) cylinder(r = tr, h = z_g - z_fb);
                    translate([0, -rb - hw, z_fb]) cube([eps, y_back + rb + hw, z_g - z_fb]);
                }
                translate([-x_hs, -50, z_fb - 1]) cube([100, 50 + y_back, 100]);
            }
        }
        // spring bore, spigot left standing
        difference() {
            translate([0, 0, z_ft]) cylinder(r = rb, h = z_rb - z_ft);
            translate([0, 0, z_ft - eps]) cylinder(d = sid - 0.6, h = 2);
        }
        // crank slot, from the spring's axis through the shaft side
        translate([0, -crank_t / 2 - 0.5, -stroke - arm_bot - 1.5]) cube([60, crank_t + 1, z_rb + stroke + arm_bot + 1.5 + eps]);
        // front opening, for the crank going in over the cap (as the main model)
        translate([-x_hs - 1, -rb - hw - 1, lift - pin_r - 0.5]) cube([2 * x_hs + 2, rb + hw - crank_t / 2 + 0.5, z_rt]);
        // stop screw (M4) up through the floor, nut captive from below
        translate([0, 0, z_fb - 1]) cylinder(d = 4.5, h = z_ft - z_fb + 4, $fn = 24);
        translate([0, 0, z_fb - eps]) cylinder(d = 8.1, h = 3.6, $fn = 6);
        // rest screw (M4) down through the roof, nut captive from above
        translate([0, 0, z_rb - 1]) cylinder(d = 4.5, h = 10, $fn = 24);
        translate([0, 0, z_rt - 3.6]) cylinder(d = 8.1, h = 3.61, $fn = 6);
        // ear screws (M3) into heat-set inserts in the face
        for (z = [z_fb + 4, z_rt - 4]) translate([-x_hs - 5, face_y + 1, z]) rotate([90, 0, 0]) cylinder(d = 3.4, h = 8, $fn = 20);
        // sensor bore, from the seat up through the tower's top
        translate([xs, sensor_dy, z_seat]) cylinder(r = sb, h = z_g - z_seat + 1);
        // the sensor's tail, out the back through the tongue
        translate([xs - tail_slot[0] / 2, sensor_dy, z_seat - 0.3]) cube([tail_slot[0], 30, tail_slot[1]]);
        // guide's retaining screw (M3), from the front
        translate([xs, sensor_dy - tr - 1, z_g - guide_t / 2]) rotate([-90, 0, 0]) cylinder(d = 3.4, h = tw + 2, $fn = 20);
    }
}

module cap() {
    // the main model's cap: a disc with a spigot into the spring and a hole for the stop screw
    difference() {
        union() {
            cylinder(d = 2 * rb - 0.6, h = cap_t);
            translate([0, 0, -2.5]) cylinder(d = sid - 0.6, h = 2.5 + eps);
        }
        translate([0, 0, -4]) cylinder(d = 5.2, h = cap_t + 5, $fn = 24);
    }
}

module guide() {
    difference() {
        cylinder(r = sb - 0.2, h = guide_t);
        translate([0, 0, -1]) cylinder(d = rod_d + 0.4, h = guide_t + 2, $fn = 32);
        // retaining screw's hole, self-tapped from the front
        translate([0, -sb, guide_t / 2]) rotate([-90, 0, 0]) cylinder(d = 2.6, h = sb - rod_d / 2 - 1.5, $fn = 16);
    }
}

module plunger() {
    // flange at the bottom (z = 0 is the flange's top), rod up to a domed head
    l = z_h0 - z_fl;
    translate([0, 0, -flange[1]]) cylinder(d = flange[0], h = flange[1]);
    cylinder(d = rod_d, h = l - rod_d / 2, $fn = 32);
    translate([0, 0, l - rod_d / 2]) sphere(d = rod_d, $fn = 32);
    // spigot centring the stiff spring under the flange
    translate([0, 0, -flange[1] - 2]) cylinder(d = stiff_od - 2.4, h = 2 + eps, $fn = 32);
}

module puck() {
    difference() {
        cylinder(d = puck_d, h = puck_t);
        translate([0, 0, puck_t - 1]) cylinder(d = stiff_od + 0.6, h = 2);
    }
}

// ------------------------------------------------------------------ assembly
module coil(od, wire, len, turns) {
    for (i = [0 : turns - 1]) translate([0, 0, wire / 2 + i * (len - wire) / (turns - 1)])
        rotate_extrude($fn = 32) translate([od / 2 - wire / 2, 0]) circle(d = wire, $fn = 12);
}
// The main model's crank, about the shaft, its flat bottom now reaching past the tower
module crank2d() {
    xt = -(crank_r - (xs + tr)) + 2;
    offset(r = 1) offset(delta = -1)
        polygon([[-crank_r - 4, -arm_bot], [xt, -arm_bot], [-10, -12], [-10, 12], [-crank_r - 4, arm_top]]);
    circle(r = 13);
}
module crank(t) {
    translate([crank_r, 0, 0]) rotate([0, -th(t), 0]) {
        translate([0, crank_t / 2, 0]) rotate([90, 0, 0]) linear_extrude(height = crank_t) crank2d();
        translate([-crank_r, -crank_t / 2, 0]) rotate([-90, 0, 0]) cylinder(d = pin_d, h = crank_t, $fn = 24);
    }
}


if (part == "assembly") {
    cut = sensor_dy;                                          // section on the sensor's axis
    color("lightsteelblue") intersection() { housing(); translate([-100, cut, -100]) cube(200); }
    color("silver") intersection() { crank(knee); translate([-100, 0, -100]) cube(200); }
    for (c = [["cap", "dimgray"], ["spring", "goldenrod"], ["screw", "silver"], ["plunger", "orange"],
              ["soft", "seagreen"], ["stiff", "darkred"], ["puck", "tan"], ["pad", "black"],
              ["fsr", "gold"], ["guide", "white"]])
        color(c[1]) intersection() { stack_part(c[0]); translate([-100, cut, -100]) cube(200); }
} else if (part == "housing") {
    translate([0, 0, -z_fb]) housing();
} else if (part == "cap") {
    translate([0, 0, cap_t]) rotate([180, 0, 0]) cap();
} else if (part == "guide") {
    guide();
} else if (part == "plunger") {
    translate([0, 0, flange[1] + 2]) plunger();
} else if (part == "puck") {
    puck();
}

// One piece of the moving stack, for colouring
module stack_part(w) {
    t = knee;
    d = crank_r * sin(th(t));
    x = px(t);
    if (w == "cap") translate([0, 0, -pin_r - cap_t - d]) cap();
    if (w == "spring") translate([0, 0, z_ft]) coil(spring[0], spring[1], sp_rest - d, 7);
    if (w == "screw") translate([0, 0, z_fb + 3.6]) cylinder(d = 4, h = -stroke - pin_r - z_fb - 3.6, $fn = 16);
    translate([xs, sensor_dy, 0]) {
        if (w == "guide") translate([0, 0, z_g - guide_t]) guide();
        if (w == "plunger") translate([0, 0, z_fl - x]) plunger();
        if (w == "soft") translate([0, 0, z_pt]) coil(soft[0], 1.0, soft[1] - soft_pre - x, 6);
        if (w == "stiff") translate([0, 0, z_pt - 1]) coil(stiff_od, 1.2, min(stiff_free, z_fl - flange[1] - x - z_pt + 1), 5);
        if (w == "puck") translate([0, 0, z_pt - puck_t]) puck();
        if (w == "pad") translate([0, 0, z_pt - puck_t - pad_t]) cylinder(d = puck_d, h = pad_t);
        if (w == "fsr") {
            translate([0, 0, z_seat]) cylinder(d = fsr_d, h = fsr_t);
            translate([-tail_slot[0] / 2 + 1, 0, z_seat]) cube([tail_slot[0] - 2, 25, fsr_t]);
        }
    }
}
