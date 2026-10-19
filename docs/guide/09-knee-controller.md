# Knee controller

*This chapter is a draft. The mechanism has been checked in the model but
not yet built. The feel (force and travel) follows a Singer knee controller
as measured; the pot's gearing is a placeholder until the board's speed
against resistance has been measured.*

With `compartment_option = "knee"`, the base's right bay becomes a knee
speed control, in the manner of Singer's own knee-lever machines. A bar
hangs down past the table edge. Pressing it with your knee turns a shaft
running front to back in the bay. Gears on the shaft turn a potentiometer,
which takes the place of the slide pot on an inexpensive foot-pedal
speed-control board. A snap switch keeps the motor off for the first inch of
travel.

![The knee controller in the right bay (part `knee_assembly`, a cutaway):
the spring housing and the hub's crank on the front face, the shaft, the
gears in front of the bulkhead, and the board cover at the back.](../images/renders/knee.png){width=90%}

> **Warning: mains voltage.** The donor board, the pot's pins, the switch's
> terminals and every wire to them are live whenever the controller is
> plugged in. The triac's tab is connected to the live side. Work on it only
> with the plug pulled, keep the printed cover on the board, use wire rated
> for 300 V or more, and don't use a pot with a metal shaft (see below).
> If you are not comfortable building mains equipment, don't build this part.

## The feel

The defaults follow a Singer knee controller, measured at the knee, 12.5"
below the shaft (`knee_bar_drop`):

| Knee travel | Force | What happens |
|---|---|---|
| 0 (rest) | about 1 lb | The spring's preload |
| 0 to 1" | rising to about 2.5 lb | Dead travel: the switch holds the motor off |
| 1" (`knee_travel_on`) | about 2.5 lb | The switch closes; the motor starts |
| 1" to 2" | about 2.5 to 4 lb | The speed range |
| 2" (`knee_travel`) | about 4 lb | Full speed |
| 2.25" (`knee_travel_max`) | about 4.3 lb | Hard stop |

The force rises in a straight line, about 1.5 lb per inch
(`knee_force_rest`, `knee_force_rate`). The console's *Knee controller*
block gives the figures for your settings, in pounds and newtons.

## How it works

- **Bar and hub.** The steel bar's square end plugs into the printed hub on
  the front face. The hub's crank reaches sideways, away from the push, into
  the spring housing beside it. The hub is fixed to the 8 mm shaft with a set
  screw, but that screw only turns the shaft for the gears: the knee's force
  goes from the bar through the hub's crank into the spring and the stops,
  never into the shaft, its set screws or the gears.
- **Spring and stops.** The housing, screwed to the front face, holds a
  compression spring standing upright. A steel pin across the crank's tip
  bears on a printed cap on top of the spring. At rest the spring pushes the
  crank up against the **rest screw** in the housing's roof. At full travel
  the pin comes down onto the **stop screw**, which stands up through the
  middle of the spring from the housing's floor. Both are M4 screws in
  captive nuts, with jam nuts, so rest and full travel are adjustable and
  steel meets steel at the hard stop. The housing is a closed loop: the
  spring's preload stays inside it, and only the knee's push reaches the base,
  through a tongue on the housing's back that sits in a pocket in the face.
- **Shaft.** The shaft runs in two flanged bronze bushings, one in the
  front wall and one in a bulkhead across the bay.
- **Gears.** Two stages, about 11.75:1 overall. A 64-tooth sector on the
  shaft drives a 16-tooth pinion on an idler, 4:1 (`knee_ratio`); a 47-tooth
  sector on the same idler drives a 16-tooth pinion on the pot's own shaft,
  2.94:1 (`knee_gear2_teeth`, `knee_pinion2_teeth`). The idler turns on a
  3/16" steel pin pressed into the bulkhead; the pot's bushing is its
  pinion's bearing. The model generates each pinion by rolling it against
  its gear, so the 16-tooth pinions have the undercut a small pinion needs
  and each pair runs with a little backlash.
