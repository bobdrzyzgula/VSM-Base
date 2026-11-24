#!/usr/bin/env python3
"""Draw the carrying-harness diagram for the User's Guide (docs/images/diagrams/carry-harness.svg).

Drawn by Claude at Bob Drzyzgula's direction, November 2026. A sketch of
one way to carry the base: two lengths of webbing from the four harness
rods, crossing in an X over the machine, running together through the
printed handle (standalone/harness-handle). Each end wraps its rod and
comes back up through a three-bar slide. Dimensions are
the Singer 99K base's defaults; the machine is an outline only.
"""
import os

L, W, H = 431.5, 230.0, 82.7          # base, mm
ROD_X, ROD_Z = 7.0, 7.0               # rod center in from the end face, above the bottom
NOTCH = [(20, 52), (178, 210)]        # notch spans along Y (notch_inset 20, notch_len 32)
NT_X1 = ROD_X + 4.7625 / 2 + 5        # notch depth from the face (notch_clear 5)
NT_Z1 = ROD_Z + 4.7625 / 2 + 5        # notch height
HANDLE_Z = 387.0                       # handle above the table
HANDLE_L = 154.0                       # the printed handle's length
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
SLIDE_Z = H + 22                       # the slide, a little above the base's top
for x, face, he in ((ROD_X, 0, hx - HANDLE_L / 2), (L - ROD_X, L, hx + HANDLE_L / 2)):
    # up the end face from the rod, over the top edge, then to the handle
    sz = SLIDE_Z
    sx = face + (he - face) * (sz - H) / (hz - H)
    pts = f"{fx(x):.1f},{fz(ROD_Z):.1f} {fx(face):.1f},{fz(ROD_Z + 14):.1f} {fx(face):.1f},{fz(H):.1f} {fx(he):.1f},{fz(hz):.1f}"
    parts.append(f"<polyline points='{pts}' fill='none' stroke='{strap}' stroke-width='7' stroke-linecap='round' stroke-linejoin='round' opacity='0.9'/>")
    # rod, and the three-bar slide on the leg
    parts.append(f"<circle cx='{fx(x):.1f}' cy='{fz(ROD_Z):.1f}' r='4' fill='{ink}'/>")
    parts.append(f"<rect x='{fx(sx)-8:.1f}' y='{fz(sz)-6:.1f}' width='16' height='12' rx='2' fill='white' stroke='{accent}' stroke-width='2.5'/>")
# handle
parts.append(f"<rect x='{fx(hx - HANDLE_L / 2):.1f}' y='{fz(hz)-20:.1f}' width='{HANDLE_L*S:.1f}' height='34' rx='10' fill='{accent}' opacity='0.9'/>")
parts.append(t(fx(hx), fz(hz) - 28, "handle", 13, "middle", accent, "bold"))
parts.append(t(fx(hx + HANDLE_L / 2) + 14, fz(hz) + 2, "high enough to clear the head and spool pins", 12, "start", ink))
parts.append(t(fx(L) - 4, fz(ROD_Z) + 24, "webbing round the harness rod, in its notch, and back up through a three-bar slide", 12, "end", accent))
parts.append(t(fx(28), fz(150), "webbing", 13, "end", strap, "bold"))
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
# each length: its corner to the near end of the handle, through it, and on
# to the opposite corner from the far end
hl, hr = L / 2 - HANDLE_L / 2, L / 2 + HANDLE_L / 2
for a, b in (("lf", "rb"), ("rf", "lb")):
    (x0, y0), (x1, y1) = c[a], c[b]
    e0, e1 = (hl, hr) if x0 < x1 else (hr, hl)
    pts = f"{tx(x0):.1f},{ty(y0):.1f} {tx(e0):.1f},{ty(W/2):.1f} {tx(e1):.1f},{ty(W/2):.1f} {tx(x1):.1f},{ty(y1):.1f}"
    parts.append(f"<polyline points='{pts}' fill='none' stroke='{strap}' stroke-width='7' stroke-linecap='round' stroke-linejoin='round' opacity='0.9'/>")
# bar tacks just outside each end
for xe in (hl - 8, hr + 8):
    parts.append(f"<line x1='{tx(xe):.1f}' y1='{ty(W/2)-6:.1f}' x2='{tx(xe):.1f}' y2='{ty(W/2)+6:.1f}' stroke='{ink}' stroke-width='3'/>")
for (x, y) in centers:
    parts.append(f"<circle cx='{tx(x):.1f}' cy='{ty(y):.1f}' r='4' fill='{ink}'/>")
