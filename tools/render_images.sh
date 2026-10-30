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
render attached-bay       "260,110,40,55,0,25,820"   -D 'part="exploded"' -D 'compartment_mount="attached"' -D back_ext=false -D left_ext=false -D corner_ext=false -D split=false
# Printed hinge, cut through the middle: at rest and at its stop
preview printed-hinge   "330,27,10,0,27,10"        -D 'part="printed_hinge_view"' -D 'hinge_type="printed"' -D 'machine="Kenmore 158-14001"' --projection=o
# A printed hinge taken apart over its recess (exploded view, 99K)
preview printed-hinge-exploded "290,195,110,55,0,335,400" -D 'part="exploded"' -D 'hinge_type="printed"' -D back_ext=false -D left_ext=false -D corner_ext=false -D split=false -D explode=40
# Larger extensions, one lid each: bins with finger-notched dividers (lids off)
preview ext-bins        "20,215,30,50,0,20,1250"  -D 'part="extensions_view"' -D explode=400 -D left_ext_double=true -D back_ext_double=true -D 'left_ext_layout="1+2"'
# Larger extensions, a lid per bay, lids lifted
preview ext-per-bay     "20,215,60,50,0,20,1400"  -D 'part="extensions_view"' -D explode=60 -D left_ext_double=true -D back_ext_double=true -D 'back_lids="per bay"' -D 'left_lids="per bay"' -D 'corner_lids="per bay"'
# The front face with a ruler (inch below cm) and a logo in each upper corner
preview ruler           "216,0,41,90,0,0,760"      -D 'part="base"' -D split=false -D ruler=true -D 'logo_left="../docs/images/logo-example.svg"' -D 'logo_right="../docs/images/logo-example.svg"' --projection=o
