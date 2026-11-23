#!/usr/bin/env python3
"""Draw the carrying-harness diagram for the User's Guide (docs/images/diagrams/carry-harness.svg).

Drawn by Claude at Bob Drzyzgula's direction, November 2026. A sketch of
one way to carry the base: two lengths of webbing from the four harness
rods, crossing in an X over the machine, through a handle. Dimensions are
the Singer 99K base's defaults; the machine is an outline only.
"""
import os

L, W, H = 431.5, 230.0, 82.7          # base, mm
ROD_X, ROD_Z = 7.0, 7.0               # rod center in from the end face, above the bottom
NOTCH = [(25, 50), (180, 205)]        # notch spans along Y
HANDLE_Z = 387.0                       # handle above the table
S = 1.15                               # px per mm

ink, soft, strap, accent = "#2b2f33", "#8a929a", "#c2582b", "#2f6f9f"
font = "font-family='Helvetica, Arial, sans-serif'"

def t(x, y, s, size=13, anchor="start", color=ink, weight="normal"):
    return f"<text x='{x:.1f}' y='{y:.1f}' {font} font-size='{size}' text-anchor='{anchor}' fill='{color}' font-weight='{weight}'>{s}</text>"

parts = []
# ---------------------------------------------------------------- front view
ox, oy = 90, 40 + HANDLE_Z * S + 10     # origin: base's bottom left, front view
def fx(x): return ox + x * S
def fz(z): return oy - z * S
parts.append(t(ox, 28, "Front view", 15, weight="bold"))
# base
parts.append(f"<rect x='{fx(0):.1f}' y='{fz(H):.1f}' width='{L*S:.1f}' height='{H*S:.1f}' rx='6' fill='#e9ecef' stroke='{ink}' stroke-width='1.5'/>")
for x0 in (0, L):   # handholds (dashed, inside the ends)
    hx = fx(x0 + (16 if x0 == 0 else -16)) - (0 if x0 == 0 else 0)
parts.append(t(fx(L / 2), fz(H / 2) + 5, "base", 13, "middle", soft))
# machine outline (generic flatbed: bed, then head, arm and pillar, and the hand wheel)
bed_x0, bed_x1, bed_top = 60, 370, H + 14
dash = f"fill='none' stroke='{soft}' stroke-width='1.5' stroke-dasharray='5 3'"
parts.append(f"<rect x='{fx(bed_x0):.1f}' y='{fz(bed_top):.1f}' width='{(bed_x1-bed_x0)*S:.1f}' height='{(bed_top-H)*S:.1f}' {dash}/>")
m = [(55, 175), (55, 275), (310, 275), (310, bed_top), (268, bed_top), (268, 238), (118, 238), (118, 175)]
pts = " ".join(f"{fx(x):.1f},{fz(z):.1f}" for x, z in m)
parts.append(f"<polygon points='{pts}' {dash}/>")
parts.append(f"<line x1='{fx(86):.1f}' y1='{fz(175):.1f}' x2='{fx(86):.1f}' y2='{fz(bed_top+6):.1f}' stroke='{soft}' stroke-width='1.5' stroke-dasharray='3 3'/>")
parts.append(f"<circle cx='{fx(338):.1f}' cy='{fz(222):.1f}' r='{38*S:.1f}' {dash}/>")
parts.append(f"<line x1='{fx(200):.1f}' y1='{fz(275):.1f}' x2='{fx(200):.1f}' y2='{fz(318):.1f}' stroke='{soft}' stroke-width='2' stroke-dasharray='4 3'/>")
parts.append(t(fx(190), fz(255), "machine (outline only)", 12, "middle", soft))
parts.append(t(fx(205), fz(322), "spool pin", 11, "start", soft))
# straps: from the rods at each end up to the handle (the front and back straps overlap in this view)
hx, hz = L / 2, HANDLE_Z
for x in (ROD_X, L - ROD_X):
    parts.append(f"<line x1='{fx(x):.1f}' y1='{fz(ROD_Z):.1f}' x2='{fx(hx):.1f}' y2='{fz(hz):.1f}' stroke='{strap}' stroke-width='7' stroke-linecap='round' opacity='0.9'/>")
    # snap hook
    parts.append(f"<circle cx='{fx(x):.1f}' cy='{fz(ROD_Z):.1f}' r='7' fill='white' stroke='{accent}' stroke-width='2.5'/>")
