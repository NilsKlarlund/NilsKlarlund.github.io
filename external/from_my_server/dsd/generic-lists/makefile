SHELL	= /usr/common/bin/bash -i

all:	book.html dsd.html generic-list.html  persons.html person.txt

%.html:	%.dsd
	DSD $*


%.txt:	%.xml
	(rm $*.txt; cp $*.xml $*.txt)


MORE: 	FORCE
	(cd demo-mid; $(MAKE))


FORCE:

