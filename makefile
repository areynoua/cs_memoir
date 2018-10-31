SHELL:=/bin/bash

all: main-draft.pdf main.pdf main-draft-crop.pdf

main.aux main.bbl: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex) info.bib
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	bibtex main.aux | grep 'Warning\|Error' --color ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	for f in main.* ; do cp "$$f" "main-draft.$${f##*.}" ; done
	rm -f main.pdf main-draft.bak main-draft.default main-draft.tex main-draft.pdf

main.pdf: main.tex main.aux main.bbl $(wildcard parts/*.tex) $(wildcard res/*.tex)
	@echo -e '\n\n\n------------- FINAL ------------------------------------------------------------\n\n\n'
	sed -i -e '1,3s/^/%/' -e '4,6s/^%*//' options.tex
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	while grep -i 'Rerun to get' main.log ; do xelatex -halt-on-error main.tex | ./texout.py ; done

main-draft.pdf main-draft-crop.pdf: main.tex main.aux main.bbl $(wildcard parts/*.tex) $(wildcard res/*.tex)
	@echo -e '\n\n\n------------- DRAFT ------------------------------------------------------------\n\n\n'
	sed -i -e '4,6s/^/%/' -e '1,3s/^%*//' options.tex
	xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	while grep -i 'Rerun to get' main-draft.log ; do xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; done
	rm -f /tmp/memoir-*.pdf
	echo $$(pdfinfo main-draft.pdf | grep Pages | grep -o '[0-9]\+')
	p=$$(pdfinfo main-draft.pdf | grep Pages | grep -o '[0-9]\+') ; let p=p-2 ; pdfseparate -f 4 -l $$p main-draft.pdf /tmp/memoir-%d.pdf
	pdfunite $$(ls -v /tmp/memoir-*.pdf) main-draft.pdf
	rm -f /tmp/memoir-*.pdf
	source ~/.bash_aliases ; pdfautocrop main-draft.pdf


clean:
	rm -f *.aux *.bbl *.log *.toc *.idx *.blg *.out

test:
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )

.PHONY: all clean test
