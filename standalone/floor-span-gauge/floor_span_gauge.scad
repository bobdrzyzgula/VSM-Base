// Floor span gauge: measures the clear floor between two ribs, in a space
// too cramped for a rule or calipers.
// Written by Claude at Bob Drzyzgula's direction, 2026-10-27.
//
// Two printed parts:
//   body   - a low channel that lies on the floor, closed at its back end
//            (one jaw); its open front end is the reading edge
//   slider - a flat bar in the channel, carrying the scale; its front end
//            (the other jaw) comes out of the channel. A spring beam along
//            one side holds it by friction
//
// Use: lay the gauge on the floor between the ribs, closed, the body's back
// against one rib. Push the slider out (a pick in the hole near its tail,
// reached through the channel's open top) until its front
// end meets the other rib. READING: the mark on the slider level with the
// body's front edge is the span, back jaw to front jaw, in millimetres along
// one side of the scale and inches along the other. Everything stands lower
// than a 4 mm rib, so the jaws meet the ribs' faces, and both jaws are
// chamfered at the floor so a cast fillet at a rib's foot doesn't hold them
// off. Photograph it in place, or lift it out without disturbing the slider
// and measure across the jaws with calipers.
//
// Two colours: the scale is raised 0.4 mm on the slider's top face.
// - One extruder: print the slider face up and change filament at the
//   first layer above the face (z = slider_t), or
// - Several: export "slider_marks" too and give it its own filament
//   (it shares the slider's coordinates).
// Print both parts flat, as given; neither needs supports.
// part = "assembly" shows them together at the reading set by "show_at".

part = "assembly"; // [assembly, body, slider, slider_marks]

/* [Size] */
// Slider: length, width, thickness
slide_len = 26;       // [16:0.5:40]
slide_w = 14;         // [10:0.5:18]
slide_t = 1.7;        // [1.2:0.1:2.5]
// The slider stays this far in the channel at full stretch
overlap = 8;          // [5:0.5:15]
// Body: back wall (the fixed jaw), channel floor, walls, the lips over the slider's edges
back_t = 2.0;         // [1.2:0.1:4]
floor_t = 1.0;        // [0.6:0.1:2]
wall_t = 1.4;         // [1:0.1:3]
lip = 0.6;            // [0.3:0.1:1.2]
lip_t = 0.6;          // [0.4:0.1:1.2]
// Clearance round the slider
clr = 0.2;            // [0.1:0.05:0.5]
// The spring beam's interference with the channel wall
grip = 0.3;           // [0:0.05:0.8]
// Chamfer on each jaw's lower edge, for a fillet at the rib's foot
chamfer = 0.8;        // [0:0.1:1.5]

/* [Scale] */
mark_h = 0.4;         // [0.2:0.1:1]
text_size = 2.2;      // [1.4:0.1:3.5]
// Every line in the scale is at least this wide, so the slicer keeps it (a nozzle's width or a little more)
line_w = 0.5;         // [0.3:0.05:0.8]

/* [Show] */
show_at = 36;         // [20:0.5:50]

$fn = 32;
eps = 0.01;
font = "Liberation Sans:style=Bold";

// Frame: the floor is z = 0; the gauge's length runs along +X from the back
// jaw (x = 0) to the reading edge (x = body_len) and on to the front jaw.
body_len = back_t + slide_len;                   // also the smallest reading
max_read = body_len + slide_len - overlap;
in_w = slide_w + 2 * clr;                        // the channel's inside width
body_w = in_w + 2 * wall_t;
body_h = floor_t + slide_t + clr + lip_t;        // the walls' top
echo(str("Floor span gauge reads ", body_len, " to ", max_read, " mm (",
         round(body_len / 25.4 * 1000) / 1000, " to ", round(max_read / 25.4 * 1000) / 1000,
         " in); ", body_w, " mm wide, ", max(body_h, floor_t + slide_t + mark_h), " mm tall"));

// ---------------------------------------------------------------- body
module body() {
    difference() {
        cube([body_len, body_w, body_h]);
        // the channel, open at the front and the top; lips left over the edges
        translate([back_t, wall_t, floor_t]) cube([slide_len + 1, in_w, slide_t + clr]);
        translate([back_t, wall_t + lip, floor_t]) cube([slide_len + 1, in_w - 2 * lip, body_h]);
        // the back jaw's lower edge
        translate([0, -1, 0]) rotate([0, 45, 0]) cube([chamfer * sqrt(2), body_w + 2, chamfer * sqrt(2)], center = true);
    }
}

