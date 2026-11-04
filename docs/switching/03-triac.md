# The triac and the diac

## Two thyristors in one chip

A triac is, in effect, two SCRs connected inverse-parallel and built into a
single piece of silicon with a single gate. General Electric introduced it
in the 1960s, for lamp dimmers and appliance controls. Because it conducts
either way, its main terminals aren't called anode and cathode. They are
**MT1**, the terminal the gate is referenced to, and **MT2**. On a TO-220
package such as the BT136, MT2 is the metal tab, so the tab is live.

![A triac in cross-section, schematically and not to scale. The same four
main layers as an SCR, with N-type emitters let into both faces: N2 under
MT1, N4 under MT2 on the opposite side, and N3 under the gate. One SCR
(orange) conducts when MT2 is positive, the other (blue), the same layers
the other way up, when it is negative.](../images/switching/triac-structure.svg){width=100%}

**Inside, it is one chip with two SCRs folded together.** The figure shows
the layout. The thick, lightly doped N1 layer in the middle blocks the
voltage in both directions, as in an SCR. Above and below it are P2 and
P1. The N-type emitters are let into the outer faces at different places:

- **N2, under MT1,** makes P1–N1–P2–N2, an SCR that conducts from MT2 to
  MT1 when MT2 is positive. This is the left-hand path in the figure.
- **N4, under MT2,** on the opposite side of the chip, makes P2–N1–P1–N4,
  an SCR the other way up, conducting from MT1 to MT2 when MT2 is negative.
  It sits under the part of MT1 that touches P2 directly.
- **N3, under the gate,** is a small emitter beside the gate's contact to
  P2. It is what lets a negative gate current fire the triac (below).

Each terminal's metal touches both an N emitter and the P layer beside it.
That is a deliberate short. It keeps the emitters from injecting until a
real gate or load current flows, which is what sets the triac's
sensitivity and its dV/dt rating.

The triac behaves as described for the SCR: it latches, the gate can't turn
it off, and it turns off when the current through it falls below the
holding current. So all a control circuit can choose is when to switch it
on in each half-cycle. That moment is the **firing angle** $\alpha$,
measured from the voltage zero. This is **leading-edge** (or forward-phase)
control:

- **The line crosses zero.** The triac is off, and stays off.
- **At $\alpha$ the gate is pulsed,** and the triac switches the line onto
  the load. A larger $\alpha$ means a later start and less power.
- **The current reaches zero,** and the triac turns itself off until the
  next pulse.

With a resistive load the current reaches zero with the voltage. A motor is
inductive, so its current lags and the triac stays on a little past the
voltage zero. *Inside the Motor* (§3 there) shows the motor current behind
a triac in detail.

## Four quadrants

A triac can be fired with gate current of either sign, whichever way MT2
is biased. That gives four combinations, called quadrants:

| Quadrant | MT2, relative to MT1 | Gate current | BT136-600E: gate current to fire (typ / max) |
|---|---|---|---|
| I | positive | positive, into the gate | 2.5 / 10 mA |
| II | positive | negative, out of the gate | 4 / 10 mA |
| III | negative | negative | 5 / 10 mA |
| IV | negative | positive | 11 / 25 mA |

The four work by different routes through the structure, which is why
they aren't equally easy:

- **Quadrant I** is an ordinary SCR's gate. Current from the gate flows
  through P2 to N2, forward-biases the P2–N2 junction, and the left-hand
  SCR fires.
- **Quadrant II** uses the gate's own emitter. With the gate negative, N3
  injects electrons into P2. That turns on a small auxiliary SCR,
  P1–N1–P2–N3, under the gate first. Its current flows sideways through P2
  to MT1, and acts as a large gate current for the main SCR, which fires
  next. The auxiliary SCR is a built-in amplifier.
- **Quadrant III** is a "remote gate". With MT2 negative, the SCR to fire
  is the right-hand one, which has no gate of its own. Electrons injected
  by N3 cross P2 into N1. There they lower N1's potential and act as base
  current for the PNP section, P2–N1–P1, which turns the right-hand SCR
  on.
