#!/bin/sh
# Export the triac board's schematic, and the MCU controller concept, as SVG
# figures for the motor-control paper, cropped to the drawing. Needs kicad-cli (KiCad 7 or later).
# Usage: sh tools/export_schematic.sh   (run from the repository root)
set -e
SCH=hardware/triac-board/KB3151C.kicad_sch
OUT=docs/images/diagrams/kb3151c-schematic.svg
TMP=$(mktemp -d)
HOME=$TMP kicad-cli sch export svg --exclude-drawing-sheet -o "$TMP" "$SCH" > /dev/null
# crop the A4 sheet to the circuit (mm), leaving out the notes below it
# (the paper's caption carries them)
python3 - "$TMP/KB3151C.svg" "$OUT" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
x, y, w, h = 34, 31, 206, 89
s = re.sub(r'width="[^"]*mm" height="[^"]*mm" viewBox="[^"]*"',
           f'width="{w}mm" height="{h}mm" viewBox="{x} {y} {w} {h}"', s, count=1)
open(sys.argv[2], "w").write(s)
PY
# the MCU controller concept, cropped the same way (its notes are in the paper)
MCU=hardware/mcu-controller/mcu_controller.kicad_sch
MOUT=docs/images/diagrams/mcu-controller-schematic.svg
HOME=$TMP kicad-cli sch export svg --exclude-drawing-sheet -o "$TMP" "$MCU" > /dev/null
python3 - "$TMP/mcu_controller.svg" "$MOUT" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
x, y, w, h = 18, 33, 386, 224
s = re.sub(r'width="[^"]*mm" height="[^"]*mm" viewBox="[^"]*"',
           f'width="{w}mm" height="{h}mm" viewBox="{x} {y} {w} {h}"', s, count=1)
open(sys.argv[2], "w").write(s)
PY
rm -rf "$TMP"
echo "wrote $OUT and $MOUT"
