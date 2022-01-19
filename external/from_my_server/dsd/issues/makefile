SHELL	= /usr/common/bin/bash -i
all:	index.html

index.html:	index.xml
	ibmxsl index.xml ../PML/index.xsl > index.html

%.html:	%.dsd
	DSD $*
%.txt:	%.pml
	(rm $*.txt; cp $*.pml $*.txt)

FORCE:

