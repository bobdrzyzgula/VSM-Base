#!/usr/bin/env python3
"""Draw the measurement diagrams for the guide as SVG.

Usage: tools/make_diagrams.py   (run from the repository root)
Writes docs/images/diagrams/*.svg. The shapes are schematic, drawn roughly
to the Singer 99's proportions; the labels name the model parameters.
"""
import math
import os

OUT = "docs/images/diagrams"

CAST = "#4a4a4a"     # casting
CAST2 = "#7a7a7a"    # thickened areas
EDGE = "#222222"
DIM = "#1f5fa8"      # dimension lines and labels
NOTE = "#555555"
FONT = "font-family='Helvetica, Arial, sans-serif'"


class Svg:
    def __init__(self, w, h):
        self.w, self.h, self.items = w, h, []

    def add(self, s):
        self.items.append(s)

    def rect(self, x, y, w, h, fill, stroke=EDGE, rx=0, sw=1.5, dash=None):
        d = f" stroke-dasharray='{dash}'" if dash else ""
        self.add(f"<rect x='{x:.1f}' y='{y:.1f}' width='{w:.1f}' height='{h:.1f}' "
                 f"rx='{rx}' fill='{fill}' stroke='{stroke}' stroke-width='{sw}'{d}/>")

    def circle(self, x, y, r, fill="white", stroke=EDGE, sw=1.5, dash=None):
        d = f" stroke-dasharray='{dash}'" if dash else ""
        self.add(f"<circle cx='{x:.1f}' cy='{y:.1f}' r='{r:.1f}' fill='{fill}' "
                 f"stroke='{stroke}' stroke-width='{sw}'{d}/>")

    def line(self, x1, y1, x2, y2, stroke=DIM, sw=1.2, dash=None):
        d = f" stroke-dasharray='{dash}'" if dash else ""
        self.add(f"<line x1='{x1:.1f}' y1='{y1:.1f}' x2='{x2:.1f}' y2='{y2:.1f}' "
                 f"stroke='{stroke}' stroke-width='{sw}'{d}/>")

    def poly(self, pts, fill, stroke=EDGE, sw=1.5):
        p = " ".join(f"{x:.1f},{y:.1f}" for x, y in pts)
        self.add(f"<polygon points='{p}' fill='{fill}' stroke='{stroke}' stroke-width='{sw}'/>")

    def text(self, x, y, s, size=14, fill=DIM, anchor="middle", weight="normal",
             italic=False, rotate=None):
        st = " font-style='italic'" if italic else ""
        rot = f" transform='rotate({rotate} {x:.1f} {y:.1f})'" if rotate is not None else ""
        self.add(f"<text x='{x:.1f}' y='{y:.1f}' {FONT} font-size='{size}' "
                 f"fill='{fill}' text-anchor='{anchor}' font-weight='{weight}'{st}{rot}>"
                 f"{s}</text>")

    def arrow_head(self, x, y, ang):
        a = math.radians(ang)
        l, w = 9, 4
        bx, by = x - l * math.cos(a), y - l * math.sin(a)
        px, py = -math.sin(a) * w, math.cos(a) * w
        self.poly([(x, y), (bx + px, by + py), (bx - px, by - py)], DIM, DIM, 0.5)

    def dim_h(self, x1, x2, y, label, ext_from=None, below=False):
        """Horizontal dimension at height y between x1 and x2."""
        if ext_from is not None:
            for x in (x1, x2):
                self.line(x, ext_from, x, y + (6 if below else -6) * -1, sw=0.8)
        self.line(x1, y, x2, y)
        self.arrow_head(x1, y, 180)
        self.arrow_head(x2, y, 0)
        self.text((x1 + x2) / 2, y + (18 if below else -7), label)

    def dim_v(self, x, y1, y2, label, ext_from=None, left=False):
        if ext_from is not None:
            for y in (y1, y2):
                self.line(ext_from, y, x + (-6 if left else 6), y, sw=0.8)
        self.line(x, y1, x, y2)
        self.arrow_head(x, y1, -90)
        self.arrow_head(x, y2, 90)
        if left:
            self.text(x - 8, (y1 + y2) / 2 + 5, label, anchor="end")
        else:
            self.text(x + 8, (y1 + y2) / 2 + 5, label, anchor="start")

    def save(self, name):
        os.makedirs(OUT, exist_ok=True)
        body = "\n".join(self.items)
        with open(os.path.join(OUT, name), "w") as f:
            f.write(f"<svg xmlns='http://www.w3.org/2000/svg' width='{self.w}' "
                    f"height='{self.h}' viewBox='0 0 {self.w} {self.h}'>\n"
                    f"<rect width='100%' height='100%' fill='white'/>\n{body}\n</svg>\n")


