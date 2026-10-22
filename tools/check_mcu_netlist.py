#!/usr/bin/env python3
"""Compare the netlist tools/make_mcu_schematic.py intends with KiCad's.
Usage: python3 tools/make_mcu_schematic.py > intended.txt
       kicad-cli sch export netlist -o kicad.net hardware/mcu-controller/mcu_controller.kicad_sch
       python3 tools/check_mcu_netlist.py intended.txt kicad.net"""
import re, sys
s = open(sys.argv[2]).read()
kic = set()
for m in re.finditer(r'\(net \(code "?\d+"?\) \(name "([^"]*)"\)(.*?)(?=\(net \(code|\Z)', s, re.S):
    nodes = sorted(f"{r}.{p}" for r, p in re.findall(r'\(ref "([^"]+)"\) \(pin "([^"]+)"', m.group(2)) if not r.startswith("#"))
    if len(nodes) > 1:
        kic.add(" ".join(nodes))
mine, pw = set(), {}
for g in (l.split() for l in open(sys.argv[1])):
    p = [x for x in g if x.startswith("<")]
    n = [x for x in g if not x.startswith("<")]
    if p:
        pw.setdefault(p[0], []).extend(n)
    else:
        mine.add(" ".join(sorted(n)))
mine |= {" ".join(sorted(v)) for v in pw.values()}
bad = (kic - mine) | (mine - kic)
print("netlists match" if not bad else f"MISMATCH\n only KiCad: {kic - mine}\n only intended: {mine - kic}")
sys.exit(1 if bad else 0)
