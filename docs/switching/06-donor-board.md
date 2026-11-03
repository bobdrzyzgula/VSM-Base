# The donor board, worked through

The VSM Base's first knee controller reuses an inexpensive foot-pedal
board, the XWW KB3151C (75 × 35 mm, labeled 110–120 V, 1.0 A), with a knee
lever turning a pot in place of the pedal. The speed-control paper (§11
there) describes the controller and its mechanism. This section looks at
the board's circuit.

![The KB3151C, traced from photos; KiCad source in
`hardware/triac-board/`. J1 and J2 are its two spade tabs: the board is a
two-terminal switch in series with the motor, and the triac's tab is MT2
(live). Timing: from MT2 through RV1's pin-1 section, in parallel with RV2
plus RV1's pin-3 section, to the wiper, then through R2 into C2 and back to
MT1. When C2 reaches the DB3's breakover it fires the BT136 through R1. R3
and C1 are the snubber across the triac.](../images/diagrams/kb3151c-schematic.svg){width=100%}

**What is on it.** It is §4's minimal circuit with a few additions:

- a BT136-600E triac, a sensitive-gate, four-quadrant part (§3), with a
  1 kΩ and 0.1 µF snubber across it (§5);
- a DB3 diac feeding the gate through R1 (1 kΩ), which limits the pulse;
- the timing capacitor C2 (0.1 µF, X2-rated) charged through R2 (1 kΩ)
  from the wiper of a 200 kΩ linear slide pot, RV1;
- a 2 MΩ trimmer, RV2, connected around the slide pot.

**It is a two-terminal series device.** It has only two spade tabs and sits
in series in one leg of the motor circuit, with no separate mains input or
motor output. That works because, as §4 showed, the timing network needs
only the voltage across the triac. In the original pedal, only this control
loop enters the box, as a two-wire lead from a standard cordset, and one
pedal fits many machines.

**At the end of the slide pot's travel** there is an off zone, where the
wiper runs off the track and nothing fires. That is the pedal at rest.

## The timing network and RV2

The board's timing network is the one in §4's figure, with one addition:
the 2 MΩ trimmer RV2 is connected around the slide pot RV1 (200 kΩ). As
traced, RV2 joins RV1's pin 1, which is tied to MT2, to RV1's pin-3 end. So
current from MT2 can reach RV1's wiper by two paths. One runs directly
along RV1's track from pin 1 to the wiper. The other runs through RV2 to
pin 3, then back along the rest of the track to the wiper. The wiper feeds
C2 through R2.

Which of RV1's pins is the wiper is still to be checked with a meter. The
algebra below doesn't depend on it.

**The parallel resistance.** Let $R$ be RV1's whole track (200 kΩ), $a$ the
section from pin 1 to the wiper, and $R - a$ the rest. Let $R_v$ be RV2's
setting, 0 to 2 MΩ. The direct path is $a$, and the other is
$R_v + (R - a)$. In parallel:

$$R_{eq} = \frac{a\,(R_v + R - a)}{R_v + R}$$

C2 (0.1 µF) charges through $R_{eq}$ plus R2 (1 kΩ). Pressing the pedal
moves the wiper from the pin-3 end toward pin 1, so $a$ falls from $R$ to
0. Three things follow from the formula:

- **At full pedal,** $a = 0$ and $R_{eq} = 0$, whatever RV2 is set to.
  R2 alone sets the top speed.
- **At the start of the travel,** just past the off zone, $a = R$ and
  $R_{eq} = R R_v / (R + R_v)$: RV1 and RV2 in parallel. This is RV2's main
  effect. It lowers the largest timing resistance the pedal can reach,
  from RV1's 200 kΩ toward zero.
- **In between,** $dR_{eq}/da = (R_v + R - 2a)/(R_v + R)$, which is zero
  at $a = (R_v + R)/2$. If $R_v \ge R$, that point is at or past the end
  of the track. Then $R_{eq}$ rises steadily all the way back to the off
  zone, and the pedal is monotonic: less pedal, less speed. If $R_v < R$,
  $R_{eq}$ peaks at $(R_v + R)/4$ partway along the travel and falls again
  toward the off zone. At $R_v = 0$ it becomes $a(R - a)/R$, a parabola
  that is zero at both ends and 50 kΩ in the middle.

