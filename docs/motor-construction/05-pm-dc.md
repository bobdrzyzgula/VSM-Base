# Brushed permanent-magnet DC motors

## Construction

A brushed permanent-magnet (PM) motor is a shunt motor whose field coils
have been replaced by magnets.

- **The stator.** A steel can that serves as the magnetic return path, with
  two (or four) curved magnets glued inside it: ceramic ferrite in cheap
  motors, neodymium in compact, powerful ones.
- **The rest.** The armature, commutator and brushes are the same as in the
  universal motor, only smaller for the same power. The motor has nothing
  else.

The common "775" motor, sold for drills, pumps and robots, is a good
example. It is a 42 mm can, 66.5 mm long, with a 5 mm shaft.

![A brushed permanent-magnet motor, schematically. The magnets set the flux,
which crosses the armature exactly as in the universal motor, but the
armature current no longer makes it. The lumped model has the same three
terms, with a back-EMF that depends on speed alone.](../images/motors/pmdc-construction.svg){width=100%}

## What the equations say

With the flux fixed,

$$v = R\,i + L\frac{di}{dt} + K_e\,\omega, \qquad T = K_t\,i,$$

and in SI units $K_t = K_e$ (N·m per ampere equals volts per rad/s). Three
consequences matter for a sewing machine:

- **Speed follows voltage; torque follows current.** At steady speed,
  $\omega = (V - R\,T/K_t)/K_e$: a straight line falling only by the
  resistive drop as load rises (§4, right-hand plot). A drop that is
  10% of the supply voltage at full load costs about 10% of the speed.
  For a universal motor at a crawl it costs nearly everything.
- **Torque at zero speed is just current.** A controller that sets the
  current sets the torque directly, at any speed including zero. That is
  what makes a PM motor a servo: it can push the needle through a seam at
  one stitch a second, or hold it still.
- **The back-EMF is always there.** It is made by magnets, so it does not
  vanish when the current stops. Switch the drive off for a moment and the
  terminals show $K_e\omega$, the speed, directly. The speed-control paper's
  back-EMF sampling (its §9), weak and noisy on a universal motor, is easy
  and accurate on a PM motor.

They also run backward when the supply is reversed, and they act as
generators when driven, which is the basis of braking.

## Speed control: the chopper and the H-bridge

A PM motor needs DC, and its speed is set by the average voltage across it.
A controller makes that average by **pulse-width modulation (PWM)**: it
switches the full supply on and off many thousands of times a second, and
the share of time it is on, the duty cycle, sets the average.

![Outline drive circuits. Left: a triac in series with a universal motor
on the mains. Center: a chopper for a PM motor, with one switch and a
freewheeling diode, for one direction. Right: an H-bridge, with four
switches for forward, reverse and braking.](../images/motors/drive-circuits.svg){width=100%}

- **The chopper.** One MOSFET in series with the motor, and a diode across
  the motor. When the MOSFET turns off, the motor's inductance keeps the
  current flowing, and it circulates through the diode. Without the diode
  that current would have nowhere to go, and the voltage spike would
  destroy the switch.
- **The H-bridge.** Four switches, two on each side of the motor. Turning
  on opposite corners drives it one way, the other pair drives it the
  other, and turning on both low-side switches shorts the motor. That short
  is **dynamic braking**: the motor, now a generator, brakes itself hard on
  its own back-EMF. A sewing machine that must stop with the needle in the
  right place wants exactly this.

## On the wire

![Simulated: a 24 V, 775-size motor (R = 0.98 Ω, an assumed L = 0.2 mH) on a
chopper at 50% duty, turning at about 3,500 rpm. At 2 kHz (left) the switch
period is longer than the motor's 0.2 ms electrical time constant. The
current rises steeply, then falls to zero partway through each off-time,
and the terminals show the back-EMF (the 10 V steps) until the next pulse.
At 20 kHz (right) the current only ripples by about 1.6 A around its
mean.](../images/motors/pmdc-pwm.svg){width=100%}