S = 2.0                              # px per mm
L, W = 309.6, 166.7                  # Singer 99 bed
INSET = 36.5


def bed_plan():
    """Top view: bed length, width, hinge-hole inset."""
    ox, oy = 90, 70
    s = Svg(int(L * S + 320), int(W * S + 190))
    s.rect(ox, oy, L * S, W * S, CAST, rx=10)
    s.text(ox + L * S / 2, oy + W * S / 2 + 6, "bed top surface", 16, "white")
    s.text(ox + L * S / 2, oy - 40, "BACK (hinge side)", 13, NOTE, weight="bold")
    s.text(ox + L * S / 2, oy + W * S + 62, "FRONT (operator side)", 13, NOTE, weight="bold")
    s.text(ox - 55, oy + W * S / 2, "LEFT (needle end)", 13, NOTE, weight="bold", rotate=-90)
    s.text(ox + L * S + 165, oy + W * S / 2, "RIGHT (handwheel end)", 13, NOTE,
           weight="bold", rotate=90)
    # hinge holes, in the rear skirt below the back edge
    for x in (INSET, L - INSET):
        s.circle(ox + x * S, oy + 9, 6, "white", dash="3,2")
    s.text(ox + L * S / 2, oy + 30, "hinge holes (in the rear skirt, below the edge)",
           12, "#dddddd", italic=True)
    # inset dims
    s.dim_h(ox, ox + INSET * S, oy - 14, "hinge_hole_inset_in", ext_from=oy)
    s.dim_h(ox + (L - INSET) * S, ox + L * S, oy - 14, "hinge_hole_inset_in", ext_from=oy)
    # length and width
    s.dim_h(ox, ox + L * S, oy + W * S + 30, "bed_length_in", ext_from=oy + W * S,
            below=False)
    s.dim_v(ox + L * S + 22, oy, oy + W * S, "", ext_from=ox + L * S)
    s.text(ox + L * S + 30, oy + W * S / 2 + 5, "bed_width_in", 14, anchor="start")
    s.save("bed-plan.svg")


def bed_section():
    """Section through the back edge at a hinge hole, seen from the left end."""
    s = Svg(940, 360)
    ox, top = 250, 90                   # back edge at x = ox + 380, bed top at y = top
    sc = 6.0                            # px per mm in this view
    t, drop, boss, skirt_w = 7.94, 9.53, 20, 12
    back = ox + 380
    # plate (front is to the left)
    s.rect(ox, top, back - ox, t * sc, CAST)
    # rear boss / skirt
    s.rect(back - skirt_w * sc, top, skirt_w * sc, boss * sc, CAST2)
    s.rect(ox, top, back - ox, t * sc, CAST, sw=0)
    s.line(ox, top, back, top, EDGE, 1.5)
    s.line(back, top, back, top + boss * sc, EDGE, 1.5)
    # hole
    s.circle(back - skirt_w * sc / 2 - 4, top + drop * sc, 0.25 * 25.4 / 2 * sc, "white")
    hx = back - skirt_w * sc / 2 - 4
    s.line(hx - 30, top + drop * sc, hx + 30, top + drop * sc, NOTE, 0.8, "4,3")
    # labels
    s.text(ox + 120, top + t * sc / 2 + 5, "flat bed plate", 14, "white")
    s.text(back - skirt_w * sc - 8, top + boss * sc - 10, "thickened rear boss", 13,
           NOTE, anchor="end", italic=True)
    s.text(ox + 30, top - 14, "FRONT", 12, NOTE, weight="bold")
    s.text(back - 30, top - 14, "BACK", 12, NOTE, weight="bold")
    # dims
    s.dim_v(ox - 20, top, top + t * sc, "bed_plate_thickness_in", ext_from=ox, left=True)
    s.dim_v(back + 30, top, top + drop * sc, "hinge_hole_drop_in", ext_from=back)
    s.dim_v(back + 30 + 170, top, top + boss * sc, "relief thickness", ext_from=back)
    s.line(back, top + boss * sc, back + 30 + 176, top + boss * sc, DIM, 0.8)
    s.text(470, 335, "Section through the back edge at a hinge hole, seen from the left end.",
           12, NOTE, italic=True)
    s.save("bed-section.svg")


