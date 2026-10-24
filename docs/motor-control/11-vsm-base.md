# The controllers in the VSM Base

The base's right-hand bay can hold a speed controller
(`compartment_option = "knee"`). Two designs are in progress. The first is
built and modeled. The second is in design. This section is kept up to date as
they develop. The base's User's Guide has the build details for the first.

## The knee controller: a repurposed pedal board

**What it is.** An inexpensive foot-pedal speed-control board (the XWW
KB3151C, 75 × 35 mm) moved into the bay, with a knee lever in place of the
pedal. A bar hangs below the table edge and turns a shaft running front to
back in the bay. Two gear stages, about 11.75:1, turn a Bourns 91A1A-B28-A25L
pot (1 MΩ linear cermet) that replaces the board's slide pot, VR1. A snap
switch (Omron SS-5GL), held open by a cam on the shaft's sector through the
first inch of travel, cuts the motor.

**What kind of controller it is.** Electrically it is the open-loop triac phase
control of §5: a BT136 triac, a DB3 diac and an RC timing network, with the
pot setting the firing angle. It therefore behaves like a good stock pedal. It
gives no speed regulation; the load sets speed, with the cogging at a crawl
and the snap-on hysteresis described there. The 2 MΩ trimmer VR2 sets the
minimum speed. The knee mechanism improves the command, not the regulation:

- The feel copies a Singer knee controller, measured at the knee 12.5"
  below the shaft: about 1 lb at rest, rising 1.5 lb/in; an inch of dead
  travel before the motor starts; the speed range over the next inch (about
  2.5 to 4 lb); a hard stop at 2.25". The original's own action is short: an
  inch from the motor starting to groan to flat out.
- The return spring is a compression spring in a housing on the front face,
  pushed by a crank on the bar's hub, with steel screw stops at rest and at
  full travel. The knee's force goes from the bar through the crank into the
  spring and stops, never into the shaft, the gears or the pot.
