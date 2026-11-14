# Notes for Claude

## Standalone models kept in two repositories

Two of the standalone models are also copied into the Sewing Notions
repository (github.com/bobdrzyzgula/Sewing-Notions):

| Here | In Sewing Notions |
|---|---|
| `standalone/bobbin-box/bobbin_box.scad` | `bobbin-box/bobbin_box.scad` |
| `standalone/tilt-prop/tilt_prop.scad` | `tilt-prop/tilt_prop.scad` |

Copied November 8, 2026. When you change either copy of a model, or its
README, ask Bob whether he wants the same change made in the other
repository. Don't change the other copy without asking.

The bobbin trays and tilt prop built into the main model
(`scad/`) are separate code; this note covers only the standalone files.

### Keeping them in sync

The two copies of each .scad file should be identical except for the
header comment that names the other repository (about three lines near
the top). Run `diff` on the two copies before and after any change and
confirm that only those header lines differ.

Sewing Notions also carries rendered STLs (`bobbin-box/stl/`,
`tilt-prop/stl/`) and README images. When a model changes, re-render them
from the new .scad at the default settings, and check that a fresh
render's triangle count and bounding box match the committed STL.

Last checked on November 13, 2026: both models matched, and the bobbin
box's box and lid STLs matched fresh renders.