- **Switch.** The switch lies on the bulkhead under the shaft, lever up. A
  cam on the sector holds its lever down at rest, so its normally-closed
  contact is open and the motor is off. A ramp on the cam lets the lever up
  at 1" of knee travel. The switch is wired in series with the motor.

For why this controller behaves as it does (an open-loop triac phase
control, like a good stock pedal, that holds no speed under load), and for
the microcontroller design that follows it, see the companion paper, *Speed
Control of Universal Motors in Sewing Machines*
([`docs/motor-control/`](../motor-control/11-vsm-base.md)).

The console's *Knee controller* block gives the numbers for your settings:
the shaft's angles, the gearing, how far the pot turns and how much of its
resistance that spans, where the switch releases, the spring's load, the
knee force along the travel, and warnings if anything runs into the bay's
walls, the floor, the bulkhead or the ends of the front face.

## What you need

The hardware list in the console has the full list, with lengths.

| Item | Part | Notes |
|---|---|---|
| Speed-control board | XWW KB3151C "speed controller" pedal board, 75 × 35 mm | BT136-600E triac, DB3 diac, two 0.1 µF X2 capacitors, 2 MΩ min-speed trimmer (VR2); 110–120 V, 1.0 A |
| Pot | Bourns 91A1A-B28-A25L | 1 MΩ linear cermet; plastic slotted 1/4" shaft, 7/8" long; 3/8-32 bushing with nut and lockwasher; anti-rotation lug |
| Off switch | Omron SS-5GL (Digi-Key) | Hinge lever, SPDT, 5 A at 125 VAC; the standard 0.49 N version, not the low-force SS-5GL-F |
| Shaft | 8 mm steel rod, about 77 mm | File two small flats for the set screws |
| Bushings | 2 × flanged bronze sleeve bearing, 8 × 12 × 10 mm, flange 16 × 2 mm | Pressed into the front wall and the bulkhead |
| Pins | `rod_d` rod (3/16"): 24 mm for the idler, 14 mm for the crank | The same rod as the harness rods; a 3/16" push-on retaining nut for the idler |
| Return spring | McMaster 9001T46, or one like it [5] | Compression spring, 0.6" OD, 0.072" wire, 1.25" long, 45 lb/in, rated 26 lb at 0.668" |
| Stop screws | 1 × M4 × 35 (stop), 1 × M4 × 14 (rest), each with 2 nuts | One nut of each is captive in the housing, the other a jam nut |
| Bar | Steel, 3/8" square at the hub end | Out from the hub, bent down 12.5" (`knee_bar_drop`) |
| Screws | M3 set screws, M3 screws and nuts, M3 heat-set inserts; 2 M2 × 12 or #2-56 × 1/2" for the switch | 2 × M3 × 12 hold the spring housing |
| Power, `cordset` | A standard pedal controller cordset | Its molded entry and steel clip fit the base's entry |
| Power, `iec` | Schurter KE16.5100.107 fused C14 inlet (1-pole, snap-in, 2 mm panel), its fuse drawer, a T2A 5 × 20 mm fuse; 3 Wago 221-413 lever connectors | Earth strip (brass or phosphor bronze) for the shaft |

Print the knee parts (`knee_sector`, `knee_idler`, `knee_pinion`,
`knee_hub`, `knee_spring_housing`, `knee_spring_cap`, `knee_cover`, and
`knee_cord_clamp` for a bare cord) in PETG. They are on the print plates with
the other small parts. The hub prints back face down, with the crank flat on
the bed, so the crank's bending runs along the layers. The spring housing
prints standing on its floor. Print `knee_entry_test` first if you are using
a cordset.

## The pot

The board's original slide pot (VR1) comes off, and the Bourns pot takes its
place as a two-terminal variable resistor. In the board's own terms:

- the Bourns pot's **wiper** goes to the old **pin-2** pad;
- the pot's **end that the wiper approaches at full knee travel** goes to
  the old **pin-1** pad;
- a jumper joins the old **pin-3** pad to the pin-2 pad, which puts RV2
  across the pot.

Over the speed range, from 1" to 2" of knee travel, it should sweep about
the same resistance as the slide pot did, about 220 kΩ (`knee_r_span`). The
shaft turns only 4.5° over that inch, so the gearing is high: the pot turns
about 53°, about 221 kΩ of its 1 MΩ. This is a linear placeholder. The
board's speed is far from linear in resistance (low speed is crowded into
the high-resistance end), so the gearing, or the gear shapes, will change
once the board's speed against resistance has been measured.