# handle
parts.append(f"<rect x='{fx(hx)-34:.1f}' y='{fz(hz)-20:.1f}' width='68' height='26' rx='12' fill='{accent}' opacity='0.9'/>")
parts.append(t(fx(hx), fz(hz) - 28, "handle", 13, "middle", accent, "bold"))
parts.append(t(fx(hx) + 48, fz(hz) + 2, "high enough to clear the head and spool pins", 12, "start", ink))
parts.append(t(fx(L - ROD_X) - 8, fz(ROD_Z) + 24, "snap hook on the harness rod, in its notch", 12, "end", accent))
parts.append(t(fx(20), fz(120), "webbing", 13, "end", strap, "bold"))
front_bottom = oy + 34

# ---------------------------------------------------------------- top view
ox2, oy2 = 90, front_bottom + 30
def tx(x): return ox2 + x * S
def ty(y): return oy2 + (W - y) * S        # front (y = 0) at the bottom
parts.append(t(ox2, oy2 - 12, "Top view", 15, weight="bold"))
parts.append(f"<rect x='{tx(0):.1f}' y='{ty(W):.1f}' width='{L*S:.1f}' height='{W*S:.1f}' rx='8' fill='#e9ecef' stroke='{ink}' stroke-width='1.5'/>")
parts.append(f"<rect x='{tx(bed_x0):.1f}' y='{ty(185):.1f}' width='{(bed_x1-bed_x0)*S:.1f}' height='{167*S:.1f}' fill='none' stroke='{soft}' stroke-width='1.5' stroke-dasharray='5 3'/>")
parts.append(t(tx((bed_x0 + bed_x1) / 2), ty(30) , "machine bed", 12, "middle", soft))
centers = []
for x0 in (0, L):
    for (y0, y1) in NOTCH:
        nx = 0 if x0 == 0 else L - 16
        parts.append(f"<rect x='{tx(nx):.1f}' y='{ty(y1):.1f}' width='{16*S:.1f}' height='{(y1-y0)*S:.1f}' fill='white' stroke='{ink}' stroke-width='1'/>")
        cx = ROD_X if x0 == 0 else L - ROD_X
        centers.append((cx, (y0 + y1) / 2))
# the X: front-left to back-right, front-right to back-left
c = {k: v for k, v in zip(["lf", "lb", "rf", "rb"], centers)}
for a, b in (("lf", "rb"), ("rf", "lb")):
    (x0, y0), (x1, y1) = c[a], c[b]
    parts.append(f"<line x1='{tx(x0):.1f}' y1='{ty(y0):.1f}' x2='{tx(x1):.1f}' y2='{ty(y1):.1f}' stroke='{strap}' stroke-width='7' stroke-linecap='round' opacity='0.9'/>")
for (x, y) in centers:
    parts.append(f"<circle cx='{tx(x):.1f}' cy='{ty(y):.1f}' r='7' fill='white' stroke='{accent}' stroke-width='2.5'/>")
parts.append(f"<rect x='{tx(L/2)-34:.1f}' y='{ty(W/2)-13:.1f}' width='68' height='26' rx='12' fill='{accent}' opacity='0.9'/>")
parts.append(t(tx(L / 2), ty(W / 2) + 34, "sewn together where they cross,", 12, "middle", ink))
parts.append(t(tx(L / 2), ty(W / 2) + 50, "through the handle", 12, "middle", ink))
parts.append(t(tx(0), ty(0) + 22, "front", 12, "start", soft))
bottom = ty(0) + 40

width = int(ox + L * S + 290)
svg = (f"<svg xmlns='http://www.w3.org/2000/svg' width='{width}' height='{int(bottom)}' viewBox='0 0 {width} {int(bottom)}'>"
       f"<rect width='100%' height='100%' fill='white'/>" + "".join(parts) + "</svg>\n")
out = os.path.join(os.path.dirname(__file__), "..", "docs", "images", "diagrams", "carry-harness.svg")
with open(out, "w") as f:
    f.write(svg)
print("wrote", os.path.normpath(out))
