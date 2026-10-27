// Shaft fit collars: a set of snap-on test collars for finding the bore a
// printed part (a clamp ring, collar, hub or pulley) needs on a shaft that
// may not be a standard size, measured by what your printer actually makes.
// Written by Claude at Bob Drzyzgula's direction, 2026-10-26.
//
// Each collar is a C-shaped clip that pushes onto the shaft from the side,
// with its bore engraved on a tab. Push each one on where the part will sit:
//   - too small: it won't seat, or seats only with force and sits proud;
//   - too large: it seats easily and turns or slides freely;
//   - right: it seats with a definite snap and turns with light drag.
// Then narrow the search: print a new set centred on the best size with a
// smaller step (for example 0.25, then 0.1, then 0.05 mm).
//
// The bores are what the printer actually makes, which is what matters:
// print the final part in the same filament and the same orientation (bore
// vertical, flat on the bed, as these are) and it will fit the same way.

/* [Search] */
// Middle bore of the set (mm); 12.25 was the Kenmore 158's arm shaft
centre = 12.25;
// Step between collars (mm)
step = 0.25;
// Number of collars (odd keeps the centre in the set)
count = 5;

/* [Collar] */
thickness = 5;        // along the shaft: fits the 5-10 mm of clear shaft
wall = 2.4;           // ring wall
mouth = 0.86;         // mouth width as a fraction of the bore (smaller = firmer snap)
lead = 1.2;           // lead-in chamfer at the mouth
tab = [16, 7];        // label tab, opposite the mouth
gap = 6;              // spacing between collars on the plate

$fn = 96;
eps = 0.01;
font = "Liberation Sans:style=Bold";

bores = [for (i = [0 : count - 1]) centre + (i - (count - 1) / 2) * step];
function label(d) = let(c = round(d * 100), f = c % 100)
    str(floor(c / 100), ".", f < 10 ? "0" : "", f);   // always two decimals: 12.00, 12.25

module collar2d(d) {
    R = d / 2 + wall;
    m = mouth * d;
    difference() {
        union() {
            circle(r = R);
            // the tab, on the side away from the mouth
            translate([-tab[0] / 2, -R - tab[1] + 1]) square([tab[0], tab[1]]);
        }
        circle(d = d);
        // the mouth, with lead-in flares
        translate([-m / 2, 0]) square([m, R + 1]);
        hull() {
            translate([-m / 2, R - lead]) square([m, eps]);
            translate([-m / 2 - lead, R + 1]) square([m + 2 * lead, eps]);
        }
    }
}

module collar(d) {
    R = d / 2 + wall;
    difference() {
        linear_extrude(thickness) collar2d(d);
        // the bore, engraved on the tab
        translate([0, -R - tab[1] / 2 + 1, thickness - 0.6])
            linear_extrude(1) text(label(d), size = 3, font = font, halign = "center", valign = "center");
    }
}

pitch = max(bores) + 2 * wall + gap;
for (i = [0 : count - 1]) translate([i * max(pitch, tab[0] + gap), 0, 0]) collar(bores[i]);
echo(str("Bores: ", bores));
