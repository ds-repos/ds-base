#
# Makefile for building a FreeBSD GNUstep environment
#

build:
	cd scripts && ./clean.sh
	cd scripts && ./bootstrap.sh
	cd scripts && ./checkout.sh
	cd scripts && ./build.sh

install:
	cd scripts && ./uninstall.sh
	cd scripts && ./install.sh

uninstall:
	cd scripts && ./uninstall.sh

clean:
	cd scripts && ./clean.sh