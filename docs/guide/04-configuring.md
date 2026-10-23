# Configuring the model

*This chapter is an outline, still to be written. It will cover:*

- Opening the model and using OpenSCAD's Customizer.
- The settings that decide the fit (machine bed, reliefs, hinges) and the ones that are a matter of taste (compartment, extensions, rounding).
- The `part` setting and the views it gives: assembly, all, test parts, individual parts.
- Reading the console: what each line means, and every WARNING with what to do about it.
- Choosing a side compartment, extensions, trenches and lid hinges.
- Organizer inserts: bobbin trays (corner bay), notion trays and the spool tray (back or left bay, chosen with `ot_bay`), the stack-height budget the console reports, and the `*_assembly` views.

> **Note: starting a Custom machine from a profile.** The Customizer's
> preset menu, at the top of its panel, has a preset for each machine
> profile, named for it with "(as Custom)" (`Singer 99K (as Custom)`, say).
> It sets `machine = "Custom"` and fills every Custom machine setting with
> that profile's values, so you can change what differs on your casting
> and save the result as a preset of your own. The presets live in
> `scad/vsm_base.json`, which OpenSCAD reads alongside the model; presets
> you save go into the same file, and are kept when it is rebuilt. If `git
> pull` stops because that file has changes of yours, run `git stash`, `git
> pull`, `git stash pop`. To override just the printed hinge's pin, you
> don't need Custom: set `ph_pin_d` and `ph_pin_engage`.
>
> **Note: the barrel hinge.** `hinge_type = "barrel"` takes the hinges
> from a vintage portable case: a steel barrel, 15.2 mm across and 17.5 mm
> tall, standing in a round hole, with an arm that pivots in the barrel's
> slotted top on a cross pin and a 6.85 mm pin that goes into the bed's
> hole. A slotted screw with a washer comes up from under the base into
> the barrel's tapped bottom; its head sits in a counterbore. The barrel is
> set so the pin meets the bed's hole: on the 99K its top stands 1.7 mm
> above the rim (in its case it was flush with the wood, the bed sunk a
> little lower), the back extension's lip is notched round it, and the
> arm's swing is cut away in front of it. These hinges tip the machine
> back only about 65°. Their dimensions (`barrel_*`, measured by Bob
> Drzyzgula from a 99K's case) may differ a little from hinge to hinge;
> print the hinge coupon and try one first. The hinge needs only about
> 25 mm of back rim, against the lollipop's 42.
>
> **Note: a base without hinges.** `hinge_type = "none"` makes a base for
> a machine to sit in, for a machine without hinges or for anyone who
> doesn't want them: no hinge recesses or nut traps, no hinge checks or
> hardware in the console, and no hinge test parts; the back-wall tunnels run
> the whole back wall, and the hinge-hole measurements are ignored. The back
> rim starts at `back_rim_thin` (12 mm) instead of the hinge's 42 mm before
> the base is rounded up to its depth class (below), so the 99K's comes out
> at 200 mm rather than 230; its back rim, and so its back extension's lip,
> differ from a hinged base's. Nothing holds the machine in its seat, so carry
> the machine and base separately, or strap them together; to reach the
> cavity (an attached bay's screws, say), lift the machine out. Decide at
> print time: hinge recesses can't be added well to a printed base later.
>
> **Note: the printed hinge.** `hinge_type = "printed"` is a hinge to print,
> for a machine whose hinges are missing or broken, or which came in a
> molded base whose hinges went with it (most portable Kenmores, for one).
> Each hinge is a printed **arm**, a printed **block** and two pieces of
> cut steel rod. The machine's hinge holes run straight into the back of
> the bed, so the machine can't tip back on pins fixed in them; like the
> lollipop hinge, which has a knuckle inside its round body, the printed
> hinge's arm turns. A steel **pin**, pressed into the arm's front face,
> goes into the bed's hole; the arm turns on a steel **pivot rod** that runs
> across the back, pressed into the block's two cheeks; and the block sits
> in a square recess in the back rim. It is held by one screw driven up
> from under the base, its pan or socket head in a round counterbore
> (`ph_head_d`), into a nut slid into a slot in the block's front face, below
> the arm, with plastic under it for the nut to bear on. The pivot is set
> at the bed hole's height from your measurements, so the pin always lines
> up. The arm and cheeks are cut down flush with the rim wherever that
> leaves `ph_min_cover` (2.5 mm) of plastic over the rods: on the
> Kenmore 158-14001, whose holes are 6.75 mm down, the whole hinge is flush; on
> the 99K, whose holes are only 4 mm down, the arm stands 2.1 mm proud, and
> the back extension's lip is notched around it. The block and the base's
> recess are larger than the lollipop's, so the back rim needs about 8 mm
> more; the 99K still fits the 230 mm class.
>
> ![The printed hinge, cut through the middle: at rest, with the pin in
> the bed's hole (left), and tilted back to its stop
> (right).](../images/renders/printed-hinge.png){width=100%}
>
> ![A printed hinge taken apart over its recess in the back rim (part
> `exploded`): the block, the arm above it, the pin drawn out of the arm's
> front, and the pivot rod drawn out to the
> side.](../images/renders/printed-hinge-exploded.png){width=70%}
>
> The arm runs on past the pivot into a short tail (`ph_tail`, 12 mm). When
> the machine is tipped back, the tail swings down into a pocket in the
> block and comes to rest on its floor, so the machine stops at about
> `ph_stop_angle` (100°), where a Singer lollipop hinge's knuckle stops a
> 99K; nothing of the stop stands above the arm. That is far enough to
> service the machine's underside at about 90°. On the way there the
> machine passes its balance point (about 55° on a 99K), where it takes the
> least effort to hold, and past about 75° the machine's weight behind the
> base outweighs the base, so the base starts to tip up unless you hold the
> machine or brace its arm (on a 99K at 90°, about 6" above the table
> behind). The tilt prop (part `tilt_prop`, one of the tools) does the
> bracing: a stand on the table behind the base whose cradle, lined with
> felt, catches the arm at 90°, so you can work with both hands while the
> machine's weight goes into the table instead of tipping the base. Its
> height and the cradle's radius come from the machine profile (6" and 1"
> for the 99K; `custom_tilt_prop_mm`, or `tilt_prop_h` and `tilt_prop_r`,
> for others): tip the machine back to 90° on a level gauge and measure
> from the table to the underside of the arm. For a machine whose arm
> isn't round, a cradle radius of 0 in the profile, or `tilt_prop_top =
> "flat"`, gives a flat, level top instead. A standalone version, with no
> machine settings but a sloping top and a foot sized for stability, is in
> `standalone/tilt-prop/`. Because the base tips first, the stop never has to hold more
> than a few newton-metres, well within the pins and the plastic; don't
> drop the machine onto it all the same. Set `ph_stop_angle` between 45°
> and 110°, or 0 for no stop. Check that nothing on your machine reaches
> the base's back rim before the stop. Print the hinges in PETG or another
> tough
> filament; their rods are cut-to-length steel rod or dowel pins. The pin's
> diameter and how far it goes into the hole come from the machine profile
> (1/4" and 12 mm for the 99K, 6 mm and 16 mm for the Kenmore 158-14001), unless
> you set `ph_pin_d` and `ph_pin_engage`; the pivot is `ph_pivot_d` (1/4").
> Hardened dowel pins make good rods and save cutting: set `ph_pin_len` to
> a stock pin's length, and the pin goes into the bed's hole by whatever
> is left past the arm; the console gives the range of lengths that fit,
> from 8 mm into the hole up to just short of its depth
> (`hinge_hole_depth_mm` in the profile: 22 mm on both the 99K and the
> Kenmore, so their pins may be 30.5–43 mm long; a 6 × 40 mm pin goes
> 17.5 mm in, a 9/32" × 1 1/2" pin about 15 mm). Set
> `ph_pivot_len` to a stock pivot's length (1 1/8", 28.575 mm, say) and the
> block's cheeks widen or narrow to suit. Precision dowel pins are made a
> few hundredths of a millimetre over size (an m6 6 mm pin is 6.004–6.012
> mm), so try one in the bed's hole before buying a set.
> The console's *Printed hinge* lines give the sizes, the rod lengths, and
> where the parts stand against the rim. The printed hinge is new in v34
> (its tail stop in v35) and hasn't been printed yet.
>
> **Note: a bed set flush, or standing on its feet.** Some machines sit
> with the bed's top level with the base's rim: the Kenmores of the 1960s,
> whose bobbin covers lift on hinges rather than sliding out over the
> edge, sat that way in their molded bases. A profile with `bed_flush` sets
> the seat as deep as the plate (plus its cushions). Some of those machines
> also stand on cast feet under the casting, and their bases carried them
> on the feet; a profile with `foot_height_mm` sets the floor from the
> feet (the plate's underside to the feet's bottoms, plus `bed_cushion_in`
> for pads under them), and the ledge round the cavity then sits 1 mm
> under the plate and only locates the bed. `inner_depth` isn't used then.
> For a Custom machine these are `custom_bed_flush` and
> `custom_foot_height_mm`.
>
> **Note: recessed lips and trim strips.** The extensions hold on with
> lips that lie on the base's rim, and a lip is only as thick as the bed
> stands above the rim: 5.3 mm on the 99K, nothing at all on a flush bed.
> Where the bed stands less than `lip_min_t` (5.4 mm) above the rim, the
> rim is cut down under each lip so the lip keeps that thickness and its
> top stays level with the bed: the left rim, and the back rim along the
> back lip's length, with a full-height island left round each hinge, which
> the lip goes round. With the extensions off, trim strips (parts
> `back_trim` and `left_trim`) drop into the cuts and fill them back to the
> rim, held by the same peg inserts in the same holes; they print flat,
> without supports. The cuts are made only for the extensions you have
> turned on, and none at all with `ext_peg_holes = false`, for a base
> that will never have extensions. On the 99K nothing changes.
>
> **Note: a cord slot.** Where a machine's cords leave the casting at the
> back (the Kenmore 158-14001's foot-control connector, 50 mm from the right
> end), the profile's `cord_slot` cuts a slot through the back rim from the
> top down to the cords' height. Unplug the connector, lay the cords into
> the slot, and plug it back in; then press part `cord_slot_trim` into the
> top of the slot, which leaves a channel for the cords underneath. When
> the machine tips back, the connector swings forward inside the base and
> draws the cords in through the channel, so leave a little slack inside.
> The console warns if the slot falls behind the back extension.
>
> **Note: an attached bay.** A bed much over 12" is too long to print as
> two halves with the side compartment built in. With
> `compartment_mount = "attached"` the compartment becomes its own part,
> `right_bay`, screwed to the base's right end. Four M5 socket-head screws go
> through the base's end wall from inside the machine cavity (tip the machine
> back on its hinges to reach them) into heat-set inserts in the bay's inner
> wall, and two 3/16" dowels locate it, so its top sits flush with the base's.
> The bay has its own handhold and harness rods at its outer end, so the
> machine carries with the bay on; the base keeps its own right handhold,
> rods and right-rim peg holes for when it is off. The bay's lid defaults to
> none (`attached_lid_type`), since cords from the machine may lie over its
> edge; hinged and lift-out lids are offered too. For now the attached bay is
> storage only; the outlet and the knee controller are to follow. Print
> `attach_test` first to try the inserts, dowels and screws. The console's
> *Attached bay* lines give the sizes and the joint's positions, and warn if a
> screw would run into a casting relief.
>
> ![An attached bay, pulled clear of the base (part `exploded`, with
> `compartment_mount = "attached"`).](../images/renders/attached-bay.png){width=80%}
>
> **Note: an outlet base used for storage first.** Set
> `compartment_option = "outlet"` and `passthrough_knockouts = true`: the
> base gets the outlet's curbs and screw hole, but the cord pass-through is
> closed at both ends by thin walls, so the compartment works for storage.
> Cover the outside screw hole with the printed cap. For a storage lid,
> switch `compartment_option` to `storage` just to print the lid; it is the
> same size. When you fit the outlet, tap the two walls out with a punch and
> a small hammer, and print the outlet lid. To close the pass-through again
> later, print `passthrough_cover`.

> **Note: a short back extension.** If `back_ext_length` is too short to
> reach the last back peg hole, the back lip runs on past the body over the
> base's back rim to reach it (`back_lip_extend`), with a rounded end and a
> fillet into the body; the console says how far. That extension then fits
> only a base with the same `back_peg_xs`. If you move the base's peg holes
> left with `back_peg_xs` instead, the lip needn't run on, but the
> extension, again, fits only bases with those holes.

> **Note: standard sizes.** So that bases share extensions, and every
> extension takes the same inserts, sizes come in standards.
>
> - **Depth classes.** The base's front-to-back size is 200, 230 or 250 mm
>   (`base_depth`; Auto takes the smallest that fits), the spare going into
>   the back rim. The 99K comes out at 200 with no hinges and 230 with
>   lollipop or printed hinges; the Kenmore 158-14001 at 230 with no hinges
>   and 250 with hinges. A class too small for the machine stops the render;
>   `back_rim_width` overrides the class, with a note.
> - **Height.** Every extension's top stands at `ext_height` (88.225 mm, the
>   99K's bed top), with the same 81.2 mm bays. A bed lower than that raises
>   the base by thickening its floor (the Kenmore's by 3.9 mm, which makes
>   its plate screws 5/8"); a bed higher than that stands each extension on
>   a podium (parts `back_podium`, `left_podium`, `corner_podium`), a frame
>   at least `podium_min` (5 mm) thick, pinned to the extension by four
>   3/16" × 3/8" dowel pins. `ext_standard = false` lets the extensions
>   follow the bed instead.
> - **Length and pegs.** The back extension is 240 mm long
>   (`back_ext_length`; other lengths get a note), and its pegs sit at 16
>   and 160 mm from the base's left face (`back_peg_xs`), clear of the
>   hinges and the split on both machines.
>
> Bases of the same machine and class share extensions. Machines whose
> beds are set flush, like the Kenmore, won't share extensions with
> machines whose beds stand on the rim, like the 99K, since the lips sit
> differently; nor will a hingeless thin-backed base share a back extension
> with a hinged one, and other differences (a printed hinge's notch in the
> back lip, say) can break the match too.

> **Note: larger extensions and their bins.** The left extension's width
> (`left_ext_width`) and the back extension's depth (`back_ext_depth`) are
> 100 mm at least; 100 mm more on the left makes a table about the size of
> a Sew Steady Junior. Each piece keeps the bay a 100 mm piece gives,
> against the base, so the inserts always fit it: the bobbin bin in the
> corner, the notion and spool trays' bays in the left and back
> extensions. Whatever a piece has past that becomes open bins, each
> behind a divider (`ext_divider`, 2.5 mm) whose top is level with the
> lid's ledge, so it helps hold up the one lid; a finger notch in the
> middle of each divider (`ext_divider_notch`, 30 mm wide and 20 mm deep)
> lets you reach into a narrow bin, and keeps papers in it from flopping
> over. In the corner, the bins go left of the bobbin bin and behind it;
> with both larger, `corner_layout` decides the rest: `2x2` gives the far
> corner a bin of its own, `long left` runs the left bin the full depth,
> and `long back` runs the back bin the full width. The left and back
> extensions get one outer bin along their length (`1+1`), or two (`1+2`,
> `left_ext_layout`, `back_ext_layout`); their inner bay stays whole. A
> strip under `ext_bin_min` (10 mm) inside is left solid.
>
> **Two equal bins.** `left_ext_double` and `back_ext_double` work out the
> width or depth for an outer bin the same size as the inner one, ignoring
> `left_ext_width` or `back_ext_depth`, and the console gives the size
> used. The corner and the extension beside it share that size, and their
> bays can differ by a little (each lid's hinge edge sets its own ledge),
> so the larger need wins and the other piece's outer bin is walled in to
> match its inner one. With both on, a `2x2` corner holds four bobbin
> stacks, and a `1+1` left extension two spool or notion trays.
>
> **One lid or a lid per bay.** Each piece takes one lid over all its bays
> (`back_lids`, `left_lids`, `corner_lids` = `one`), resting on the
> dividers too, or a lid per bay (`per bay`), each in its own rabbet. Per
> bay, the bays are spaced for a ledge either side of an `ext_frame` rib
> between the rabbets, about 12 mm, and under the ledges the divider
> tapers at 45° to `ext_divider` at the floor, so it prints without
> supports and takes little plastic; there are no finger notches. The
> inner bay's lid keeps its piece's lid settings; the outer bins' lids
> share `bin_lid_type` (lift-out by default) and `bin_lid_hinge`, with a
> finger hole sized to the lid. A bin under `bin_lid_min` (15 mm) inside
> gets no lid, and a hinged bin lid too small to hinge (under 30 mm along
> the hinge or 20 mm across) is made lift-out, with a warning. The bin
> lids print as part `bin_lids`, and go on the `all` plates with the
> others. A per-bay inner lid with bins beside it uses a finger hole, not
> a tab, since a tab's notch would cross the bins.
>
> ![Larger extensions with `left_ext_double` and `back_ext_double`, one lid
> each (lids off): a 2x2 corner with four bobbin-bin-sized bins, the left
> extension split `1+2`, and the finger-notched
> dividers.](../images/renders/ext-bins.png){width=80%}
>
> ![The same sizes with a lid per bay, lids lifted: each bay in its own
> rabbet, the bin lids lift-out with finger holes, the inner bays' lids
> hinged as before.](../images/renders/ext-per-bay.png){width=80%}

![The five bobbin trays stacked on their center post, lifted out of the
corner bay (part `bobbin_trays`, printed in PETG), with metal and plastic
class 15/66 bobbins.](../images/photos/bobbin-stack.jpg){width=55%}

**A standalone bobbin box.** The corner bay and its bobbin trays also come
as a separate, self-contained model, `standalone/bobbin-box/bobbin_box.scad`:
a small lidded box with the five-tray stack, which needs nothing from the
main model. It is a way to try a small piece of the project, or to give
someone the box without the base. It has its own settings (trays, lid type,
bobbin size, hinge and lid fit) and test parts; see its README.
