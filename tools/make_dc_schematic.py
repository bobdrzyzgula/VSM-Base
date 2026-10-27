#!/usr/bin/env python3
"""Generate the draft MCU controller schematic for a 24 V brushed PM motor
(a "775"), in KiCad 7 format.

The DC variant of tools/make_mcu_schematic.py: the same RP2350B core board,
operator inputs, switches, index sensor and encoder, with the mains side
(triac, opto-triac, zero-cross, relay, isolated supply) replaced by a 24 V
input from a certified adapter, a 5 V buck module, and an off-the-shelf
H-bridge (Pololu G2 High-Power Motor Driver 24v13), with current, bus-voltage
and motor-terminal sensing and an optional brake chopper.

Writes hardware/mcu-controller-dc/mcu_controller_dc.kicad_sch and prints
the netlist it intends (compare it with KiCad's netlist export). Every
symbol is defined here. Run from the repository root.
"""
import uuid, sys

U = lambda: str(uuid.uuid4())
ROOT = U()
G = 2.54

def eff(size=1.27, hide=False, justify=None, bold=False):
    j = f" (justify {justify})" if justify else ""
    b = " bold" if bold else ""
    return f"(effects (font (size {size} {size}){b}){j}{' hide' if hide else ''})"

# ---------------------------------------------------------------- symbols
# pin: (number, name, x, y, angle, length, etype)
SYMS = {}
def symbol(name, ref, pins, gfx, show_names=False, power=False, ref_at=(0, 0), val_at=(0, 0)):
    p = []
    for (n, nm, x, y, a, l, t) in pins:
        p.append(f'(pin {t} line (at {x} {y} {a}) (length {l}){" hide" if power else ""} '
                 f'(name "{nm}" {eff(1.0)}) (number "{n}" {eff(1.0)}))')
    body = "\n".join(gfx)
    s = f'''(symbol "VSM:{name}" {"(power) " if power else ""}{"" if show_names else "(pin_names (offset 0) hide) "}(pin_numbers hide) (in_bom {"no" if power else "yes"}) (on_board {"no" if power else "yes"})
  (property "Reference" "{ref}" (at {ref_at[0]} {ref_at[1]} 0) {eff(hide=power)})
  (property "Value" "{name}" (at {val_at[0]} {val_at[1]} 0) {eff()})
  (property "Footprint" "" (at 0 0 0) {eff(hide=True)})
  (property "Datasheet" "" (at 0 0 0) {eff(hide=True)})
  (symbol "{name}_0_1"
{body})
  (symbol "{name}_1_1"
{chr(10).join(p)}))'''
    if show_names:
        s = s.replace("(pin_numbers hide)", "(pin_numbers hide) (pin_names (offset 0.5))", 1)
    SYMS[name] = dict(text=s, pins={pp[0]: pp for pp in pins}, power=power)

def line(*pts, w=0.254, fill="none"):
    xy = " ".join(f"(xy {x} {y})" for x, y in pts)
    return f"(polyline (pts {xy}) (stroke (width {w}) (type default)) (fill (type {fill})))"
def rect(x0, y0, x1, y1, w=0.254, fill="none"):
    return f"(rectangle (start {x0} {y0}) (end {x1} {y1}) (stroke (width {w}) (type default)) (fill (type {fill})))"
def circ(x, y, r, w=0.254, fill="none"):
    return f"(circle (center {x} {y}) (radius {r}) (stroke (width {w}) (type default)) (fill (type {fill})))"
def gtext(t, x, y, size=1.27):
    return f'(text "{t}" (at {x} {y} 0) {eff(size)})'

two = lambda l=1.27, e=3.81: [("1", "~", 0, e, 270, l, "passive"), ("2", "~", 0, -e, 90, l, "passive")]
symbol("R", "R", two(), [rect(-1.016, -2.54, 1.016, 2.54)], ref_at=(2.54, 1.27), val_at=(2.54, -1.27))
symbol("C", "C", two(3.048), [line((-2.032, 0.762), (2.032, 0.762), w=0.508), line((-2.032, -0.762), (2.032, -0.762), w=0.508)],
       ref_at=(3.048, 1.27), val_at=(3.048, -1.27))
symbol("D", "D", [("1", "K", 0, 3.81, 270, 2.54, "passive"), ("2", "A", 0, -3.81, 90, 2.54, "passive")],
       [line((-1.27, -1.27), (1.27, -1.27), (0, 1.27), (-1.27, -1.27)), line((-1.27, 1.27), (1.27, 1.27))],
       ref_at=(2.54, 1.27), val_at=(2.54, -1.27))
symbol("Fuse", "F", two(), [rect(-0.762, -2.54, 0.762, 2.54), line((0, -2.54), (0, 2.54))], ref_at=(2.54, 1.27), val_at=(2.54, -1.27))
symbol("MOV", "RV", two(), [rect(-1.016, -2.54, 1.016, 2.54), line((-1.905, -2.286), (1.905, 2.286), (2.54, 2.286))],
       ref_at=(3.048, 1.27), val_at=(3.048, -1.27))
symbol("Triac", "Q", [("1", "MT1", 0, -5.08, 90, 3.81, "passive"), ("2", "MT2", 0, 5.08, 270, 3.81, "passive"),
                      ("3", "G", -5.08, -2.54, 0, 2.54, "input")],
       [line((-2.54, 1.27), (2.54, 1.27)), line((-2.54, -1.27), (2.54, -1.27)),
        line((-2.54, -1.27), (0, -1.27), (-1.27, 1.27), (-2.54, -1.27)),
        line((0, 1.27), (2.54, 1.27), (1.27, -1.27), (0, 1.27)), line((-2.54, -2.54), (-1.27, -1.27))],
       ref_at=(3.81, 1.27), val_at=(3.81, -1.27))