From the Bourns datasheet [1]:

- The 91 is a 5/8" (15.9 mm) square single-turn panel control with PC pins
  in line. Mechanical rotation is 300°, electrical travel 240° (linear).
- Shaft code B28 is a plastic, single-slotted 1/4" shaft, 7/8" long.
- Bushing A is 3/8-32 UNEF, 3/8" long, with an anti-rotation lug at 0.305"
  (7.75 mm) radius. The L suffix fits the lug.
- Cermet: 2 W at 70 °C, limited to 350 VAC. The dielectric withstanding
  voltage is 1,500 VAC between the element and the bushing. Rotational life
  is 100,000 cycles.

The plastic shaft matters. The bar, hub, shaft and gears are things you
touch. The pot's plastic shaft and the printed pinion are what keep them
apart from mains, together with the pot's 1,500 VAC rating between element
and bushing. **Don't substitute a pot with a metal shaft.**

The pot mounts from behind the bulkhead, with its bushing through the
3 mm panel and its nut on the front. The lug goes into the small hole
beside the main one; `knee_pot_lug_angle` sets where that hole is, so you
can turn the pot to put its pins where the wiring is easiest.

**Setting the pot.** Set it at full speed. Hold the bar at 2" of travel,
turn the pot's shaft until the wiper just reaches 0 Ω to the pin-1 end, and
tighten the pinion's clamp screw. At rest it then reads about 445 kΩ (the
console gives the figure for your settings). From full speed to the hard
stop the pot turns another 13° into the dead zone past its electrical end,
where the resistance stays at 0; its mechanical stop is about 30° beyond the
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

The switch screws to the front face of the bulkhead, lying under the
shaft, lever up and its free end toward the push, so that the actuating
point is straight below the shaft. Its two slots let it move ±1.5 mm up and
down. The cam on the sector has a dwell, a stretch at a constant radius that
holds the lever down at rest, then a ramp at about 45° that lets it rise.
The switch releases at 1" of travel (`knee_travel_on`), about 4.6° of the
shaft's swing. Past the ramp the cam still rests lightly on the lever, well
above its release point.

To adjust it: with the bar at rest, slide the switch up until it clicks
off, then a little further (`knee_switch_press`, 0.3 mm), and tighten the
screws. Then set where it releases by turning the sector on the shaft:
loosen its set screw, hold the bar at 1" of travel, turn the sector until a
meter across the normally-closed contact just shows it closing, and tighten
the set screw. Turning the sector is the fine adjustment (each degree moves
the release point about 5.5 mm at the knee); the switch's height is coarse
(each 0.1 mm moves it about 1.9 mm).

**Wiring.** Put the switch's normally-closed contact in series with the
motor lead. Through the dead travel the motor is then fully off, rather than
creeping at the minimum speed set by the board's trimmer.

If the switch's contacts were ever to weld, the motor would creep at the
rest setting rather than run away. Setting VR2 as low as the motor will
still start keeps that creep small.

## The return spring

The spring is a compression spring standing in the housing: by default
McMaster's 9001T46 [5], 0.6" (15.24 mm) outside diameter, 0.072" (1.83 mm)
wire, 1.25" (31.75 mm) long, 45 lb/in (7.88 N/mm), rated 26 lb at 0.668"
long (14.8 mm of deflection). Any spring of about that size and rate will
do; set `knee_spring`, `knee_spring_rate` and `knee_spring_max` to its
figures.

