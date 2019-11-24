#-------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/08/19
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#  @brief	Makefile for building documentation.
#
#-------------------------------------------------------------------------------

.PHONY: all clean
.DEFAULT: all

all:
	pdflatex tutorial.tex
	pdflatex tutorial.tex

clean:
	@rm -rf chapters/*log
	@rm -rf chapters/*aux
	@rm -rf *.log
	@rm -rf *.xml
	@rm -rf *.toc
	@rm -rf *-blx.bib
	@rm -rf *.aux
	@rm -rf *.out
	@rm -rf *.pdf
	@rm -rf *.gz
