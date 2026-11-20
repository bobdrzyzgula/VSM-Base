# PDF snapshots

Copies of the documents as PDF, for reading and for sending as a link.

**They may not be the latest version.** They are committed here by hand from
time to time, not built automatically, so the sources in `docs/` (and
`standalone/motor-rig/`) may have moved on since. The date of each file's
last commit is the date of its snapshot.

| File | Document |
|---|---|
| [vsm-base-guide.pdf](vsm-base-guide.pdf) | The User's Guide |
| [vsm-motor-control.pdf](vsm-motor-control.pdf) | Motor speed control |
| [vsm-inside-the-motor.pdf](vsm-inside-the-motor.pdf) | Inside the Motor |
| [vsm-inside-a-switching-circuit.pdf](vsm-inside-a-switching-circuit.pdf) | Inside a Switching Circuit |
| [vsm-force-sensing-pedal.pdf](vsm-force-sensing-pedal.pdf) | A Force-Sensing Pedal (design study) |
| [vsm-analog-knee-controller.pdf](vsm-analog-knee-controller.pdf) | An Analog Force-Sensing Knee Controller (design study) |
| [vsm-motor-rig.pdf](vsm-motor-rig.pdf) | The motor test rig's guide |

## The latest version

- **Released versions:** each release on the repository's Releases page
  carries the documents as PDF and HTML, built from that release's source.
- **The current source:** build them yourself with `make pdf` at the top of
  the repository (see the main [README](../README.md) for what it needs).
  They land in `build/`.

## Updating the snapshots

    make pdf
    make snapshot          # copies build/*.pdf here
    git add pdfs/*.pdf
    git commit -m "Update the PDF snapshots"

Nothing else in the build reads or writes this folder.