The voltage at the motor is a square wave between the supply and slightly
below zero (the diode's drop). The current is what the inductance makes of
it.

- **The ripple depends on how the switching period compares with $L/R$.**
  Here the motor's electrical time constant is only about 0.2 ms, against
  a universal motor's several milliseconds. At 20 kHz the switching period
  is 50 µs, short against that, so the current rises and falls only a
  little in each period: the ripple is about $V D(1-D)/(L f) \approx 1.5$ A.
- **At 2 kHz the ripple is ten times larger, and the current goes
  discontinuous.** The current is zero for part of each period, which wastes
  heat in the copper and makes the motor sing at the switching frequency.
- **So PWM for motors runs at 20 kHz or more.** That is above hearing, and
  with small ripple. The RP2350's PWM slices do this with no effort.
- **Discontinuous current changes the average.** While the current is
  zero, the terminals show the back-EMF, not 0 V, so the average voltage,
  and with it the speed, depends on the load. At 20 kHz the current stays
  continuous and the average is simply the duty cycle times the supply.

**Hearing it: the cordless drill.** A cordless drill whose trigger is held
just short of turning the chuck often lets out a high-pitched whine. That
whine is the switching frequency.

- **Where the sound comes from.** Each pulse of current pulls on the
  windings and the iron, and they flex very slightly at the switching rate.
  The motor becomes a small loudspeaker playing a tone at the PWM frequency.
- **Why it is loudest at the edge of the trigger.** With the rotor stopped
  there is no fan, gear or brush noise to cover the tone. The duty cycle is
  also small, so the current is discontinuous, in short pulses that start
  and stop sharply. That makes a harsher, louder tone than a current
  rippling around a steady mean.
- **Why the tool sings at all.** Many cordless tools switch at a few
  kilohertz to around 10 kHz, where it can be heard. Slower switching wastes
  less power in the transistors, and the parts cost less. Tools that switch
  above 16–20 kHz are silent.
- **The same holds for any battery tool.** A cordless router or saw, brushed
  or brushless, sings in the same way, since a brushless controller chops
  its three phases with PWM too. A corded tool on a triac control is
  different: its hum is at twice the line frequency (120 Hz on 60 Hz mains)
  and its multiples.

The tone can be measured. A spectrum-analyzer app on a phone, held near the
tool, shows a sharp peak at the switching frequency. There are two cautions:

- **Harmonics.** Peaks may also show at 2×, 3× and so on. A part whose
  force goes as the square of the current can make 2× the strongest. If the
  peaks are evenly spaced, the spacing is the switching frequency.
- **A changing frequency.** Some cheap controllers change frequency with the
  trigger's position, so the pitch moves as the trigger is squeezed.

The certain answer is a scope across the motor's leads, which shows the
frequency and the duty cycle at once, at a battery voltage that is safe to
probe.

**Measured: a drill and an impact driver.** Two DeWalt cordless tools were
measured this way in a quiet room, with a phone's microphone and a
spectrum-analyzer app. Each tool was recorded three times: the room alone,
the trigger just in, and the trigger fully in.

![Measured: sound spectra of a DeWalt cordless drill (top) and impact driver
(bottom), from an iPhone running an FFT analyzer app, each with the room
alone (gray), the trigger just in (blue) and the trigger fully in (orange).
The dotted lines mark the narrow lines described in the text. Read back
from the app's screenshots and replotted.](../images/motors/tool-spectra.svg){width=100%}

- **The drill sings at about 3.85 kHz.** With the trigger just in, the
  spectrum shows a sharp line there, some 20 dB above its surroundings. It
  has harmonics at 7.7 kHz and 15.4 kHz, twice and four times the
  fundamental. The third harmonic, near 11.5 kHz, is faint.
- **It never stops chopping.** The line is still there with the trigger
  fully in, so this drill tops out short of 100% duty. It has moved down
  to about 3.3 kHz, so the controller changes its frequency near full
  power, whether by design or as a side effect of how it controls current.
  The drill's two-position speed switch, which on these drills usually
  selects a gear ratio, changed nothing in the spectrum.
- **The impact driver shows 7.7 kHz and 15.4 kHz.** These are narrow lines
  that hold their frequency as the trigger moves, the signature of
  switching. There is no clean line at 3.85 kHz, only a broad hump from 2
  to 4 kHz that grows with speed, and is more likely mechanical. So either
  this tool switches at 7.7 kHz, or it switches at 3.85 kHz and its
  fundamental is lost in the hump. A three-phase brushless drive with
  centre-aligned PWM puts its strongest current ripple at twice the
  switching frequency, which would give the second result.
- **The speed can be heard too.** In the impact driver a tall, narrow line
  rises from about 320 Hz to 380 Hz as the trigger goes in, and the drill
  shows one near 320 Hz at full trigger. A line that moves with speed
  follows the motor's rotation, so the spectrum doubles as a tachometer.

A faint third harmonic has a likely cause. A train of pulses at duty cycle
$D$ has harmonics whose sizes go as $|\sin(n\pi D)|/n$. At $D$ near 1/3,
the third falls to nothing while the second and fourth stay strong. The
motor's mechanical response and the phone's microphone shape the levels
too, so this is a likely cause, not a proof.

**What it means for control.** A PM motor drive usually has two loops:

- **A fast current loop.** It measures the current with a shunt resistor,
  once per PWM period, and sets the duty cycle to hold the commanded
  current, which is the commanded torque.
- **A slower speed loop around it.** It commands the current.

A third, position loop can sit outside both. This is how industrial servo
drives are built, and an RP2350 can run all three.
