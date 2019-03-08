#
# TODO Document the project;
#

#MANDATORY PARAMETERS : 
#TARGET_ARCH

#OPTIONAL PARAMETERS :


#INTERNAL VARIABLES, MUST NOT BE USED OR MODIFIED :
#__AB_DIR__
#__EDIR__
#__IDIR__


#------------------------------------------------------------- directories names

#Determine the arch builder project root directory;
__AB_DIR__ := $(dir $(lastword $(MAKEFILE_LIST)))


#--------------------------------------------------------------------- arch call


#TODO SEPARATE SCRIPTS BELOW

#TODO SCRIPTS FLAGS

#TODO CALL SCRIPTS;


#--------------------------------------------------------- arch variables check

#Arch makefiles must mandatorily have defined :
# - __TC_TYPE__ : the toolchain type variable;
# - LD_MMAP_DIR : the directory where the target chip's memory map linker
#   script "memory_map.ld" resides;

ifndef __TC_TYPE__
$(error Arch make units did not define the toolchain type)
endif

ifndef LD_MMAP_DIR
$(error Arch make units did not define the directort of the memory map file)
endif


#--------------------------------------------------------- toolchain definition

#include the toolchain file, that will define all toolchain related variables;
include $(__AB_IDIR__)/toolchains.mk


#------------------------------------------------------------- toolchain checks

#arch makefiles must define the toolchain, namely : 
# - CC : the C compiler;
# - LD : the elf linker;
# - AR : the elf archiver;
# - OC : (objcopy) the elf copier;
# - OD : (objdump) the elf dumper;
# - RD : (readelf) the elf reader;

ifndef CC
$(error arch make units did not define CC (compiler))
endif

ifndef LD
$(error arch make units did not define LD (linker))
endif

ifndef AR
$(error arch make units did not define AR (archiver))
endif

ifndef OC
$(error arch make units did not define OC (objcopy))
endif

ifndef OD
$(error arch make units did not define OD (objdump))
endif

ifndef RD
$(error arch make units did not define RD (readelf))
endif


