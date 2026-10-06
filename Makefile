# Build system for the master's thesis.
#
#   make          build thesis.pdf (converts figures first if needed)
#   make figures  convert SVG figures to PDF
#   make watch    rebuild continuously on every change
#   make clean    remove LaTeX auxiliary files (keeps thesis.pdf and figure PDFs)
#   make distclean  remove everything that can be regenerated
#   make check    show warnings: undefined references, overfull boxes, etc.

MAIN     := thesis
BUILDDIR := build
LATEXMK  := latexmk
PYTHON   := python3

FIG_SVG  := $(wildcard figures/diagrams/*.svg figures/plots/*.svg)
FIG_PDF  := $(FIG_SVG:.svg=.pdf)

.PHONY: all pdf figures watch clean distclean check

all: pdf

# latexmk tracks LaTeX dependencies itself, so it is always invoked.
pdf: $(FIG_PDF)
	$(LATEXMK) $(MAIN).tex
	cp $(BUILDDIR)/$(MAIN).pdf $(MAIN).pdf

figures: $(FIG_PDF)

%.pdf: %.svg scripts/svg2pdf.py
	$(PYTHON) scripts/svg2pdf.py $< $@

watch: $(FIG_PDF)
	$(LATEXMK) -pvc -view=none $(MAIN).tex

check: pdf
	@grep -nE "Warning|Overfull|Underfull|undefined" $(BUILDDIR)/$(MAIN).log \
	  | grep -vE "Font shape|hyperref|pdfTeX warning" || echo "No relevant warnings."

clean:
	$(LATEXMK) -c $(MAIN).tex
	rm -rf $(BUILDDIR) _minted-$(MAIN)

distclean: clean
	rm -f $(MAIN).pdf $(FIG_PDF)