// ---------------------------------------------------------------- slider
// In its own frame: the front jaw at x = 0, the bar running back along +X,
// its underside at z = 0; the mm edge at y = 0, the inch edge at y = slide_w.
beam_len = overlap + 1;          // the spring beam: along the inch edge, at the tail
beam_w = 1.4;
module slider_bar() {
    difference() {
        union() {
            cube([slide_len - beam_len, slide_w, slide_t]);
            // the tail, with the beam flared so its free end presses the wall by "grip"
            translate([slide_len - beam_len - eps, 0, 0]) linear_extrude(slide_t)
                polygon([[0, 0], [beam_len + eps, 0], [beam_len + eps, slide_w + 2 * clr + grip], [0, slide_w]]);
        }
        // the slit that frees the beam
        translate([slide_len - beam_len, slide_w - beam_w - 0.6, -1]) cube([beam_len + 1, 0.6, slide_t + 2]);
        // pick hole near the tail, between the scales (the channel is open on top,
        // so it can be reached wherever the slider is)
        translate([slide_len - 2, slide_w / 2, -1]) cylinder(d = 1.6, h = slide_t + 2);
        // the front jaw's lower edge (it stands floor_t up, but a fillet can still reach it)
        translate([0, -1, 0]) rotate([0, 45, 0]) cube([chamfer * sqrt(2) * 0.6, slide_w + 2, chamfer * sqrt(2) * 0.6], center = true);
    }
}

// The scale, raised on the top face. A mark at distance d behind the front
// jaw reads body_len + d: it lines up with the body's front edge when the
// slider sticks out by d. The lettering is turned half round, so it reads
// upright with the body's back jaw on the left and the slider to the right.
y_mm0 = lip + clr + 0.3;                  // ticks start just clear of the lips
y_in0 = slide_w - lip - clr - 0.3;
module marks() {
    translate([0, 0, slide_t - eps]) linear_extrude(mark_h + eps) {
        // millimetres, along the y = 0 edge, numbered every 5
        for (v = [ceil(body_len) : floor(max_read)]) {
            d = v - body_len;
            len = v % 5 == 0 ? 2.2 : 1.3;
            translate([d - line_w / 2, y_mm0]) square([line_w, len]);
            if (v % 5 == 0 && d > 1.2)
                translate([d, y_mm0 + 2.5]) rotate(180) fat() text(str(v), size = text_size, font = font, halign = "center", valign = "top");
        }
        // inches, along the y = slide_w edge, ticks every 1/16, labelled at the quarters
        // in decimals (a font's fraction glyphs have strokes too fine to print)
        for (k = [ceil(body_len / 25.4 * 16) : floor(max_read / 25.4 * 16)]) {
            d = k * 25.4 / 16 - body_len;
            len = k % 4 == 0 ? 2.2 : (k % 2 == 0 ? 1.4 : 0.9);
            translate([d - line_w / 2, y_in0 - len]) square([line_w, len]);
            if (k % 4 == 0 && d > 1.2)
                translate([d, y_in0 - 3.0]) rotate(180) fat() text(str(k / 16),
                                                 size = text_size, font = font, halign = "center", valign = "bottom");
        }
        // the units, near the tail (always inside the channel when reading)
        translate([slide_len - overlap + 2.5, y_mm0 + 2.5]) rotate(180) fat() text("mm", size = text_size * 0.8, font = font, halign = "right", valign = "top");
        translate([slide_len - overlap + 2.5, y_in0 - 3.0]) rotate(180) fat() text("in", size = text_size * 0.8, font = font, halign = "right", valign = "bottom");
    }
}

// thicken lettering so no stroke is narrower than about line_w: a bold font's
// strokes at this size are only about 0.3 mm, and a slicer drops anything much
// under its line width (the first print came out as scattered blobs)
module fat() offset(delta = max(line_w - 0.14 * text_size, 0) / 2) children();

// ---------------------------------------------------------------- views
// the slider in the body's frame, sticking out by e
module slider_at(e) translate([body_len + e, wall_t + clr + slide_w, floor_t]) rotate([0, 0, 180]) children();

if (part == "assembly") {
    color("white") body();
    e = min(max(show_at - body_len, 0), slide_len - overlap);
    slider_at(e) { color("dimgray") slider_bar(); color("white") marks(); }
    echo(str("Shown at ", body_len + e, " mm"));
} else if (part == "body") body();
else if (part == "slider") { slider_bar(); marks(); }
else if (part == "slider_marks") marks();