# opto-triac: output (line side) left, LED (control side) right
symbol("MOC3023", "U", [("6", "MT", -10.16, 2.54, 0, 2.54, "passive"), ("4", "MT", -10.16, -2.54, 0, 2.54, "passive"),
                        ("5", "NC", -10.16, 0, 0, 2.54, "no_connect"),
                        ("1", "A", 10.16, 2.54, 180, 2.54, "passive"), ("2", "K", 10.16, -2.54, 180, 2.54, "passive"),
                        ("3", "NC", 10.16, 0, 180, 2.54, "no_connect")],
       [rect(-7.62, -5.08, 7.62, 5.08, fill="background"), line((0, -4.572), (0, 4.572), w=0.152)],
       show_names=True, ref_at=(0, 6.35), val_at=(0, -6.35))
# AC-input optocoupler: AC (line side) left, transistor right
symbol("H11AA1", "U", [("1", "AC1", -10.16, 2.54, 0, 2.54, "passive"), ("2", "AC2", -10.16, -2.54, 0, 2.54, "passive"),
                       ("3", "NC", -10.16, 0, 0, 2.54, "no_connect"),
                       ("5", "C", 10.16, 2.54, 180, 2.54, "passive"), ("4", "E", 10.16, -2.54, 180, 2.54, "passive"),
                       ("6", "B", 10.16, 0, 180, 2.54, "passive")],
       [rect(-7.62, -5.08, 7.62, 5.08, fill="background"), line((0, -4.572), (0, 4.572), w=0.152)],
       show_names=True, ref_at=(0, 6.35), val_at=(0, -6.35))
symbol("ACDC_5V", "PS", [("1", "L", -12.7, 2.54, 0, 2.54, "power_in"), ("2", "N", -12.7, -2.54, 0, 2.54, "power_in"),
                         ("3", "+Vo", 12.7, 2.54, 180, 2.54, "power_out"), ("4", "-Vo", 12.7, -2.54, 180, 2.54, "power_out")],
       [rect(-10.16, -5.08, 10.16, 5.08, fill="background"), line((0, -4.572), (0, 4.572), w=0.152)],
       show_names=True, ref_at=(0, 6.35), val_at=(0, -6.35))
symbol("Relay_SPST", "K", [("3", "COM", -12.7, 2.54, 0, 2.54, "passive"), ("4", "NO", -12.7, -2.54, 0, 2.54, "passive"),
                           ("1", "COIL+", 12.7, 2.54, 180, 2.54, "passive"), ("2", "COIL-", 12.7, -2.54, 180, 2.54, "passive")],
       [rect(-10.16, -5.08, 10.16, 5.08, fill="background"), line((0, -4.572), (0, 4.572), w=0.152)],
       show_names=True, ref_at=(0, 6.35), val_at=(0, -6.35))
symbol("NMOS", "Q", [("1", "G", -5.08, 0, 0, 2.54, "input"), ("3", "D", 2.54, 5.08, 270, 2.54, "passive"),
                     ("2", "S", 2.54, -5.08, 90, 2.54, "passive")],
       [line((-2.54, -1.778), (-2.54, 1.778)), line((-1.778, -2.032), (-1.778, 2.032)),
        line((-1.778, 1.524), (2.54, 1.524), (2.54, 2.54)), line((-1.778, -1.524), (2.54, -1.524), (2.54, -2.54)),
        line((-1.778, 0), (2.54, 0), (2.54, -1.524)), line((-0.762, 0.508), (-1.778, 0), (-0.762, -0.508))],
       ref_at=(3.81, 1.27), val_at=(3.81, -1.27))
symbol("Pot", "RV", [("1", "1", 0, 3.81, 270, 1.27, "passive"), ("3", "3", 0, -3.81, 90, 1.27, "passive"),
                     ("2", "W", 3.81, 0, 180, 1.27, "passive")],
       [rect(-1.016, -2.54, 1.016, 2.54), line((2.54, 0), (1.27, 0)), line((1.778, 0.508), (1.27, 0), (1.778, -0.508))],
       ref_at=(-2.54, 1.27), val_at=(-2.54, -1.27))
symbol("SW", "SW", [("1", "1", 0, 5.08, 270, 2.54, "passive"), ("2", "2", 0, -5.08, 90, 2.54, "passive")],
       [circ(0, 2.032, 0.508), circ(0, -2.032, 0.508), line((0.254, -1.778), (1.778, 2.286))],
       ref_at=(2.54, 1.27), val_at=(2.54, -1.27))
symbol("DRV5023", "U", [("1", "VCC", -7.62, 2.54, 0, 2.54, "power_in"), ("2", "OUT", -7.62, 0, 0, 2.54, "output"),
                        ("3", "GND", -7.62, -2.54, 0, 2.54, "power_in")],
       [rect(-5.08, -3.81, 5.08, 3.81, fill="background")], show_names=True, ref_at=(0, 5.08), val_at=(0, -5.08))
symbol("DRV5013", "U", [("1", "VCC", -7.62, 2.54, 0, 2.54, "power_in"), ("2", "OUT", -7.62, 0, 0, 2.54, "output"),
                        ("3", "GND", -7.62, -2.54, 0, 2.54, "power_in")],
       [rect(-5.08, -3.81, 5.08, 3.81, fill="background")], show_names=True, ref_at=(0, 5.08), val_at=(0, -5.08))
