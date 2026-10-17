# Build the documentation.
#
#   make params   regenerate the parameter reference from the model
#   make images   render the model views (needs OpenSCAD + BOSL2)
#   make pdf      build docs/vsm-base-guide.pdf (needs pandoc 3.1.2+ and typst)
#   make all      all of the above
#
# The guide's chapters are the docs/guide/*.md files, in filename order.
# Images are referenced as ../images/... from the chapters, which works both
# on GitHub and in the PDF build. Typst reads the SVG diagrams directly.

MODEL    := scad/vsm_base.scad
CHAPTERS := $(sort $(wildcard docs/guide/[0-9]*.md))
PDF      := docs/vsm-base-guide.pdf

.PHONY: all params images pdf clean

all: params images pdf

params: docs/guide/90-parameters.md

docs/guide/90-parameters.md: $(MODEL) tools/extract_params.py
	python3 tools/extract_params.py $(MODEL) > $@

images:
	sh tools/render_images.sh

pdf: $(PDF)

$(PDF): $(CHAPTERS) docs/guide/metadata.yaml
	cd docs/guide && pandoc metadata.yaml $(notdir $(CHAPTERS)) \
	    --from markdown --to typst --standalone --toc --toc-depth=2 \
	    -o guide.typ
	typst compile --root docs docs/guide/guide.typ $@
	rm -f docs/guide/guide.typ

clean:
	rm -f $(PDF) docs/guide/guide.typ
