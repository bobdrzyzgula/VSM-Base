# The thyristor (SCR)

The silicon-controlled rectifier, or SCR, is the oldest of the power
switches in this paper and the parent of the triac. "Thyristor" is the
family name; in everyday use it means the SCR. Bell Labs worked out the
four-layer PNPN device in the mid-1950s, and General Electric brought the
SCR to market in 1957. Within a few years it had replaced the thyratron
tube and the magnetic amplifier in motor drives, lamp dimmers and
battery chargers. It is still the cheapest way to switch large currents
from an AC line.

## Four layers, two transistors

An SCR is a sandwich of four alternately doped layers: P, N, P, N. The
outer P layer is the **anode**, the outer N layer the **cathode**, and the
**gate** connects to the inner P layer next to the cathode.

![Left: the SCR's four layers and its three junctions. Right: the same
layers seen as two transistors that share their middle layers. The PNP's
collector feeds the NPN's base, and the NPN's collector feeds the PNP's
base, so once either conducts it turns the other on
harder.](../images/switching/scr-structure.svg){width=95%}

The structure has three junctions, J1, J2 and J3. With the anode positive,
J1 and J3 are forward biased, but J2 in the middle is reverse biased and
blocks. With the anode negative, J1 and J3 block. So an SCR that has not
been triggered blocks in both directions.

The key to the device is to see the four layers as two transistors that
share their middle layers, as the figure shows: a PNP made of the first
three layers and an NPN made of the last three. The PNP's collector is the
NPN's base, and the NPN's collector is the PNP's base. Each transistor's
output current is the other's input.

Call the two transistors' common-base current gains $\alpha_1$ (PNP) and
$\alpha_2$ (NPN), the fraction of each one's emitter current that reaches
its collector. Summing the currents at the junctions gives the anode
current:

$$I_A = \frac{\alpha_2 I_G + I_{CO1} + I_{CO2}}{1 - (\alpha_1 + \alpha_2)}$$

Here $I_G$ is the gate current and the $I_{CO}$ terms are the two
transistors' small leakage currents. In silicon, $\alpha$ is small at tiny
currents and rises with current. With no gate current, the sum
$\alpha_1 + \alpha_2$ is well below 1 and only leakage flows: the SCR is
off. A pulse of gate current raises the NPN's current and so its $\alpha$.
That sends more current into the PNP's base, which raises its $\alpha$, and
so on. When $\alpha_1 + \alpha_2$ reaches 1, the denominator goes to zero:
the loop gain is one, and the current is limited only by the external
circuit. The SCR has switched on, and it stays on with no gate current at
all.

## Latching and holding

Two currents describe the latch:

- **Latching current, $I_L$.** The anode current must reach this before the
  gate pulse ends, or the loop gain falls below one and the SCR drops out.
  It matters with inductive loads, where the current rises slowly after
  firing.
- **Holding current, $I_H$.** Once latched, the SCR stays on until the
  anode current falls below this, a few milliamps for a small device.
  Then the loop gain falls below one and it turns off.

The gate can start the regenerative loop but can't stop it. A negative gate
current large enough to steal the loop's own current would turn it off,
but for an ordinary SCR that is about the whole anode current. The gate
turn-off thyristor (GTO) is built to make that practical; §7 comes back to
it.

So an SCR is turned off by **commutation**: something outside it brings
its current to zero. On an AC line, the line does that every half-cycle
("natural" or "line" commutation). After the current stops, the SCR also
needs a short time with no forward voltage, its **turn-off time** $t_q$,
tens of microseconds for a phase-control part, to sweep the stored charge
out of its middle layers. Apply forward voltage sooner and it turns back
on. Early DC choppers and inverters had to force commutation with extra
capacitors and SCRs, and the circuitry was elaborate; transistor switches
retired them (§7).

## Ways to turn it on, intended and not

Any current that drives the loop gain to one fires an SCR. The gate is the
intended way, but there are others:

- **Breakover.** Raise the forward voltage far enough and J2's leakage
  avalanches until the loop latches. This is the breakover voltage, well
  above the device's rating. The diac (§3) is built to work this way on
  purpose.
- **Rate of rise of voltage (dV/dt).** The blocking junction J2 is a
  capacitor. A forward voltage rising at $dV/dt$ drives a current
  $C\,dV/dt$ through it, which acts exactly like gate current. Fast enough,
  and the SCR fires with no gate signal. Datasheets give the critical
  $dV/dt$. Snubbers (§5) exist largely to stay under it.
- **Temperature.** Leakage roughly doubles every 10 °C or so, so a hot SCR
  needs less to fire and holds on at lower currents.
- **Light.** Photons absorbed near J2 make carriers too. Light-triggered
  thyristors fire this way deliberately, in high-voltage DC converters, and
  the opto-triacs in §3 use the same idea.

There is also a limit on how fast the current may rise once it fires,
$dI/dt$. Conduction starts in a small region near the gate and spreads
across the chip over microseconds. A current that rises too fast crowds
into that region and can burn it.

## What SCRs are used for

An SCR conducts in one direction only, so on AC it gives controlled
rectification: DC whose average is set by the firing angle. The classic
uses:

- **DC motor drives.** A bridge with SCRs in some or all of its arms turns
  the line into adjustable DC for a permanent-magnet or shunt-wound motor.
  This is how the KB Electronics KBIC controllers discussed in the
  speed-control paper (§8 there) work, with feedback from the armature.
- **AC phase control with two SCRs** connected inverse-parallel, one for
  each half-cycle. In large industrial heaters and soft starters this pair
  is still preferred over a triac, because each SCR has a whole half-cycle
  to recover.
- **Crowbars,** which short a power supply's output when it goes over
  voltage, so that a fuse blows instead of the load.
- **Chargers, welders and high-voltage DC links,** at sizes up to whole
  power stations.

For a sewing-machine pedal, though, the useful step was putting two SCRs
into one chip with one gate: the triac.