for n in (2, 3, 4):
    pins = [(str(i + 1), str(i + 1), -5.08, (n - 1) * G / 2 - i * G, 0, 3.81, "passive") for i in range(n)]
    symbol(f"Conn_{n}", "J", pins, [rect(-1.27, -(n * G) / 2, 1.27, (n * G) / 2)],
           ref_at=(0, (n * G) / 2 + 1.27), val_at=(0, -(n * G) / 2 - 1.27))
# RP2350B core board: drawn generically, by GPIO number (each board puts
# these pins in its own places): power and the ADC pins on the left,
# digital GPIOs on the right
LEFT = ["VBUS", "GND", "RUN", "VSYS", "GP47/ADC7", "GP46/ADC6", "GP45/ADC5", "GP44/ADC4", "GP43/ADC3",
        "GP42/ADC2", "GP41/ADC1", "GP40/ADC0", "ADC_VREF", "3V3(OUT)", "3V3_EN"]
RIGHT = ["GP0", "GP1", "GP2", "GND", "GP3", "GP4", "GP5", "GP6", "GP7",
         "GP8/UART1_TX", "GP9/UART1_RX", "GP10", "GP11", "GP12", "GP13"]
pins = [(f"L{i+1}", nm, -17.78, 17.78 - i * G, 0, 5.08, "bidirectional") for i, nm in enumerate(LEFT)]
pins += [(f"R{i+1}", nm, 17.78, 17.78 - i * G, 180, 5.08, "bidirectional") for i, nm in enumerate(RIGHT)]
symbol("RP2350B_CORE", "A", pins, [rect(-12.7, -20.32, 12.7, 20.32, fill="background")], show_names=True,
       ref_at=(0, 21.59), val_at=(0, -21.59))
symbol("+5V", "#PWR", [("1", "+5V", 0, 0, 90, 0, "power_in")],
       [line((-0.762, 1.27), (0, 2.54), (0.762, 1.27)), line((0, 0), (0, 2.54))], power=True, val_at=(0, 3.556))
symbol("+3V3", "#PWR", [("1", "+3V3", 0, 0, 90, 0, "power_in")],
       [line((-0.762, 1.27), (0, 2.54), (0.762, 1.27)), line((0, 0), (0, 2.54))], power=True, val_at=(0, 3.556))
symbol("GND", "#PWR", [("1", "GND", 0, 0, 270, 0, "power_in")],
       [line((0, 0), (0, -1.27), (1.27, -1.27), (0, -2.54), (-1.27, -1.27), (0, -1.27))], power=True, val_at=(0, -3.81))
POWER = {"+5V", "+3V3", "GND"}


# Variants for this layout: connectors with pins on the right; parts that
# straddle the (horizontal) isolation barrier, line-side pins on top and
# control-side pins below; a triac with its gate on the right
for n in (2, 3, 4):
    pins = [(str(i + 1), str(i + 1), 5.08, (n - 1) * G / 2 - i * G, 180, 3.81, "passive") for i in range(n)]
    symbol(f"ConnR_{n}", "J", pins, [rect(-1.27, -(n * G) / 2, 1.27, (n * G) / 2)])
def barrier(name, ref, top, bot, w=5.08):
    pins = []
    for i, (n, nm, t) in enumerate(top):
        pins.append((n, nm, (i - (len(top) - 1) / 2) * 2 * G / (2 if len(top) == 3 else 1), 7.62, 270, 2.54, t))
    for i, (n, nm, t) in enumerate(bot):
        pins.append((n, nm, (i - (len(bot) - 1) / 2) * 2 * G / (2 if len(bot) == 3 else 1), -7.62, 90, 2.54, t))
    symbol(name, ref, pins, [rect(-w, -5.08, w, 5.08, fill="background"), line((-w + 0.508, 0), (w - 0.508, 0), w=0.152)],
           show_names=True)
barrier("MOC3023_H", "U", [("6", "MT", "passive"), ("5", "NC", "no_connect"), ("4", "MT", "passive")],
        [("1", "A", "passive"), ("3", "NC", "no_connect"), ("2", "K", "passive")])
barrier("H11AA1_H", "U", [("1", "AC", "passive"), ("3", "NC", "no_connect"), ("2", "AC", "passive")],
        [("5", "C", "passive"), ("6", "B", "passive"), ("4", "E", "passive")])
barrier("Relay_H", "K", [("4", "NO", "passive"), ("3", "COM", "passive")],
        [("1", "COIL+", "passive"), ("2", "COIL-", "passive")])
barrier("ACDC_5V_H", "PS", [("1", "L", "power_in"), ("2", "N", "power_in")],
        [("3", "+Vo", "power_out"), ("4", "-Vo", "power_out")], w=7.62)
barrier("CT_H", "T", [("1", "P", "passive"), ("2", "P", "passive")],
        [("3", "S1", "passive"), ("4", "S2", "passive")])
symbol("Triac_R", "Q", [("1", "MT1", 0, 5.08, 270, 3.81, "passive"), ("2", "MT2", 0, -5.08, 90, 3.81, "passive"),
                        ("3", "G", 5.08, 2.54, 180, 2.54, "input")],
       [line((-2.54, 1.27), (2.54, 1.27)), line((-2.54, -1.27), (2.54, -1.27)),
        line((-2.54, 1.27), (0, 1.27), (-1.27, -1.27), (-2.54, 1.27)),
        line((0, -1.27), (2.54, -1.27), (1.27, 1.27), (0, -1.27)), line((2.54, 2.54), (1.27, 1.27))])


