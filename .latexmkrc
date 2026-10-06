# latexmk configuration (used by `make` and by editors such as VS Code LaTeX Workshop).
$pdf_mode = 1;
$out_dir  = 'build';
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S';
$bibtex_use = 2;   # run bibtex when needed, delete .bbl on clean

# Reproducible output: identical sources give a byte-identical PDF, so git does
# not see thesis.pdf as changed after a rebuild without content changes.
# (The title page year is set explicitly with \thesisyear in thesis.tex.)
$ENV{SOURCE_DATE_EPOCH} = '1704067200';  # 2024-01-01
$ENV{FORCE_SOURCE_DATE} = '1';
