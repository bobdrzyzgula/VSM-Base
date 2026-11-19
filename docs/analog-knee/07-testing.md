# Testing it, and the open questions

## Testing order

1. **The low-voltage side alone, on the bench.** Power it from a 5 V bench
   supply, with a signal generator's 60 Hz square wave standing in for Z.
   Watch the ramp, D and the comparator output on the scope; press the
   FSR and see the comparator's edge move along the ramp. No mains
   involved.
2. **The sensors.** Measure each FSR's resistance against force (the
   pedal paper's §6 describes a kitchen-scale method), and rerun
   `tools/make_analog_knee_figures.py` with the fitted curve. Pick RM.
3. **The whole controller, with a lamp.** On the isolation transformer,
   with a 60–100 W incandescent bulb as the load: check the zero-cross
   window's width, the firing against force, and that the LED drive ends
   before each zero crossing.
4. **With a motor** on the rig: check that the held gate drive fires the
   triac reliably at every angle, and how the start feels.
5. **The knee mechanics**: a printed test lever with a 402, trying a
   linear spring, a nested pair and an elastomer pad, before committing a
   design to the base.

## Open questions

- **The feel.** Whether a progressive stack can match the Singer knee's
  position feel, and whether a near-isometric knee is better or worse.
  This is the main open question, and it is mechanical, not electrical.
- **The real FSR curve.** As in the pedal paper, the model's power law is
  a fit to two numbers.
- **The comparator's drive.** Confirm from the MCP6562's data sheet that
  its output-low voltage at 11 mA leaves the MOC3023's LED enough current;
  if not, a 2N7002 can sink the LED instead.
- **Shared board.** Whether to build this and the MCU controller's
  low-voltage side as alternatives on one board, sharing the mains side.
