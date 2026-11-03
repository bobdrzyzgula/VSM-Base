# Where each appears in the project

Every family in this paper turns up somewhere in the VSM Base's
controllers or in the controllers the speed-control paper compares.

- **The knee controller** (speed-control paper §11) is the donor board of
  §6: a BT136 triac fired by a DB3 diac, leading-edge phase control, with a
  snubber. Its knee lever turns a pot in place of the slide pot, and a snap
  switch in series makes it fully off at rest, which a snubbed triac alone
  never is (§5).
- **The MCU phase controller** (speed-control paper §11) uses a BTA08-600BW,
  a three-quadrant snubberless triac (§3, §5). A MOC3023 random-phase
  opto-triac fires it from the isolated microcontroller, and an H11AA1
  optocoupler tells the microcontroller when the line crosses zero, so it
  can time the firing angle itself. A relay in series lets the firmware cut
  the motor whatever the triac is doing. There is room for a snubber, to
  be fitted only if testing shows the triac re-firing or failing to latch.
- **The rectified-DC variant** puts the universal motor behind a diode
  bridge, with a freewheeling diode across it, and switches the bridge's AC
  side with the same triac. The freewheeling diode lets the motor's current
  continue between the triac's pulses, so the current never stops and the
  triac's commutation problem largely disappears.
- **The DC-motor variant** drops the triac entirely. A 24 V supply feeds a
  Pololu G2 H-bridge, four MOSFETs (§7) switched at a PWM frequency above
  hearing, driving a "775" permanent-magnet motor. The body diodes carry
  the current when a MOSFET turns off, and the bridge can brake the motor
  actively, which no triac can.
- **The KB Electronics KBIC controllers** (speed-control paper §8) are SCR
  bridges (§2) that turn the line into adjustable DC for a DC motor, with
  feedback from the armature voltage.
- **Variable-frequency drives and industrial servo motors** (*Inside the
  Motor*, §7) are IGBT bridges (§7). The project doesn't build one, but the
  clutch motor's replacement on industrial machines is one.
