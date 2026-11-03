# The triac and the diac

## Two thyristors in one chip

A triac is, in effect, two SCRs connected inverse-parallel and built into a
single piece of silicon with a single gate. General Electric introduced it
in the 1960s, for lamp dimmers and appliance controls. Because it conducts
either way, its main terminals aren't called anode and cathode. They are
**MT1**, the terminal the gate is referenced to, and **MT2**. On a TO-220
package such as the BT136, MT2 is the metal tab, so the tab is live.

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

| Quadrant | MT2 relative to MT1 | Gate current | BT136-600E: gate current to fire (typ / max) |
|---|---|---|---|
| I | + | + (into the gate) | 2.5 / 10 mA |
| II | + | − (out of the gate) | 4 / 10 mA |
| III | − | − | 5 / 10 mA |
| IV | − | + | 11 / 25 mA |

The four aren't equally easy. In quadrant IV the gate's current has to work
through more of the structure, so it needs the most gate current and fires
the slowest. Circuits avoid it where they can:

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

A diac is a three-layer, two-terminal trigger, symmetrical, with no gate.
It blocks in both directions until the voltage across it reaches its
breakover voltage, about 32 V for the common DB3 (28–36 V). Then it breaks
over: its voltage falls back by at least 5 V (the "breakback"), and it
conducts heavily. That negative-resistance snap is the point. A capacitor
charged to 32 V dumps part of its charge through the diac into the triac's
gate as a short, sharp pulse of current, far more than the gate needs.

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
