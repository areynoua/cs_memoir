all: main.pdf

main.aux: main.tex $(wildcard parts/*.tex)
	xelatex main.tex

main.bbl: main.aux info.bib
	bibtex main.aux

main.pdf: main.tex main.bbl $(wildcard parts/*.tex)
	xelatex main.tex
	xelatex main.tex

clean:
	rm -f main.aux main.bbl main.bib main.log

.PHONY: clean
