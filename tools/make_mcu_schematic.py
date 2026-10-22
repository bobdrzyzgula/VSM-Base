#!/usr/bin/env python3
"""Generate the draft MCU phase-controller schematic (KiCad 7 format).

Writes hardware/mcu-controller/mcu_controller.kicad_sch. Every symbol is
defined here (no KiCad libraries needed), and every connection is made by a
net label (or power port) on a short stub at each pin, so the netlist is
exactly the NETS table below. Run from the repository root.
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
for n in (2, 3, 4):
    pins = [(str(i + 1), str(i + 1), -5.08, (n - 1) * G / 2 - i * G, 0, 3.81, "passive") for i in range(n)]
    symbol(f"Conn_{n}", "J", pins, [rect(-1.27, -(n * G) / 2, 1.27, (n * G) / 2)],
           ref_at=(0, (n * G) / 2 + 1.27), val_at=(0, -(n * G) / 2 - 1.27))
# Nucleo-32 (NUCLEO-G431KB): CN3 left, CN4 right; names from UM2397
CN3 = ["VIN", "GND", "NRST", "+5V", "A7/PA2", "A6/PA7", "A5/PA6", "A4/PA5", "A3/PA4", "A2/PA3",
       "A1/PA1", "A0/PA0", "AREF", "3V3", "D13/PB3"]
CN4 = ["D1/PA9", "D0/PA10", "NRST", "GND", "D2/PA12", "D3/PB0", "D4/PB7", "D5/PA15", "D6/PB6",
       "D7/PF0", "D8/PF1", "D9/PA8", "D10/PA11", "D11/PB5", "D12/PB4"]
pins = [(f"CN3_{i+1}", nm, -17.78, 17.78 - i * G, 0, 5.08, "bidirectional") for i, nm in enumerate(CN3)]
pins += [(f"CN4_{i+1}", nm, 17.78, 17.78 - i * G, 180, 5.08, "bidirectional") for i, nm in enumerate(CN4)]
symbol("NUCLEO-G431KB", "A", pins, [rect(-12.7, -20.32, 12.7, 20.32, fill="background")], show_names=True,
       ref_at=(0, 21.59), val_at=(0, -21.59))
symbol("+5V", "#PWR", [("1", "+5V", 0, 0, 90, 0, "power_in")],
       [line((-0.762, 1.27), (0, 2.54), (0.762, 1.27)), line((0, 0), (0, 2.54))], power=True, val_at=(0, 3.556))
symbol("+3V3", "#PWR", [("1", "+3V3", 0, 0, 90, 0, "power_in")],
       [line((-0.762, 1.27), (0, 2.54), (0.762, 1.27)), line((0, 0), (0, 2.54))], power=True, val_at=(0, 3.556))
symbol("GND", "#PWR", [("1", "GND", 0, 0, 270, 0, "power_in")],
       [line((0, 0), (0, -1.27), (1.27, -1.27), (0, -2.54), (-1.27, -1.27), (0, -1.27))], power=True, val_at=(0, -3.81))
POWER = {"+5V", "+3V3", "GND"}

# ---------------------------------------------------------------- parts
# (ref, symbol, value, x, y, {pin: net}, note)
P = []
def part(ref, sym, val, x, y, nets, fp=""):
    P.append((ref, sym, val, x, y, nets))

# Line side ------------------------------------------------------------
part("J1", "Conn_3", "IEC C14 inlet (L, N, PE)", 40.64, 45.72, {"1": "L_IN", "2": "N", "3": "PE"})
part("F1", "Fuse", "T2A 250V", 60.96, 45.72, {"1": "L_IN", "2": "L_F"})
part("RV1", "MOV", "150VAC 14mm", 76.2, 45.72, {"1": "L_F", "2": "N"})
part("F2", "Fuse", "T250mA", 91.44, 45.72, {"1": "L_F", "2": "L_PS"})
part("J2", "Conn_4", "to duplex outlet: LIGHT hot, MOTOR hot, N, PE", 40.64, 83.82,
     {"1": "L_F", "2": "MOT_OUT", "3": "N", "4": "PE"})
part("Q1", "Triac", "BTA08-600BW", 76.2, 121.92, {"1": "L_K", "2": "MOT_OUT", "3": "GATE"})
part("R4", "R", "360 0.5W", 91.44, 121.92, {"1": "MOT_OUT", "2": "OPTO_MT"})
part("R5", "R", "330", 50.8, 121.92, {"1": "GATE", "2": "L_K"})
part("R6", "R", "100 1W (DNP)", 111.76, 121.92, {"1": "MOT_OUT", "2": "SNUB"})
part("C2", "C", "47n X2 (DNP)", 132.08, 121.92, {"1": "SNUB", "2": "L_K"})
part("R7", "R", "22k 0.5W", 76.2, 170.18, {"1": "L_F", "2": "ZC_A"})
part("R8", "R", "22k 0.5W", 91.44, 170.18, {"1": "ZC_B", "2": "N"})
# Across the barrier --------------------------------------------------
part("K1", "Relay_SPST", "G5LE-1A 5V (motor enable)", 175.26, 68.58,
     {"3": "L_F", "4": "L_K", "1": "+5V", "2": "RLY_D"})
part("U3", "MOC3023", "MOC3023", 175.26, 121.92,
     {"6": "OPTO_MT", "4": "GATE", "1": "OPTO_A", "2": "GND"})
part("U2", "H11AA1", "H11AA1", 175.26, 170.18,
     {"1": "ZC_A", "2": "ZC_B", "5": "ZC", "4": "GND"})
part("PS1", "ACDC_5V", "IRM-05-5 (5V 1A, isolated)", 175.26, 218.44,
     {"1": "L_PS", "2": "N", "3": "+5V", "4": "GND"})
# Control side ---------------------------------------------------------
part("D1", "D", "1N4148", 210.82, 68.58, {"1": "+5V", "2": "RLY_D"})
part("Q2", "NMOS", "2N7002", 231.14, 68.58, {"3": "RLY_D", "2": "GND", "1": "RLY_G"})
part("R12", "R", "100", 246.38, 68.58, {"1": "RELAY", "2": "RLY_G"})
part("R13", "R", "100k", 256.54, 68.58, {"1": "RLY_G", "2": "GND"})
part("R11", "R", "270", 210.82, 121.92, {"1": "FIRE", "2": "OPTO_A"})
part("R9", "R", "10k", 210.82, 170.18, {"1": "+3V3", "2": "ZC"})
part("C3", "C", "1n", 220.98, 170.18, {"1": "ZC", "2": "GND"})
part("C12", "C", "10u", 243.84, 170.18, {"1": "+5V", "2": "GND"})
part("C13", "C", "100n", 254.0, 170.18, {"1": "+5V", "2": "GND"})
part("A1", "NUCLEO-G431KB", "NUCLEO-G431KB", 299.72, 129.54, {
    "CN3_2": "GND", "CN3_4": "+5V", "CN3_14": "+3V3",
    "CN3_12": "KNEE_F", "CN3_11": "PEDAL_F", "CN3_10": "FSR_F", "CN3_9": "LIMIT_F",
    "CN4_4": "GND", "CN4_5": "ZC", "CN4_6": "FIRE", "CN4_7": "NEEDLE", "CN4_9": "HALL_F",
    "CN4_12": "STITCH", "CN4_14": "RELAY"})
# hand-wheel Hall sensor and its input
part("J3", "Conn_3", "hand-wheel Hall sensor", 210.82, 218.44, {"1": "+3V3", "2": "HALL", "3": "GND"})
part("R14", "R", "10k", 226.06, 218.44, {"1": "+3V3", "2": "HALL"})
part("R15", "R", "100", 236.22, 218.44, {"1": "HALL", "2": "HALL_F"})
part("C4", "C", "1n", 246.38, 218.44, {"1": "HALL_F", "2": "GND"})
part("U4", "DRV5023", "DRV5023 (at the hand wheel)", 297.18, 218.44, {"1": "+3V3", "2": "HALL", "3": "GND"})
part("C5", "C", "100n (at sensor)", 266.7, 218.44, {"1": "+3V3", "2": "GND"})
# operator inputs
part("J4", "Conn_3", "knee lever sensor (pot or Hall)", 355.6, 45.72, {"1": "+3V3", "2": "KNEE", "3": "GND"})
part("R16", "R", "1k", 370.84, 45.72, {"1": "KNEE", "2": "KNEE_F"})
part("C6", "C", "100n", 381.0, 45.72, {"1": "KNEE_F", "2": "GND"})
part("J5", "Conn_3", "travel pedal (pot or Hall)", 355.6, 76.2, {"1": "+3V3", "2": "PEDAL", "3": "GND"})
part("R17", "R", "1k", 370.84, 76.2, {"1": "PEDAL", "2": "PEDAL_F"})
part("C7", "C", "100n", 381.0, 76.2, {"1": "PEDAL_F", "2": "GND"})
part("J6", "Conn_2", "pressure pedal (FSR)", 355.6, 106.68, {"1": "+3V3", "2": "FSR"})
part("R18", "R", "10k", 365.76, 106.68, {"1": "FSR", "2": "GND"})
part("R19", "R", "1k", 375.92, 106.68, {"1": "FSR", "2": "FSR_F"})
part("C8", "C", "100n", 386.08, 106.68, {"1": "FSR_F", "2": "GND"})
part("RV2", "Pot", "10k lin (speed limit, panel)", 358.14, 137.16, {"1": "+3V3", "2": "LIMIT", "3": "GND"})
part("R20", "R", "1k", 370.84, 137.16, {"1": "LIMIT", "2": "LIMIT_F"})
part("C9", "C", "100n", 381.0, 137.16, {"1": "LIMIT_F", "2": "GND"})
part("SW1", "SW", "needle stop up/down (toggle)", 358.14, 172.72, {"1": "NEEDLE", "2": "GND"})
part("C10", "C", "100n", 370.84, 172.72, {"1": "NEEDLE", "2": "GND"})
part("SW2", "SW", "single stitch (push)", 358.14, 203.2, {"1": "STITCH", "2": "GND"})
part("C11", "C", "100n", 370.84, 203.2, {"1": "STITCH", "2": "GND"})

# ---------------------------------------------------------------- emit
out = []
def stub_dir(a):           # outward direction (screen coords) for a pin of lib angle a
    return {0: (-1, 0), 180: (1, 0), 90: (0, 1), 270: (0, -1)}[a]

pwr_n = [0]
netlist = {}
for (ref, sym, val, x, y, nets) in P:
    S = SYMS[sym]
    props = [f'(property "Reference" "{ref}" (at {x + 0} {y - 0} 0) {eff(hide=True)})',
             f'(property "Value" "{val}" (at {x} {y} 0) {eff(hide=True)})']
    pin_uuids = " ".join(f'(pin "{n}" (uuid {U()}))' for n in S["pins"])
    # visible reference and value as free text beside the symbol
    out.append(f'''(symbol (lib_id "VSM:{sym}") (at {x} {y} 0) (unit 1) (in_bom yes) (on_board yes) (dnp no) (uuid {U()})
  {props[0]}
  {props[1]}
  (property "Footprint" "" (at {x} {y} 0) {eff(hide=True)})
  (property "Datasheet" "" (at {x} {y} 0) {eff(hide=True)})
  {pin_uuids}
  (instances (project "mcu_controller" (path "/{ROOT}" (reference "{ref}") (unit 1)))))''')
    # labels: ref and value placed above-right of the body
    lib = S["text"]
    for n, pin in S["pins"].items():
        _, nm, px, py, a, l, t = pin
        sx, sy = x + px, y - py                     # pin's connection point (screen)
        net = nets.get(n)
        if net is None:
            if t == "no_connect" or nm in ("NC", "B", "VIN", "NRST", "AREF") or sym.startswith("NUCLEO"):
                out.append(f"(no_connect (at {sx} {sy}) (uuid {U()}))")
            continue
        netlist.setdefault(net, []).append(f"{ref}.{n}")
        dx, dy = stub_dir(a)
        ex, ey = round(sx + dx * G, 2), round(sy + dy * G, 2)
        out.append(f"(wire (pts (xy {sx} {sy}) (xy {ex} {ey})) (stroke (width 0) (type default)) (uuid {U()}))")
        if net in POWER:
            pwr_n[0] += 1
            if net == "GND":
                rot = {(0, 1): 0, (1, 0): 90, (0, -1): 180, (-1, 0): 270}[(dx, dy)]
            else:
                rot = {(0, -1): 0, (-1, 0): 90, (0, 1): 180, (1, 0): 270}[(dx, dy)]
            out.append(f'''(symbol (lib_id "VSM:{net}") (at {ex} {ey} {rot}) (unit 1) (in_bom no) (on_board no) (dnp no) (uuid {U()})
  (property "Reference" "#PWR{pwr_n[0]:03d}" (at {ex} {ey} 0) {eff(hide=True)})
  (property "Value" "{net}" (at {ex} {ey} 0) {eff(1.0, hide=True)})
  (property "Footprint" "" (at {ex} {ey} 0) {eff(hide=True)})
  (property "Datasheet" "" (at {ex} {ey} 0) {eff(hide=True)})
  (pin "1" (uuid {U()}))
  (instances (project "mcu_controller" (path "/{ROOT}" (reference "#PWR{pwr_n[0]:03d}") (unit 1)))))''')
        else:
            ang = {(-1, 0): 180, (1, 0): 0, (0, -1): 90, (0, 1): 270}[(dx, dy)]
            just = "left bottom" if ang in (0, 90) else "right bottom"
            out.append(f'(label "{net}" (at {ex} {ey} {ang}) {eff(1.0, justify=just)} (uuid {U()}))')

# reference/value captions
def text(t, x, y, size=1.27, bold=False, just="left bottom"):
    t = t.replace('"', '\\"')
    out.append(f'(text "{t}" (at {x} {y} 0) {eff(size, justify=just, bold=bold)} (uuid {U()}))')
for (ref, sym, val, x, y, nets) in P:
    S = SYMS[sym]
    xs = [p[2] for p in S["pins"].values()]
    ys = [p[3] for p in S["pins"].values()]
    big = sym in ("MOC3023", "H11AA1", "ACDC_5V", "Relay_SPST", "NUCLEO-G431KB", "DRV5023") or sym.startswith("Conn")
    if big:
        top = y - max(ys) - (5.08 if not sym.startswith("Conn") else 3.0)
        text(ref, x, top - 2.0, 1.27, True, "left bottom" if sym.startswith("Conn") else "left bottom")
        text(val, x, top, 1.0)
    else:
        cx, j = (x - 3.81, "right bottom") if sym == "Pot" else (x + 3.81, "left bottom")
        text(ref, cx, y - 0.5, 1.27, True, j)
        for k, ln in enumerate(val.split(" ", 1) if len(val) > 12 else [val]):
            text(ln, cx, y + 1.6 + k * 1.6, 1.0, False, j)

def polyline(pts, w=0.4, kind="dash"):
    xy = " ".join(f"(xy {a} {b})" for a, b in pts)
    out.append(f"(polyline (pts {xy}) (stroke (width {w}) (type {kind})) (uuid {U()}))")

# isolation barrier
polyline([(175.26, 25.4), (175.26, 280.0)], 0.6)
text("LINE SIDE: LIVE, 120 V", 120, 28, 2.0, True)
text("CONTROL SIDE: isolated, SELV (3.3 V / 5 V)", 182, 28, 2.0, True)
text("ISOLATION BARRIER: U2, U3, K1, PS1 straddle it; keep >= 6 mm creepage", 177.8, 278.0, 1.27)
# block titles
for (t, x, y) in [("MAINS IN, FUSING, SURGE", 25.4, 35.56), ("OUTLET (base's duplex: LIGHT always on, MOTOR controlled)", 25.4, 73.66),
                  ("MOTOR ENABLE RELAY (cuts the triac's line on a fault)", 120, 58.42),
                  ("TRIAC STAGE (AN1662: triac in series with the motor)", 25.4, 106.68),
                  ("ZERO-CROSS DETECTOR (AN1662 uses a resistor to a pin; here isolated)", 25.4, 154.94),
                  ("ISOLATED 5 V SUPPLY", 120, 205.74), ("RELAY DRIVER", 203.2, 58.42), ("TRIAC FIRING (LED of U3)", 203.2, 106.68),
                  ("ZERO-CROSS INPUT", 203.2, 154.94), ("5 V BULK", 238.76, 154.94),
                  ("NUCLEO-32 (STM32G431KB)", 281.94, 101.6), ("HAND-WHEEL HALL SENSOR (one magnet: one pulse per stitch)", 203.2, 203.2),
                  ("OPERATOR INPUTS (RC-filtered ADC; switches: internal pull-ups)", 335.28, 33.02)]:
    text(t, x, y - 5.08, 1.5, True)

notes = [
 "NOTES (draft, Claude at Bob Drzyzgula's direction, October 2026; not built or tested)",
 "1. After Freescale AN1662 (Skalka): zero-cross interrupt starts a timer; at the firing angle a short gate pulse (~100 us) fires the triac each half-cycle;",
 "   tacho period measured by input capture; speed loop updated every half-cycle (120 Hz); stall watchdog. Added here: full isolation, relay, inputs.",
 "2. Pins: ZC on D2/PA12 (EXTI); FIRE on D3/PB0 (TIM3_CH3, one-pulse); HALL on D6/PB6 (TIM4_CH1 input capture); RELAY on D11/PB5;",
 "   A0-A3 = knee, pedal, FSR, speed limit; NEEDLE on D4/PB7 (SB2 must be OFF); STITCH on D9/PA8. D0/D1 left for the ST-LINK virtual COM port.",
 "3. Power: PS1 feeds CN3-4 (+5V). Per UM2397 the ST-LINK is then unpowered: program and debug over USB with the mains unplugged.",
 "   For live debugging use a USB isolator. Never connect a scope ground to the line side.",
 "4. Fire only after a zero-cross has been seen and the speed command is zero (no start on power-up); close K1 last, open it first.",
 "5. Values to check: R7/R8 set H11AA1 LED current (~3.9 mA peak at 170 V); R11 gives ~8 mA into U3 from 3.3 V; Q1 needs a heatsink for long runs;",
 "   R6/C2 snubber is DNP with a snubberless (BW) triac and fitted if it false-fires; MOV 150 VAC for 120 V mains.",
 "6. Hall: DRV5023 unipolar switch (open drain) at the hand wheel on a 3-wire cable; one magnet gives one pulse per stitch and needle position.",
]
for i, n in enumerate(notes):
    text(n, 20.32, 230.0 + i * 3.6, 1.27, i == 0)

body = "\n".join(out)
libs = "\n".join(s["text"] for s in SYMS.values())
sch = f'''(kicad_sch (version 20230121) (generator eeschema)
  (uuid {ROOT})
  (paper "A3")
  (title_block
    (title "VSM MCU phase controller (draft)")
    (date "2026-10-22")
    (rev "draft-1")
    (comment 1 "After Freescale AN1662, with an isolated control side; NUCLEO-G431KB")
    (comment 2 "Drafted by Claude at the direction of Robert Drzyzgula; not built or tested"))
  (lib_symbols
{libs})
{body}
  (sheet_instances (path "/" (page "1"))))
'''
open(sys.argv[1] if len(sys.argv) > 1 else "hardware/mcu-controller/mcu_controller.kicad_sch", "w").write(sch)
for k in sorted(netlist):
    print(f"{k}: {' '.join(netlist[k])}")
