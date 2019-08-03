THIS_FILE := $(lastword $(MAKEFILE_LIST))
SHELL:=/bin/bash

all: main-draft.pdf main.pdf main-draft-cut.pdf main-draft-cut-crop.pdf main-draft-crop.pdf

main.pdf main-draft.pdf: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex) main.bbl
	$(eval TARGET := $(basename $@))
	@echo -e "\n\n\n------------ COMPILE $(TARGET) ------------\n\n"
	@mkdir -p /tmp/memo/ ; touch $(TARGET).aux ; cat $(TARGET).aux > /tmp/memo/aux.old
	@if [[ "$@" == *draft* ]] ; then sed -i -e '4,6s/^%*/%/' -e '1,3s/^%*//' options.tex ; else sed -i -e '1,3s/^%*/%/' -e '4,6s/^%*//' options.tex ; fi
	xelatex -halt-on-error -jobname="$(TARGET)" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( rm -f $(TARGET).pdf && cp /tmp/memo/aux.old $(TARGET).aux && false )
	#xelatex -halt-on-error -jobname="$(TARGET)" main.tex || ( rm -f $(TARGET).pdf && cp /tmp/memo/aux.old $(TARGET).aux && false )
	@if grep 'There were undefined citations.' $(TARGET).log ; then echo "------ UPDATE bbl -----" ; bibtex $(TARGET).aux ; fi
	cat $(TARGET).aux > /tmp/memo/aux.new
	if ! diff /tmp/memo/aux.old /tmp/memo/aux.new > /dev/null ; then rm $@ ; $(MAKE) -f $(THIS_FILE) $@ ; fi

main.bbl main-draft.bbl: info.bib
	$(eval TARGET := $(basename $@))
	@echo -e "\n\n\n------------ UPDATE  $@ ------------\n\n"
	xelatex -halt-on-error -jobname="$(TARGET)" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	bibtex $(TARGET).aux | grep 'Warning\|Error' --color ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
	#for f in main.* ; do cp "$$f" "main-draft.$${f##*.}" ; done
	#rm -f main.pdf main-draft.bak main-draft.default main-draft.tex main-draft.pdf

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
	rm -f */*.aux */*.bbl */*.log */*.toc */*.idx */*.blg */*.out

mrproper: clean
	rm -f main-draft.pdf main.pdf main-draft-cut.pdf main-draft-cut-crop.pdf main-draft-crop.pdf

test:
	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )

#main.aux main.bbl main-draft.aux main-draft.bbl: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex) info.bib
#	$(eval TARGET := $(basename $@))
#	@echo -e '\n\n\n------------- PREPROCESSING ----------------------------------------------------\n\n\n'
#	xelatex -halt-on-error -jobname="$(TARGET)" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
#	bibtex main.aux | grep 'Warning\|Error' --color ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
#	xelatex -halt-on-error -jobname="$(TARGET)" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
#	for f in main.* ; do cp "$$f" "main-draft.$${f##*.}" ; done
#	rm -f main.pdf main-draft.bak main-draft.default main-draft.tex main-draft.pdf
#
#main.pdf: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex)
#	@echo -e '\n\n\n------------- FINAL ------------------------------------------------------------\n\n\n'
#	mkdir -p /tmp/memo/ ; touch main.aux ; touch main.bbl
#	cat main.aux main.bbl > /tmp/memo/aux.old
#	sed -i -e '1,3s/^/%/' -e '4,6s/^%*//' options.tex
#	xelatex -halt-on-error main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
#	cat main.aux main.bbl > /tmp/memo/aux.new
#	if ! diff /tmp/memo/aux.old /tmp/memo/aux.new ; then $(MAKE) -f $(THIS_FILE) main.aux main.bbl ; fi
#	while grep -i 'Rerun to get' main.log ; do xelatex -halt-on-error main.tex | ./texout.py ; done
#	cp main.aux main-draft.aux ; cp main.bbl main-draft.aux
#
#main-draft.pdf: main.tex $(wildcard parts/*.tex) $(wildcard res/*.tex)
#	@echo -e '\n\n\n------------- DRAFT ------------------------------------------------------------\n\n\n'
#	mkdir -p /tmp/memo/ ; touch main-draft.aux ; touch main-draft.bbl
#	cat main-draft.aux main-draft.bbl > /tmp/memo/aux-draft.old
#	sed -i -e '4,6s/^/%/' -e '1,3s/^%*//' options.tex
#	xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; [ $${PIPESTATUS[0]} -eq 0 ] || ( make clean && false )
#	cat main-draft.aux main-draft.bbl > /tmp/memo/aux-draft.new
#	if ! diff /tmp/memo/aux-draft.old /tmp/memo/aux-draft.new ; then $(MAKE) -f $(THIS_FILE) main-draft.aux main-draft.bbl ; fi
#	while grep -i 'Rerun to get' main-draft.log ; do xelatex -halt-on-error -jobname="main-draft" main.tex | ./texout.py ; done
#	cp main-draft.aux main.aux ; cp main-draft.bbl main.aux

.PHONY: all clean test mrproper
