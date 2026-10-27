# Induction motors: AC with nothing to wear

The motors so far all have something that switches the current to keep the
torque going one way: a commutator and brushes, or transistors. The
induction motor has neither. It is the motor of fans, pumps, compressors,
table saws and almost every factory floor, and on the sewing floor it was
the clutch motor that the brushless servo replaced (§6).

## Construction

- **The stator.** Laminated iron with slots, carrying a three-phase winding.
  It is the same kind of stator as a brushless motor's (§6).
- **The rotor.** A *squirrel cage*: a laminated core with bars of aluminium
  or copper running through its slots, joined at each end by a ring that
  shorts them all together. Taken out of the iron, the bars and rings look
  like a hamster's exercise wheel, hence the name.

The rotor has no magnets, no brushes, no commutator and no electrical
connection of any kind. Its only wearing parts are its two bearings.

## The rotating field

Three windings set 120° apart around the stator, carrying three currents
120° apart in time, make a field of constant strength that turns. Nothing
moves to make it rotate. The rotation comes from the supply itself, as each
phase's current peaks in turn. The field turns at the **synchronous speed**

$$n_s = \frac{120 f}{p} \ \text{rpm},$$

with $f$ the supply frequency and $p$ the number of poles. On 60 Hz a
two-pole motor's field turns at 3,600 rpm, a four-pole motor's at 1,800,
and a six-pole motor's at 1,200.

This is what a brushless controller does with its six transistors (§6): it
makes a rotating field. The difference is that the brushless controller
times the field to the rotor's position, which it reads from Hall sensors.
The induction motor's field just turns at line frequency, and the rotor
follows as best it can.

## Slip and torque

If the rotor turned at the synchronous speed, the field would stand still
relative to the bars, nothing would be induced in them, and there would be
no torque. So the rotor always runs a little slower than the field. The
difference is the **slip**:

$$s = \frac{n_s - n}{n_s}.$$

The field sweeps past the bars at the slip speed. That induces currents in
them, the shorting rings let those currents flow, and the currents in the
field make torque. A larger load slows the rotor a little more, which
raises the slip, the induced current and the torque, until the torque
matches the load. At full load the slip is typically 2–5%, which is why a
four-pole motor's nameplate says about 1,725 rpm, not 1,800.

![A representative four-pole induction motor (computed with the Kloss
approximation: breakdown torque 2.8 times full load, at 20% slip). On the
60 Hz line (black) it starts with about full-load torque, rises to its
breakdown torque, and settles on the steep upper part of the curve, where
speed barely changes with load. On a VFD (gray), the same curve slides down
with the synchronous speed.](../images/motors/induction-speed-torque.svg){width=100%}

The curve has three landmarks:

- **Starting (locked-rotor) torque.** With the rotor standing still, the
  slip is 100%. The rotor currents are large but lag badly, so the torque
  is only moderate. The current drawn is large too, typically five to seven
  times full-load current. That is why big induction motors dim the lights
  when they start.
- **Breakdown torque.** The most the motor can give, typically two to three
  times full load. Load it beyond this and the motor slides down the curve
  and stalls.
- **The running region.** Between full load and no load, the curve is
  nearly flat. The speed falls only by the slip, a few percent, so the
  motor behaves much like a shunt or PM motor (§4, §5). It runs at nearly
  the same speed whatever the load.

## Single-phase motors

A single winding on single-phase AC makes a field that pulses back and
forth but does not rotate. Such a motor, once turning, keeps turning in
either direction, but it has no starting torque at all. The cure is a
second, *auxiliary* winding, set 90° around the stator from the main one,
with its current shifted in time:

- **Split-phase.** The auxiliary winding is wound with finer wire, so its
  current leads the main winding's a little.
- **Capacitor-start.** A capacitor in series with the auxiliary winding
  shifts its current much further, for a strong start. A centrifugal switch
  cuts the auxiliary winding out once the motor is near speed, which is the
  click heard as a table saw or a bench grinder spins down.
- **Permanent split capacitor (PSC).** A smaller capacitor stays in
  circuit all the time. It starts weakly but runs quietly, as in fans.

## The clutch motor

The induction motor's fixed speed is its strength in a factory and its
weakness at a sewing machine. The industrial clutch motor works around it
mechanically:

- **The motor runs all the time,** at its fixed speed, commonly about
  1,725 or 3,450 rpm, driving a heavy flywheel. Clutch motors are made
  both single-phase and three-phase.
- **The treadle works a clutch.** Pressing it pushes a cork-faced clutch
  plate against the flywheel, and the plate drives the belt to the machine.
  Letting it up pulls the plate back against a brake.
- **Speed control is slip in the clutch.** A skilled operator feathers it.
  A beginner gets a machine that lunges to full speed, and a slow, steady
  crawl is hard for anyone.

The motor hums and draws power all day, sewing or not. The brushless servo
that replaced it (§6) is quiet, off between seams, holds a set speed, and
can stop with the needle up or down. The clutch motor's speed control was
in the operator's foot and in the cork, never in the motor.

## Speed control: the variable-frequency drive

Since the speed follows the supply's frequency, the way to change the speed
is to change the frequency. That is what a **variable-frequency drive**
(VFD) does:

1. **A rectifier** turns the mains into DC.
2. **A DC bus,** a bank of capacitors, smooths it.
3. **A three-phase inverter,** six transistors on PWM (2–16 kHz), turns the
   DC back into three-phase AC at whatever frequency is wanted.

The inverter is the same three-phase bridge that drives a brushless motor
(§6). The difference is in what times it. A brushless controller follows
the rotor's position. A plain VFD just generates the frequency it is told
to.

- **Volts per hertz.** A winding's reactance falls with frequency, so at a
  lower frequency the VFD must also lower the voltage, in proportion,
  to keep the same flux. It holds $V/f$ constant, which keeps the curve's
  shape (the gray curves in the figure). Near zero frequency the winding's
  resistance takes over, and the drive adds a little voltage boost to keep
  the torque up.
- **On the wire.** The voltage at the motor is PWM pulses at the switching
  frequency. The windings' inductance smooths them, as in a PM motor on
  PWM (§5), so the current is nearly a sine wave at the output frequency.
- **Vector control.** A drive that models the rotor's currents, often with
  an encoder, can control torque directly, much as field-oriented control
  does for a brushless motor (§6). Such a drive can hold full torque at a
  standstill. Without it, an induction motor cannot hold a load still.

**Why it is not the answer for the VSM Base.** An induction motor of a
sewing motor's power would be larger and heavier than the brushless motors
of §9 for the same output, and needs its VFD for any speed control. A
three-phase motor needs a three-phase drive. The drives sold for
single-phase motors are few, and a capacitor-start motor, with its
centrifugal switch, does not work on one at all. The brushless motor does
the same job, is smaller, and its controller already knows where the rotor
is.
