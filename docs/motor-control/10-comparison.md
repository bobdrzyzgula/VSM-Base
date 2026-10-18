# How the methods compare at the needle

Only the feedback methods hold speed through a seam; among open-loop pedals,
the carbon pile has the best command resolution and the variac the best
regulation and smoothness.

| Method | Pedal commands | Low-speed resolution | Holds speed under load | Smoothness at a crawl | Heat in controller | Pedal at line voltage |
|---|---|---|---|---|---|---|
| Stepped / wire-wound rheostat | Resistance (by position) | Poor: steps, crowded low end | Worst | Poor | High | Yes |
| Carbon pile | Resistance (by force, log-like) | Excellent | Poor (operator compensates) | Good | High | Yes |
| Variac | Voltage (by position) | Good | Fair | Excellent | Negligible | Not isolated |
| Triac, open loop | Firing angle (by position) | Fair: snap-on hysteresis | Fair | Poor: pulses, cogging | Low | Yes, if the pot is in the pedal |
| Half-wave SCR, back-EMF | Speed (approx.) | Good | Good | Fair: half-wave ripple | Low | Usually yes |
| KBIC (DC, IR comp) | Speed (approx.) | Good | Good: ~1% of base speed | Good | Low | Yes, unless isolated input |
| MCU + tachometer | Speed | Whatever the pedal sensor gives | Best | Good | Low | No (isolated by design) |

The ratings are qualitative, drawn from the physics above and the cited
regulation figures; they are not bench measurements.

![Model speed against load torque, with all three set to the same slow speed
at nominal load. The resistance pedal and the reduced-voltage controls start at
the same speed, but the resistance pedal keeps the full-line slope and stalls at
about 1.6× load, while the reduced-voltage curve only halves its speed by 2×.
Computed from $\omega = V/\sqrt{KT} - R/K$ with $K = 1$, $R = 0.1$
(`tools/make_speed_chart.py`); illustrative, not measured.](../images/diagrams/speed-vs-load.svg){width=100%}
