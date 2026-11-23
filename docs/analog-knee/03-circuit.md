# The circuit

![Research only: not built or tested, and not safe to build as drawn. The low-voltage side. U2's output transistor, pulled up by RZ, goes high
for a few degrees around each zero crossing (Z); Q3 then empties the ramp
capacitor CR. The LM334 charges CR at a constant 45 µA the rest of the
time. RM and the FSR divide the 5 V supply into the command D, filtered
by CF. When the ramp rises past D, U4's output goes low and lights U3's
LED, which fires the triac. Everything to the left of the barrier is
intended to be SELV (not verified); the mains side is the MCU controller's.](../images/analog-knee/analog-knee-schematic.svg){width=100%}

## The mains side

It is the MCU controller's line side, unchanged (`hardware/mcu-controller/`,
and the speed-control paper's §11): the earthed IEC inlet, the T2A fuse,
the 150 VAC MOV, the snubberless triac (the BTA16-600BW the project has
bought) fired by the MOC3023, the H11AA1 zero-cross detector fed from the
line through R7 and R8 (22 kΩ each), and the IRM-05-5 on its own T250mA
fuse. The pads for an RC snubber stay, unfitted.

Two things differ:

- **No relay.** The MCU controller's relay K1 lets the firmware cut the
  motor. Here, the knee's rest switch does that job (§5; with a foot pedal the relay returns, §6): a mains-rated
  snap switch in series with the motor, open whenever the knee lever is at
  rest. It guards against a shorted triac or a fault in the
  electronics, as the relay does, but it is one layer, not a protection
  that survives a single fault of its own (a welded contact, a jammed
  lever; see §7).
- **The zero-cross pull-up.** The MCU controller pulls U2's output up
  through 10 kΩ; here, RZ is 100 kΩ (below).

## The low-voltage side

**The zero-cross window (U2, RZ).** U2's two LEDs carry the line current
through R7 and R8, so its output transistor is on, holding Z low, for most
of each half-cycle. Near a zero crossing the LED current falls too low,
the transistor turns off, and RZ pulls Z high. How wide that window is
depends on the pull-up: with 100 kΩ, the transistor needs only 50 µA, and
with the H11AA1's guaranteed current-transfer ratio of 20% that takes
0.25 mA in the LEDs, about 11 V on the line, within 4° of each zero
crossing. The H11AA1's transfer ratio is specified at 10 mA and falls at
small currents, so a real window may be wider; §4 tests ±8°, which
barely matters. (With the MCU
controller's 10 kΩ the window would be ten times wider, which is fine for
timing an interrupt but would eat into the firing range here.)

**The ramp reset (Q3).** Z drives a 2N7000's gate. While Z is high, Q3
shorts CR, so the ramp starts every half-cycle from zero.

**The ramp (LM334, RSET, CR).** The LM334 is a three-terminal adjustable
current source: its current is 67.7 mV divided by RSET, at room
temperature. With RSET at 1.5 kΩ it gives 45 µA, which charges CR
(0.1 µF, film) in a straight line to about 3.6 V by the end of the
half-cycle. A straight line matters: it makes the firing angle simply
proportional to the command. The LM334 needs about a volt of headroom,
which 5 V leaves.

**The command (RM, FSR, CF).** RM (22 kΩ) runs from 5 V to the command
node D, and the FSR from D to ground. With the knee at rest the FSR is
open, D sits at 5 V, above the ramp's peak, and nothing fires: no
current, no hum. Pressing lowers the FSR's resistance and pulls D down.
CF (0.1 µF) filters D, with a time constant of at most 2 ms, too short for
a knee to notice. In normal operation the FSR sees no more than 5 V or carries more than
about 0.23 mA, well within Interlink's typical drive and current limit.

**The comparator (U4).** An MCP6562, a dual comparator with rail-to-rail
inputs and a push-pull output that runs from 5 V. The ramp goes to its
inverting input and D to its non-inverting one. While the ramp is below D
the output is high and U3's LED is off. When the ramp rises past D the
output goes low, and the LED lights through RL (330 Ω, about 11 mA,
against the MOC3023's 5 mA trigger current). Rail-to-rail inputs matter
because D sits at 5 V at rest; a comparator like the LM393, whose inputs
work only up to 1.5 V below its supply, would need the divider scaled
down. The second comparator in the package is spare.

**Gating to the end of the half-cycle.** Once the ramp passes D it stays
above it until the next reset, so the LED stays lit from the firing angle
to the end of the half-cycle. That is deliberate. A universal motor's
current lags the voltage, and a triac given only a short gate pulse may
let go before the current has built up past its latching level. Held
gate drive keeps the triac on until the current flows. And because Z
resets the ramp just *before* each zero crossing, the drive ends before
the line reverses, so the triac can't be fired at the very start of the
next half-cycle by a leftover drive.

## Why it starts smoothly

Each half-cycle starts from a reset ramp, so nothing carries over from
the last one. As the knee presses past the start, D falls just below the
ramp's peak, the triac fires at the very end of the half-cycle, and the
motor gets a sliver of each half-cycle: it starts from zero. There is no
snap-on, the RC pedal's habit of jumping to a quarter of line voltage
(pedal paper, §4.3; switching paper, §4).

## Parts

| Part | Value | Notes |
|---|---|---|
| U4 | MCP6562 (Microchip), DIP-8 | Dual comparator, rail-to-rail inputs, push-pull |
| LM334 | LM334Z (TI), TO-92 | Adjustable current source |
| RSET | 1.5 kΩ, 1% | Sets 45 µA |
| CR | 0.1 µF film, 5% | The ramp's timing; film for stability |
| Q3 | 2N7000 (TO-92) or 2N7002 | Ramp reset; on order |
| RZ | 100 kΩ | Zero-cross pull-up |
| RM | 22 kΩ, 1% | Sets the force range (§4) |
| CF | 0.1 µF ceramic | Command filter |
| RL | 330 Ω | U3's LED current, about 11 mA |
| FSR | Interlink UX 406 or 402 | At 5 V either is within its current limit |
| Rest switch | Mains-rated snap switch | In series with the motor; the knee design's existing switch |
| Mains side | As the MCU controller | Triac, MOC3023, H11AA1, R7/R8, IRM-05-5, fuses, MOV, inlet |

Apart from the MCP6562 and the LM334, everything is already on the
project's order or in the drawer.
