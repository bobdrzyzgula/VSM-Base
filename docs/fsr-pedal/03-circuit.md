# The circuit

![Research only: not built or tested, and not safe to build as drawn. The proposed pedal: a two-terminal device in series with the motor, as
the KB3151C is. RD and the back-to-back zeners D1 and D2 make a clamped
supply at node N. RS and the FSR charge C from it; RB bleeds C and sets the
force at which the motor starts. When C reaches the DB3's breakover, the
diac fires the triac through RG. F1 and the MOV protect it. Every part is
at mains potential.](../images/fsr-pedal/fsr-pedal-schematic.svg){width=100%}

## How it would work

**A clamped timing supply.** RD (22 kΩ) runs from the triac's MT2 side to
node N, and two 56 V zeners, back to back, clamp N to MT1. Until the triac
fires, MT2 follows the line, so N follows it too until it reaches about
57 V (the zener plus the other's forward drop), then stays there: a
trapezoid instead of a sine (the green trace in §4's waveform figure).
When the triac fires, MT2 drops to about a volt and N collapses with it.

This is the classic way to give a phase-control timing network a steady
supply: unijunction-transistor circuits of the 1960s used it (source 6).
Here it does two jobs. It bounds the voltage on everything after N,
the FSR included. And it makes the timing independent of the line's
exact voltage: a low line no longer means a late firing.

**The FSR sets the charging rate.** From N, RS (12 kΩ) and the FSR in
series charge the timing capacitor C (0.1 µF). With the foot off, the FSR
is above 10 MΩ: C barely moves and nothing fires. Pressing lowers the
FSR's resistance, C charges faster, and it reaches the diac's breakover
earlier in each half-cycle, so the triac fires earlier and the motor gets
more of the cycle.

**RS sets the top end.** At full force the FSR falls to about 1 kΩ, so RS
is most of the charging resistance there. It limits the FSR's current,
and it decides how quickly the curve approaches full speed: the larger RS,
the more of the FSR's range is spread across the top half of the speed
range (§4).

**RB sets where the motor starts.** RB (100 kΩ plus a 1 MΩ trimmer)
across C drains it continuously. C can only reach the diac's breakover
when the charging current outruns RB, so RB sets the smallest force that
starts the motor. It also trims out part of the diac's tolerance (§4).

**Firing.** When C reaches the DB3's breakover (32 V nominal, 28 to 36 V
across parts), the diac snaps back by about 10 V and dumps that charge
into the triac's gate through RG. With RG at 100 Ω, the pulse peaks near
90 mA for about 10 µs. That comfortably exceeds the BTA16-600BW's 50 mA
maximum gate trigger current. The KB3151C's 1 kΩ would give about 9 mA,
enough for its sensitive-gate BT136-600E but not for a snubberless
triac. A diac fires the triac in quadrants I and III only, which is all a
snubberless "W" triac needs (switching paper, §3).

**Protection.** F1 (T2A, slow-blow for the motor's inrush) is in series
with the pedal, so it carries the motor current. The MOV (a 241KD14) sits across the pedal on the inner side of the fuse, so
a MOV that fails short blows F1 instead of burning. It clamps surges to
about 395 V, well inside the triac's 600 V.

**No snubber.** The snubberless BTA16-600BW is rated to commutate an
inductive load without one (switching paper, §5). A board would want pads
for a 100 Ω resistor and a 47 nF X2 capacitor across the triac, in case
testing showed otherwise.

## Parts as drawn

| Part | Value | Notes |
|---|---|---|
| TR1 | BTA16-600BW (or -600BWRG) | Snubberless, insulated tab; small clip heatsink |
| DB3 | Diac, 32 V nominal | 28–36 V spread; see §4 |
| RG | 100 Ω, 0.25 W | Gate pulse about 90 mA |
| C | 0.1 µF film, 100 V or more | Sees about ±57 V; not across the line, so it needn't be X2 |
| RS | 12 kΩ, 0.25 W | Range; 6.8–18 kΩ explored in §4 |
| FSR | Interlink UX 406 | About 34 mm square active area; the larger area matters (§4) |
| RB | 100 kΩ fixed plus 1 MΩ trimmer | Start force |
| D1, D2 | 56 V, 1 W zeners (1N4758A), back to back | Each carries a few mA |
| RD | 22 kΩ, 1 W, rated 350 V or more | 0.23 W with the pedal at rest |
| RV1 | MOV, 14 mm, 150 VAC (241KD14) | Across the pedal, after F1 |
| F1 | T2A, 5 × 20 mm, in a holder | In series with the pedal |

## What it costs at rest

With the foot off, the pedal still passes the clamp's current. The
simulation gives 3.3 mA RMS through the motor, and 0.23 W in RD. The motor
won't turn on 3 mA. RD wants a 1 W part, for margin, and for the voltage:
it carries up to about 115 V.

At full force the triac fires at about 49°, the motor gets 94% of the
line, and RD dissipates almost nothing, because the voltage across the
pedal is gone for most of each half-cycle. The triac itself dissipates
about 1.5 W at a 99K's current, as in any triac pedal, which would need a
small clip heatsink. These figures are simulated, like the rest of §4.
