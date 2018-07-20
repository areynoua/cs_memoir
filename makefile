all: main.pdf

main.aux main.bbl: main.tex $(wildcard parts/*.tex) info.bib
	xelatex main.tex
	bibtex main.aux
	xelatex main.tex

main.pdf: main.tex main.aux main.bbl $(wildcard parts/*.tex)
	xelatex main.tex

clean:
	rm -f main.aux main.bbl main.bib main.log

.PHONY: clean
