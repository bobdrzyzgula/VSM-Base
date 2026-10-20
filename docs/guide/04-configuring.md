# Configuring the model

*This chapter is an outline, still to be written. It will cover:*

- Opening the model and using OpenSCAD's Customizer.
- The settings that decide the fit (machine bed, reliefs, hinges) and the ones that are a matter of taste (compartment, extensions, rounding).
- The `part` setting and the views it gives: assembly, all, test parts, individual parts.
- Reading the console: what each line means, and every WARNING with what to do about it.
- Choosing a side compartment, extensions, trenches and lid hinges.
- Organizer inserts: bobbin trays (corner bay), notion trays and the spool tray (back or left bay, chosen with `ot_bay`), the stack-height budget the console reports, and the `*_assembly` views.

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
> in a square recess in the back rim on the same screw and nut trap as a
> lollipop hinge, so the nut tool serves for it too. The pivot is set at the
> bed hole's height from your measurements, so the pin always lines up.
> The arm, cheeks and stop wall stand a few millimetres above the rim (the
> console gives how far); the back extension's lip is notched around them.
> The block and the base's recess are larger than the lollipop's, so the
> back rim is about 10 mm wider.
>
> ![The printed hinge, cut through the middle: at rest, with the pin in
> the bed's hole (left), and tilted back to its stop
> (right).](../images/renders/printed-hinge.png){width=100%}
>
> When the machine is tipped back, the top of the arm comes to rest on a
> sloping face of the block's back wall, so the machine stops at about
> `ph_stop_angle` (60°) instead of falling back onto the table. The stop
> takes the machine's weight leaning back through the pins, and the
> further past upright the machine leans, the harder it presses: a 30 lb
> machine at 60° presses each stop with a few hundred newtons, which the
> parts are sized for, but don't let the machine drop onto the stop. Set
> `ph_stop_angle` between 45° and 110°, or 0 for no stop. Check that
> nothing on your machine (a motor behind the arm, say) reaches the base's
> back rim before the stop. Print the hinges in PETG or another tough
> filament; their rods are cut-to-length steel rod or dowel pins, 1/4" for
> a 99 (`ph_pin_d`, `ph_pivot_d`). The console's *Printed hinge* lines give
> the sizes, the rod lengths, and how far the parts stand above the rim.
> The printed hinge is new in v34 and hasn't been printed yet.
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
