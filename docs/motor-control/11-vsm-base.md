# The controllers in the VSM Base

The base's right-hand bay can hold a speed controller
(`compartment_option = "knee"`). Two designs are in progress. The first is
built and modeled. The second is in design. This section is kept up to date as
they develop. The base's User's Guide has the build details for the first.

## The knee controller: a repurposed pedal board

**What it is.** An inexpensive foot-pedal speed-control board (the XWW
KB3151C, 75 × 35 mm) moved into the bay, with a knee lever in place of the
pedal. A bar hangs below the table edge and turns a shaft running front to
back in the bay. A 4:1 gear sector on the shaft turns a Bourns 91A1A-B28-A25L
pot (1 MΩ linear cermet) that replaces the board's slide pot, VR1. A snap
switch (Omron SS-5GL), held open by the sector at rest, cuts the motor.

**What kind of controller it is.** Electrically it is the open-loop triac phase
control of §5: a BT136 triac, a DB3 diac and an RC timing network, with the
pot setting the firing angle. It therefore behaves like a good stock pedal. It
gives no speed regulation; the load sets speed, with the cogging at a crawl
and the snap-on hysteresis described there. The 2 MΩ trimmer VR2 sets the
minimum speed. The knee mechanism improves the command, not the regulation:

- The geared pot turns about 45° over 2.5" of knee travel (54° to the hard
  stop at 3"), so the usable range is spread over the whole lever travel.
- Hard stops, a steel pin in a slot in the hub on the front face, take the
  knee's force, so it never reaches the gears or the pot.
- The off switch opens at rest and closes about 2.4° into the 11.3° swing.
  With it in series with the motor, the motor is fully off at rest instead of
  creeping at the minimum set by VR2.

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

It is set at the hard stop: with the bar held there, the wiper is put at the
pin-1 end (about 0 Ω) and the pinion clamped. At rest it then reads about
225 kΩ, close to the 0–220 kΩ the slide pot used. The pot's plastic shaft and
the printed pinion are the isolation between the touchable bar and mains,
with the pot's 1,500 VAC rating between element and bushing; a metal-shaft pot
must not be substituted.

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

One idea, untested: Bourns makes the 91 in audio (logarithmic) tapers. Since
low speed sits at the high-resistance end of the pot's span, a log taper
would spread that end over more of the knee's travel, a little like the carbon
pile's resolution at the bottom of the range (§4). Whether it helps with this
board's RC network is a bench question.

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
  side, so it needs no mains-rated parts. The geared mechanism, hard stops and
  return spring of the first design carry over.
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
