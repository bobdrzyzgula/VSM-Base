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

- An STM32 on a NUCLEO-G431KB, carried on a controller board laid out as a
  Nucleo-32 carrier.
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

The power stage, isolation, sensing and control loop will be filled in here as
the design settles.

## Other options considered

- **A KBIC with an isolated command (§8).** Proven regulation through IR
  compensation with almost no design work, driven from an isolated source (a
  KBSI-240D, or an MCU through an isolated 0–9 V output). It needs space in the
  bay for the drive and its heatsink, and a check that its DC output reaches
  the 99's top speed.

Two bench measurements would settle the open questions for any of these: the
99 motor's current and speed on a variac at several voltages, giving $K$ and
$R$ for the model in §2, and its top speed on rectified DC.
