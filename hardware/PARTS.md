# Electronic parts: knee controller, test rig, MCU controller

*Compiled by Claude at Bob Drzyzgula's direction, October 2026. A working
shopping list. Mechanical hardware (screws, bearings, springs, belts,
plywood) stays in each project's own guide.*

**Where each part is used:**
- **K:** the knee controller (User's Guide, chapter 9);
- **R:** the motor test rig (`motor-rig/RIG_GUIDE.md`);
- **M:** the MCU controller, a concept so far (`mcu-controller/`; references
  are to its schematic);
- **B:** the base's outlet compartment.

**Sourcing, in three classes:**
- **Any:** a generic part that AliExpress is fine for, at the stated
  rating.
- **Check:** generic, but counterfeits or under-rated copies are common.
  Buy from a seller who states the rating, and check it on arrival.
- **Dist:** buy from a distributor (Digi-Key, Mouser, Newark). These parts
  carry mains safety, or their exact part matters; clones of them are
  common and not equivalent.

Record any substitution in the log at the end: what was bought, from
where, and the specification checked.

## Mains-side parts

| Item | Specification | Qty | Use | Source | Notes |
|---|---|---|---|---|---|
| Fused IEC C14 inlet | Snap-in, 52.5 × 27.5 mm cutout, 1-pole fuse drawer, 5 × 20 mm fuse | 1 K, 1 R, 1 M | K R M | Dist | Schurter KE16.5100.107 as specified for K; the same cutout serves R. Check the depth behind the panel (`knee_iec_depth`). |
| Fuses, slow-blow 5 × 20 mm | T2A 250 V; T250mA 250 V (M's supply) | a few of each | K R M | Dist | Cheap, but fake fuses are a known hazard. |
| PCB fuse holders, 5 × 20 mm | Clip or enclosed, 250 V | 2 | M | Check | F1, F2 |
| Lever connectors | Wago 221-413 (3 positions, 0.2–4 mm²) | 3 K, 6 R | K R | Dist | Genuine Wago only; the copies are not the same. |
| Duplex outlet | US 15 A duplex receptacle, center screw hole | 1 | B | Any | Its tie bar broken off so LIGHT and MOTOR are separate; size checked by the console |
| Pedal cordset | Standard sewing-machine pedal controller cordset (plug or duplex at the junction) | 1 | K | Any | `knee_power = "cordset"` only |
| Speed-control board | XWW KB3151C pedal board, 75 × 35 mm | 1 + spare | K R | Any | The board itself comes from pedal listings. |
| Quick-disconnects | Female FASTON, 3.2 mm (.125") tab size, insulated | 4 | K R | Any | To fit the KB3151C's tabs (measured). Not the common 6.3 mm (.250") size. |
| Triac | BTA08-600BW (snubberless, insulated tab), TO-220 | 2 | M | Dist | BTA16-600BW if more margin is wanted |
| TO-220 heatsink | Small clip-on or bolt-on, about 10 °C/W | 1 | M | Any | The tab is insulated on the BTA type. |
| Opto-triac driver | MOC3023, random-phase (not the zero-crossing MOC304x) | 2 | M | Dist | U3 |
| AC-input optocoupler | H11AA1, or another AC-input optocoupler | 2 | M | Dist | U2 |
| Relay | Omron G5LE-1A 5 V DC (SPST-NO, 10 A), or a like 5 V relay with a stated mains rating | 1 | M | Check | K1 |
| Isolated 5 V supply | Mean Well IRM-05-5 (5 V 1 A, safety-certified) | 1 | M | Dist | PS1. Hi-Link copies are common; buy the certified part. |
| MOV | 14 mm disc, 150 VAC rating (varistor voltage about 240 V, e.g. 14D241K) | 2 | M | Check | RV1 |
| Resistors, mains | 22 kΩ 0.5 W (2, R7/R8); 360 Ω 0.5 W (R4); 100 Ω 1 W (R6, DNP) | 1 set | M | Any | Metal film, 350 V or higher working voltage for R7/R8 |
| Resistor | 330 Ω 0.25 W (R5) | 1 | M | Any | |
| X2 capacitor | 47 nF X2 (C2, DNP) | 1 | M | Check | Must be X2-rated across the mains. |
| Screw terminals | 5.08 mm pitch, 300 V rated | a few | M | Any | For the mains wiring on a prototype board |
| Hook-up wire | 18 AWG, 300 V insulation (600 V better), stranded | a few m | K R M | Any | |
| Isolation transformer | Hammond 171B (200 VA), corded | 1 | R | Dist | Needed only when the scope goes on the AC side |

## Low-voltage parts

| Item | Specification | Qty | Use | Source | Notes |
|---|---|---|---|---|---|
| Controller board | WeAct Studio RP2350B Core V1.0 | 2–3 | M | Any | A1, about $6. Its schematic and model: <https://github.com/WeActStudio/WeActStudio.RP2350BCoreBoard> |
| Pin headers for it | 2.54 mm female headers, 1 × 15 (or 2 × 15), to socket the board | 4 (or 2) | M | Any | |
| Debug probe (optional) | Raspberry Pi Debug Probe, or a second Pico board as a probe | 1 | M | Any | Only for step-through debugging; flashing works over USB. |
| MOSFET | 2N7002, SOT-23 (or 2N7000, TO-92, on perfboard) | 2 | M | Any | Q2, the relay driver |
| Diodes | 1N4148 (D1); SS14 Schottky (D2; can be left out on the WeAct board) | a few | M | Any | |
| Resistors, 0.25 W | 270 Ω (R11), 100 Ω (R12, R15), 100 kΩ (R13), 10 kΩ (R9, R14, R18), 1 kΩ (R16, R17, R19, R20) | 1 set | M | Any | An assortment kit covers these. |
| Capacitors | 100 nF ceramic (about 10), 1 nF ceramic (2), 10 µF (1) | 1 set | M | Any | |
| Hand-wheel sensor | TI DRV5023 unipolar Hall switch (TO-92 for wiring at the sensor), 3.3 V-capable | 2 | M | Dist | U4. Generic A3144 parts need 4.5 V or more; don't substitute those. |
| Magnet | Neodymium disc, about 6 × 3 mm | a few | M | Any | One on the hand wheel; check the pole facing the sensor. |
| Knee and pedal sensors | 10 kΩ linear pot, or a linear Hall sensor (DRV5055 or SS49E class) with a magnet | 2 | M | Any | For the knee lever and the travel pedal |
| Pressure sensor | FSR, Interlink 402 (round) or 406 (square) | 1 | M | Check | The pressure pedal. Clones vary widely in range. |
| Speed-limit knob | 10 kΩ linear panel pot, with knob | 1 | M | Any | RV2 |
| Switches | SPDT or SPST panel toggle (needle up/down); momentary push button (single stitch) | 1 each | M | Any | |
| Pedal and sensor connectors | 3- or 4-pin, to be chosen: GX12 aviation, M8, or 3.5 mm TRS jacks | to suit | M | Any | Low voltage only, but they must never be mistakable for a mains connector. |
| Cable | 3- or 4-core shielded, 24–26 AWG | a few m | M | Any | Hall sensor and pedals |
| Prototype board | Perfboard or stripboard; a breadboard for first tests | 1–2 | M R | Any | Keep 6 mm between mains and low-voltage copper. |

## Test rig panel and patching

| Item | Specification | Qty | Use | Source | Notes |
|---|---|---|---|---|---|
| Panel sockets | 4 mm shrouded (safety) banana sockets, panel mount; red and black among them | 11 | R | Check | Shrouded, rated for mains (CAT II 600 V or better) |
| Safety banana leads | 4 mm shrouded both ends, CAT II or better | 6–8 | R | Check | |
| Shorting plugs (optional) | 4 mm shrouded, 19 mm spacing | 2 | R | Check | |
| Breadboard | Half-size, 400 points | 1 | R | Any | |
| Jumper wires | Breadboard jumpers | 1 set | R | Any | |

## Bench equipment the rig assumes

These are probably on hand already:
- a DC bench supply;
- a multimeter;
- a scope, and with it either the isolation transformer above or a
  differential probe;
- a plug-in power meter (Kill-A-Watt type);
- a decade resistance box rated for at least 200 V, with resistors of at
  least 0.5 W each;
- a kitchen scale for the brake, about 75 × 80 mm;
- a tachometer.

## Substitution log

| Date | Item | Bought instead | From | Specification checked | Notes |
|---|---|---|---|---|---|
| | | | | | |
