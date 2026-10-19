# Introduction

*About this guide.* VSM Base was designed and tested by Robert Drzyzgula.
This guide was written by Claude, an AI model made by Anthropic, at his
direction, from the design, his measurements and photographs, and his
builds. Claude also wrote most of the OpenSCAD code, again at his direction.
Please report errors as issues on the project's GitHub repository.

VSM Base is a parametric model of a portable, hinged base for vintage
flatbed sewing machines. You give it measurements of your machine's bed
casting; it produces a base whose seat, hinge recesses and clearances fit
that casting, and that prints in two halves on an ordinary desktop printer.

## What has been tested

Only a small part of what the model can make has been printed and used.
Treat everything else as **untested on a real printer**: it has been checked
in the model, but not built.

Tested, on a Singer 99K (the default machine profile), printed in PETG:

- the base in its default form: split into two halves with the dovetail
  keys and mending plates, the storage compartment, the handholds and
  harness rods;
- the back, left and corner extensions with their hinged lids, the printed
  extension pegs, and the extended back lip;
- the organizer insert test parts (`bobbin_test`, `notion_test`) and the
  full stack of five bobbin trays; a spool tray and a divided notion tray
  for the back bay. On the spool tray, in silk PLA, a curb split from the
  floor at the first layer above it; the gussets and taller curb added
  since have not been printed yet.

These were printed from development versions of the model as it evolved,
not from the current one: later changes (the split joint's serrations, for
one) have not all been printed yet.

Not yet tested, among others: other machines and custom profiles; the base
printed in one piece; the outlet, knee-controller and jack compartments;
the freestanding boxes, and the standalone bobbin box; the turn button; pin or molded extension pegs; the
pass-through cover; and every option set away from its default. The knee
controller and the motor-control paper's designs have not been built at
all.

If you build something from the untested list, please report how it went
as an issue on the project's GitHub repository.

## Why this exists

Many vintage sewing machines were sold built into cabinets and tables.
Today few people have room for a sewing table, and a machine without a
portable base is hard to use, to store, or even to give away. Too many good
machines are scrapped for that reason alone.

Collectors make their own bases, and a few small makers sell them. The
difficult part is the hinge recesses and the fit of the bed: they need
careful work with a router and chisels, and so most homemade bases are
boxes the machine simply sits in. The shops and skills for that kind of
work are becoming scarce. 3D printers, on the other hand, are now common
and inexpensive, and a printer is very good at exactly the precise,
repeatable shapes that are hard to make by hand.

The model is published under the MIT license so that nobody has to repeat
the work. It is only useful, though, if it works the first time: a full
base is a long print and a lot of filament. This guide is written to make
that likely. It asks you to measure carefully, to read what the model tells
you about your numbers, and to print a few small test parts before the
real thing.

## How to use this guide

Work through the chapters in order the first time:

- **What you need**: printer, filament, software and hardware.
- **Measuring your machine**: the measurements the model needs, how to
  take them, and a worked example for the Singer 99K.
- **Configuring the model**: the Customizer, which settings matter for
  fit, and how to read the console output.
- **Test parts**: what each one checks, what a good result looks like,
  and what to adjust if it isn't.
- **Printing**: orientation, supports, and the features that are removed
  or drilled out after printing.
- **Assembly**: plates, nuts, hinges, rods, extensions and lids.
- **Other machines and hinges**: adapting the model and contributing a
  profile.

The last chapter is a reference listing every parameter in the model. It
is generated from the model's own comments, so it always matches the code.

## Conventions

**Directions.** Directions are given as you sit at the machine to sew.
*Front* is the side nearest you and *back* is the hinge side. On most
flatbed machines, including the Singer 99, the needle is at the *left*
end and the pillar and handwheel are at the *right*.

**Units.** Measurements of the machine's bed are entered in **inches**,
because vintage castings were designed in fractional inches and are easiest
to measure that way; enter them as decimals (12 3/16" is `12.1875`).
Everything else in the model, including the casting reliefs and bobbin
trenches, is in **millimetres**. Each parameter's description says which.

**Parameter names** are shown like `bed_length_in`. They are the names you
will see in OpenSCAD's Customizer and in the parameter reference.

**Coordinates.** Inside the model, X runs from left to right, Y from front
to back and Z upward, with the origin at the base's outer front-left
bottom corner. You only need this if you read the code.
