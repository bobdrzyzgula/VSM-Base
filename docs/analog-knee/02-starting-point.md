# The starting point

## What the base provides

The pedal paper's constraints came from the cordset: two wires, no earth,
unknown polarity (polarized cordset plugs are wired to the pedal at random,
so even those give no help), and everything live. In the VSM Base:

- **An earthed IEC inlet** brings line, neutral and earth into the base, as
  in the MCU controller (its README in `hardware/mcu-controller/`).
- **An isolated 5 V supply**, the Mean Well IRM-05-5, is certified for
  reinforced isolation between its mains input and its output. The
  module's certification covers the module; the design means the
  circuits on its output side to be safety extra-low voltage (SELV), but
  whether a built controller achieves that depends on its layout, wiring,
  enclosure and testing, none of which exists yet.
- **Two optocouplers** carry the only signals across the barrier: the
  H11AA1, which tells the low-voltage side when the line crosses zero,
  and the MOC3023, which lets the low-voltage side fire the triac. Each is
  rated for several kilovolts of isolation.

So the design aims for the knee, its sensor, its cable and all the control
circuitry to be SELV, wired like any low-voltage gadget. Only the triac,
its driver's output, the zero-cross detector's input, the supply's input
and the protection parts would be live, in one place, on one side of one
barrier. That is the intent of the drawing, not a property of anything
built: a barrier drawn on a schematic is not proof of isolation (see §7).

## The principle: ramp and compare

The KB3151C, and the pedal paper's circuit, fire the triac when a
capacitor charging from the line reaches the diac's breakover. That ties
the timing to the line's voltage, to the diac's tolerance and to the
capacitor's leftover charge from the last half-cycle, the source of the
snap-on (switching paper, §4).

Industrial phase controllers do it differently, and the classic phase-
control ICs, Siemens' TCA785 among them, were built around the
difference. They generate a **timing ramp** that restarts at every zero
crossing, and **compare** it against a control voltage. The triac fires
when the ramp crosses the control voltage. The firing angle is then
proportional to the control voltage and nothing else: not the line
voltage, not the last half-cycle.

The MCU controller does the same thing in firmware: its zero-cross
interrupt starts a timer, and the timer's alarm fires the triac. This
design does it with a capacitor and a comparator.