# ---------------------------------------------------------------- DC-variant symbols
# Pololu G2 24v13 H-bridge module: power on the left (in) and right (motor),
# logic along the bottom
G2B = ["3V3", "VREF", "PWM", "DIR", "SLP", "FLT", "GND", "CS"]
pins = [("VIN", "VIN", -12.7, 5.08, 0, 2.54, "power_in"), ("VM", "VM", -12.7, 0, 0, 2.54, "power_out"),
        ("PGND", "GND", -12.7, -5.08, 0, 2.54, "power_in"),
        ("OUTA", "OUTA", 12.7, 2.54, 180, 2.54, "output"), ("OUTB", "OUTB", 12.7, -2.54, 180, 2.54, "output")]
pins += [(nm if nm != "GND" else "LGND", nm, -8.89 + i * G, -12.7, 90, 2.54,
          "power_out" if nm == "3V3" else ("power_in" if nm == "GND" else ("output" if nm in ("FLT", "CS") else "input")))
         for i, nm in enumerate(G2B)]
symbol("G2_24v13", "A", pins, [rect(-10.16, -10.16, 10.16, 10.16, fill="background")], show_names=True)
# 5 V buck module (Traco TSR 1-2450 or similar 7805-pinout switcher)
symbol("Buck_5V", "PS", [("1", "VIN", -7.62, 0, 0, 2.54, "power_in"), ("2", "GND", 0, -6.35, 90, 2.54, "power_in"),
                         ("3", "VOUT", 7.62, 0, 180, 2.54, "power_out")],
       [rect(-5.08, -3.81, 5.08, 3.81, fill="background")], show_names=True)
symbol("Motor", "M", [("1", "+", 0, 5.08, 270, 2.54, "passive"), ("2", "-", 0, -5.08, 90, 2.54, "passive")],
       [circ(0, 0, 2.54), gtext("M", 0, 0, 2.0)])

# ---------------------------------------------------------------- placement
# ref: (symbol, value, x, y, rotation)
PARTS = {}
def part(ref, sym, val, x, y, rot=0):
    PARTS[ref] = (sym, val, x, y, rot)

def rotp(px, py, r):
    return {0: (px, py), 90: (-py, px), 180: (-px, -py), 270: (py, -px)}[r]
def pin_xy(ref, n):
    sym, val, x, y, r = PARTS[ref]
    _, nm, px, py, a, l, t = SYMS[sym]["pins"][n]
    qx, qy = rotp(px, py, r)
    return (round(x + qx, 3), round(y - qy, 3))
def pin_out(ref, n):           # outward unit vector (screen)
    sym, val, x, y, r = PARTS[ref]
    a = (SYMS[sym]["pins"][n][4] + r) % 360
    return {0: (-1, 0), 180: (1, 0), 90: (0, 1), 270: (0, -1)}[a]

# Line side ------------------------------------------------------------

# Control side (as in the mains version) --------------------------------
part("A1", "RP2350B_CORE", "RP2350B core board", 139.7, 190.5)
part("D2", "D", "SS14 (Schottky)", 114.3, 173.99, 180)
part("C4", "C", "1n", 208.28, 232.41)
part("R15", "R", "100", 220.98, 228.6, 90)
part("R14", "R", "10k", 233.68, 222.25)
part("U4", "DRV5023", "DRV5023 at hand wheel", 264.16, 228.6)
part("C5", "C", "100n at sensor", 281.94, 228.6)
part("SW1", "SW", "needle up/down", 175.26, 233.68)
part("C10", "C", "100n", 182.88, 233.68)
part("SW2", "SW", "single stitch", 187.96, 248.92)
part("C11", "C", "100n", 195.58, 248.92)
part("RV2", "Pot", "10k speed limit", 45.72, 152.4)
part("R20", "R", "1k", 58.42, 152.4, 90)
part("C9", "C", "100n", 71.12, 156.21)
part("J6", "ConnR_4", "pressure pedal (FSR) + heel", 30.48, 172.72)
part("R18", "R", "10k", 43.18, 175.26)
part("R19", "R", "1k", 53.34, 171.45, 90)
part("C8", "C", "100n", 66.04, 175.26)
part("J5", "ConnR_4", "travel pedal + heel", 30.48, 224.79)
part("R17", "R", "1k", 50.8, 223.52, 90)
part("C7", "C", "100n", 66.04, 227.33)
part("J4", "ConnR_3", "knee lever", 30.48, 241.3)
part("R16", "R", "1k", 50.8, 241.3, 90)
part("C6", "C", "100n", 66.04, 245.11)
part("R21", "R", "1k", 68.58, 205.74, 90)
part("C14", "C", "100n", 78.74, 209.55)
for k, y0 in enumerate((172.72, 205.74)):
    part(f"C{17 + k}", "C", "1n", 307.34, y0 + 3.81)
    part(f"R{22 + k}", "R", "100", 320.04, y0, 90)
    part(f"R{24 + k}", "R", "10k", 332.74, y0 - 6.35)
    part(f"U{5 + k}", "DRV5013", "DRV5013 at hand wheel", 363.22, y0)
    part(f"C{15 + k}", "C", "100n at sensor", 381.0, y0)

