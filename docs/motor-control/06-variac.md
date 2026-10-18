# Variac (variable autotransformer)

A variac is the clean reference case: a true, nearly lossless, sinusoidal
voltage source you can set anywhere from zero to slightly above line. A brush
slides over the exposed turns of a single winding to tap a continuously
variable fraction of it
([Wikipedia: Autotransformer](https://en.wikipedia.org/wiki/Autotransformer)).
Variac was General Radio's trademark from 1934 to 2002 and is now used
generically.

For a universal motor it delivers exactly the model in the physics section
with $V$ reduced: speed–torque slope and stall torque both fall with $V$, but
there is no added series resistance and no chopping. That makes it the best of
the open-loop methods for smoothness and regulation:

- **Smooth torque.** The current is sinusoidal (apart from commutation), so
  torque arrives at 120 Hz with no dead time. Low-speed running is much
  smoother than phase control at the same average speed.
- **Better regulation than a pile.** Compared at the same no-load speed, the
  variac has a lower source voltage and no $R_s$, so a torque pulse costs less
  speed. It still has no feedback, so a seam still slows it.
- **Good test instrument.** Because the waveform is clean, motor current and
  speed versus voltage measured on a variac reflect the motor itself, not a
  controller. This makes it the right tool for running in a rebuilt motor,
  checking brush seating, or measuring the $K$ and $R$ of the model above.

As a foot control it fails on practical grounds: it is heavy, its brush is not
built for constant motion under the foot, and it is not isolating (one side of
the output is tied to the line). A motor-driven variac would work but responds
too slowly for sewing.
