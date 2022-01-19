
all:	dsd-1.0.dsd.xml.html EXAMPLES

EXAMPLES: FORCE
	(cd Examples; $(MAKE))

%.xml.html:	%.xml
	xsl $< ../dsd/dsdtohtml.xsl  > $<.html.org
	C:/MKSNT/sed  's/\(href=["][^"]*[.]xml\)/\1.html/g' $<.html.org > $<.html 


FORCE:

