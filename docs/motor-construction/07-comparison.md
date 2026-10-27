# The four motors side by side

| | Universal (series) | Wound-field DC (shunt) | Brushed PM DC | Brushless DC |
|---|---|---|---|---|
| Field made by | the load current | a separate field winding | magnets on the stator | magnets on the rotor |
| Commutation | commutator and brushes | commutator and brushes | commutator and brushes | transistors, from Hall sensors or an encoder |
| Runs on | AC or DC, straight off the line | DC (rectified mains) | DC only | DC, through its controller only |
| Torque | $K i^2$: high at a stall | $K_t i_a$ | $K_t i$ | $K_t i$ |
| Speed with load | falls steeply; races unloaded | nearly constant | nearly constant | nearly constant |
| Speed control | voltage: rheostat, triac, variac | armature voltage (SCR drive), field weakening | PWM chopper or H-bridge | PWM on a three-phase bridge |
| Speed feedback | needs a sensor; back-EMF only while current flows | armature voltage minus $IR$ | back-EMF read directly | Hall sensors or encoder, built in |
| Braking, holding | coasts; cannot hold | dynamic braking | dynamic braking; holds with current | dynamic braking; holds with current |
| Wear | brushes, commutator | brushes, commutator | brushes, commutator | bearings only |
| Electrical noise | brush sparking | brush sparking | brush sparking, PWM | PWM |
| Without electronics | works (with a pedal) | works on DC | works on DC (no speed control) | does not run |

Read across, the table says why the universal motor won the sewing machine
and why it is no longer the obvious choice.

- **Why it won.** It is the only one that runs straight off the wall with
  nothing but a pedal. It gives plenty of torque from a standstill. It was
  cheap to make in 1920 and still is.
- **What it costs.** Speed that depends on load, no braking, no holding, and
  brushes. Its low-speed weakness is the subject of the speed-control paper.
- **What changed.** Strong magnets, cheap power transistors and
  microcontrollers moved the hard part of the motor into electronics. The
  brushless servo motor that replaced the clutch motor on industrial
  machines is that change carried through. The question for the VSM Base is
  whether the same change fits in a domestic machine's motor bracket.
