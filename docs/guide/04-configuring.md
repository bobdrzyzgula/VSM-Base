# Configuring the model

*This chapter is an outline, still to be written. It will cover:*

- Opening the model and using OpenSCAD's Customizer.
- The settings that decide the fit (machine bed, reliefs, hinges) and the ones that are a matter of taste (compartment, extensions, rounding).
- The `part` setting and the views it gives: assembly, all, test parts, individual parts.
- Reading the console: what each line means, and every WARNING with what to do about it.
- Choosing a side compartment, extensions, trenches and lid hinges.
- Organizer inserts: bobbin trays (corner bay), notion trays and the spool tray (back or left bay, chosen with `ot_bay`), the stack-height budget the console reports, and the `*_assembly` views.

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

![The five bobbin trays stacked on their center post, lifted out of the
corner bay (part `bobbin_trays`, printed in PETG), with metal and plastic
class 15/66 bobbins.](../images/photos/bobbin-stack.jpg){width=55%}
