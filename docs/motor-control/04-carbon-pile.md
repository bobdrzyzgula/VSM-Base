# Carbon-pile pedals: why they feel best

Electrically, a carbon pile is just another series resistance, so it inherits
every load-regulation weakness of the rheostat above. Its advantage is
entirely in how the resistance is commanded. The pile turns foot force, not
foot position, into resistance, and does so continuously over a very wide
ratio.

**How it works.** A stack of graphite discs is squeezed by the pedal through a
spring. Resistance lives almost entirely at the disc-to-disc contacts: more
force flattens more microscopic asperities into contact, so conducting area
grows and resistance falls
([UQ Physics Museum](https://physicsmuseum.uq.edu.au/resistance-carbon-stack)).
Measurements on voltage-regulator piles fit a power law, $R = nC/P^m$, for $n$
discs under force $P$ with constants $C$ and $m$
([Hayashi, Tanso 1953](https://www.jstage.jst.go.jp/article/tanso1949/3/2/3_2_56/_article)).
Sewing pedals run from several hundred ohms at light pressure to a few tens of
ohms at heavy pressure. A brass contact then shorts the pile for full speed
([softsolder.com](https://softsolder.com/2009/03/10/old-kenmore-sewing-machine-foot-control-repair/);
[EEVblog forum](https://www.eevblog.com/forum/beginners/help-understanding-a-sewing-machine-pedal/)).

Four properties explain the feel:

1. **Continuous and logarithmic.** A power law means $dR/R = -m\,dP/P$: each
   equal fractional increase in force gives an equal fractional drop in
   resistance. Human force perception is also roughly proportional (Weber's
   law), so the pedal spreads its resolution evenly across what the foot can
   distinguish. The bottom of the range, where the motor is most sensitive,
   gets the same share of resolution as the top. A linear wire-wound rheostat
   crowds the useful low-speed region into a few millimetres of travel.
2. **Force, not position.** The pile and its spring are stiff, so the pedal
   barely moves. The foot works almost isometrically, and adjusting force
   needs no limb movement and no travel time. I believe this is a large part of
   why the pile feels quick, though I found no study measuring it for pedals.
3. **The operator is the feedback loop.** When a seam slows the machine, the
   sewer hears and feels it and presses harder within a few hundred
   milliseconds. The pile responds instantly, with no mechanical lag between
   force and resistance. In effect the carbon pile plus the human is a
   closed-loop controller, and the pile's fine low-end resolution is what makes
   that loop stable at a crawl.
4. **No steps, no gap.** Resistance changes without breaking the circuit, so
   there is no contact arcing during speed changes and no jump between taps.

One further effect is plausible but I could not confirm it in the sources:
granular carbon contacts are mildly non-ohmic, and their resistance tends to
fall as current through them rises. If so, a load that slows the motor
(raising current) would slightly lower the pile's resistance and partly
compensate. This is a small IR compensation built into the material. Treat it
as a hypothesis to test with a bench measurement, not as established.

The drawbacks are the rheostat's: heat (the pile can run hot inside its case),
weak starting torque at light pressure, and drift as discs wear and the stack
loosens. Worn piles give long travel before anything happens, then abrupt
starts
([softsolder.com](https://softsolder.com/2009/03/10/old-kenmore-sewing-machine-foot-control-repair/)).
