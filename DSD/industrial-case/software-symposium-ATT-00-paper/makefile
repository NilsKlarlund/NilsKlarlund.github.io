SHELL	= /usr/common/bin/bash -i
all:	xpml-core.html xpml-core.xml xpml-core.txt \
xpml-speech.html xpml-speech.xml xpml-speech.txt\
xpml-menu-interaction.html xpml-menu-interaction.xml xpml-menu-interaction.txt\
xpml.html  xpml.xml xpml.txt\
xpml-att.html  xpml-att.xml xpml-att.txt\
greetings-are-us.xml greetings-are-us.txt\
blue-widgets.xml greetings-are-us.txt\
index.html

index.html:	index.xml
	ibmxsl index.xml index.xsl > index.html

%.html:	%.dsd
	DSD $*

%.xml:	%.pml
	(rm $*.xml; cp $*.pml $*.xml)

%.xml:	%.dsd
	(rm $*.xml; cp $*.dsd $*.xml)

%.txt:	%.pml
	(rm $*.txt; cp $*.pml $*.txt)

%.txt:	%.dsd
	(rm $*.txt; cp $*.dsd $*.txt)


MORE: 	FORCE
	(cd demo-mid; $(MAKE))


FORCE:

