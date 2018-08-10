SHELL:=/bin/bash

all: main.pdf

main.aux main.bbl: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex) info.bib
	$$(echo X) | xelatex main.tex | ./texout.py ; [ $${PIPESTATUS[1]} -eq 0 ] || ( make clean && false )
	bibtex main.aux | grep 'Warning\|Error' --color ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	$$(echo X) | xelatex main.tex | ./texout.py ; [ $${PIPESTATUS[1]} -eq 0 ] || ( make clean && false )

main.pdf: main.tex main.aux main.bbl $(wildcard parts/*.tex) $(wildcard res/*.tex)
	@echo -e '\n\n\n--------------------------------------------------------------------------------\n\n\n'
	$$(echo X) | xelatex main.tex | ./texout.py ; [ $${PIPESTATUS[1]} -eq 0 ] || ( make clean && false )

clean:
	rm -f main.aux main.bbl main.bib main.log

test:
	$$(echo X) | xelatex main.tex | ./texout.py ; [ $${PIPESTATUS[1]} -eq 0 ] || ( make clean && false )

.PHONY: all clean test