def bed_underside():
    """Underside: thickened areas and how their positions are measured."""
    ox, oy = 110, 90
    s = Svg(int(L * S + 230), int(W * S + 230))
    s.rect(ox, oy, L * S, W * S, CAST, rx=10)
    # cavity area (just to show the bed from below)
    s.rect(ox + 16 * S, oy + 16 * S, (L - 32) * S, (W - 32) * S, "#5c5c5c", sw=0.8)
    ends = 76.2
    for x in (0, L - 14):
        s.rect(ox + x * S, oy + (W / 2 - ends / 2) * S, 14 * S, ends * S, CAST2)
    for xc in (INSET, L - INSET):
        s.rect(ox + (xc - 25.4) * S, oy, 50.8 * S, 14 * S, CAST2)
    s.text(ox + L * S / 2, oy + W * S / 2 + 6, "underside (machine upside down, back at top)",
           14, "white")
    s.text(ox + 14 * S + 8, oy + W * S / 2 - 70, "end boss", 12, "#eeeeee", anchor="start")
    s.text(ox + INSET * S, oy + 14 * S + 18, "hinge boss", 12, "#eeeeee")
    # back boss: center from left end, length
    s.dim_h(ox, ox + INSET * S, oy - 44, "center (from left end)", ext_from=oy)
    s.dim_h(ox + (INSET - 25.4) * S, ox + (INSET + 25.4) * S, oy - 14, "length",
            ext_from=oy)
    # end boss: center from front edge, length
    yb = oy + W * S
    s.dim_v(ox - 52, yb, oy + W / 2 * S, "", ext_from=ox)
    s.text(ox - 60, oy + W * S * 0.75, "center (from front edge)", 13, anchor="middle",
           rotate=-90)
    s.dim_v(ox - 16, oy + (W / 2 - ends / 2) * S, oy + (W / 2 + ends / 2) * S, "",
            ext_from=ox)
    s.text(ox - 22, oy + W * S / 2 - 50, "length", 13, rotate=-90, anchor="middle")
    s.text(ox + L * S / 2, oy + W * S + 40, "FRONT", 12, NOTE, weight="bold")
    s.text(ox + L * S / 2, oy + W * S + 75,
           "Each thickened area is one bed_reliefs entry: [edge, center, length, thickness].",
           13, NOTE, italic=True)
    s.save("bed-underside.svg")


def bobbin_plate():
    """Top view of the left end with the slide plate pulled out."""
    sc = 2.4
    ox, oy = 230, 60
    bw = 166.7
    s = Svg(860, int(bw * sc + 150))
    # bed (left part only)
    s.rect(ox, oy, 140 * sc, bw * sc, CAST, rx=8)
    pw, pl, out = 55.6, 70, 31.75
    py = oy + (bw / 2 - pw / 2) * sc
    # plate, slid out past the left edge
    s.rect(ox - out * sc, py, pl * sc, pw * sc, "#c9ced4")
    s.text(ox + 8, py + pw * sc / 2 + 5, "slide plate", 13, EDGE, anchor="start")
    s.line(ox, oy - 10, ox, oy + bw * sc + 10, NOTE, 1.0, "5,4")
    s.text(ox + 8, oy + bw * sc + 28, "edge of casting", 12, NOTE, anchor="start", italic=True)
    # dims
    s.dim_h(ox - out * sc, ox, py - 16, "")
    s.text(ox - out * sc - 6, py - 28, "travel past the edge", 13, anchor="end")
    s.dim_v(ox - out * sc - 22, py, py + pw * sc, "", ext_from=ox - out * sc)
    s.text(ox - out * sc - 30, py + pw * sc / 2, "width", 13, rotate=-90)
    yb = oy + bw * sc
    s.dim_v(ox + 140 * sc + 24, oy + bw / 2 * sc, yb, "center (from front edge)",
            ext_from=ox + 140 * sc)
    s.text(ox + 70 * sc, yb + 50, "FRONT", 12, NOTE, weight="bold")
    s.text(430, yb + 80, "left_trench = [center, width, length, depth]", 13, NOTE,
           italic=True)
    s.save("bobbin-plate.svg")


if __name__ == "__main__":
    bed_plan()
    bed_section()
    bed_underside()
    bobbin_plate()
