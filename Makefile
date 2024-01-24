#
# Makefile for building a FreeBSD GNUstep environment
#

build:
	cd scripts && ./bootstrap.sh
	cd scripts && ./checkout.sh
	#cd scripts && ./build.sh

install:
	#cd scripts && ./install.sh

clean:
	cd scripts && ./cleanup.sh