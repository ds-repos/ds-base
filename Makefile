#
# Makefile for building a FreeBSD GNUstep environment
#

install:
	cd scripts && ./bootstrap.sh
	cd scripts && ./clean.sh
	cd scripts && ./checkout.sh
	cd scripts && ./install.sh

deinstall:
	cd scripts && ./deinstall.sh

clean:
	cd scripts && ./clean.sh