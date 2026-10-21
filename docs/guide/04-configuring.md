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
> **Note: a base without hinges.** `hinge_type = "none"` makes a base for
> a machine to sit in, for a machine without hinges or for anyone who
> doesn't want them: no hinge recesses or nut traps, no hinge checks or
> hardware in the console, and no hinge test parts; the back-wall tunnels run
> the whole back wall, and the hinge-hole measurements are ignored. The back
> rim stays as wide as it would be with lollipop hinges, so the extensions
> are the same for both; set `back_rim_width` (9 matches the front rim) for a
> base about 32 mm shallower. Nothing holds the machine in its seat, so carry
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
> from under the base, through the same kind of trap a lollipop hinge's nut
> sits in, into a nut slid into a slot in the block's front face, below
> the arm, with plastic under it for the nut to bear on. The pivot is set
> at the bed hole's height from your measurements, so the pin always lines
> up. The arm and cheeks are cut down flush with the rim wherever that
> leaves `ph_min_cover` (2.5 mm) of plastic over the rods: on the
> Kenmore 158-14001, whose holes are 6.75 mm down, the whole hinge is flush; on
> the 99K, whose holes are only 4 mm down, the arm stands 1.7 mm proud, and
> the back extension's lip is notched around it. The block and the base's
> recess are larger than the lollipop's, so the back rim is about 8 mm
> wider.
>
> ![The printed hinge, cut through the middle: at rest, with the pin in
> the bed's hole (left), and tilted back to its stop
> (right).](../images/renders/printed-hinge.png){width=100%}
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
> "flat"`, gives a flat, level top instead. Because the base tips first, the stop never has to hold more
> than a few newton-metres, well within the pins and the plastic; don't
> drop the machine onto it all the same. Set `ph_stop_angle` between 45°
> and 110°, or 0 for no stop. Check that nothing on your machine reaches
> the base's back rim before the stop. Print the hinges in PETG or another
> tough
> filament; their rods are cut-to-length steel rod or dowel pins. The pin's
> diameter and how far it goes into the hole come from the machine profile
> (1/4" and 12 mm for the 99K, 6 mm and 16 mm for the Kenmore 158-14001), unless
> you set `ph_pin_d` and `ph_pin_engage`; the pivot is `ph_pivot_d` (1/4").
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
>
> **Note: outlet labels.** With the outlet, LIGHT (always on) and MOTOR
> (the controlled output) are recessed into the floor by their receptacles,
> LIGHT at the back by default (`outlet_light_side`), since the outlet goes
> in with the always-on side and the cord to the back. The words, size and
> depth are settings; `outlet_labels = false` leaves them off.
>
> **Note: the outlet's cords out through the walls.** By default the
> outlet's two cords leave through slots in the compartment's lid. With
> `outlet_cord_exit`, they can leave through slots in the walls instead,
> which suits a table where the cords should drop down behind or in front:
>
> - `front_rear`: the power cord, from the outlet's back end, goes straight
>   out the back wall, and the controller cord, from its front end,
>   straight out the front wall.
> - `rear`: both go out the back. The controller cord drops from the
>   outlet's front end into a channel in the floor, turns through a
>   180-degree bend (about 27 mm radius on the 99K) and runs back along the divider,
>   under the machine's cords where they come through the pass-through,
>   and out through the back wall beside the power cord. The channel holds
>   two-wire lamp cord standing on edge (`outlet_channel_w`,
>   `outlet_channel_depth`), so the bend is an easy flat bend; small lips
>   along its edges, on alternate sides, let the cord press in and keep it
>   down. The floor labels move over beside the channel, smaller to fit.
>   The cords are taken to leave the outlet's ends at its centre, 1/8" up
>   from its back, as on the usual cordset outlet (`outlet_cord_z` and
>   `outlet_cord_x` if yours differ), and the bend is as wide as the room
>   in front of the outlet allows.
>
> Each wall slot runs from the top of the wall down to its cord. With the
> cord in place, a trim (part `outlet_trims`, one per slot) presses into
> the slot from above, flush with the rim and with the lid's ledge, and
> leaves an eased opening under it for the cord. The lid then has no cord
> slots. The tunnel lightening the back wall stops short of the slots.
>
> **Note: insert trays need their bay.** The bobbin trays need the corner
> bay and the notion and spool trays need the bay named by `ot_bay`. The bay
> can be the attached extension or its freestanding box (`make_corner_box`
> and so on), which is how to hold a second bobbin stack. With no bay, the
> render stops with a message saying which setting to turn on.
>
> **Note: notion tray heights.** The console's STACK line gives the total
> height the trays may add up to in the chosen bay (78.2 mm in the back bay
> at the defaults), so any mix of the 30, 25, 20, 15, 10 mm and custom
> trays that totals no more than that fits under the lid. The spool tray
> line gives what is left above a spool tray.
>
> **Note: compartments and gussets.** Divided notion trays aim for 2"
> compartments by default (`ot_cell`), which gives 2 × 4 in the back or left
> bay; 1" gives 3 × 8. Every notion tray, and the spool tray's curbs, has
> small triangular gussets at the foot of its long walls (`ot_gussets`),
> because a thin wall standing on a thin floor joins it at a single layer
> line, the weakest place in the print. On the spool tray they sit in the
> gaps between spools. Let trays cool on the plate before taking them off;
> a long, thin tray pulled off warm can bow.

![The five bobbin trays stacked on their center post, lifted out of the
corner bay (part `bobbin_trays`, printed in PETG), with metal and plastic
class 15/66 bobbins.](../images/photos/bobbin-stack.jpg){width=55%}

**A standalone bobbin box.** The corner bay and its bobbin trays also come
as a separate, self-contained model, `standalone/bobbin-box/bobbin_box.scad`:
a small lidded box with the five-tray stack, which needs nothing from the
main model. It is a way to try a small piece of the project, or to give
someone the box without the base. It has its own settings (trays, lid type,
bobbin size, hinge and lid fit) and test parts; see its README.