parts.append(f"<rect x='{tx(hl):.1f}' y='{ty(W/2)-23:.1f}' width='{HANDLE_L*S:.1f}' height='46' rx='8' fill='{accent}' opacity='0.9'/>")
parts.append(t(tx(L / 2), ty(W / 2) + 44, "both lengths run through the handle,", 12, "middle", ink))
parts.append(t(tx(L / 2), ty(W / 2) + 60, "sewn together just outside each end", 12, "middle", ink))
parts.append(t(tx(0), ty(0) + 22, "front", 12, "start", soft))
bottom = ty(0) + 40

# ------------------------------------------- detail: one end of a leg, in section
K = 3.2                                    # px per mm
dx0, dz0 = ox2 + L * S + 70, ty(0) - 10    # face at the bottom of the base
def dx(x): return dx0 + x * K              # x into the base from its end face
def dz(z): return dz0 - z * K
parts.append(t(dx(-14), dz(H + 62), "One end, in section", 13, "start", ink, "bold"))
# end wall with its notch (the cavity beyond is not drawn)
wall = [(0, 0), (0, NT_Z1 + NT_X1), (NT_X1, NT_Z1), (NT_X1, 0), (30, 0), (30, H), (0, H)]
parts.append("<polygon points='" + " ".join(f"{dx(x):.1f},{dz(z):.1f}" for x, z in [(0, NT_Z1 + NT_X1), (NT_X1, NT_Z1), (NT_X1, 0), (30, 0), (30, H), (0, H)]) + f"' fill='#e9ecef' stroke='{ink}' stroke-width='1.5'/>")
parts.append(t(dx(16), dz(H / 2 + 6), "end", 11, "middle", soft))
parts.append(t(dx(16), dz(H / 2 - 8), "wall", 11, "middle", soft))
# webbing: down the face, in over the rod, round behind and under it, out and
# back up beside itself to the slide; the tail stands above the slide
rr, tw = 4.7625 / 2, 1.8
a, b = -2.2, -5.2                           # the two strands outside the face
path = (f"M {dx(a):.1f},{dz(H + 50):.1f} L {dx(a):.1f},{dz(NT_Z1 + NT_X1 - 1):.1f} "
        f"L {dx(ROD_X):.1f},{dz(ROD_Z + rr + tw / 2):.1f} "
        f"A {(rr + tw / 2) * K:.1f} {(rr + tw / 2) * K:.1f} 0 1 1 {dx(ROD_X):.1f},{dz(ROD_Z - rr - tw / 2):.1f} "
        f"L {dx(b):.1f},{dz(1.5):.1f} L {dx(b):.1f},{dz(H + 40):.1f}")
parts.append(f"<path d='{path}' fill='none' stroke='{strap}' stroke-width='{tw * K:.1f}' stroke-linejoin='round'/>")
parts.append(f"<circle cx='{dx(ROD_X):.1f}' cy='{dz(ROD_Z):.1f}' r='{rr * K:.1f}' fill='{ink}'/>")
# the slide, gripping both strands above the base's top
parts.append(f"<rect x='{dx(b) - 9:.1f}' y='{dz(H + 30):.1f}' width='{(a - b) * K + 18:.1f}' height='{8 * K:.1f}' rx='3' fill='none' stroke='{accent}' stroke-width='3'/>")
parts.append(t(dx(a) + 14, dz(H + 24), "three-bar slide,", 11, "start", accent))
parts.append(t(dx(a) + 14, dz(H + 24) + 14, "above the base's top", 11, "start", accent))
parts.append(t(dx(a) + 14, dz(H + 48), "to the handle", 11, "start", strap))
parts.append(t(dx(b) - 6, dz(H + 38), "tail", 11, "end", strap))
parts.append(t(dx(ROD_X) + 16, dz(ROD_Z) + 4, "rod", 11, "start", ink))
parts.append(t(dx(-14), dz(0) + 20, "outside", 11, "start", soft))
bottom = max(bottom, dz(0) + 34)

width = int(max(ox + L * S + 290, dx(30) + 30))
svg = (f"<svg xmlns='http://www.w3.org/2000/svg' width='{width}' height='{int(bottom)}' viewBox='0 0 {width} {int(bottom)}'>"
       f"<rect width='100%' height='100%' fill='white'/>" + "".join(parts) + "</svg>\n")
out = os.path.join(os.path.dirname(__file__), "..", "docs", "images", "diagrams", "carry-harness.svg")
with open(out, "w") as f:
    f.write(svg)
print("wrote", os.path.normpath(out))
