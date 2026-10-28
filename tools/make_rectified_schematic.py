#!/usr/bin/env python3
"""Generate the draft MCU phase-controller schematic, rectified-DC variant
(KiCad 7 format).

The mains controller of tools/make_mcu_schematic.py with one change in the
power path: the triac feeds the motor through a bridge rectifier, with a
freewheeling diode across the motor, so the universal motor runs on
phase-controlled DC as on a KBIC. The motor moves off the outlet to its own
keyed connector (J3), the outlet keeps only the light, and the current
transformer moves to the bridge's AC lead.

Writes hardware/mcu-controller-rectified/mcu_controller_rectified.kicad_sch. Every symbol is
defined here (no KiCad libraries needed). Parts are placed and wired by
hand in the tables below; power rails (+5V, +3V3, GND) use power ports.
The script splits wires where another wire or a pin lands on them, adds
the junction dots, marks unused pins, and prints the netlist it intends
(compare it with KiCad's netlist export). Run from the repository root.
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
symbol("Bridge", "BR", [("1", "~", 0, 7.62, 270, 2.54, "passive"), ("2", "~", 7.62, 0, 180, 2.54, "passive"),
                       ("3", "+", -7.62, 0, 0, 2.54, "passive"), ("4", "-", 0, -7.62, 90, 2.54, "passive")],
       [line((0, 5.08), (5.08, 0), (0, -5.08), (-5.08, 0), (0, 5.08)),
        line((-3.0, 0.6), (-1.6, 2.0)), line((0.6, 3.0), (2.0, 1.6)), line((0.6, -3.0), (2.0, -1.6)), line((-3.0, -0.6), (-1.6, -2.0))],
       show_names=True)
symbol("Triac_R", "Q", [("1", "MT1", 0, 5.08, 270, 3.81, "passive"), ("2", "MT2", 0, -5.08, 90, 3.81, "passive"),
                        ("3", "G", 5.08, 2.54, 180, 2.54, "input")],
       [line((-2.54, 1.27), (2.54, 1.27)), line((-2.54, -1.27), (2.54, -1.27)),
        line((-2.54, 1.27), (0, 1.27), (-1.27, -1.27), (-2.54, 1.27)),
        line((0, -1.27), (2.54, -1.27), (1.27, 1.27), (0, -1.27)), line((2.54, 2.54), (1.27, 1.27))])

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
part("J1", "ConnR_3", "IEC inlet", 25.4, 50.8)
part("F1", "Fuse", "T2A 250V", 40.64, 48.26, 90)
part("RV1", "MOV", "150VAC", 55.88, 53.34)
part("J2", "ConnR_3", "light outlet: PE, LIGHT, N", 25.4, 88.9)
part("J3", "ConnR_2", "motor (keyed)", 63.5, 88.9)
part("BR1", "Bridge", "GBU8J 600V 8A", 106.68, 83.82)
part("D3", "D", "UF5408", 86.36, 87.63)
part("Q1", "Triac_R", "BTA08-600BW", 160.02, 87.63)
part("R4", "R", "360 0.5W", 182.88, 99.06)
part("R5", "R", "330", 172.72, 80.01)
part("R6", "R", "100 1W DNP", 137.16, 80.01)
part("C2", "C", "47n X2 DNP", 137.16, 88.9)
part("R7", "R", "22k 0.5W", 261.62, 66.04)
part("R8", "R", "22k 0.5W", 266.7, 66.04)
part("F2", "Fuse", "T250mA", 317.5, 93.98)
# Across the barrier (y = 114.3) ---------------------------------------
YB = 114.3
part("U3", "MOC3023_H", "MOC3023", 185.42, YB)
part("K1", "Relay_H", "G5LE-1A 5V", 223.52, YB)
part("U2", "H11AA1_H", "H11AA1", 264.16, YB)
part("PS1", "ACDC_5V_H", "IRM-05-5", 320.04, YB)
part("T1", "CT_H", "ZMCT103C 1000:1 (optional)", 124.46, YB)
# Control side ---------------------------------------------------------
part("R11", "R", "270", 182.88, 133.35)
part("Q2", "NMOS", "2N7002", 223.52, 147.32)
part("D1", "D", "1N4148", 236.22, 132.08)
part("R12", "R", "100", 210.82, 147.32, 90)
part("R13", "R", "100k", 215.9, 153.67)
part("R9", "R", "10k", 271.78, 133.35)
part("C3", "C", "1n", 279.4, 143.51)
part("C12", "C", "10u", 335.28, 133.35)
part("C13", "C", "100n", 345.44, 133.35)
part("A1", "RP2350B_CORE", "RP2350B core board", 139.7, 190.5)
part("D2", "D", "SS14 (Schottky)", 114.3, 173.99, 180)
# hand-wheel Hall sensor (at the end of a 3-wire cable)
part("C4", "C", "1n", 208.28, 232.41)
part("R15", "R", "100", 220.98, 228.6, 90)
part("R14", "R", "10k", 233.68, 222.25)
part("U4", "DRV5023", "DRV5023 at hand wheel", 264.16, 228.6)
part("C5", "C", "100n at sensor", 281.94, 228.6)
# motor-current sense (optional, for IR compensation): burden, mid-supply bias, filter
part("R26", "R", "100 burden", 134.62, 130.81)
part("R27", "R", "1k", 149.86, 127.0, 90)
part("C19", "C", "10n", 157.48, 130.81)
part("R28", "R", "10k", 116.84, 132.08)
part("R29", "R", "10k", 116.84, 142.24)
part("C20", "C", "10u", 127.0, 142.24)
# switches
part("SW1", "SW", "needle up/down", 175.26, 233.68)
part("C10", "C", "100n", 182.88, 233.68)
part("SW2", "SW", "single stitch", 187.96, 248.92)
part("C11", "C", "100n", 195.58, 248.92)
# operator inputs
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
# heel switch (in either pedal, to GND): filtered here, to GP11 by label
part("R21", "R", "1k", 68.58, 205.74, 90)
part("C14", "C", "100n", 78.74, 209.55)
# optional hand-wheel encoder: two Hall latches over a ring of alternating
# magnets, a quarter-cycle apart (quadrature); same network as the index sensor
for k, y0 in enumerate((172.72, 205.74)):
    part(f"C{17 + k}", "C", "1n", 307.34, y0 + 3.81)
    part(f"R{22 + k}", "R", "100", 320.04, y0, 90)
    part(f"R{24 + k}", "R", "10k", 332.74, y0 - 6.35)
    part(f"U{5 + k}", "DRV5013", "DRV5013 at hand wheel", 363.22, y0)
    part(f"C{15 + k}", "C", "100n at sensor", 381.0, y0)

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

LR, NR = 48.26, 58.42            # L (fused) and N rails
# mains in, rails, MOV, outlet
wire("J1.1", "F1.1")
wire("F1.2", ("h", 317.5), ("v", 90.17))                 # L rail to F2's lane
wire("F2.1", (317.5, 90.17))
wire("J1.2", ("h", 38.1), ("v", NR), ("h", 322.58), ("v", 106.68))   # N rail, on to PS1.N
wire("PS1.2", (322.58, 106.68))
wire("J1.3", ("h", 33.02), ("v", 86.36), "J2.1")          # PE
wire("J2.2", ("h", 50.8), ("v", LR))                      # LIGHT from L
wire("J2.3", ("h", 45.72), ("v", NR))                     # N
wire("T1.1", ("v", 83.82), ("h", 114.3))                  # from T1 to the bridge's AC input
wire("BR1.1", ("v", NR))                                   # the bridge's other AC input, to N
wire("BR1.3", ("h", 73.66), ("v", 87.63), "J3.1")          # DC+ to the motor
wire("BR1.4", ("h", 71.12), ("v", 90.17), "J3.2")          # DC- from the motor
wire("T1.2", ("v", 92.71), ("h", 160.02), "Q1.2")          # from the triac's MT2
wire("RV1.1", ("v", LR)); wire("RV1.2", ("v", NR))
# triac stage
wire("C2.2", (137.16, 92.71))
wire("R6.2", "C2.1")
wire("R6.1", ("v", 76.2), ("h", 220.98), "K1.4")          # MT1 / relay NO
wire("Q1.1", ("v", 76.2))
wire("R5.1", ("v", 76.2))
wire("Q1.3", ("h", 187.96), "U3.4")                       # gate
wire("R5.2", ("v", 85.09))
wire("R4.1", ("v", 92.71), ("h", 160.02))                 # MT2 to the opto's MT (via R4)
wire("R4.2", "U3.6")
wire("K1.3", ("v", LR))                                   # relay COM from L
# zero-cross input network and supply
wire("R7.1", ("v", LR)); wire("R7.2", "U2.1")
wire("R8.1", ("v", NR)); wire("R8.2", "U2.2")
wire("F2.2", "PS1.1")
# control side: triac LED
wire("U3.1", "R11.1")
wire("R11.2", ("v", 185.42), "A1.R6")                  # FIRE
# relay driver
wire("K1.2", "Q2.3")                                      # COIL- to drain
wire("D1.2", ("v", 137.16), ("h", 226.06))
wire("R12.2", "Q2.1")
wire("R13.1", ("v", 147.32))
wire("R12.1", ("h", 203.2), ("v", 187.96), "A1.R7")    # RELAY
# zero-cross
wire("U2.5", ("v", 190.5), "A1.R8")                    # ZC
wire("R9.2", ("v", 139.7), ("h", 261.62))
wire("C3.1", ("v", 139.7), ("h", 271.78))
# Hall
wire("A1.R9", ("h", 198.12), ("v", 228.6), "R15.1")    # HALL_F
wire("C4.1", (208.28, 228.6))
wire("R15.2", "U4.2")                                      # HALL
wire("R14.2", ("v", 228.6))
# switches
wire("A1.R14", ("h", 175.26), "SW1.1")                  # NEEDLE
wire((175.26, 226.06), ("h", 182.88), "C10.1")
wire("A1.R12", ("h", 187.96), "SW2.1")                  # STITCH
wire((187.96, 241.3), ("h", 195.58), "C11.1")
# 5 V into VSYS through the Schottky, so USB can be plugged in as well
wire("D2.1", ("v", 180.34), "A1.L4")
# operator inputs
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
# heel: stubs from both pedal jacks, joined to the filter by the HEEL label
wire("J6.3", (40.64, 173.99))
wire("J5.4", (40.64, 228.6))
wire("J6.4", ("h", 39.37), ("v", 181.61), ("h", 43.18))   # J6's ground into R18's
wire((55.88, 205.74), "R21.1")
wire("R21.2", ("h", 86.36))
wire("C14.1", (78.74, 205.74))
wire("A1.R13", ("h", 167.64))                             # HEEL_F
# motor current: S2 is the signal, S1 the 1.65 V bias
wire("T1.4", ("v", 127.0), "R27.1")
wire("R26.2", ("v", 137.16))
wire("T1.3", ("v", 137.16), ("h", 134.62))
wire("R28.2", "R29.1")
wire((116.84, 137.16), (121.92, 137.16))
wire("C20.1", ("v", 137.16))
wire("R27.2", ("h", 165.1))
wire("C19.1", (157.48, 127.0))
wire("A1.L8", ("h", 109.22))                              # ISENSE (ADC4)
# encoder A and B: from GP2 and GP3 by label
wire("A1.R3", ("h", 162.56))
wire("A1.R5", ("h", 162.56))
for k, y0 in enumerate((172.72, 205.74)):
    wire((297.18, y0), f"R{22 + k}.1")
    wire(f"C{17 + k}.1", (307.34, y0))
    wire(f"R{22 + k}.2", f"U{5 + k}.2")
    wire(f"R{24 + k}.2", ("v", y0))
wire("R16.2", ("h", 106.68), ("v", 200.66), "A1.L12")   # KNEE
wire("C6.1", (66.04, 241.3))

# Power ports on pins (a stub and a port in the pin's outward direction)
POWER = {
 "+5V":  ["K1.1", "D1.1", "PS1.3", "C12.1", "C13.1", "D2.2"],
 "+3V3": ["R9.1", "R14.1", "U4.1", "C5.1", "A1.L14", "RV2.1", "J6.1", "J5.1", "J4.1",
          "R24.1", "R25.1", "U5.1", "U6.1", "C15.1", "C16.1", "R28.1"],
 "GND":  ["U3.2", "U2.4", "PS1.4", "Q2.2", "R13.2", "C3.2", "C12.2", "C13.2", "A1.L2", "A1.R4",
          "C4.2", "U4.3", "C5.2", "SW1.2", "C10.2", "SW2.2", "C11.2", "RV2.3", "C9.2", "R18.2", "C8.2",
          "J5.3", "C7.2", "J4.3", "C6.2", "C14.2", "C17.2", "C18.2", "U5.3", "U6.3", "C15.2", "C16.2", "R29.2", "C20.2", "C19.2"],
}
# Net names shown along wires: (name, x, y, angle)
NAMES = [("L (fused)", 80.0, LR, 0), ("N", 80.0, NR, 0), ("PE", 33.02, 70.0, 90),
         ("MOTOR+", 88.9, 83.82, 0), ("MOTOR-", 88.9, 91.44, 0), ("MT1 (via K1)", 190.5, 76.2, 0), ("GATE", 168.0, 85.09, 0),
         ("FIRE", 165.0, 185.42, 0), ("RELAY", 165.0, 187.96, 0), ("ZC", 165.0, 190.5, 0),
         ("HALL", 165.0, 193.04, 0), ("STITCH", 165.0, 200.66, 0), ("NEEDLE", 160.0, 205.74, 0),
         ("LIMIT", 80.0, 152.4, 0), ("FSR", 80.0, 171.45, 0), ("PEDAL", 80.0, 223.52, 0), ("KNEE", 80.0, 241.3, 0),
         ("HEEL", 36.07, 173.99, 0), ("HEEL", 36.07, 228.6, 0), ("HEEL", 56.39, 205.74, 0), ("HEEL_F", 80.5, 205.74, 0),
         ("HEEL_F", 158.0, 203.2, 0), ("ENC_A", 158.0, 177.8, 0), ("ENC_B", 158.0, 182.88, 0),
         ("ENC_A", 297.7, 172.72, 0), ("ENC_B", 297.7, 205.74, 0),
         ("ISENSE", 159.0, 127.0, 0), ("ISENSE", 109.6, 190.5, 0)]

CAP_LEFT = {"R7", "SW1", "SW2", "R6", "C2", "D2", "D3"}

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
  (instances (project "mcu_controller_rectified" (path "/{ROOT}" (reference "{ref}") (unit 1)))))""")
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
  (instances (project "mcu_controller_rectified" (path "/{ROOT}" (reference "#PWR{pw[0]:03d}") (unit 1)))))""")
connected = {p for s in segs for p in s}
for p, name in pins_all.items():
    if p not in connected:
        out.append(f"(no_connect (at {p[0]} {p[1]}) (uuid {U()}))")
for (nm, x, y, a) in NAMES:
    out.append(f'(label "{nm}" (at {x} {y} {a}) {eff(1.0, justify="left bottom")} (uuid {U()}))')

def text(t, x, y, size=1.27, bold=False, just="left bottom"):
    t = t.replace('"', '\\"')
    out.append(f'(text "{t}" (at {x} {y} 0) {eff(size, justify=just, bold=bold)} (uuid {U()}))')
# reference and value beside each part
for ref, (sym, val, x, y, r) in PARTS.items():
    if sym in ("MOC3023_H", "H11AA1_H", "Relay_H", "ACDC_5V_H", "CT_H"):
        w = 7.62 if sym == "ACDC_5V_H" else 5.08
        text(ref, x + w + 1.27, y - 1.0, 1.27, True); text(val, x + w + 1.27, y + 2.0, 1.0)
    elif sym == "Bridge":
        text(ref, x + 6.35, y - 3.0, 1.27, True); text(val, x + 6.35, y - 1.0, 1.0)
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
        dx = -3.81 if (sym == "Triac_R" or ref in CAP_LEFT) else 3.81
        j = "left bottom" if dx > 0 else "right bottom"
        text(ref, x + dx, y - 0.5, 1.27, True, j)
        for k, ln in enumerate(val.split(" ", 1) if len(val) > 9 else [val]):
            text(ln, x + dx, y + 1.6 + k * 1.6, 1.0, False, j)

def polyline(pts, w=0.4, kind="dash"):
    xy = " ".join(f"(xy {a} {b})" for a, b in pts)
    out.append(f"(polyline (pts {xy}) (stroke (width {w}) (type {kind})) (uuid {U()}))")
polyline([(20.32, YB), (398.78, YB)], 0.6)
text("LINE SIDE: LIVE, 120 V", 345.44, YB - 3.0, 2.0, True)
text("CONTROL SIDE: isolated, SELV (3.3 V / 5 V)", 345.44, YB + 6.0, 2.0, True)
text("ISOLATION BARRIER: U3, K1, U2, PS1 (and T1) straddle it; keep at least 6 mm creepage across it", 20.32, YB - 1.5, 1.27)
for (t, x, y) in [("MAINS IN, FUSE, SURGE; LIGHT OUTLET (always on)", 20.32, 38.1), ("MOTOR ON DC: BRIDGE, FREEWHEEL", 60.96, 68.58),
                  ("TRIAC STAGE (after AN1662: triac in series with the motor)", 134.62, 68.58),
                  ("MOTOR-ENABLE RELAY", 210.82, 104.14), ("ZERO-CROSS", 251.46, 104.14), ("ISOLATED 5 V", 304.8, 104.14),
                  ("RELAY DRIVER", 231.14, 162.56), ("ZERO-CROSS INPUT", 284.48, 139.7), ("TRIAC FIRING", 170.18, 128.27),
                  ("5 V BULK", 332.74, 121.92), ("MOTOR CURRENT (optional)", 132.08, 120.65), ("RP2350B CORE BOARD (pins by GPIO number)", 124.46, 165.1),
                  ("HAND-WHEEL INDEX SENSOR (one magnet, one pulse per stitch)", 200.66, 210.82),
                  ("HAND-WHEEL ENCODER (two Hall latches, quadrature; same cable as the index)", 297.18, 160.02),
                  ("HEEL SWITCH", 55.88, 199.39),
                  ("SWITCHES (internal pull-ups)", 170.18, 218.44),
                  ("OPERATOR INPUTS (RC-filtered ADC)", 20.32, 139.7)]:
    text(t, x, y, 1.5, True)
notes = [
 "NOTES. A concept drawn by Claude at Bob Drzyzgula's direction, October 2026: not built, not tested, values not checked.",
 "1. After Freescale AN1662: zero-cross interrupt sets a timer alarm (or a PIO program); at the firing delay a ~100 us gate pulse fires the",
 "   triac; hand-wheel period from edge timestamps; speed loop every half-cycle (120 Hz); stall watchdog. Added: isolation, relay, inputs.",
 "2. Pins (RP2350B): FIRE GP4; RELAY GP5; ZC GP6; HALL (index) GP7; ENC_A/B GP2/GP3 (PIO counter); STITCH GP10; HEEL GP11; NEEDLE GP12;",
 "   knee, pedal, FSR, limit on ADC0-3 (GP40-43); ISENSE ADC4; ADC5-7 spare; GP8/GP9 UART1 for debug (or USB serial). Avoid GP0, GP23, GP25 (PSRAM, key, LED).",
 "3. PS1 feeds VSYS through D2, so USB may stay plugged in (the control side is SELV). Flash by UF2 (BOOTSEL) or SWD. Drive GP4 at 8-12 mA.",
 "4. Fire only after a zero-cross has been seen and the command is zero; close K1 last and open it first. Never scope the line side.",
 "5. R7/R8: ~3.9 mA peak in the H11AA1; R11: ~8 mA into U3 from 3.3 V; R6/C2 fitted only if a snubberless triac false-fires. T1 optional: the bridge's AC lead through its window, 0.1 V/A about 1.65 V.",
 "6. On a WeAct RP2350B Core board, feed PS1 to the 5V pin: the board has its own diode from USB VBUS, so D2 may be left out.",
 "7. Heel: momentary switch to GND in either pedal (J5 pin 4, J6 pin 3); a heel tap sends the needle to its other stop.",
 "8. Encoder U5/U6 (ring of alternating magnets) optional: stops taught and landed by angle; 5-wire cable (3V3, GND, index, A, B).",
 "9. RECTIFIED-DC VARIANT: BR1 turns the triac's output into DC; D3 carries the motor's current between firings. J3 is the motor's own keyed",
 "   connector (or the leads pass through and are hardwired), never a mains outlet, and is at line potential. T1 sits on the AC side: a CT can't sense DC.",
]
for i, n in enumerate(notes):
    text(n, 20.32, 258.6 + i * 2.4, 1.15, i == 0)

libs = "\n".join(s["text"] for s in SYMS.values())
sch = f"""(kicad_sch (version 20230121) (generator eeschema)
  (uuid {ROOT})
  (paper "A3")
  (title_block
    (title "VSM MCU phase controller, rectified-DC variant (concept)")
    (date "2026-10-27")
    (rev "draft-4r")
    (comment 1 "After Freescale AN1662, with an isolated control side; RP2350B core board")
    (comment 2 "Drafted by Claude at the direction of Robert Drzyzgula; not built or tested"))
  (lib_symbols
{libs})
{chr(10).join(out)}
  (sheet_instances (path "/" (page "1"))))
"""
open(sys.argv[1] if len(sys.argv) > 1 else "hardware/mcu-controller-rectified/mcu_controller_rectified.kicad_sch", "w").write(sch)
for g in sorted(groups.values(), key=lambda v: sorted(v)):
    if len(g) > 1:
        print(" ".join(sorted(g)))
