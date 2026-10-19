# KB3151C triac board

`KB3151C.kicad_sch` is a schematic of the XWW pedal speed-control board
(KB3151C, 75 × 35 mm) that the knee controller reuses, traced from photos
of the board. It is a diac-triggered triac phase control, a two-terminal
device in series with the motor. Open it in KiCad 7 or later.

The notes on the sheet list the points still to be checked with a meter
(marked VERIFY). The figure in the motor-control paper is exported from it
by `tools/export_schematic.sh` (run by `make images`).

For the knee controller, the slide pot RV1 is replaced by a Bourns 91 pot
wired as a two-terminal resistor, with RV1's pin-3 pad jumpered to its
wiper pad so that RV2 lies across the new pot; see chapter 9 of the User's
Guide.

The motor test rig in [`../motor-rig/`](../motor-rig/RIG_GUIDE.md) studies
this board on the bench, with a decade box in place of RV1.
