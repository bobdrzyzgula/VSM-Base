#!/bin/sh
# Export the triac board's schematic, and the MCU controller concepts (mains, rectified DC and DC motor), as SVG
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
# the DC-motor variant, cropped the same way
DC=hardware/mcu-controller-dc/mcu_controller_dc.kicad_sch
DOUT=docs/images/diagrams/mcu-controller-dc-schematic.svg
HOME=$TMP kicad-cli sch export svg --exclude-drawing-sheet -o "$TMP" "$DC" > /dev/null
python3 - "$TMP/mcu_controller_dc.svg" "$DOUT" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
x, y, w, h = 18, 33, 386, 222
s = re.sub(r'width="[^"]*mm" height="[^"]*mm" viewBox="[^"]*"',
           f'width="{w}mm" height="{h}mm" viewBox="{x} {y} {w} {h}"', s, count=1)
open(sys.argv[2], "w").write(s)
PY
# the rectified-DC variant of the mains controller, cropped like the mains one
RC=hardware/mcu-controller-rectified/mcu_controller_rectified.kicad_sch
ROUT=docs/images/diagrams/mcu-controller-rectified-schematic.svg
HOME=$TMP kicad-cli sch export svg --exclude-drawing-sheet -o "$TMP" "$RC" > /dev/null
python3 - "$TMP/mcu_controller_rectified.svg" "$ROUT" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
x, y, w, h = 18, 33, 386, 224
s = re.sub(r'width="[^"]*mm" height="[^"]*mm" viewBox="[^"]*"',
           f'width="{w}mm" height="{h}mm" viewBox="{x} {y} {w} {h}"', s, count=1)
open(sys.argv[2], "w").write(s)
PY
rm -rf "$TMP"
echo "wrote $OUT, $MOUT, $DOUT and $ROUT"