# 24 V power side -------------------------------------------------------
YV = 49.53                       # the fused 24 V bus
part("J1", "ConnR_2", "24 V DC in", 25.4, 50.8)
part("F1", "Fuse", "5A blade", 45.72, YV, 90)
part("D1", "D", "SMBJ30A (TVS)", 63.5, 55.88)
part("C1", "C", "1000u 50V, at A2", 78.74, 55.88)
part("C2", "C", "1u 50V", 96.52, 55.88)
part("C3", "C", "10u 50V", 116.84, 66.04)
part("PS1", "Buck_5V", "TSR 1-2450 (5 V, 1 A)", 129.54, 62.23)
part("C12", "C", "10u", 147.32, 66.04)
part("C13", "C", "100n", 160.02, 66.04)
# brake chopper (optional; fit if braking pumps the bus up)
part("R9", "R", "10 50W (DNP)", 175.26, 81.28)
part("Q1", "NMOS", "IRLZ44N (DNP)", 172.72, 93.98)
part("R10", "R", "100", 152.4, 93.98, 90)
part("R11", "R", "100k", 162.56, 97.79)
# bus-voltage sense
part("R1", "R", "100k", 203.2, 83.82)
part("R2", "R", "10k", 203.2, 95.25)
part("C20", "C", "100n", 193.04, 95.25)
# the H-bridge
part("A2", "G2_24v13", "Pololu G2 24v13", 238.76, 76.2)
part("R4", "R", "47k (set on bench)", 227.33, 95.25)
part("R3", "R", "1k", 254.0, 93.98, 90)
# the motor, with its suppression capacitor, and the terminal-voltage dividers
part("M1", "Motor", "775, 24 V", 269.24, 76.2)
part("C19", "C", "100n at motor", 276.86, 76.2)
part("R5", "R", "100k", 287.02, 67.31)
part("R6", "R", "10k", 287.02, 57.15)
part("R7", "R", "100k", 287.02, 85.09)
part("R8", "R", "10k", 287.02, 95.25)

# ---------------------------------------------------------------- wiring
# Each wire is a list of points: "REF.PIN", (x, y), ("h", x) to run
# horizontally to x, or ("v", y) to run vertically to y.
P = pin_xy
W = []
def wire(*pts):
    out = []
    for p in pts:
        if isinstance(p, str):
            r, n = p.split(".", 1); q = P(r, n)
        elif p[0] == "h":
            q = (p[1], out[-1][1])
        elif p[0] == "v":
            q = (out[-1][0], p[1])
        else:
            q = p
        out.append((round(q[0], 3), round(q[1], 3)))
    W.append(out)

# control side (as in the mains version)
wire("A1.R9", ("h", 198.12), ("v", 228.6), "R15.1")    # HALL_F
wire("C4.1", (208.28, 228.6))
wire("R15.2", "U4.2")
wire("R14.2", ("v", 228.6))
wire("A1.R14", ("h", 175.26), "SW1.1")                  # NEEDLE
wire((175.26, 226.06), ("h", 182.88), "C10.1")
wire("A1.R12", ("h", 187.96), "SW2.1")                  # STITCH
wire((187.96, 241.3), ("h", 195.58), "C11.1")
wire("D2.1", ("v", 180.34), "A1.L4")
wire("RV2.2", "R20.1")
wire("R20.2", ("h", 106.68), ("v", 193.04), "A1.L9")    # LIMIT
wire("C9.1", (71.12, 152.4))
wire("J6.2", "R19.1")
wire("R18.1", (43.18, 171.45))
wire("R19.2", ("h", 101.6), ("v", 195.58), "A1.L10")    # FSR
wire("C8.1", (66.04, 171.45))
wire("J5.2", "R17.1")
wire("R17.2", ("h", 101.6), ("v", 198.12), "A1.L11")    # PEDAL
wire("C7.1", (66.04, 223.52))
wire("J4.2", "R16.1")
wire("J6.3", (40.64, 173.99))
wire("J5.4", (40.64, 228.6))
wire("J6.4", ("h", 39.37), ("v", 181.61), ("h", 43.18))
wire((55.88, 205.74), "R21.1")
wire("R21.2", ("h", 86.36))
wire("C14.1", (78.74, 205.74))
wire("A1.R13", ("h", 167.64))                             # HEEL_F
wire("A1.R3", ("h", 162.56))                              # ENC_A
wire("A1.R5", ("h", 162.56))                              # ENC_B
for k, y0 in enumerate((172.72, 205.74)):
    wire((297.18, y0), f"R{22 + k}.1")
    wire(f"C{17 + k}.1", (307.34, y0))
    wire(f"R{22 + k}.2", f"U{5 + k}.2")
    wire(f"R{24 + k}.2", ("v", y0))
wire("R16.2", ("h", 106.68), ("v", 200.66), "A1.L12")   # KNEE
wire("C6.1", (66.04, 241.3))
# MCU ends of the motor-drive signals (joined by label)
for pin in ("R6", "R7", "R8", "R15", "R2"):               # PWM, DIR, SLP, FLT, BRAKE
    wire(f"A1.{pin}", ("h", 167.64))
for pin in ("L5", "L6", "L7", "L8"):                      # VBUS_S, VB, VA, ISENSE
    wire(f"A1.{pin}", ("h", 109.22))

# 24 V power side
wire("J1.1", "F1.1")
wire("F1.2", ("h", 220.98), ("v", 71.12), "A2.VIN")       # the bus, to the driver
wire("D1.1", ("v", YV)); wire("C1.1", ("v", YV)); wire("C2.1", ("v", YV))
wire("PS1.1", ("h", 114.3), ("v", YV))
wire("PS1.3", "C12.1"); wire("C12.1", "C13.1")
# brake chopper
wire("R9.1", ("v", YV)); wire("R9.2", "Q1.3")
wire("R10.2", "Q1.1"); wire("R10.1", ("h", 143.51))
# bus sense, from the driver's VM (after its reverse-voltage protection)
wire("A2.VM", ("h", 203.2), "R1.1")
wire("R1.2", "R2.1")
wire("C20.1", ("h", 203.2))
# driver logic stubs (joined to the MCU by label) and its current limit
for nm in ("PWM", "DIR", "SLP", "FLT"):
    x = P("A2", nm)[0]
    wire(f"A2.{nm}", ("v", 104.14))
