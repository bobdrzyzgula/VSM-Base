// SPDX-License-Identifier: MIT
// Nut tool: a rod that carries a nut up a nut trap and holds it at its seat
// Copyright (c) 2026 Robert Drzyzgula
// All dimensions in mm unless noted.
//
// Push a nut onto the tip, slide it up the trap until it seats, and hold it
// there while you start the screw from the other side; once the screw has
// caught a couple of threads, pull the tool out and finish. The trap's hex
// keeps the nut from turning. The shaft is round and a little under the
// nut's width across flats, so it passes the trap; the shoulder at its end
// pushes the nut; the tip, tapered, holds the nut by its bore (the nylon
// insert of a locknut grips it well) and is pointed to find the hole.
//
// Pick a nut size, or "custom" and give the sizes yourself. Set the shaft
// length to the depth of your trap, from the face you push from to the
// nut's seat, less the nut's thickness. Print standing on the handle; no
// supports. Self-contained: no libraries needed.
//
// Spun off from the VSM Base (https://github.com/bobdrzyzgula/VSM-Base).

/* [Nut] */
// Nut size (sizes from common hex and nylon-insert locknuts); custom = use the settings below
nut_size = "#8-32"; // [#4-40, #6-32, #8-32, #10-24, #10-32, 1/4-20, M3, M4, M5, M6, custom]
// Custom: nut width across flats
custom_across_flats = 8.73; // [3 : 0.01 : 25]
// Custom: tip diameter, to fit the nut's bore (a locknut's nylon insert, about the thread's minor diameter)
custom_tip_d = 3.0; // [1 : 0.05 : 12]

/* [Tool] */
// Tip diameter; 0 = from the nut size
tip_d = 0; // [0 : 0.05 : 12]
// Tip length (keep it shorter than the nut, so the screw can catch before the tool comes out)
tip_len = 3; // [1 : 0.5 : 10]
// Tip taper: the tip is this much fatter at its root than at its end, so the bore grips it
tip_taper = 0.6; // [0 : 0.05 : 2]
// Shaft diameter; 0 = 1.2 mm under the nut's width across flats
shaft_d = 0; // [0 : 0.1 : 30]
// Shaft length, from the handle to the shoulder that pushes the nut
shaft_len = 58.7; // [5 : 0.5 : 250]
// Handle diameter
handle_d = 20; // [8 : 0.5 : 50]
// Handle length
handle_len = 16; // [5 : 0.5 : 60]
// Number of tools, side by side
count = 1; // [1 : 1 : 10]

/* [Hidden] */
// [name, across flats, tip diameter]
sizes = [["#4-40", 6.35, 2.2], ["#6-32", 7.94, 2.6], ["#8-32", 8.73, 3.0],
         ["#10-24", 9.53, 3.5], ["#10-32", 9.53, 3.8], ["1/4-20", 11.11, 5.0],
         ["M3", 5.5, 2.4], ["M4", 7.0, 3.2], ["M5", 8.0, 4.1], ["M6", 10.0, 4.9]];
row  = [for (r = sizes) if (r[0] == nut_size) r];
af   = nut_size == "custom" || len(row) == 0 ? custom_across_flats : row[0][1];
tip  = tip_d > 0 ? tip_d : nut_size == "custom" || len(row) == 0 ? custom_tip_d : row[0][2];
sd   = shaft_d > 0 ? shaft_d : af - 1.2;
hd   = max(handle_d, sd + 4);
$fs = 0.3;
$fa = 4;

echo(str("Nut tool: ", nut_size, " (", af, " mm across flats); shaft ", sd, " x ", shaft_len,
         " mm; tip ", tip + tip_taper / 2, " to ", tip - tip_taper / 2, " mm over ", tip_len,
         " mm; handle ", hd, " x ", handle_len, " mm"));
if (sd >= af)
    echo("WARNING: the shaft is as wide as the nut across flats; it won't pass the trap");
if (tip >= sd - 1)
    echo("WARNING: the tip leaves under 0.5 mm of shoulder to push the nut");

for (i = [0 : count - 1]) translate([i * (hd + 6), 0, 0]) nut_tool();

module nut_tool() {
    // fluted handle
    difference() {
        cylinder(h = handle_len, d = hd, $fn = 48);
        n = max(6, round(hd * PI / 5));
        for (k = [0 : n - 1]) rotate(k * 360 / n)
            translate([hd / 2 + 0.6, 0, -1]) cylinder(h = handle_len + 2, d = 3, $fn = 16);
    }
    // shaft, with a small chamfer at the shoulder
    translate([0, 0, handle_len - 0.01]) {
        cylinder(h = shaft_len - 0.6 + 0.01, d = sd, $fn = 40);
        translate([0, 0, shaft_len - 0.6]) cylinder(h = 0.6, d1 = sd, d2 = sd - 1.2, $fn = 40);
    }
    // tapered tip and its point
    translate([0, 0, handle_len + shaft_len - 0.01]) {
        cylinder(h = tip_len + 0.01, d1 = tip + tip_taper / 2, d2 = tip - tip_taper / 2, $fn = 24);
        translate([0, 0, tip_len]) cylinder(h = 1, d1 = tip - tip_taper / 2, d2 = max(0.4, tip - tip_taper / 2 - 0.9), $fn = 24);
    }
}
