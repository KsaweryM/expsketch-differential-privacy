# Differential privacy techniques in data sketches

Praca magisterska — Ksawery Możdżyński, Politechnika Wrocławska,
Wydział Informatyki i Telekomunikacji (kierunek: Algorithmic Computer Science,
Cryptography and Computer Security). Promotor: dr inż. Jakub Lemiesz.

Praca omawia prywatność różnicową w szkicach danych i proponuje różnicowo
prywatną wersję algorytmu (Fast)ExpSketch wraz z dowodami, symulacją ataku
rekonstrukcyjnego i analizą eksperymentalną.

## Budowanie

```sh
make            # konwertuje rysunki SVG -> PDF i buduje thesis.pdf
make watch      # przebudowuje przy każdej zmianie
make check      # wypisuje ostrzeżenia (niezdefiniowane referencje, overfull itp.)
make hooks      # włącza hook pre-commit (raz po sklonowaniu repozytorium)
make clean      # usuwa katalog build/
make distclean  # usuwa build/ oraz thesis.pdf
```

Wszystko, co powstaje podczas budowania (pliki pomocnicze LaTeX-a, rysunki
przekonwertowane do PDF, cache `minted`, logi), trafia do `build/`, który jest
ignorowany przez gita. Do katalogu głównego kopiowany jest tylko gotowy
`thesis.pdf`, który jest wersjonowany.

### Hook pre-commit

Po `make hooks` (ustawia `git config core.hooksPath .githooks`) każdy commit
zmieniający źródła pracy najpierw przebudowuje `thesis.pdf` i dodaje go do
commita. Gdy kompilacja się nie powiedzie, commit jest przerywany, a pełny log
zostaje w `build/pre-commit.log`. Commity zmieniające tylko README, LICENSE
lub `notes/` pomijają budowanie. Jednorazowe obejście: `git commit --no-verify`.

Hook buduje stan katalogu roboczego, więc przed commitem warto mieć
zapisane (i dodane) wszystkie zmiany.

### Wymagania

- TeX Live z `latexmk`, `pdflatex`, `bibtex` oraz pakietami: `mwcls`, `polski`,
  `tex-gyre`, `newtx`, `algorithms`, `algorithmicx`, `minted`, `booktabs`,
  `mathtools`, `caption`/`subcaption`, `koma-script`.
  Na Debianie/Ubuntu: `texlive-latex-extra texlive-science texlive-fonts-extra latexmk`.
- `minted` (ładowany przez klasę) wymaga `-shell-escape` i Pygments (`python3-pygments`);
  jest to ustawione w `.latexmkrc`.
- Do konwersji rysunków: Python 3 z PyGObject + librsvg + pycairo
  (`python3-gi python3-gi-cairo gir1.2-rsvg-2.0`). Skrypt `scripts/svg2pdf.py`
  w razie braku tych bibliotek próbuje użyć `rsvg-convert` lub `inkscape`.

## Struktura

```
thesis.tex               plik główny: preambuła, makra notacji, kolejność rozdziałów
dyplom.cls, dyplom.bst   klasa i styl bibliografii PWr (szablon uczelniany)
dyplom-en.bst            angielski wariant stylu bibliografii (używany w pracy)
bibliography.bib         bibliografia (tylko cytowane pozycje)
frontmatter/abstract.tex streszczenie (EN + PL)
chapters/
  00-introduction.tex       wstęp
  01-differential-privacy.tex
  02-data-sketches.tex
  03-literature-review.tex
  04-expsketch-privacy.tex  DP-ExpSketch, dowody, FastExpSketch
  05-privacy-attacks.tex    ataki rekonstrukcyjne i symulacja
  06-experiments.tex
  07-summary.tex            podsumowanie
appendices/proofs.tex    dowody twierdzeń z rozdz. 4
figures/
  diagrams/              schematy (SVG z diagrams.net, z osadzonym źródłem)
  plots/                 wykresy z eksperymentów (SVG)
  unused/                rysunki nieużywane obecnie w pracy
notes/                   lista lektur i niecytowane wpisy BibTeX
scripts/svg2pdf.py       konwersja SVG -> PDF
.githooks/pre-commit     hook przebudowujący thesis.pdf przed commitem
build/                   wyniki budowania (ignorowane przez gita)
```

## Konwencje

- Rysunki dołączamy przez `\includegraphics{nazwa}` (bez ścieżki i rozszerzenia —
  `\graphicspath` wskazuje na przekonwertowane pliki w `build/figures/`).
  Nowy rysunek: wrzuć SVG do `figures/diagrams/` lub `figures/plots/`, `make` sam zrobi PDF.
- Notacja zdefiniowana w preambule `thesis.tex`:
  `\lmax` (λ_MAX), `\Lmin` (Λ_min), `\thr` (ε/λ_MAX), `\Exp`, `\Lap`, `\Range`,
  `\merge`, `\N`, `\R`, `\abs{}`, `\norm{}`, `\dd` (różniczka w całkach).
- Odwołania: `Figure~\ref{...}`, `Algorithm~\ref{...}`, `Theorem~\ref{...}`,
  równania przez `\eqref{...}`.
- Pisownia amerykańska (analyze, behavior, neighboring).
- `\JL{...}` — czerwona uwaga promotora w tekście (do usunięcia przed oddaniem).
- Rok na stronie tytułowej ustawia `\thesisyear{...}` w `thesis.tex`.

## Licencja

Treść pracy, rysunki i skrypty: [CC BY 4.0](LICENSE).
Wyjątek: `dyplom.cls`, `dyplom.bst` i `dyplom-en.bst` pochodzą z szablonu
Politechniki Wrocławskiej i podlegają warunkom ich autorów.