- **Quadrant IV** is the most indirect. Positive gate current
  forward-biases P2–N2 under MT1, and N2 injects electrons that have to
  find their way to N1 to fire the right-hand SCR, the far side of the
  chip. Little of the gate's effort gets there, so it needs the most gate
  current and fires the slowest.

Circuits avoid quadrant IV where they can:

- **A diac-triggered pedal** fires in I and III. The timing capacitor
  charges with the same sign as MT2, so the gate pulse has the same sign
  too.
- **A microcontroller running at line potential**, as in many appliance
  controllers, usually drives the gate negative in both half-cycles. That
  is quadrants II and III, both sensitive, and it needs only one supply
  polarity.
- **"Three-quadrant" triacs,** such as ST's Snubberless and NXP's Hi-Com
  types, don't fire in quadrant IV at all. In exchange they turn off
  inductive loads far better (§5).

## Why a triac is harder to turn off than two SCRs

In an inverse-parallel pair, each SCR conducts for one half-cycle and then
has the whole next half-cycle, 8 ms, to recover while the other one
carries the current. In a triac the same silicon carries both directions.
When the current falls to zero at the end of one half-cycle, the region
that just conducted is still full of carriers. The voltage across the
triac is about to rise in the opposite direction, and that direction
belongs to the other half of the same chip. If the voltage rises fast
enough, the leftover carriers act like gate current and the triac turns
straight back on, now in the other direction.

So triac datasheets add two ratings:

- the **commutating dV/dt**, $(dV/dt)_c$, the fastest rise of reapplied
  voltage that the triac will block after conducting;
- the **commutating dI/dt**, $(dI/dt)_c$, the fastest fall of current
  through zero that it can turn off from. A current that falls fast leaves
  more carriers behind.

With a resistive load the voltage rises gently from zero after the current
stops, and neither rating matters. With a motor, the current reaches zero
after the voltage, so the line is already tens of volts into the next
half-cycle. That voltage appears across the triac within microseconds.
This is the case the snubber in §5 is for.

## The diac

![Left: a diac's three layers, with no gate connection. Right: its
current against its voltage, schematically: almost nothing until the
breakover, then a fall in voltage as the current rises, the same either
way round.](../images/switching/diac-structure.svg){width=100%}

A diac is a three-layer, two-terminal trigger, symmetrical, with no gate.
In effect it is a transistor with no base connection, built with both
junctions alike so that it works the same either way round.

With voltage across it, one junction is forward-biased and the other
reverse-biased. Almost nothing flows until the reverse-biased junction
reaches its avalanche voltage, about 32 V for the common DB3 (28–36 V).
The avalanche current flows into the floating middle layer, where it acts
as base current. The transistor's gain rises with current, as an SCR's
does (§2), so the more current flows, the less voltage it takes to keep it
flowing. That is a negative resistance: past breakover, the voltage falls
back by at least 5 V (the "breakback") as the current rises, until the
device is conducting heavily at a lower voltage.

That snap is the point. A capacitor charged to 32 V dumps part of its
charge through the diac into the triac's gate as a short, sharp pulse of
current, far more than the gate needs. Unlike an SCR, a diac doesn't
latch: it has no fourth layer, so when the capacitor's current falls
away, it stops conducting.

Why not feed the gate straight from the capacitor through a resistor? The
gate fires at a fraction of a volt and a few milliamps, so it would fire
on a slowly rising, poorly defined current that varies with temperature
and from one triac to the next. The diac waits for a definite voltage, then
delivers a definite pulse. The firing point is set by the RC network and
the diac, not by the triac's gate sensitivity.

## Other ways to fire a triac

- **Opto-triacs** (MOC3020 to MOC3023, and others) put a small
  light-triggered triac in a package with an LED. They fire the main
  triac's gate from an isolated, low-voltage circuit, such as a
  microcontroller. The MCU design in the speed-control paper uses a
  MOC3023. Zero-crossing versions (MOC3041 to MOC3043) only fire near the
  voltage zero, which suits switching heaters on and off. They can't do
  phase control.
- **Pulse transformers** isolate the gate drive magnetically. They are
  common in industrial SCR drives.
- **Solid-state relays** package an opto-coupler and a triac (or two SCRs)
  together. Most switch at the zero crossing and are on-off switches, not
  phase controls. "Random-turn-on" versions exist for phase control.
