# latexmk configuration (used by `make` and by editors such as VS Code LaTeX Workshop).
$pdf_mode = 1;
$out_dir  = 'build';
$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -synctex=1 -shell-escape %O %S';
$bibtex_use = 2;   # run bibtex when needed, delete .bbl on clean