wire("A2.VREF", ("v", 91.44), ("h", 227.33), "R4.1")
wire("A2.CS", ("v", 93.98), "R3.1")
wire("R3.2", ("h", 262.89))
# motor, suppression cap, terminal-voltage dividers
wire("A2.OUTA", ("h", 261.62), ("v", 71.12), "M1.1")
wire("A2.OUTB", ("h", 261.62), ("v", 81.28), "M1.2")
wire("M1.1", ("h", 276.86), "C19.1")
wire("M1.2", ("h", 276.86), "C19.2")
wire((276.86, 71.12), ("h", 287.02))                       # OUTA on to its divider
wire((276.86, 81.28), ("h", 287.02))                       # OUTB on to its divider
wire("R6.2", "R5.1")
wire("R5.1", ("h", 294.64))                                # VA
wire("R7.2", "R8.1")
wire("R7.2", ("h", 294.64))                                # VB

POWER = {
 "+5V":  ["C12.1", "D2.2"],
 "+3V3": ["R14.1", "U4.1", "C5.1", "A1.L14", "RV2.1", "J6.1", "J5.1", "J4.1",
          "R24.1", "R25.1", "U5.1", "U6.1", "C15.1", "C16.1"],
 "GND":  ["J1.2", "D1.2", "C1.2", "C2.2", "C3.2", "PS1.2", "C12.2", "C13.2", "Q1.2", "R11.2",
          "R2.2", "C20.2", "A2.PGND", "A2.LGND", "R4.2", "R6.1", "R8.2",
          "A1.L2", "A1.R4",
          "C4.2", "U4.3", "C5.2", "SW1.2", "C10.2", "SW2.2", "C11.2", "RV2.3", "C9.2", "R18.2", "C8.2",
          "J5.3", "C7.2", "J4.3", "C6.2", "C14.2", "C17.2", "C18.2", "U5.3", "U6.3", "C15.2", "C16.2"],
}
NAMES = [("+24V (fused)", 100.0, YV, 0),
         ("PWM", 159.0, 185.42, 0), ("DIR", 159.0, 187.96, 0), ("SLP", 159.0, 190.5, 0),
         ("FLT", 159.0, 208.28, 0), ("BRAKE", 159.0, 175.26, 0),
         ("VBUS_S", 109.6, 182.88, 0), ("VB", 109.6, 185.42, 0), ("VA", 109.6, 187.96, 0), ("ISENSE", 109.6, 190.5, 0),
         ("PWM", 234.95, 104.14, 90), ("DIR", 237.49, 104.14, 90), ("SLP", 240.03, 104.14, 90), ("FLT", 242.57, 104.14, 90),
         ("ISENSE", 258.3, 93.98, 0), ("BRAKE", 144.0, 93.98, 0), ("VBUS_S", 193.6, 91.44, 0),
         ("VA", 288.3, 63.5, 0), ("VB", 288.3, 88.9, 0),
         ("OUTA", 253.6, 73.66, 0), ("OUTB", 253.6, 78.74, 0),
         ("STITCH", 165.0, 200.66, 0), ("NEEDLE", 160.0, 205.74, 0), ("HALL", 165.0, 193.04, 0),
         ("LIMIT", 80.0, 152.4, 0), ("FSR", 80.0, 171.45, 0), ("PEDAL", 80.0, 223.52, 0), ("KNEE", 80.0, 241.3, 0),
         ("HEEL", 36.07, 173.99, 0), ("HEEL", 36.07, 228.6, 0), ("HEEL", 56.39, 205.74, 0), ("HEEL_F", 80.5, 205.74, 0),
         ("HEEL_F", 158.0, 203.2, 0), ("ENC_A", 158.0, 177.8, 0), ("ENC_B", 158.0, 182.88, 0),
         ("ENC_A", 297.7, 172.72, 0), ("ENC_B", 297.7, 205.74, 0)]

CAP_LEFT = {"SW1", "SW2", "D2", "R4", "R11"}

# ---------------------------------------------------------------- connectivity
def on_seg(p, a, b):
    (x, y), (x1, y1), (x2, y2) = p, a, b
    if abs(x1 - x2) < 1e-6 and abs(x - x1) < 1e-6:
        return min(y1, y2) + 1e-6 < y < max(y1, y2) - 1e-6
    if abs(y1 - y2) < 1e-6 and abs(y - y1) < 1e-6:
        return min(x1, x2) + 1e-6 < x < max(x1, x2) - 1e-6
    return False
segs = []
for w in W:
    for a, b in zip(w, w[1:]):
        if a != b:
            assert abs(a[0] - b[0]) < 1e-6 or abs(a[1] - b[1]) < 1e-6, (a, b)
            segs.append((a, b))
pins_all = {}
for ref in PARTS:
    for n in SYMS[PARTS[ref][0]]["pins"]:
        pins_all[P(ref, n)] = f"{ref}.{n}"
# power stubs
stubs = []
for net, lst in POWER.items():
    for pr in lst:
        r, n = pr.split(".", 1)
        (x, y), (dx, dy) = P(r, n), pin_out(r, n)
        e = (round(x + dx * G, 3), round(y + dy * G, 3))
        segs.append(((x, y), e)); stubs.append((net, e, (dx, dy)))
