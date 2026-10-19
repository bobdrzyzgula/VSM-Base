#!/bin/sh
# Export the triac board's schematic as an SVG figure for the motor-control
# paper, cropped to the drawing. Needs kicad-cli (KiCad 7 or later).
# Usage: sh tools/export_schematic.sh   (run from the repository root)
set -e
SCH=hardware/triac-board/KB3151C.kicad_sch
OUT=docs/images/diagrams/kb3151c-schematic.svg
TMP=$(mktemp -d)
HOME=$TMP kicad-cli sch export svg --exclude-drawing-sheet -o "$TMP" "$SCH" > /dev/null
# crop the A4 sheet to the drawing (mm): x 4..240, y 28..152
python3 - "$TMP/KB3151C.svg" "$OUT" <<'PY'
import re, sys
s = open(sys.argv[1]).read()
x, y, w, h = 4, 28, 236, 124
s = re.sub(r'width="[^"]*mm" height="[^"]*mm" viewBox="[^"]*"',
           f'width="{w}mm" height="{h}mm" viewBox="{x} {y} {w} {h}"', s, count=1)
open(sys.argv[2], "w").write(s)
PY
rm -rf "$TMP"
echo "wrote $OUT"
