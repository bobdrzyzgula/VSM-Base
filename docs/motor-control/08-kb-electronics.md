# KB Electronics controllers

Of KB's catalog, the KBIC family is the one that fits a sewing-machine
universal motor: a full-wave SCR DC drive with IR compensation that is
explicitly rated for AC/DC motors. The others are either open-loop or rated
only for PM and shunt motors.

| Model | What it is | Motors | Speed feedback | Fit for the 99 |
|---|---|---|---|---|
| KBIC | Full-wave SCR DC drive; MIN, MAX, ACCEL, IR, CL trimpots; auto-inhibit; plug-in horsepower resistor | Shunt, PM and AC/DC (universal) | Armature voltage + IR compensation; 1% of base speed, 50:1 range | Best KB option |
| KBMM | Full-wave SCR DC drive with ACCEL and DECEL ramps | Shunt and PM only | Armature (1%) or tachometer (1%) | Not rated for universal motors |
| KBWC | Triac wall-box fan control; minimum-speed trimpot; RFI filter | Shaded pole, PSC, AC/DC | None (open-loop phase control) | No better than a stock pedal |
| KBSI-240D | Signal isolator: 0–25/120/550 V or 4–20 mA in, up to 10 V out | Accessory | Not applicable | Isolates a pedal or MCU from the drive |

**Using a KBIC on the 99.** The motor runs on rectified DC rather than AC,
which a universal motor accepts. Set up this way:

- **IR compensation is the trimpot that matters.** Turn it up until the machine
  holds speed when you sew across a folded seam at a crawl, then back it off
  where the motor starts to hunt or surge. Too much IR compensation is positive
  feedback and oscillates.
- **MIN** sets the speed the machine idles at with the pedal just pressed; set
  it to zero or just below the threshold of motion. **MAX** limits top speed,
  and **ACCEL** softens starts. On a sewing machine ACCEL should be near its
  fastest, or the machine feels sluggish to the foot.
- **CL** (current limit) protects the small motor and the operator's fingers
  when the needle jams. Set it low.
- **Top speed is worth checking.** The KBIC's 90 V DC output range on 115 V
  line may run a 120 V universal motor slightly slower than full AC line. A
  universal motor runs faster on DC than on AC at the same RMS voltage, so the
  difference may be small; measure before relying on it.

**Isolation.** KB DC drives are not isolated: their speed-pot terminals are not
isolated from the line, which is why KB sells the KBSI-240D to interface
non-isolated drives with external signals
([KBSI-240D](https://motorsandcontrol.com/kb-electronics-9431-kbsi-240d-signal-isolator-stand-alone)).
A pedal wired straight to a KBIC is therefore live. The KBIC also accepts an
isolated 0–9 V DC signal in voltage-following mode (KBIC D-210). Feeding that
input from an isolated pedal or MCU is the clean way to keep the pedal at a
safe voltage.
