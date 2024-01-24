#
# Makefile for building a FreeBSD GNUstep environment
#

# Check if running as root
ifeq ($(shell id -u),0)
    $(error This Makefile must be run as root.)
endif

build:
	cd scripts && ./bootstrap.sh
	cd scripts && ./checkout.sh
	#cd scripts && ./build.sh

install:
	#cd scripts && ./install.sh

clean:
	cd scripts && ./cleanup.sh