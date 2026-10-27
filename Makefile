# Build the documentation.
#
#   make params   regenerate the parameter reference from the model
#   make images   render the model views (needs OpenSCAD + BOSL2)
#   make pdf      build build/vsm-base-guide.pdf, build/vsm-motor-control.pdf,
#                 build/vsm-inside-the-motor.pdf and build/vsm-motor-rig.pdf
#                 (needs pandoc 3.1.2+ and typst; a recent pandoc (3.7, at least) needs
#                 typst 0.12 or later. The release build uses pandoc 3.7.0.2
#                 and typst 0.13.1.) PANDOC= and TYPST= pick other binaries.
#   make html     build the same two as self-contained HTML pages, images
#                 embedded (needs pandoc 3.1.2+)
#   make docs     pdf and html
#   make all      params, images, pdf and html
#
# VERSION labels the guide's title page: `make docs VERSION=0.1.0-alpha`
# gives "Version 0.1.0-alpha"; without it the guide says "Development
# Build vNN", NN being the model's version from the header of
# scad/vsm_base.scad. The release workflow (.github/workflows/release.yml) builds both
# documents this way for each version tag and attaches them to the release.
#
# Two documents: the User's Guide (docs/guide/*.md) and the paper on motor
# speed control (docs/motor-control/*.md), each in filename order.
# Images are referenced as ../images/... from the chapters, which works on
# GitHub and in both builds. Typst reads the SVG diagrams directly.

MODEL    := scad/vsm_base.scad
CHAPTERS := $(sort $(wildcard docs/guide/[0-9]*.md))
MC_CHAPTERS := $(sort $(wildcard docs/motor-control/[0-9]*.md))
BUILD    := build
PDF      := $(BUILD)/vsm-base-guide.pdf
HTML     := $(BUILD)/vsm-base-guide.html
MC_PDF   := $(BUILD)/vsm-motor-control.pdf
MC_HTML  := $(BUILD)/vsm-motor-control.html
MX_CHAPTERS := $(sort $(wildcard docs/motor-construction/[0-9]*.md))
MX_PDF   := $(BUILD)/vsm-inside-the-motor.pdf
MX_HTML  := $(BUILD)/vsm-inside-the-motor.html
RIG_MD   := standalone/motor-rig/RIG_GUIDE.md
RIG_PDF  := $(BUILD)/vsm-motor-rig.pdf
PANDOC   ?= pandoc
TYPST    ?= typst
VERSION  ?=
DEVVER   := $(shell sed -n 's/^\/\/ VSM Base, version \([0-9]*\).*/\1/p' $(MODEL) | head -1)
LABEL    := $(if $(VERSION),Version $(VERSION),Development Build v$(DEVVER))
IMAGES   := $(wildcard docs/images/*/*)

.PHONY: presets all params images pdf html docs clean

all: params presets images docs

docs: pdf html

params: docs/guide/90-parameters.md

docs/guide/90-parameters.md: $(MODEL) tools/extract_params.py
	python3 tools/extract_params.py $(MODEL) > $@

# Customizer presets, one per machine profile "(as Custom)"
presets: scad/vsm_base.json

scad/vsm_base.json: $(MODEL) tools/make_presets.py
	python3 tools/make_presets.py $(MODEL)

images:
	sh tools/render_images.sh
	python3 tools/make_speed_chart.py
	python3 tools/make_motor_waveforms.py
	python3 tools/make_motor_drawings.py
	sh tools/export_schematic.sh

pdf: $(PDF) $(MC_PDF) $(MX_PDF) $(RIG_PDF)

html: $(HTML) $(MC_HTML) $(MX_HTML)

$(PDF): $(CHAPTERS) docs/guide/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/guide && $(PANDOC) metadata.yaml $(notdir $(CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=2 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o guide.typ
	$(TYPST) compile --root docs docs/guide/guide.typ $@
	rm -f docs/guide/guide.typ

$(HTML): $(CHAPTERS) docs/guide/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/guide && $(PANDOC) metadata.yaml $(notdir $(CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=2 --number-sections --css guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="VSM Base User's Guide" \
	    -o ../../$@

# The motor test rig's guide: its own title (the file's first heading and
# credit line are dropped), sections already numbered in the text
$(RIG_PDF): $(RIG_MD) standalone/motor-rig/metadata.yaml standalone/motor-rig/rig_iso.png
	mkdir -p $(BUILD)
	cd standalone/motor-rig && sed '1,4d' RIG_GUIDE.md | $(PANDOC) metadata.yaml - --shift-heading-level-by=-1 \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o rig.typ
	$(TYPST) compile --root . standalone/motor-rig/rig.typ $@
	rm -f standalone/motor-rig/rig.typ

$(MC_PDF): $(MC_CHAPTERS) docs/motor-control/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/motor-control && $(PANDOC) metadata.yaml $(notdir $(MC_CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o paper.typ
	$(TYPST) compile --root docs docs/motor-control/paper.typ $@
	rm -f docs/motor-control/paper.typ

$(MC_HTML): $(MC_CHAPTERS) docs/motor-control/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/motor-control && $(PANDOC) metadata.yaml $(notdir $(MC_CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --number-sections --css ../guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="Speed Control of Universal Motors in Sewing Machines" \
	    -o ../../$@

# The companion paper, "Inside the Motor" (docs/motor-construction/)
$(MX_PDF): $(MX_CHAPTERS) docs/motor-construction/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/motor-construction && $(PANDOC) metadata.yaml $(notdir $(MX_CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o paper.typ
	$(TYPST) compile --root docs docs/motor-construction/paper.typ $@
	rm -f docs/motor-construction/paper.typ

$(MX_HTML): $(MX_CHAPTERS) docs/motor-construction/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/motor-construction && $(PANDOC) metadata.yaml $(notdir $(MX_CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --number-sections --css ../guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="Inside the Motor" \
	    -o ../../$@

clean:
	rm -rf $(BUILD) docs/guide/guide.typ docs/motor-control/paper.typ docs/motor-construction/paper.typ