- Because the speed range is only 4.5° of the shaft's swing, the gearing is
  high: the pot turns about 53° (about 220 kΩ, the slide pot's span) over
  that inch. This is a linear-in-resistance placeholder; see below.
- The off switch opens at rest and closes at 1" of travel, about 4.6° into
  the 10.2° swing. With it in series with the motor, the motor is fully off
  through the dead travel instead of creeping at the minimum set by VR2.

![The donor board, KB3151C (XWW speed controller, 110–120 V, 1.0 A), traced
from photos; KiCad source in `hardware/triac-board/`. J1 and J2 are its two
spade tabs: the board is a two-terminal switch in series with the motor, and
the triac's tab is MT2 (live). Timing: from MT2 through RV1's pin-1 section,
in parallel with RV2 plus RV1's pin-3 section, to the wiper, then through R2
into C2 and back to MT1. When C2 reaches the DB3's breakover it fires the
BT136 through R1. RV2 lies across RV1's whole track. At RV1's pin-3 end is an
off zone where the wiper is open and nothing fires; moving toward pin 1 the
resistance falls toward zero and speed rises, and RV2, by capping the
resistance just past the off zone, sets the slowest speed. R3 and C1 are the
snubber across the triac. Still to check with a meter: that RV2's wiper is
tied to its pin-3 end, that RV1's pin 1 and R3 go to the MT2 tab, and which
of RV1's pins is the wiper.](../images/diagrams/kb3151c-schematic.svg){width=100%}

**The board is a two-terminal series device.** It has only two spade tabs
and sits in series in one leg of the motor circuit; it has no separate mains
input or motor output. In the original pedal, only this control loop enters
the box, as a two-wire lead from a standard cordset. The cordset's junction
(a three-pin machine plug or a duplex outlet) joins it to the mains cord, and
cordsets are interchangeable, so one pedal fits many machines.

**Wiring the pot,** in the board's own terms:

- the Bourns wiper to the old pin-2 pad;
- the Bourns end that the wiper approaches at full knee travel to the old
  pin-1 pad;
- a jumper from the old pin-3 pad to pin-2, which puts RV2 across the pot.

It is set at full speed: with the bar held at 2", the wiper is put just at
the pin-1 end (0 Ω) and the pinion clamped. At rest it then reads about
445 kΩ. From full speed to the stop the pot turns another 13° into the dead
zone past its electrical end, well short of its mechanical stop. The pot's
plastic shaft and the printed pinion are the isolation between the
touchable bar and mains, with the pot's 1,500 VAC rating between element and
bushing; a metal-shaft pot must not be substituted.

**Power.** Three ways in (`knee_power`), all at mains potential:

- **cordset:** the standard pedal cordset's molded entry and steel clip, copied
  from the original pedal box. The two leads go to the board's tabs, with the
  off switch in one of them.
- **iec:** a fused IEC C14 inlet (Schurter KE, T2A fuse). The fused line feeds
  the light directly and the motor through the board and switch, with the
  motor and light leads hardwired at Wago lever connectors under the bed. This
  suits machines whose motor and light were hardwired to their original
  controller. The steel shaft can be earthed through a spring strip on its end.
- **bare:** a bare cord through a printed clamp.

**Limits.** The board is labeled 1.0 A. Its BT136 is a 4 A part but has no
heatsink, so a motor over 1 A (one here draws 1.3 A) needs a clip-on heatsink,
which is live with the triac's tab, and vents in the cover. Sewing-machine
universal motors here are 110–120 V AC/DC machines, typically 0.5–1.0 A.

**What it leaves on the table.** Everything the feedback sections describe:
it holds no speed through a seam, and at a crawl it pulses. Its virtue is that
it is cheap, uses a common part, and gives a vintage machine a knee control
in its own base.

**Low-end control.** With the board's RC firing network, speed is far from
linear in the pot's resistance: the range from stopped to sewing speed is
crowded into a small slice at the high-resistance end. A pot that moves
linearly with the knee therefore puts most of the useful control into a
fraction of the speed range. Three ways to spread it, none tested yet:

- a resistor in parallel with the pot (RV2 is already there) to bend the
  taper;
- an audio (logarithmic) taper pot, which Bourns makes in the 91; it would
  need more pot rotation and probably a 250–500 kΩ value;
- non-circular gears, shaped so that speed, rather than resistance, follows
  the knee.

The last can be fitted exactly to a bench measurement of the board's speed
against resistance on a 99 motor, which is the next step. Until then the
gearing is linear in resistance.

## The MCU phase controller (in design)

The second design is a feedback controller of the kind described in §9: a
microcontroller phase controller with an isolated control side. As it stands:

- A Raspberry Pi RP2350B on an inexpensive core board ($5–20), chosen over
  the STM32 NUCLEO-G431KB first considered for its price, its many analog
  inputs (eight on the B package), and its familiarity to hobbyists. The
  firmware is plain C on the Pico SDK, with no RTOS.
- IEC power only, with earth.
- Eventually separable from the base: standalone, mounted at the side of the
  base, or in a pedal-only base. External travel and pressure pedals as well as
  the knee lever.
- The knee lever becomes a sensor input (pot or Hall) on the isolated low-voltage
  side, so it needs no mains-rated parts. The mechanism of the first design
  (the crank, spring housing and screw stops, and the switch's dead travel)
  carries over; the speed curve moves into firmware.
- A speed sensor (handwheel or motor pulley) for true speed command, and the
  features it makes cheap: needle positioning (stops taught by hand, and a
  heel tap in the pedal), slow start, a speed limit, a single-stitch button;
  and a force-sensing pedal that reproduces the carbon
  pile's feel while holding speed.

### A first concept circuit

> **This is a concept, not a design.** The circuit below has been drawn but
> not built, simulated or tested. Its part values are first estimates, not
> yet checked against the parts' datasheets. The core board is drawn by
> GPIO number, not as any particular board. The firmware does not exist. It
> shows how the pieces of §9 fit together around the chosen board, and is a
> starting point for bench work, not something to build from. It is drawn
> by Claude at Bob Drzyzgula's direction.

The circuit follows the architecture of Freescale's AN1662: a triac in
series with the motor, fired once per half-cycle at a delay measured from
the mains zero crossing, with a speed sensor closing the loop. AN1662 runs
its microcontroller at line potential, with a resistor from the mains
straight to an input pin for zero-cross detection. Here every connection
between the mains and the controller passes through an isolating part, so
the controller, its pedals and its debug port are all at a safe low
voltage. The drawing runs the isolation barrier across the sheet, with the
live side above it.

**Line side (live).** An IEC inlet with earth feeds a 2 A slow fuse and a
150 V MOV. The base's duplex outlet keeps its two sockets: the light's is
always on, the motor's is controlled. The motor's hot lead runs from a
motor-enable relay (K1) through the triac (a BTA08-600BW, a snubberless
type) to the outlet. The relay lets the firmware cut the motor whatever the
triac is doing: it closes last and opens first. Space is left for an RC
snubber, to be fitted only if the triac fires falsely.

**Across the barrier.** Four parts span it:

- a MOC3023 random-phase opto-triac, which fires the triac's gate;
- an H11AA1 AC-input optocoupler, whose LEDs are fed from the mains
  through two 22 kΩ resistors and whose transistor gives a pulse at each
  zero crossing;
- the relay, whose coil is on the control side and its contact on the
  line side;
- an isolated 5 V supply module (Mean Well IRM-05-5 class).

**Control side (low voltage).** The RP2350B core board takes 5 V from the
module into its VSYS pin through a Schottky diode, so its USB port can stay
plugged in; its own regulator supplies 3.3 V to the sensors. A 2N7002
drives the relay coil. The opto-triac's LED is driven straight from a GPIO
set to 8–12 mA drive. The zero-cross output has a pull-up and a small filter
capacitor. The hand-wheel index sensor is a DRV5023 Hall switch; one magnet
gives one pulse per stitch. An optional encoder beside it, two Hall
latches over a ring of alternating magnets, tells the firmware the hand
wheel's angle to 15° (see below). The knee lever, a travel pedal, a pressure
pedal (a force-sensing resistor) and a speed-limit knob go to four analog
inputs through RC filters. A needle-up/down toggle, a single-stitch button
and a heel switch in the pedal use the microcontroller's internal
pull-ups.

| Signal | RP2350B pin | Use |
|---|---|---|
| Triac fire | GP4 | gate pulse (timer alarm or PIO) |
| Relay | GP5 | output |
| Zero cross | GP6 | interrupt |
| Hand-wheel encoder | GP2, GP3 | quadrature count (PIO) |
| Hand-wheel index | GP7 | edge timestamps |
| Single stitch | GP10 | input; held, teaches a stop |
| Heel switch | GP11 | input |
| Needle up/down | GP12 | input |
| Knee, pedal, pressure, limit | GP40–43 (ADC0–3) | analog inputs |

ADC4–7 are spare, and GP8/GP9 (UART1) are left for a debug line, though
the USB port's serial link will usually do. Any GPIO can serve for the
digital signals, so these are a starting point, to be placed to suit the
board chosen. A candidate is WeAct Studio's RP2350B Core board, about $6,
which brings out every GPIO including all eight analog inputs; its USB
supply already passes through a diode, so the supply module can feed its
5V pin directly.

**Firmware, in outline.** As in AN1662:

- Each zero-cross interrupt sets a hardware alarm on the chip's
  microsecond timer (or starts a small PIO program), and at the firing
  delay a pulse of about 100 µs fires the triac for the rest of that
  half-cycle.
- The hand wheel's period, from timestamps of its edges, gives the speed.
- A PI loop sets the next firing delay once per half-cycle, 120 times a
  second on 60 Hz mains. A limit on how fast the firing angle may change
  keeps a jammed needle from getting a sudden full-power pulse.
- A stall watchdog stops firing and opens the relay if the hand wheel stops
  sending pulses.
- Nothing fires until a zero crossing has been seen and the speed command
  is zero, so the machine cannot start on power-up.

**What a sewist asks of a pedal.** Danielle, who has sewn for more than
five decades and works with Bob Drzyzgula on repairing and re-homing
thrift-store machines, read a draft of this paper and described what she
values in a foot control. Her observations, which she agreed to share, set
part of this controller's brief:

- **Full power at slow speed, from the first movement.** A pedal should
  respond as soon as it engages, without the "bogginess" some show in heavy
  fabric. That is the series-resistance problem of §3: as the load rises,
  the pedal drops more voltage and the motor slows just when it needs
  torque. The speed loop answers it, adding power to hold the speed asked
  for.
- **No heat at rest.** She described a sewist who holds a carbon-pile
  pedal just short of moving the needle, so the motor hums, for several
  seconds before each start. The pile is then a resistor in series with a
  stalled motor: current flows, but nearly all the power becomes heat in
  the pedal, more so on the high-speed setting. Here a pedal below its
  start threshold commands nothing: no firing and no current.
- **Stopping the needle where it is wanted.** A foot control does more than
  set speed: it stops the needle down, in the fabric, to pivot or to hold
  the work while it is rearranged, and up, to take the work out. She
  recalls learning to do this with the pedal alone on some machines and
  never managing it on others. Even then "up" often missed the spot where
  the stitch completes and the thread releases, so the hand wheel was
  needed anyway. The heel tap of later electronic pedals (raise or lower
  the needle with a tap of the heel) she counts the most useful feature of
  all. Smooth speed at a crawl, with no pulses or stalls, is what makes
  stopping by foot possible at all.

The circuit takes these up with a heel switch in the pedal and an encoder
at the hand wheel. In the firmware:

- **The stops are taught.** With the needle toggle at "up", the sewist
  turns the hand wheel to where the thread releases (the take-up lever at
  its highest, which is not quite the needle's highest point, and differs
  from machine to machine) and holds the single-stitch button for two
  seconds. This is what service manuals for modern electronic machines call
  setting top dead center. Then the same at "down", with the needle in the
  fabric. The
  angles are kept in flash, relative to the magnets, which can therefore go
  anywhere on the wheel.
- **Stops are landed by angle.** On release, the loop brings the machine
  down to a creep speed and cuts firing short of the chosen stop by a coast
  angle. The triac design has no active braking, so the coast is learned:
  after each stop the firmware reads where the needle came to rest and
  corrects it.
- **A heel tap, with the pedal at rest, sends the needle to its other
  stop**: up to release the work, down to pivot.

The encoder is there because one magnet is not enough. A single index
pulse gives the hand wheel's angle only while it turns, by time since the
pulse, so a controller with only the index can't learn a stop from a hand
wheel turned by hand, or check where the needle landed. Two Hall latches
placed a quarter-cycle apart over a ring of twelve alternating magnets give
24 counts a turn, 15° each, in either direction, counted by a small PIO
program; the index pulse sets and checks the count once a turn. Without
the encoder the controller still stops by the index alone, more roughly.

**Two practical consequences.** Because the control side is isolated, the
board's USB port can stay connected to a computer with the mains on, for
flashing (by dragging a UF2 file onto it in BOOTSEL mode) and for the
debug serial line; step-through debugging needs a separate SWD probe, such
as Raspberry Pi's Debug Probe. And as with the test rig, a scope's ground
must never be connected to the line side.

![The MCU phase controller as a first concept (not built or tested). The
isolation barrier runs across the sheet, with the live side above it.
Line side, left to right: the IEC inlet and fuse, the surge suppressor, the
outlet, the triac stage, and the line sides of the opto-triac (U3), the
motor-enable relay (K1), the zero-cross optocoupler (U2) and the 5 V supply
(PS1). Control side: the triac's LED drive, the relay driver, the
zero-cross input, the RP2350B core board, the operator inputs and heel
switch (left), the switches, the hand-wheel index sensor and the optional
hand-wheel encoder (right). The KiCad file and its generator are in
`hardware/mcu-controller/`.](../images/diagrams/mcu-controller-schematic.svg){width=100%}

The KiCad drawing, a printed copy and the script that generates them are in
the repository at `hardware/mcu-controller/`. The power stage, sensing and
control loop will be settled on the bench, and this section will be revised
as they are.

### Fitting the encoder

Fitting an encoder is an engineering exercise on every machine, and on some
it won't be practical. Where it is, it gives the controller the needle's
angle at all times, and with it taught stops and the heel tap. The
electronics are the same everywhere: two Hall latches a quarter-cycle apart
over a ring of magnets of alternating pole, plus an index. Each magnet gives
two counts, so twelve magnets give 24 counts a turn (15° each). What
differs is where the ring can go, and two places look like the best
candidates on any machine that can be adapted.

**On the arm shaft, inside the arm.** Machines with a removable top cover,
such as the Singer 306W and many machines of the 1960s, often have room
inside the arm casting and places where the arm shaft is open to reach. Set-screw
collars on the shaft are common there, and they are left clear because the
screws must be reachable. A printed ring that snaps over the shaft or an
existing collar, locked by a set screw of its own, carries the magnets in
pockets. Its size is limited only by the room in the casting. A 40 mm ring
takes about twelve 6 mm magnets, and a larger ring, or smaller magnets,
takes more, so resolution is seldom the limit. The sensors sit on a printed
bracket fixed to an existing hole in the casting, and their leads run
inside the casting down to the bed, out of sight.

- *For it:* the ring is fixed to the shaft, so taught stops survive bobbin
  winding and the cover keeps out hands, thread and lint.
- *To check:* clearance through a full turn from cams, cranks, oil wicks
  and the cover; a lead path clear of moving parts; and a bracket that
  needs no drilling.

**On the hand wheel.** Where the arm is sealed cast iron, as on the Singer
99K, the shaft can't be reached without dismantling the machine, so the ring
goes on the hand wheel. The sensor lead can't cross the front of the
machine or come near the rim or the bobbin winder's tire track. On the 99K
the one place left is the wheel's sloped back face, between the tire track
and the rim. There the sensor head comes up between the belt and the wheel,
or in through the belt from the side, where the belt already keeps hands
away.

- *Every wheel differs:* diameter, slope and curvature, material (cast
  iron, aluminum, plastic) and finish. Many of these wheels have original
  japanning, so the ring must come off without marking it; a printed
  segment ring and a removable adhesive suit better than anything
  permanent.
- *The gap moves:* runout of the wheel and its end play on the shaft go
  straight into the gap between magnet and sensor, so the bracket needs some
  adjustment, and the sensor head must clear the belt as it flexes.
- *The stops don't survive bobbin winding:* the wheel is held to the shaft
  by the stop-motion clamp, by friction. Loosen it to wind a bobbin and the
  wheel turns free; tighten it again and the wheel is fixed at a new angle,
  so the taught stops are off by an unknown amount. The spacing between
  the up and down stops belongs to the shaft and does not change, so one
  point is enough to recover: set top dead center again, with the needle
  up and a short hold of the single-stitch button. The firmware should ask
  for this after bobbin winding rather than trust stale stops; nothing in
  the circuit can tell that the clamp slipped.

**The index.** A third sensor reading a magnet of its own (on another
radius, or off to one side of the ring) is the plain answer. Where three
sensors won't fit, a gap in the ring (one magnet left out) can stand in
for it, the firmware finding the gap by timing; but then the index is
found only once the shaft is turning, so this is a fallback rather than the
first choice.

## Directions under consideration

These are ideas, not designs, recorded so they are not lost.

**A pedal-first controller, without feedback.** Fitting any sensor to the
machine is the largest barrier to the MCU design. A middle course drops
machine feedback altogether and puts the effort into the human side: a
pedal designed for the foot, supporting all of it and responding to
changes in pressure, with response curves that can be switched or tuned.
Electrically it is open-loop phase control, like the KB3151C board in the
knee controller, whose function it would take over and refine. It would be
built in two parts. The mains stays in the base, behind a grounded IEC
inlet: the triac stage, its isolation and the isolated supply. The pedal
carries only low-voltage sensors, powered from the base, on a cable with
a connector that can't be mistaken for a mains one (a square Molex-style
connector, say). One fixed curve could be done in analog; switchable
curves, a dead band with no hum below it, soft start and a speed limit are
all simple in firmware. So this is best treated as a feedback-free mode of
the MCU design, not a separate circuit. Without feedback the load still
sets the speed, as with the carbon pile (§4), and the operator
compensates; a pressure-responsive pedal makes that compensation natural.

**Load compensation without a machine sensor.** A tunable compensation
mode is mostly firmware, but not entirely. A series motor's back-EMF
depends on its field current ($E = K I \omega$, §2), so between the
triac's pulses, with no current, there is only the weak residual-field
voltage of §9: noisy, and it would need the motor voltage carried across
the isolation barrier. The more practical route is IR compensation, as in
the KBIC (§7, §8): measure the motor current and advance the firing angle
as it rises. A small current transformer on the motor lead gives the
current with isolation built in. The correction is first-order and must be
tuned per motor, either from $K$ and $R$ measured on the test rig, or, as
with the KBIC's IR trimpot, turned up in a setup mode until the motor
begins to hunt and then backed off. Space for the current transformer on
the board would keep the option open.

**A tabletop controller for accessibility.** Many people who sew can't use
a pedal or a knee lever. A tabletop controller on the same electronics
would accept a range of assistive interfaces: a slide pot or knob, a grip
or pressure sensor, a switch. Assistive switches commonly use 3.5 mm mono
jacks, which would let existing switches plug straight in. Switch-only
use needs its own firmware modes: start and stop at a preset speed, speed
steps up and down, single stitch, needle up and down. Every latched mode
must stop on any input, and should probably have a large stop button as
well, since the user may not be able to reach for anything else in a
hurry. The right set of interfaces is a question for the people who will
use them.


## Other options considered

- **A KBIC with an isolated command (§8).** Proven regulation through IR
  compensation with almost no design work, driven from an isolated source (a
  KBSI-240D, or an MCU through an isolated 0–9 V output). Evaluated from its
  manual and set aside for now: it is proprietary, so it teaches little and
  appeals less to hobbyists; it costs about $100; and it is too large for the
  right-hand bay, so it would need its own enclosure under the machine. It
  remains the fallback if the purpose-built MCU controller proves too hard,
  and would then still need a check that its DC output reaches the 99's top
  speed.

A bench rig for these measurements is in the repository at
`hardware/motor-rig/` (its guide is `RIG_GUIDE.md`). Two bench measurements
would settle the open questions for any of these: the
99 motor's current and speed on a variac at several voltages, giving $K$ and
$R$ for the model in §2, and its top speed on rectified DC.
