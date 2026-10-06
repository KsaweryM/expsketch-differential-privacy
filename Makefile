# Build system for the master's thesis.
#
# All intermediate files (LaTeX auxiliaries, converted figures, minted cache)
# go to build/. Only the final thesis.pdf is copied to the project root.
#
#   make            build thesis.pdf
#   make figures    convert SVG figures to PDF (into build/figures/)
#   make watch      rebuild continuously on every change
#   make check      show warnings: undefined references, overfull boxes, etc.
#   make hooks      enable the git pre-commit hook that rebuilds thesis.pdf
#   make clean      remove build/
#   make distclean  remove build/ and thesis.pdf

MAIN     := thesis
BUILDDIR := build
LATEXMK  := latexmk
PYTHON   := python3

FIG_SVG  := $(wildcard figures/diagrams/*.svg figures/plots/*.svg)
FIG_PDF  := $(patsubst figures/%.svg,$(BUILDDIR)/figures/%.pdf,$(FIG_SVG))

.PHONY: all pdf figures watch check hooks clean distclean

all: pdf

# latexmk tracks LaTeX dependencies itself, so it is always invoked.
pdf: $(FIG_PDF)
	$(LATEXMK) $(MAIN).tex
	cp $(BUILDDIR)/$(MAIN).pdf $(MAIN).pdf

figures: $(FIG_PDF)

$(BUILDDIR)/figures/%.pdf: figures/%.svg scripts/svg2pdf.py
	@mkdir -p $(dir $@)
	$(PYTHON) scripts/svg2pdf.py $< $@

watch: $(FIG_PDF)
	$(LATEXMK) -pvc -view=none $(MAIN).tex

check: pdf
	@grep -nE "Warning|Overfull|undefined" $(BUILDDIR)/$(MAIN).log \
	  | grep -vE "Font shape|hyperref|pdfTeX warning" || echo "No relevant warnings."

hooks:
	git config core.hooksPath .githooks
	@echo "Pre-commit hook enabled (.githooks/pre-commit)."

clean:
	rm -rf $(BUILDDIR)

distclean: clean
	rm -f $(MAIN).pdf
