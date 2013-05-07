
image-path = images
#scala=$(shell which scala || echo ~remonet/app/bin/scala) -cp $(shell pwd)/commons-math-2.1.jar

svg-files = $(wildcard ${image-path}/*.svg)
svg-files-in-pdf = $(patsubst %.svg,%.pdf,${svg-files})
svg-with-embeded-jpg-in-pdf = $(patsubst %.svg,%.pdf,$(wildcard ${image-path}/*-embed.svg))
scala-files = $(wildcard ${image-path}/*.scala)
scala-files-in-curve = $(patsubst %.scala,%.curve,${scala-files})
gp-files = $(wildcard ${image-path}/*.gp)
gp-files-in-pdf = $(patsubst %.gp,%.pdf,${gp-files})
BASENAME=thesis

$(BASENAME).pdf: ${BASENAME}.tex ${BASENAME}.bib $(wildcard *.tex) $(wildcard ${image-path}/*) ${svg-files-in-pdf} ${svg-with-embeded-jpg-in-pdf} ${gp-files-in-pdf} Makefile
	pdflatex $<
	test ${BASENAME}.bib && bibtex   ${BASENAME}
	pdflatex $<
	pdflatex $<	
	@pdftotext $@ - | grep -Hrn '[?]' -  | awk '{print "? in PDF: " $$0}'
	@grep -Hrn TODO *.tex | awk '{print "TODO: " $$0}'

#appendix-view: $(BASENAME)-appendix.pdf
#	acroread $<

#${BASENAME}-appendix.tx: ${BASENAME}.tex appendix.tex
#	cat $< | awk 'BEGIN{show=1} /%%%BODY/{show=0; print "\\input{appendix}"} {if (show) print} /%%%\/BODY/{show=1}' > $@

#${BASENAME}-1col.tx: ${BASENAME}.tex Makefile
#	cat $< | awk '/%%%BODY/{print "\\onecolumn"} {print}' > $@

#$(BASENAME)-appendix.pdf: ${BASENAME}-appendix.tx $(wildcard ${image-path}/*) ${svg-files-in-pdf} ${gp-files-in-pdf} Makefile
#	pdflatex $<

#$(BASENAME)-1col.pdf: ${BASENAME}-1col.tx $(wildcard ${image-path}/*) ${svg-files-in-pdf} ${gp-files-in-pdf} Makefile
#	pdflatex $<
#	test ${BASENAME}.bib && bibtex   ${BASENAME}-1col
#	pdflatex $<
#	pdflatex $<

#review: review-1-answers.pdf
#	echo $<
#review-1-answers.pdf: review-1-answers.tex
#	pdflatex $<

clean:
	rm -f ${BASENAME}.pdf ${BASENAME}.aux ${BASENAME}.bbl ${BASENAME}.blg ${BASENAME}.log ${BASENAME}.toc

view: ${BASENAME}.pdf
	acroread $<

.PHONY: export appendix-view view clean continuous latexdiff
export:
	rm -rf export
	mkdir export
	cat ${BASENAME}.tex | awk '/\\listfiles/ {next} /\\documentclass.*/ {print; print "\\listfiles"; next} // {print}' > ,,.tex
	cp ${BASENAME}.tex export/
# adding the base tex file (as it is not listed)
# adding the bib also (as it uses the bbl actually)
	for i in ${BASENAME}.tex ${BASENAME}.bib $$(pdflatex ,,.tex | awk '/ *\*File List\*/ {show=1; next;} / \*\*\*\*\*+/ {show=0;next} // {if (show) {print}}') ; do test -f $$i && mkdir -p export/$$(dirname $$i) && cp $$i export/$$(dirname $$i)/; done
	echo > export/Makefile
	echo ${BASENAME}.pdf: >> export/Makefile
	echo "	"pdflatex ${BASENAME}.tex >> export/Makefile
	echo "	"bibtex ${BASENAME} >> export/Makefile
	echo "	"pdflatex ${BASENAME}.tex >> export/Makefile
	echo "	"pdflatex ${BASENAME}.tex >> export/Makefile
	echo .PHONY: ${BASENAME}.pdf >> export/Makefile

with=NONE
latexdiff:
	@test ${with} '!=' NONE || (echo -n "\n\nPlease check you saved/commited everything and use something like \n    make latexdiff with=HEAD^\n\n"; false)
	rm -rf latexdiff
	mkdir latexdiff
	git symbolic-ref -q HEAD  | sed 's@^refs/heads/@@g' > latexdiff.br
	git stash save "Before latexdiff"
	git checkout ${with}
	cp *.tex latexdiff/
	cat latexdiff.br | xargs git checkout
	(cd latexdiff && for i in *.tex ; do latexdiff $$i ../$$i > diff; yes | mv diff ../$$i; done)
	make || (echo -n "\n\nCompilation of diff'ed latex failed.\nPlease fix it, make and do whatever you want with the pdf.\nTHEN, run:\n    git reset --hard ; git stash apply\n\n" ; false) 
	mv ${BASENAME}.pdf latexdiff.pdf
	git reset --hard
	git stash apply

$(svg-files-in-pdf): %.pdf: %.svg
	inkscape -T $(patsubst %.pdf,%.svg,$@) --export-pdf=$@

$(svg-with-embeded-jpg-in-pdf):
	inkscape -T $(patsubst %.pdf,%.svg,$@) --export-pdf=$@
	(python pdffixup.py $@ images/*jpg && mv $@.replaced.pdf $@) || echo 'Skipping python process as there was an error (but it should not be fatal)'

#$(scala-files-in-curve): %.curve: %.scala
#	${scala} $< > $@

$(gp-files-in-pdf): %.pdf: %.gp %.curve
	echo "cd '${image-path}' ; set term svg enhanced $(shell cat $< | egrep -e '^#SVG:' | sed 's@#SVG:@@g'); set output '$(notdir $(patsubst %.pdf,%.svg,$@))'; load '$(notdir $<)' ;" | gnuplot
	inkscape -T $(patsubst %.pdf,%.svg,$@) --export-pdf=$@
	rm $(patsubst %.pdf,%.svg,$@)

fast:
	bibtex ${BASENAME} || echo ======== bibtex failed, still continuing
	pdflatex -halt-on-error ${BASENAME}.tex

continuous:
	while true ; do sleep 1; for i in *.tex ; do if test '!' -f ${BASENAME}.pdf -o $$i -nt ${BASENAME}.pdf; then make fast ; break ; fi ; done; done


#continuous-appendix:
#	while true ; do sleep 1; test '!' -f ${BASENAME}-appendix.pdf -o appendix.tex -nt ${BASENAME}-appendix.pdf && make ${BASENAME}-appendix.pdf ; done
##	while true ; do sleep 1; for i in appendix.tex ; do if test '!' -f ${BASENAME}-appendix.pdf -o $$i -nt ${BASENAME}-appendix.pdf; then make ${BASENAME}-appendix.pdf ; break ; fi ; done; done


reconvert-svg:
	make $(svg-files-in-pdf)

# for i ...
# do mv $i $i.old ; convert $i.old -quality 90 -normalize +level 20,100% $i ; done

