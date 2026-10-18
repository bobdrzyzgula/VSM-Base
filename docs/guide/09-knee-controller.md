# Knee controller

*This chapter is a draft. The mechanism has been checked in the model but
not yet built.*

With `compartment_option = "knee"`, the base's right bay becomes a knee
speed control, in the manner of Singer's own knee-lever machines. A bar
hangs down past the table edge. Pressing it with your knee turns a shaft
running front to back in the bay. A gear sector on the shaft turns a
potentiometer, which takes the place of the slide pot on an inexpensive
foot-pedal speed-control board. A snap switch cuts the motor whenever the
bar is at rest.

![The knee controller in the right bay (part `knee_assembly`, a cutaway):
the hub and bar socket on the front face, the shaft, the sector and pinion
in front of the bulkhead, and the board cover at the back.](../images/renders/knee.png){width=90%}

> **Warning: mains voltage.** The donor board, the pot's pins, the switch's
> terminals and every wire to them are live whenever the controller is
> plugged in. The triac's tab is connected to the live side. Work on it only
> with the plug pulled, keep the printed cover on the board, use wire rated
> for 300 V or more, and don't use a pot with a metal shaft (see below).
> If you are not comfortable building mains equipment, don't build this part.

## How it works

- **Bar and hub.** The steel bar's square end plugs into the printed hub on
  the front face. The hub is fixed to the 8 mm shaft with a set screw. A
  steel pin in the front face runs in an arc slot in the hub; the slot's
  ends are the **hard stops**, at rest and at full travel. The knee's force
  goes from the bar into the hub and the pin, not into the shaft and the
  gears.
- **Shaft.** The shaft runs in two flanged bronze bushings, one in the
  front wall and one in a bulkhead across the bay. A torsion spring on the
  shaft returns the bar to rest. One leg bears on a post on the floor, the
  other goes into a hole in the sector's hub.
- **Gears.** The sector on the shaft drives a pinion on the pot's own shaft,
  4:1 by default (`knee_ratio`). The pot's bushing is the pinion's bearing.
  The model generates the pinion by rolling it against the sector, so the
  16-tooth pinion has the undercut a small pinion needs and the pair runs
  with a little backlash.
- **Switch.** A blade on the sector holds the switch's lever in at rest, so
  its normally-closed contact is open and the motor is off. The blade swings
  clear in the first couple of degrees of travel. The switch is wired in
  series with the motor.

The console's *Knee controller* block gives the numbers for your settings:
how far the shaft and the pot turn, how much of the pot's resistance that
spans, where the switch releases, and warnings if anything runs into the
bay's walls or the bulkhead.

## What you need

The hardware list in the console has the full list, with lengths.

