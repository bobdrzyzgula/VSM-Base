# Build the documentation.
#
#   make params   regenerate the parameter reference from the model
#   make images   render the model views (needs OpenSCAD + BOSL2)
#   make pdf      build build/vsm-base-guide.pdf, build/vsm-motor-control.pdf,
#                 build/vsm-inside-the-motor.pdf,
#                 build/vsm-inside-a-switching-circuit.pdf, build/vsm-force-sensing-pedal.pdf,
#                 build/vsm-analog-knee-controller.pdf and build/vsm-motor-rig.pdf
#                 (needs pandoc 3.1.2+ and typst; a recent pandoc (3.7, at least) needs
#                 typst 0.12 or later. The release build uses pandoc 3.7.0.2
#                 and typst 0.13.1.) PANDOC= and TYPST= pick other binaries.
#   make html     build the same two as self-contained HTML pages, images
#                 embedded (needs pandoc 3.1.2+)
#   make docs     pdf and html
#   make all      params, images, pdf and html
#   make snapshot build the HTML, copy it into docs-snapshot/ (the
#                 hand-committed snapshot published on GitHub Pages) and
#                 stamp its index; committing it is up to you
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
SW_CHAPTERS := $(sort $(wildcard docs/switching/[0-9]*.md))
SW_PDF   := $(BUILD)/vsm-inside-a-switching-circuit.pdf
SW_HTML  := $(BUILD)/vsm-inside-a-switching-circuit.html
FP_CHAPTERS := $(sort $(wildcard docs/fsr-pedal/[0-9]*.md))
FP_PDF   := $(BUILD)/vsm-force-sensing-pedal.pdf
FP_HTML  := $(BUILD)/vsm-force-sensing-pedal.html
AK_CHAPTERS := $(sort $(wildcard docs/analog-knee/[0-9]*.md))
AK_PDF   := $(BUILD)/vsm-analog-knee-controller.pdf
AK_HTML  := $(BUILD)/vsm-analog-knee-controller.html
RIG_MD   := standalone/motor-rig/RIG_GUIDE.md
RIG_PDF  := $(BUILD)/vsm-motor-rig.pdf
RIG_HTML := $(BUILD)/vsm-motor-rig.html
PANDOC   ?= pandoc
TYPST    ?= typst
VERSION  ?=
DEVVER   := $(shell sed -n 's/^\/\/ VSM Base, version \([0-9]*\).*/\1/p' $(MODEL) | head -1)
LABEL    := $(if $(VERSION),Version $(VERSION),Development Build v$(DEVVER))
IMAGES   := $(wildcard docs/images/*/*)

.PHONY: presets all params images pdf html docs clean snapshot matrix matrix-full lazy-check

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
	python3 tools/make_tool_spectra.py
	python3 tools/make_triac_figures.py
	python3 tools/make_fsr_pedal_figures.py
	python3 tools/make_analog_knee_figures.py
	sh tools/export_schematic.sh

pdf: $(PDF) $(MC_PDF) $(MX_PDF) $(SW_PDF) $(FP_PDF) $(AK_PDF) $(RIG_PDF)

html: $(HTML) $(MC_HTML) $(MX_HTML) $(SW_HTML) $(FP_HTML) $(AK_HTML) $(RIG_HTML)

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

$(RIG_HTML): $(RIG_MD) standalone/motor-rig/metadata.yaml standalone/motor-rig/rig_iso.png docs/guide/guide.css
	mkdir -p $(BUILD)
	cd standalone/motor-rig && sed '1,4d' RIG_GUIDE.md | $(PANDOC) metadata.yaml - --shift-heading-level-by=-1 \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --css ../../docs/guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="Sewing-Motor Test Rig: User's Guide" \
	    -o ../../$@

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

# The second companion paper, "Inside a Switching Circuit" (docs/switching/)
$(SW_PDF): $(SW_CHAPTERS) docs/switching/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/switching && $(PANDOC) metadata.yaml $(notdir $(SW_CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o paper.typ
	$(TYPST) compile --root docs docs/switching/paper.typ $@
	rm -f docs/switching/paper.typ

$(SW_HTML): $(SW_CHAPTERS) docs/switching/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/switching && $(PANDOC) metadata.yaml $(notdir $(SW_CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --number-sections --css ../guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="Inside a Switching Circuit" \
	    -o ../../$@

# The design study "A Force-Sensing Pedal" (docs/fsr-pedal/)
$(FP_PDF): $(FP_CHAPTERS) docs/fsr-pedal/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/fsr-pedal && $(PANDOC) metadata.yaml $(notdir $(FP_CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o paper.typ
	$(TYPST) compile --root docs docs/fsr-pedal/paper.typ $@
	rm -f docs/fsr-pedal/paper.typ

$(FP_HTML): $(FP_CHAPTERS) docs/fsr-pedal/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/fsr-pedal && $(PANDOC) metadata.yaml $(notdir $(FP_CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --number-sections --css ../guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="A Force-Sensing Pedal" \
	    -o ../../$@

# The design study "An Analog Force-Sensing Knee Controller" (docs/analog-knee/)
$(AK_PDF): $(AK_CHAPTERS) docs/analog-knee/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/analog-knee && $(PANDOC) metadata.yaml $(notdir $(AK_CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=1 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o paper.typ
	$(TYPST) compile --root docs docs/analog-knee/paper.typ $@
	rm -f docs/analog-knee/paper.typ

$(AK_HTML): $(AK_CHAPTERS) docs/analog-knee/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/analog-knee && $(PANDOC) metadata.yaml $(notdir $(AK_CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=1 --number-sections --css ../guide/guide.css --mathml \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="An Analog Force-Sensing Knee Controller" \
	    -o ../../$@

snapshot: html
	cp $(BUILD)/*.html docs-snapshot/
	sed -e "s/@LABEL@/$(LABEL)/" -e "s/@DATE@/$$(date +'%B %-d, %Y')/" tools/snapshot_index.html > docs-snapshot/index.html

clean:
	rm -rf $(BUILD) docs/guide/guide.typ docs/motor-control/paper.typ docs/motor-construction/paper.typ docs/switching/paper.typ \
	    docs/fsr-pedal/paper.typ docs/analog-knee/paper.typ standalone/motor-rig/rig.typ

# Configuration test matrix (tools/test_matrix.py): "matrix" evaluates every
# combination of the main options (minutes); "matrix-full" also renders the
# printable parts (about a quarter of an hour on two cores). Both compare
# with the committed baseline, write build/test-matrix.md, and fail if anything changed.
matrix: lazy-check
	python3 tools/test_matrix.py --level quick

matrix-full: lazy-check
	python3 tools/test_matrix.py --level full

# Code that OpenSCAD's lazy union would change (tools/check_lazy_union.py);
# reads the source only, so it takes a moment. Run first by both matrices.
lazy-check:
	python3 tools/check_lazy_union.py
