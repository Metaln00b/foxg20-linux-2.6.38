# makefile for the FOX Board G20 and Netus G20
# Lee McLoughlin <lee@lmmrtech.com>
# Sergio Tanzilli <tanzilli@acmesystems.it>

# By default make will use this file (makefile) before Makefile
# I use it to setup variables for building the FOX kernel and modules
# however if you are doing anything complex with your linux builds
# then you should consider deleting this file!

ARCH=arm
CROSS_COMPILE=arm-linux-gnueabi-
INSTALL_MOD_PATH=./foxg20-modules

# arch/arm/boot/uImage
UIMAGE=./uImage

# In normal use:
# First time do:
#	make distclean
# To complete build from then on:
#	make menuconfig
#	make
#	make modules
#	make modules_install
# To remove old modules do 'rm -rf FoxModules' before make modules_install
# To install modules copy the entire FoxModules/lib to /lib on your Fox

uimage uImage: 
	@echo Generating a NON compressed uimage
	$(MAKE) $(MFLAGS) -fmakefile Image
	/bin/bash scripts/mkuboot.sh \
		-A arm \
		-O linux \
		-T kernel \
		-C none \
		-a 0x20008000 \
		-e 0x20008000 \
		-n $$(pwd | sed 's,.*/,,;s/^/FOX-/;') \
		-d arch/arm/boot/Image $(UIMAGE)
	@echo " "
	@echo Your new kernel is in: $(UIMAGE)
	@echo " "

# This is a pattern rule to cover all make targets and pass them to the
# "real" Makefile but with ARCH, CROSS_COMPILE and INSTALL_MOD_PATH set
%:
	$(MAKE) $(MFLAGS) \
		-fMakefile \
		ARCH=$(ARCH) \
		CROSS_COMPILE=$(CROSS_COMPILE) \
		INSTALL_MOD_PATH=$(INSTALL_MOD_PATH) \
		$@