# split segments at every endpoint or pin that lands inside them
pts = set(pins_all) | {p for s in segs for p in s}
changed = True
while changed:
    changed = False
    new = []
    for a, b in segs:
        cut = [p for p in pts if on_seg(p, a, b)]
        if cut:
            changed = True
            cut.sort(key=lambda p: (p[0] - a[0]) ** 2 + (p[1] - a[1]) ** 2)
            chain = [a] + cut + [b]
            new += list(zip(chain, chain[1:]))
        else:
            new.append((a, b))
    segs = new
deg = {}
for a, b in segs:
    for p in (a, b):
        deg[p] = deg.get(p, 0) + 1
junctions = [p for p, d in deg.items() if d + (1 if p in pins_all else 0) >= 3]
# union-find for the intended netlist
par = {}
def f(x):
    while par.setdefault(x, x) != x:
        x = par[x]
    return x
for a, b in segs:
    par[f(a)] = f(b)
for (nm, x, y, a) in NAMES:          # a label joins the wire it sits on to its namesakes
    hit = [sg for sg in segs if (x, y) in sg or on_seg((x, y), *sg)]
    assert hit, ("label off any wire", nm, x, y)
    par[f(hit[0][0])] = f(("label", nm))
groups = {}
for p, name in pins_all.items():
    groups.setdefault(f(p), []).append(name)
for net, e, _ in stubs:
    groups.setdefault(f(e), []).append(f"<{net}>")

# ---------------------------------------------------------------- emit
out = []
pw = [0]
for ref, (sym, val, x, y, r) in PARTS.items():
    S = SYMS[sym]
    pin_uuids = " ".join(f'(pin "{n}" (uuid {U()}))' for n in S["pins"])
    out.append(f"""(symbol (lib_id "VSM:{sym}") (at {x} {y} {r}) (unit 1) (in_bom yes) (on_board yes) (dnp no) (uuid {U()})
  (property "Reference" "{ref}" (at {x} {y} 0) {eff(hide=True)})
  (property "Value" "{val}" (at {x} {y} 0) {eff(hide=True)})
  (property "Footprint" "" (at {x} {y} 0) {eff(hide=True)})
  (property "Datasheet" "" (at {x} {y} 0) {eff(hide=True)})
  {pin_uuids}
  (instances (project "mcu_controller_dc" (path "/{ROOT}" (reference "{ref}") (unit 1)))))""")
for a, b in segs:
    out.append(f"(wire (pts (xy {a[0]} {a[1]}) (xy {b[0]} {b[1]})) (stroke (width 0) (type default)) (uuid {U()}))")
for p in junctions:
    out.append(f"(junction (at {p[0]} {p[1]}) (diameter 0) (color 0 0 0 0) (uuid {U()}))")
for net, (ex, ey), (dx, dy) in stubs:
    pw[0] += 1
    vx, vy = round(ex + dx * 4.6, 2), round(ey + dy * 4.6 + (0.6 if dy == 0 else 0), 2)
    if net == "GND":
        rot = {(0, 1): 0, (1, 0): 90, (0, -1): 180, (-1, 0): 270}[(dx, dy)]
    else:
        rot = {(0, -1): 0, (-1, 0): 90, (0, 1): 180, (1, 0): 270}[(dx, dy)]
    out.append(f"""(symbol (lib_id "VSM:{net}") (at {ex} {ey} {rot}) (unit 1) (in_bom no) (on_board no) (dnp no) (uuid {U()})
  (property "Reference" "#PWR{pw[0]:03d}" (at {ex} {ey} 0) {eff(hide=True)})
  (property "Value" "{net}" (at {vx} {vy} 0) {eff(1.0)})
  (property "Footprint" "" (at {ex} {ey} 0) {eff(hide=True)})
  (property "Datasheet" "" (at {ex} {ey} 0) {eff(hide=True)})
  (pin "1" (uuid {U()}))
  (instances (project "mcu_controller_dc" (path "/{ROOT}" (reference "#PWR{pw[0]:03d}") (unit 1)))))""")
connected = {p for s in segs for p in s}
for p, name in pins_all.items():
    if p not in connected:
        out.append(f"(no_connect (at {p[0]} {p[1]}) (uuid {U()}))")
for (nm, x, y, a) in NAMES:
    out.append(f'(label "{nm}" (at {x} {y} {a}) {eff(1.0, justify="left bottom")} (uuid {U()}))')

def text(t, x, y, size=1.27, bold=False, just="left bottom"):
    t = t.replace('"', '\\"')
    out.append(f'(text "{t}" (at {x} {y} 0) {eff(size, justify=just, bold=bold)} (uuid {U()}))')
for ref, (sym, val, x, y, r) in PARTS.items():
    if sym == "G2_24v13":
        text(ref, x - 10.16, y - 11.4, 1.27, True); text(val, x - 6.6, y - 11.4, 1.27)
    elif sym == "Buck_5V":
        text(ref, x - 5.08, y - 5.0, 1.27, True); text(val, x - 5.08, y - 7.0, 1.0)
    elif sym == "Motor":
        text(ref, x - 3.6, y - 0.5, 1.27, True, "right bottom"); text(val, x - 3.6, y + 1.6, 1.0, False, "right bottom")
    elif sym == "RP2350B_CORE":
        text(ref, x - 12.7, y - 21.6, 1.27, True); text(val, x - 7.0, y - 21.6, 1.27)
    elif sym.startswith("ConnR") or sym in ("DRV5023", "DRV5013"):
        n = len(SYMS[sym]["pins"])
        text(ref, x - 1.27, y - n * G / 2 - 4.2, 1.27, True); text(val, x - 1.27, y - n * G / 2 - 1.6, 1.0)
    elif ref == "R18":
        text(ref, x + 2.54, y + 4.6, 1.27, True); text(val, x + 2.54, y + 6.6, 1.0)
    elif r == 90:
        text(ref, x - 2.5, y - 2.4, 1.27, True); text(val, x - 2.5, y + 3.6, 1.0)
    elif sym == "Pot":
        text(ref, x - 2.54, y - 0.5, 1.27, True, "right bottom"); text(val, x - 2.54, y + 1.6, 1.0, False, "right bottom")
    else:
        dx = -3.81 if ref in CAP_LEFT else 3.81
        j = "left bottom" if dx > 0 else "right bottom"
        text(ref, x + dx, y - 0.5, 1.27, True, j)
        for k, ln in enumerate(val.split(" ", 1) if len(val) > 9 else [val]):
            text(ln, x + dx, y + 1.6 + k * 1.6, 1.0, False, j)


