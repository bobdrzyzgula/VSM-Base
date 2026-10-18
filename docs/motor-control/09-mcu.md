# MCU control: what a from-scratch design looks like

An MCU phase controller with a speed sensor can match a KBIC's regulation
while keeping AC drive, an isolated pedal and room for features. The
architecture is the one in Freescale's AN1662, with isolation added
([Skalka, AN1662](https://nxp.com/docs/en/application-note/AN1662.pdf)).

**Power stage (line side).**

- A triac (BT136/BTA class) in series with the motor, with an RC snubber
  across it unless it is a snubberless type.
- A random-phase opto-triac driver (MOC302x family) to fire it. A
  zero-crossing driver (MOC304x) only fires near the zero and cannot do phase
  control.
- An opto-isolated zero-cross detector (for example an AC-input optocoupler)
  so the MCU knows where each half-cycle starts.
- Fuse, MOV and a line relay, driven through its own isolated coil.

**Control side (isolated, low voltage).** Everything the user touches lives
here: pedal, panel switches, speed-limit knob. That removes the live-pedal
problem entirely.

**Speed sensing,** in order of preference:

1. **Handwheel or motor-pulley sensor.** A Hall sensor and one or more magnets,
   or an optical slot. One pulse per handwheel turn is one per stitch, enough
   for regulation at sewing speeds, and it also gives needle position.
2. **Back-EMF sampling.** With phase control there is a dead interval each
   half-cycle once the current stops. Sampling motor voltage there gives a
   residual-field back-EMF, as in the analog half-wave designs. It needs no
   sensor but is noisy and needs calibration per motor.

**Loop.** One firing decision per half-cycle means 120 updates per second on
60 Hz. A PI loop at that rate gives a closed-loop bandwidth of roughly
10–20 Hz, comfortably faster than a sewer's foot. A rate limit on the firing
angle stops a jammed needle from receiving a sudden full-power pulse, and a
stall watchdog (no pulses for some time) cuts the triac, as AN1662 does.

**Emulating the carbon pile's feel.** The pile's virtues (force control,
logarithmic response, fine low end) can be reproduced on purpose. Put a force
sensor (a small load cell or FSR) under a stiff pedal, take its logarithm, and
use that as the speed command. A position pedal (Hall or pot) with an
exponential mapping is the cheaper version. Unlike the pile, the command is
now speed, so the machine holds it through a seam without the operator
compensating.

**Features the sensor makes cheap:** needle-up/needle-down stop, a slow-start
ramp, a hard speed limit for beginners or free-motion work, and a single-stitch
button. Several 1970s–80s electronic domestic machines offered similar
functions with analog circuits.