| Item | Part | Notes |
|---|---|---|
| Speed-control board | XWW KB3151C "speed controller" pedal board, 75 × 35 mm | BT136-600E triac, DB3 diac, two 0.1 µF X2 capacitors, 2 MΩ min-speed trimmer (VR2); 110–120 V, 1.0 A |
| Pot | Bourns 91A1A-B28-A25L | 1 MΩ linear cermet; plastic slotted 1/4" shaft, 7/8" long; 3/8-32 bushing with nut and lockwasher; anti-rotation lug |
| Off switch | Omron SS-5GL | Hinge lever, SPDT, 5 A at 125 VAC |
| Shaft | 8 mm steel rod, about 80 mm | File two small flats for the set screws |
| Bushings | 2 × flanged bronze sleeve bearing, 8 × 12 × 10 mm, flange 16 × 2 mm | Pressed into the front wall and the bulkhead |
| Stop pin | `rod_d` rod (3/16"), 15 mm | The same rod as the harness rods |
| Return spring | Torsion spring, about 12 mm OD, at least 8.5 mm ID | To be chosen; the model leaves room for a typical one |
| Bar | Steel, 3/8" square at the hub end | Out from the hub, bent down 12.5" (`knee_bar_drop`) |
| Screws | M3 set screws, M3 screws and nuts, 5 M3 heat-set inserts; 2 M2 × 12 or #2-56 × 1/2" for the switch | |

Print the knee parts (`knee_sector`, `knee_pinion`, `knee_hub`,
`knee_cover`, `knee_cord_clamp`) in PETG or ASA. They are on the print
plates with the other small parts.

## The pot

The board's original slide pot (VR1) comes off, and the Bourns pot takes its
place, wired as a two-terminal variable resistor: the wiper and one end.
Over the knee's travel it should sweep about the same resistance as the
slide pot did, about 0–220 kΩ (`knee_r_span`). At the defaults the pot
turns about 45° over 2.5" of knee travel, which is about 190 kΩ of its
1 MΩ. **Confirm by tracing the board that VR1 is used as a two-terminal
resistor before you wire it.** If the board uses it as a three-terminal
divider, the wiring and the span change.

From the Bourns datasheet [1]:

- The 91 is a 5/8" (15.9 mm) square single-turn panel control with PC pins
  in line. Mechanical rotation is 300°, electrical travel 240° (linear).
- Shaft code B28 is a plastic, single-slotted 1/4" shaft, 7/8" long.
- Bushing A is 3/8-32 UNEF, 3/8" long, with an anti-rotation lug at 0.305"
  (7.75 mm) radius. The L suffix fits the lug.
- Cermet: 2 W at 70 °C, limited to 350 VAC. The dielectric withstanding
  voltage is 1,500 VAC between the element and the bushing. Rotational life
  is 100,000 cycles.

The plastic shaft matters. The bar, hub, shaft and sector are things you
touch. The pot's plastic shaft and the printed pinion are what keep them
apart from mains, together with the pot's 1,500 VAC rating between element
and bushing. **Don't substitute a pot with a metal shaft.**

The pot mounts from behind the bulkhead, with its bushing through the
3 mm panel and its nut on the front. The lug goes into the small hole
beside the main one; `knee_pot_lug_angle` sets where that hole is, so you
can turn the pot to put its pins where the wiring is easiest.

**Setting the rest position.** Before tightening the pinion's clamp screw,
set the pot so that, with the bar at its rest stop, it reads the high end of
the span (about 220 kΩ between the wiper and the end you are using).
Pressing the knee should then turn it toward zero. Then tighten the clamp.

## The switch

From the Omron SS datasheet [2]:

- The body is 19.8 × 10.2 × 6.4 mm. Two mounting holes, 2.35 mm across at
  9.5 mm pitch, take M2.3 screws with washers. M2 or #2-56 screws work.
- The hinge lever is stainless steel, 0.3 mm thick.
- The SS-5GL operates at 8.8 ± 0.8 mm from the mounting-hole line. Its free
  position is 13.6 mm at most, and its overtravel at least 1.0 mm.
  Operating force is 0.49 N at most.
- It is rated 5 A at 125 VAC (resistive), with a mechanical life of 30
  million operations and an electrical life of 200,000.

The switch screws to the front face of the bulkhead, below the shaft,
through two slots that let it move ±1.5 mm toward or away from the blade.
Mount it with the lever's free end toward the floor; the blade then meets
the lever far from the shaft, and the switch releases early in the swing
(about 2° of the shaft's 11°, by default).

To adjust it: with the bar at rest, slide the switch toward the blade
until it clicks off, then a little further (`knee_switch_press`, 0.3 mm),
and tighten the screws. Check with a meter that the normally-closed
contact opens at rest and closes as soon as the knee starts to move.

**Wiring.** Put the switch's normally-closed contact in series with the
motor lead. With the bar at rest the motor is then fully off, rather than
creeping at the minimum speed set by the board's trimmer.

If the switch's contacts were ever to weld, the motor would creep at the
rest setting rather than run away. Setting VR2 as low as the motor will
still start keeps that creep small.

## The board

The board lies flat in the back of the bay, its long axis front to back,
components up, on three posts 8 mm above the floor: a boss for an M3
heat-set insert (the board's 5.5 mm hole takes an M3 screw and washer), a
peg that fits the notch in the board's end, and a plain rest post. The
positions follow the controller enclosure they were copied from:

- the peg is 47.3 mm along and 5.0 mm across from the screw
- the rest post is 4.3 mm along and 19.5 mm across from the screw.

`knee_board_screw` gives the screw's position from the board's front end
and left edge, 48.3 mm and 7 mm by default. **Measure your board and set
it.** If the posts come out mirrored, set `knee_board_mirror`.

The printed cover goes over the board and screws down with two M3 × 30
screws into inserts in floor bosses. Its notches let the leads out: the
front notch, by the divider, for the pot and switch leads and the motor
lead; the side notch for the mains cord.

**Mains cord.** The cord comes in through a slot in the right end wall and
is gripped inside by a clamp bar, two M3 screws into inserts, over a
ridged saddle. `knee_cord` sets the slot for the cord's width and thickness
(flat SPT-2 by default). The motor lead goes out through the cord
pass-through in the divider, under the bed.

## Assembly order

1. Fit the heat-set inserts: the board boss, the two cover bosses and the
   two cord-clamp bosses.
2. Press the two bushings in, flanges forward: one into the front wall from
   outside, one into the bulkhead from the front.
3. Press the stop pin into the hole in the front face below the bushing,
   5.5 mm proud.
4. Mount the switch on the bulkhead, lever's free end down; leave the
   screws loose.
5. Mount the pot behind the bulkhead (lug in its hole, nut and lockwasher
   on the front) and solder its leads.
6. Slide the shaft in from the front through the front bushing, the spring
   and the sector (blade down, hub toward the bulkhead), and into the
   bulkhead's bushing. Put the spring's legs on the floor post and in the
   sector's hole. Tighten the sector's set screw on its flat.
7. Fit the hub on the shaft's front end, the pin in its slot, and tighten
   its set screw. Check that the spring brings the hub back to the rest
   stop.
8. Fit the pinion on the pot's shaft, set the rest position (above), and
   tighten its clamp.
9. Adjust the switch (above).
10. Wire the board; screw it down, fit the cover, and clamp the cord.
11. Plug the bar into the hub.

## Settings

The settings are in the *Knee controller* section. The ones you are most
likely to change:

- **`knee_push`**: which way the knee pushes the bar (right by default).
  The switch moves to the other side of the blade, and the sector's teeth
  and the stop slot follow.
- **`knee_bar_drop`, `knee_travel`, `knee_travel_max`**: the bar's drop
  below the shaft (12.5"), the knee travel for full speed (2.5") and at the
  hard stop (3").
- **`knee_ratio`**, **`knee_pinion_teeth`**: the gearing.
- **`knee_pot_angle`**: where the pot sits around the shaft (20° below the
  horizontal by default, which keeps the pot clear of the right wall).
- **`knee_board_screw`**, **`knee_board_mirror`**: the board's posts.
- **`knee_view`**: in part `knee_assembly`, shows the mechanism at rest (0)
  or at the stop (1).

## References

1. Bourns, *91, 92, 93, 94, 95, 96, 97, 99 – 5/8" Square Single-Turn Panel
   Control* datasheet (91 to 99 series), via
   [alldatasheet.com](https://www.alldatasheet.com/datasheet-pdf/pdf/353328/BOURNS/91A1A-B28-B15/A15L.html).
   Product listing for 91A1A-B28-A25L:
   [Master Electronics](https://www.masterelectronics.com/en/bourns/91a1ab28a25l-10736707.html).
2. Omron, *SS Subminiature Basic Switch*, Cat. No. B032-E1-14:
   [omronfs.omron.com](https://omronfs.omron.com/en_US/ecb/products/pdf/en-ss.pdf).