def polyline(pts, w=0.4, kind="dash"):
    xy = " ".join(f"(xy {a} {b})" for a, b in pts)
    out.append(f"(polyline (pts {xy}) (stroke (width {w}) (type {kind})) (uuid {U()}))")
YB = 114.3
polyline([(20.32, YB), (398.78, YB)], 0.6)
text("24 V POWER: high current, SELV", 345.44, YB - 3.0, 2.0, True)
text("LOGIC: 3.3 V / 5 V, same ground", 345.44, YB + 6.0, 2.0, True)
text("No mains anywhere: the certified adapter does all the isolation. Keep motor current out of the logic ground: one star point at A2's GND.", 20.32, YB - 1.5, 1.27)
for (t, x, y) in [("24 V IN: FUSE, TVS, BULK", 20.32, 38.1), ("5 V BUCK", 114.3, 44.45),
                  ("BRAKE CHOPPER (optional)", 139.7, 86.36), ("BUS SENSE", 182.88, 76.2),
                  ("H-BRIDGE (Pololu G2 24v13 module)", 220.98, 58.42),
                  ("MOTOR TERMINAL SENSE (back-EMF)", 297.18, 77.47),
                  ("RP2350B CORE BOARD (pins by GPIO number)", 124.46, 165.1),
                  ("HAND-WHEEL INDEX SENSOR (one magnet, one pulse per stitch)", 200.66, 210.82),
                  ("HAND-WHEEL ENCODER (two Hall latches, quadrature; same cable as the index)", 297.18, 160.02),
                  ("HEEL SWITCH", 55.88, 199.39),
                  ("SWITCHES (internal pull-ups)", 170.18, 218.44),
                  ("OPERATOR INPUTS (RC-filtered ADC)", 20.32, 139.7)]:
    text(t, x, y, 1.5, True)
notes = [
 "NOTES. A concept drawn by Claude at Bob Drzyzgula's direction, October 2026: not built, not tested, values not checked.",
 "1. The mains version's control side unchanged; the triac, zero-cross, relay and isolated supply replaced by a 24 V adapter, a buck and an H-bridge.",
 "2. Pins (RP2350B): PWM GP4 (20 kHz, PWM slice 2); DIR GP5; SLP GP6; FLT GP13 (internal pull-up); BRAKE GP1; HALL GP7; ENC_A/B GP2/GP3;",
 "   STITCH GP10; HEEL GP11; NEEDLE GP12; knee, pedal, FSR, limit ADC0-3; ISENSE ADC4 (GP44); VA, VB ADC5, ADC6; VBUS_S ADC7 (GP47).",
 "3. A2 truth table: PWM high drives (DIR sets the way); PWM low brakes (both outputs low). Its PWM input is pulled low on the board, so a",
 "   resetting MCU leaves the motor braked. CS is about 40 mV/A, valid only while driving: sample it mid on-time. No capacitor on CS.",
 "4. R4 lowers A2's current limit from its default ~30 A (100k gives ~16 A); aim for 8-10 A and set it on the bench with the motor stalled.",
 "5. Slow down by braking (PWM low), which spends the energy in the motor's own resistance. Never reverse at speed: that pumps the bus up.",
 "   Watch VBUS_S; if it rises past ~28 V, stop driving and fire the brake chopper (Q1, R9), if fitted. D1 only catches short spikes.",
 "6. VA, VB read each motor terminal (/11): their difference is the motor's voltage; with A2 asleep (SLP low) it is the back-EMF, the speed.",
 "7. C19 and two 47n caps from each terminal to the motor case go at the motor; twist the motor leads. PS1 feeds VSYS through D2, as before.",
]
for i, n in enumerate(notes):
    text(n, 20.32, 258.6 + i * 2.4, 1.15, i == 0)

libs = "\n".join(s["text"] for s in SYMS.values())
sch = f"""(kicad_sch (version 20230121) (generator eeschema)
  (uuid {ROOT})
  (paper "A3")
  (title_block
    (title "VSM MCU controller, 24 V DC motor variant (concept)")
    (date "2026-10-27")
    (rev "draft-1")
    (comment 1 "The mains controller's control side, driving a 775 brushed PM motor through a G2 H-bridge")
    (comment 2 "Drafted by Claude at the direction of Robert Drzyzgula; not built or tested"))
  (lib_symbols
{libs})
{chr(10).join(out)}
  (sheet_instances (path "/" (page "1"))))
"""
open(sys.argv[1] if len(sys.argv) > 1 else "hardware/mcu-controller-dc/mcu_controller_dc.kicad_sch", "w").write(sch)
for g in sorted(groups.values(), key=lambda v: sorted(v)):
    if len(g) > 1:
        print(" ".join(sorted(g)))
