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

For why this controller behaves as it does (an open-loop triac phase
control, like a good stock pedal, that holds no speed under load), and for
the microcontroller design that follows it, see the companion paper, *Speed
Control of Universal Motors in Sewing Machines*
([`docs/motor-control/`](../motor-control/11-vsm-base.md)).

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
| Off switch | Omron SS-5GL (Digi-Key) | Hinge lever, SPDT, 5 A at 125 VAC; the standard 0.49 N version, not the low-force SS-5GL-F |
| Shaft | 8 mm steel rod, about 80 mm | File two small flats for the set screws |
| Bushings | 2 × flanged bronze sleeve bearing, 8 × 12 × 10 mm, flange 16 × 2 mm | Pressed into the front wall and the bulkhead |
| Stop pin | `rod_d` rod (3/16"), 15 mm | The same rod as the harness rods |
| Return spring | McMaster 9271K585 (left-hand wound) for a knee that pushes right; 9271K651 (right-hand) for one that pushes left | 90°, 0.499" OD, 0.059" wire, 4.25 coils, 2" legs, 4.5 in·lbf; pack of 6 |
| Bar | Steel, 3/8" square at the hub end | Out from the hub, bent down 12.5" (`knee_bar_drop`) |
| Screws | M3 set screws, M3 screws and nuts, M3 heat-set inserts; 2 M2 × 12 or #2-56 × 1/2" for the switch | |
| Power, `cordset` | A standard pedal controller cordset | Its molded entry and steel clip fit the base's entry |
| Power, `iec` | Schurter KE16.5100.107 fused C14 inlet (1-pole, snap-in, 2 mm panel), its fuse drawer, a T2A 5 × 20 mm fuse; 3 Wago 221-413 lever connectors | Earth strip (brass or phosphor bronze) for the shaft |

Print the knee parts (`knee_sector`, `knee_pinion`, `knee_hub`,
`knee_cover`, and `knee_cord_clamp` for a bare cord) in PETG or ASA. They
are on the print plates with the other small parts. Print `knee_entry_test`
first if you are using a cordset.

## The pot

The board's original slide pot (VR1) comes off, and the Bourns pot takes its
place as a two-terminal variable resistor. In the board's own terms:

- the Bourns pot's **wiper** goes to the old **pin-2** pad;
- the pot's **end that the wiper approaches at full knee travel** goes to
  the old **pin-1** pad;
- a jumper joins the old **pin-3** pad to the pin-2 pad, which puts RV2
  across the pot.

Over the knee's travel it should sweep about the same resistance as the
slide pot did, about 0–220 kΩ (`knee_r_span`). At the defaults the shaft
turns 13.5° to the hard stop, so the pot turns 54°, about 225 kΩ of its
1 MΩ.

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

**Setting the pot.** Set it at the hard stop. Hold the bar against the
stop, turn the pot's shaft until the wiper reads about 0 Ω to the pin-1
end, and tighten the pinion's clamp screw. At rest it then reads about
225 kΩ (the console gives the figure for your settings), and full speed
comes at the stop. The pot's mechanical stop is about 30° beyond its
electrical end, so the pot is never the hard stop.

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
- The lever's actuating point is 14.5 mm from its pivot end, about 5.3 mm
  from its free end (`knee_switch_act`).

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

## The return spring

The spring is McMaster's 9271K585 [5]: spring steel, 0.499" (12.7 mm)
outside diameter, 0.059" (1.5 mm) wire, 4.25 coils, rated 4.5 in·lbf at
90°, for a 0.312" shaft. On the 8 mm shaft its inside diameter stays above
9 mm even wound up to the stop, since the knee uses only about two thirds
of its rated deflection.

A torsion spring should be loaded so that it winds up, its coils closing.
Seen from the front, a knee that pushes right turns the shaft
counterclockwise, which winds up a left-hand spring with its fixed leg in
front: hence 9271K585. For a knee that pushes left, use the right-hand
9271K651.

Put it on the shaft in front of the sector, the fixed leg against the post
on the floor and the moving leg's end bent 4 mm along the shaft into the
hole in the sector's hub. Trim the legs as needed; the 2" legs are longer
than the bay needs. Bend the fixed leg so the spring is wound about 45°
when the bar is at rest (`knee_spring_preload`). The console then gives the
torque: about 250 N·mm at rest and 330 N·mm at the stop, about 1 N at the
knee. That is over four times what it takes to turn the pot (Bourns'
maximum running torque, through the 4:1 gearing) and hold the switch in.

## The board

The board lies flat in the back of the bay, its long axis front to back,
components up, on three posts 8 mm above the floor: a boss for an M3
heat-set insert (the board's 5.5 mm hole takes an M3 screw and washer), a
peg that fits the notch in the board's end, and a plain rest post. The
positions are those of the board's own enclosure:

- the peg is 47.3 mm along and 5.0 mm across from the screw;
- the rest post is 4.3 mm along and 19.5 mm across from the screw.

Along is measured from the notched end, across from the long edge nearer
the screw; with the components up, across is to the right of along.
`knee_board_screw` is the screw's position, 49.6 mm along and 12.5 mm
across, measured from the board. By default the board is turned with its
notched end toward the back of the bay (`knee_board_turn`), which puts its
two spade tabs on the right, near the front, where the power leads come
in. The cover leaves 16 mm beside them for the connectors and their wires
(`knee_board_tab_room`).

The printed cover goes over the board and screws down with two M3 × 30
screws into inserts in floor bosses. Its notches let the leads out: the
front notch, by the divider, for the pot and switch leads and the motor
lead; the side notch, beside the spade tabs, for the power leads.

**Heat.** The board is labeled 1.0 A. Its BT136 triac is a 4 A part, but
it has no heatsink, and at more than 1 A it runs hot in a closed box. If
your motor draws more (`knee_motor_amps`), fit a small clip-on heatsink to
the triac and the cover gets vent slots. The triac's tab is live, so the
heatsink is too: keep it inside the cover.

## Power

`knee_power` chooses how the controller is wired in. All three are at
mains potential.

**`cordset` (default).** The controller takes a standard pedal
controller cordset, the kind that is sold separately with a three-pin
machine plug or a duplex outlet in the middle. Only the control loop enters
the box: two leads in series with the motor, to the board's two spade tabs,
with the off switch in one of them. The cordset's molded entry pushes
through a 13.9 × 8.5 mm hole in a 4.4 mm wall, pocketed into the right end
wall above the handhold. Inside, its steel clip, U down, goes on from
above: push the molded entry in hard, compressing it, until its groove
clears the wall, then push the clip down over the groove until its bump
clicks into the dimple at the top of the hole. The clip stretches the soft
molding a little, and that holds it tight. The entry sits beside the
board's tabs so that the cordset's 78 mm leads reach with slack; the console
checks this. Print `knee_entry_test` first to try the fit; the wall
thickness, hole and dimple are settings.

**`iec`.** A fused IEC C14 inlet in the right end wall feeds the
controller directly, for machines whose motor and light were hardwired to
their original controller. The inlet is a Schurter KE snap-in [3] (a
52.5 × 27.5 mm cutout in a 2 mm panel, pocketed into the end wall), on its
side above the board cover. Inside, the fused line goes to the light and,
through the board and the off switch, to the motor; the leads go through
the cord pass-through to a junction under the bed: three Wago 221-413
lever connectors [4] (line, neutral, switched motor) in a cradle on the
cavity floor beside the pass-through. The motor and light leads land
there. A T2A slow-blow fuse covers a 1.3 A motor and the lamp. The
console gives the junction's height; check that your machine's mechanism
clears it. The inlet's depth behind the panel varies by version
(`knee_iec_depth`); check yours.

With the IEC inlet, the shaft can be earthed (`knee_earth`). A post behind
the shaft's end takes an M3 insert. Screw a strip of brass or phosphor
bronze to it, with the earth lead's ring terminal, bent so its free end
bears on the end of the shaft. Contact through the oily bushings isn't
reliable, and the bar, hub and shaft are metal you touch.

**`bare`.** A bare cord through a slot in the end wall, gripped inside by
a printed clamp bar (part `knee_cord_clamp`) over a ridged saddle.

## Assembly order

1. Fit the heat-set inserts: the board boss, the two cover bosses, and the
   earth post or cord-clamp bosses if you have them.
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
10. Wire the board and the power entry; screw the board down and fit the
    cover. For `iec`, wire the junction under the bed.
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
- **`knee_board_screw`**, **`knee_board_turn`**: the board's posts and
  orientation.
- **`knee_power`**: cordset, IEC inlet or bare cord; **`knee_entry_pos`**
  and **`knee_entry_z`** place the entry.
- **`knee_motor_amps`**: over 1 A adds the cover vents and the heatsink note.
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
3. Schurter, *KE: IEC Appliance Inlet C14 with Fuseholder 1- or 2-pole*:
   [schurter.com](https://www.schurter.com/en/datasheet/KE) (order numbers,
   panel thicknesses, ratings) and the
   [PDF datasheet](https://www.schurter.com/en/datasheet/typ_KE.pdf)
   (dimension drawings).
4. WAGO 221-413 lever connector, 3-conductor, 18.8 × 18.8 × 8.6 mm, 0.2–4 mm²
   (24–12 AWG): [automa.net](https://automa.net/wago/221-413).
5. McMaster-Carr torsion springs, 9271K585 and 9271K651:
   [mcmaster.com](https://www.mcmaster.com/products/torsion-springs/).
