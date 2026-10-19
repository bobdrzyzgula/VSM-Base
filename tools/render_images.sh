#!/bin/sh
# Render the model views used in the documentation.
# Usage: tools/render_images.sh   (run from the repository root)
# Needs OpenSCAD 2021.01 or later with BOSL2 installed; on a headless
# machine, run it under xvfb-run.
set -e
MODEL=scad/vsm_base.scad
OUT=docs/images/renders
mkdir -p "$OUT"

# render: fully computed geometry (one colour per face type, exact)
# preview: fast preview that keeps the model's part colours
render() {   # name, camera, extra -D options...
    name=$1; cam=$2; shift 2
    openscad --render -o "$OUT/$name.png" --imgsize=1600,1000 \
        --camera="$cam" --colorscheme=Tomorrow "$@" "$MODEL"
}
preview() {
    name=$1; cam=$2; shift 2
    openscad -o "$OUT/$name.png" --imgsize=1600,1000 \
        --camera="$cam" --colorscheme=Tomorrow "$@" "$MODEL"
}

# Base with all three extensions and their lids
preview assembly        "150,140,40,50,0,320,1050" -D 'part="assembly"'
# Every part pulled apart, base split
preview exploded        "170,160,40,50,0,330,1250" -D 'part="exploded"'
# The base alone, from above the front
render base-top        "211,108,41,55,0,25,900"   -D 'part="base"' -D 'split=false'
# The base alone, no side compartment
render base-none       "165,108,41,55,0,25,760"   -D 'part="base"' -D 'split=false' \
                                                  -D 'compartment_option="none"'
# The base from below and outside the left end: handhold and rod notches
render end-underside   "-170,-60,-90,15,110,20"    -D 'part="base"' -D 'split=false'
# The two halves of the split base
render split           "211,108,41,60,0,20,800"   -D 'part="base"'
# Knee controller: cutaway of the right bay with the mechanism in place
preview knee            "360,85,30,50,0,25,440"    -D 'part="knee_assembly"' -D 'compartment_option="knee"'