![The timing resistance through the pedal's travel for six settings of
RV2, from the formula above. The dashed line is where the motor starts
from rest; the dotted one is how far it keeps running once
started.](../images/diagrams/kb3151c-req.svg){width=100%}

**Firing.** §4's two thresholds turn these resistances into speeds. With
C2 = 0.1 µF on 120 V, the motor starts when the timing resistance falls
below about 137 kΩ, and it settles at about 125° firing, roughly 40% of
the line's RMS voltage. Once running, it keeps firing until the resistance
rises past about 158 kΩ. The next figure runs the board's network through
the simulation of §4, pressing the pedal from rest and then easing back.
It plots motor voltage as a stand-in for speed: at light load, a universal
motor's speed rises with its voltage, though not in proportion.

![The motor voltage through the pedal's travel, simulated, for the same six
settings of RV2. Solid: pressing from rest. Dashed: easing back, where it
differs.](../images/diagrams/kb3151c-voltage.svg){width=100%}

| RV2 | $R_{eq}$ at the start of travel | Dead travel | Voltage when it starts | Lowest voltage while running |
|---|---|---|---|---|
| 2 MΩ | 182 kΩ | 27% | 38% | 9%, at 15% of travel |
| 1 MΩ | 167 kΩ | 21% | 38% | 7%, at 7% of travel |
| about 430 kΩ | 137 kΩ | none | 39% | 39%, at the off zone |
| 200 kΩ | 100 kΩ | none | 66% | 66% |
| 100 kΩ | 67 kΩ | none | 83% | 80%, a quarter of the way in |
| 0 | 0 | none | 100% | 90%, halfway |

**What a sewist notices.** RV2 is the board's minimum-speed adjustment, and
turning it goes through four distinct behaviors.

- **Turned up, toward 2 MΩ.** The first quarter of the pedal does nothing.
  Then the motor jumps on at about 40% of line voltage: a brisk start, not
  a crawl. Easing back, it slows further and keeps firing down to a tenth
  or less before it quits. Long before that, though, a sewing machine's
  motor stalls or cogs, so the motor sets the practical floor. The feel is
  "it starts too fast, but slows if I let off". After a stop, starting
  again needs the push again.
- **Turned down to about 430 kΩ.** RV1 and RV2 in parallel then just match
  the start threshold. The motor starts as soon as the pedal leaves the off
  zone, at the same 40% or so, with no dead travel. Eased back, it keeps
  running at that speed right up to the off zone. This setting uses the
  whole pedal.
- **Turned further down.** The motor starts at once, but at a higher
  minimum speed: 66% of line voltage at 200 kΩ. The low end is gone, and
  the pedal goes from off straight to a fast run.
- **Below RV1's own 200 kΩ.** The slowest point moves away from the start
  of the travel. At 100 kΩ the speed dips a little as the pedal goes down,
  then rises. Near zero the pedal is almost an on-off switch, faster at
  both ends of the travel than in the middle.

**What RV2 cannot do** is lower the snap-on speed. In every setting with
dead travel, the motor starts at about 125° firing, near 40% of line
voltage. RV2 only moves where in the travel that happens. The jump comes
from the timing capacitor's memory (§4), so a gentler start needs a
different network, such as §4's two-stage RC, not a different setting.

The start threshold also varies from board to board. A DB3's breakover
can be anywhere from 28 to 36 V, which alone moves the threshold from
about 157 kΩ down to 121 kΩ. C2's tolerance and the line voltage move it
further. So the 430 kΩ setting is a model's figure, not a dial position.
That is why RV2 is a trimmer, set by ear: back it off until the motor just
starts as the pedal leaves the off zone.

**In the knee controller,** the slide pot is replaced by the Bourns pot,
wired as a two-terminal resistor, with RV1's pin-3 pad jumpered to the
wiper pad. That puts RV2 directly across the pot's working section, so
$R_{eq} = a \parallel R_v$, which always rises with $a$. The off switch
covers the dead travel up to the switch point, about 1" of knee travel.
There the pot's section is about 220 kΩ, and it falls to zero at full
travel. With RV2 at 2 MΩ, the motor starts when $a$ falls to about
147 kΩ, a third of the way into the speed inch. At about 360 kΩ, which
makes 220 kΩ ∥ RV2 = 137 kΩ, it starts as the switch closes. The same
caveat applies: set it by ear.
