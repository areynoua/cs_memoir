SHELL:=/bin/bash

all: main-draft.pdf main.pdf main-draft-cut.pdf main-draft-cut-crop.pdf main-draft-crop.pdf

main.aux main.bbl texdep: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex) info.bib
	@echo -e '\n\n\n------------- PREPROCESSING ----------------------------------------------------\n\n\n'
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	bibtex main.aux | grep 'Warning\|Error' --color ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	for f in main.* ; do cp "$$f" "main-draft.$${f##*.}" ; done
	rm -f main.pdf main-draft.bak main-draft.default main-draft.tex main-draft.pdf
	touch texdep

main.pdf: main.tex texdep $(wildcard parts/*.tex) $(wildcard res/*.tex)
	@echo -e '\n\n\n------------- FINAL ------------------------------------------------------------\n\n\n'
	sed -i -e '1,3s/^/%/' -e '4,6s/^%*//' options.tex
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	while grep -i 'Rerun to get' main.log ; do xelatex -halt-on-error main.tex | ./texout.py ; done

main-draft.pdf: main.tex texdep $(wildcard parts/*.tex) $(wildcard res/*.tex)
	@echo -e '\n\n\n------------- DRAFT ------------------------------------------------------------\n\n\n'
	sed -i -e '4,6s/^/%/' -e '1,3s/^%*//' options.tex
	xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	while grep -i 'Rerun to get' main-draft.log ; do xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; done

main-draft-cut.pdf: main-draft.pdf
	@echo -e '\n\n\n------------- DRAFT CUT --------------------------------------------------------\n\n\n'
	rm -f /tmp/memoir-*.pdf
	echo $$(pdfinfo main-draft.pdf | grep Pages | grep -o '[0-9]\+')
	p=$$(pdfinfo main-draft.pdf | grep Pages | grep -o '[0-9]\+') ; let p=p-2 ; pdfseparate -f 5 -l $$p main-draft.pdf /tmp/memoir-%d.pdf
	pdfunite $$(ls -v /tmp/memoir-*.pdf) main-draft-cut.pdf
	rm -f /tmp/memoir-*.pdf

main-draft-crop.pdf: main-draft.pdf
	@echo -e '\n\n\n------------- DRAFT CROP -------------------------------------------------------\n\n\n'
	source ~/.bash_aliases ; pdfautocrop main-draft.pdf

main-draft-cut-crop.pdf: main-draft-cut.pdf
	@echo -e '\n\n\n------------- DRAFT CUT CROP ---------------------------------------------------\n\n\n'
	source ~/.bash_aliases ; pdfautocrop main-draft-cut.pdf

clean:
	rm -f *.aux *.bbl *.log *.toc *.idx *.blg *.out

test:
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )

.PHONY: all clean test
