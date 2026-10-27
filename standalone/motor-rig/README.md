# Motor test rig

A plywood board of printed modules for studying sewing-machine motors and
their speed controllers on the bench: resistance, inductance, speed, and
torque with a Prony brake, plus the KB3151C triac board from the knee
controller. It needs nothing from the main VSM Base model.

![The rig](rig_iso.png)

**The full guide is [RIG_GUIDE.md](RIG_GUIDE.md)**: what to buy, what to
print, how to build and wire it, the safety rules for working at mains
voltage, and the test procedures. `make pdf` at the top of the repository
builds it as `build/vsm-motor-rig.pdf`, and each release attaches that PDF.

| File | What it is |
|---|---|
| `motor_rig.scad` | The rig: board layout, drilling template and every rig part |
| `motor_cradle.scad` | The motor cradle |
| `prony_brake.scad` | The Prony brake's jaws |
| `rig_template.svg` | The board's drilling template, 1:1 |

Part of the [VSM Base](../../README.md) project. Written by Claude
(Anthropic) at Robert Drzyzgula's direction. MIT license; see the
[LICENSE](../../LICENSE) in the main project.
