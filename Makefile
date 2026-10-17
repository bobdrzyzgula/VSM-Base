# Build the documentation.
#
#   make params   regenerate the parameter reference from the model
#   make images   render the model views (needs OpenSCAD + BOSL2)
#   make pdf      build build/vsm-base-guide.pdf (needs pandoc 3.1.2+ and typst)
#   make html     build build/vsm-base-guide.html, one self-contained page
#                 with the images embedded (needs pandoc 3.1.2+)
#   make docs     pdf and html
#   make all      params, images, pdf and html
#
# VERSION labels the guide's title page: `make docs VERSION=0.1.0-alpha`
# gives "Version 0.1.0-alpha"; without it the guide says "Development
# build". The release workflow (.github/workflows/release.yml) builds both
# documents this way for each version tag and attaches them to the release.
#
# The guide's chapters are the docs/guide/*.md files, in filename order.
# Images are referenced as ../images/... from the chapters, which works on
# GitHub and in both builds. Typst reads the SVG diagrams directly.

MODEL    := scad/vsm_base.scad
CHAPTERS := $(sort $(wildcard docs/guide/[0-9]*.md))
BUILD    := build
PDF      := $(BUILD)/vsm-base-guide.pdf
HTML     := $(BUILD)/vsm-base-guide.html
VERSION  ?=
LABEL    := $(if $(VERSION),Version $(VERSION),Development build)
IMAGES   := $(wildcard docs/images/*/*)

.PHONY: all params images pdf html docs clean

all: params images docs

docs: pdf html

params: docs/guide/90-parameters.md

docs/guide/90-parameters.md: $(MODEL) tools/extract_params.py
	python3 tools/extract_params.py $(MODEL) > $@

images:
	sh tools/render_images.sh

pdf: $(PDF)

html: $(HTML)

$(PDF): $(CHAPTERS) docs/guide/metadata.yaml $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/guide && pandoc metadata.yaml $(notdir $(CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=2 \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -o guide.typ
	typst compile --root docs docs/guide/guide.typ $@
	rm -f docs/guide/guide.typ

$(HTML): $(CHAPTERS) docs/guide/metadata.yaml docs/guide/guide.css $(IMAGES)
	mkdir -p $(BUILD)
	cd docs/guide && pandoc metadata.yaml $(notdir $(CHAPTERS)) \
	    --from markdown --to html5 --standalone --embed-resources \
	    --toc --toc-depth=2 --number-sections --css guide.css \
	    -M date="$(LABEL), $$(date +'%B %Y')" \
	    -M lang=en -M pagetitle="VSM Base User's Guide" \
	    -o ../../$@

clean:
	rm -rf $(BUILD) docs/guide/guide.typ
