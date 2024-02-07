#
# Makefile for building a FreeBSD GNUstep environment
#

install:
	cd scripts && ./bootstrap.sh
	cd scripts && ./checkout.sh
	cd scripts && ./install.sh

deinstall:
	cd scripts && ./clean.sh
	cd scripts && ./deinstall.sh

clean:
	cd scripts && ./clean.sh

image:
	cd scripts && ./image.sh