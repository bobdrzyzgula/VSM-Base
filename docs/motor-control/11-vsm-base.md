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
  features it makes cheap: needle positioning, slow start, a speed limit, a
  single-stitch button; and a force-sensing pedal that reproduces the carbon
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
capacitor. The hand-wheel sensor is a DRV5023 Hall switch on a three-wire
cable; one magnet gives one pulse per stitch and also marks needle
position. The knee lever, a travel pedal, a pressure pedal (a
force-sensing resistor) and a speed-limit knob go to four analog inputs
through RC filters. A needle-up/down toggle and a single-stitch button use
the microcontroller's internal pull-ups.

| Signal | RP2350B pin | Use |
|---|---|---|
| Triac fire | GP4 | gate pulse (timer alarm or PIO) |
| Relay | GP5 | output |
| Zero cross | GP6 | interrupt |
| Hand wheel | GP7 | edge timestamps |
| Single stitch | GP10 | input |
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
zero-cross input, the RP2350B core board, the operator inputs (left), the switches and
the hand-wheel Hall sensor. The KiCad file and its generator are in
`hardware/mcu-controller/`.](../images/diagrams/mcu-controller-schematic.svg){width=100%}

The KiCad drawing, a printed copy and the script that generates them are in
the repository at `hardware/mcu-controller/`. The power stage, sensing and
control loop will be settled on the bench, and this section will be revised
as they are.

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