The model sets the crank's length from the spring's rate so that the knee
feels `knee_force_rate`: with this spring, 58 mm (`knee_crank_r`; set it to
fix the length instead). The spring is preloaded 3.1 mm at rest, 24 N, which
gives the 1 lb at the knee, and compressed 13.4 mm at the hard stop, 105 N,
90% of its rating. The crank's lever arm is what turns a 45 lb/in spring
into 1.5 lb/in at the knee: the knee is 5.5 times as far from the shaft as
the crank pin.

The housing stands beside the hub, on the side away from the push (to the
left of the hub for a knee that pushes right). The console warns if the
housing would run off the end of the front face, reach the base's bottom or
top, or if the spring is compressed past its rating.

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

1. Fit the heat-set inserts: the board boss, the two cover bosses, the two
   in the front face for the spring housing, and the earth post or
   cord-clamp bosses if you have them.
2. Press the two bushings in, flanges forward: one into the front wall from
   outside, one into the bulkhead from the front.
3. Press the idler pin into the bulkhead from the front, through its boss,
   flush with the bulkhead's back face.
4. Mount the switch on the bulkhead, lying under the shaft, lever up; leave
   the screws loose.
5. Mount the pot behind the bulkhead (lug in its hole, nut and lockwasher
   on the front) and solder its leads.
6. Slide the idler onto its pin, gear toward the bulkhead, and push the
   retaining nut on in front of it.
7. Slide the shaft in from the front through the front bushing and the
   sector (teeth toward the idler, cam down, hub toward the bulkhead), and
   into the bulkhead's bushing. Snug the sector's set screw on its flat.
8. Put the captive nuts in the spring housing (from below in the floor,
   from above in the roof) and run the stop screw up from below; leave the
   rest screw out. Drop the spring onto the floor's spigot and the cap onto
   the spring, spigot down. Screw the housing to the front face, its tongue
   in the pocket.
9. Press the crank pin through the hub's crank, centered, standing about
   1 mm proud of the crank's bottom edge. Fit the hub onto the shaft's front
   end with the crank tilted up a few degrees, so that its tip goes in
   through the housing's front opening above the cap, and tighten the hub's
   set screw. The spring now pushes the crank up.
10. Run the rest screw down through the roof until it holds the crank where
    you want the bar to rest (the spring's preload).
11. Set the stop screw so the pin meets it at 2.25" of knee travel, and lock
    both screws with their jam nuts.
12. Adjust the switch and the sector (above), then fit the pot's pinion and
    set the pot (above).
13. Wire the board and the power entry; screw the board down and fit the
    cover. For `iec`, wire the junction under the bed.
14. Plug the bar into the hub.

## Settings

The settings are in the *Knee controller* section. The ones you are most
likely to change:

- **`knee_push`**: which way the knee pushes the bar (right by default).
  The spring housing moves to the other side of the hub, and the switch,
  the cam and the gears' teeth follow.
- **`knee_bar_drop`, `knee_travel_on`, `knee_travel`, `knee_travel_max`**:
  the bar's drop below the shaft (12.5"), and the knee travel where the
  motor starts (1"), for full speed (2") and at the hard stop (2.25").
- **`knee_force_rest`, `knee_force_rate`**: the knee force at rest and how
  fast it rises.
- **`knee_spring`, `knee_spring_rate`, `knee_spring_max`, `knee_crank_r`**:
  the return spring and the crank.
- **`knee_ratio`, `knee_gear2_teeth`, `knee_pinion2_teeth`**: the gearing.
- **`knee_idler_angle`, `knee_pot_angle`**: where the idler sits around the
  shaft (10° above the horizontal), and the pot around the idler (120° below
  the horizontal, toward the shaft), which keeps the pot clear of the right
  wall and the floor.
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
5. McMaster-Carr precision compression springs, 9001T46:
   [mcmaster.com](https://www.mcmaster.com/precision-compression-springs).
