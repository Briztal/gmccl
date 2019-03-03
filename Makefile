#
# TODO Document the project;
#

#MANDATORY PARAMETERS : 
#MOTHERBOARD_NAME

#OPTIONAL PARAMETERS :
#EXT_ARCH_DIR
#MOTHERBOARD_DIR_NAME
#CHIP_DIR_NAME
#PROC_DIR_NAME

#INTERNAL VARIABLES, MUST NOT BE USED OR MODIFIED :
#__AB_IDIR__
#__AB_EDIR__
#__MB_IDIR__
#__MB_EDIR__
#__CH_IDIR__
#__CH_EDIR__
#__PR_IDIR__
#__PR_EDIR__
#__TC_TYPE__

#USABLE EXTERNAL VARIABLES, MUST NOT BE MODIFIED : 
#CC
#LD
#AR
#OC
#LD_MMAP_DIR

#COMPLETABLE EXTERNAL VARIABLES, MUST NOT BE RESET :
#CC_FLAGS
#LD_FLAGS
#AR_FLAGS
#OC_FLAGS


#---------------------------------------------------------- prerequisites check

#If the motherboard name is not provided :
ifndef MOTHERBOARD_NAME

#Fail. The motherboard name is mandatory to setup the environment;
$(error The motherboard name has not been provided;)

#endif


#------------------------------------------------------------ directories names

#Determine the arch builder project root directory;
__AB_IDIR__ := $(dir $(lastword $(MAKEFILE_LIST)))

#If the external arch directory is not defined, it is defaulted to the
# directory of the first used makefile;
ifdef EXT_ARCH_DIR
__AB_EDIR__ := $(EXT_ARCH_DIR)
else
__AB_EDIR__ := $(dir $(firstword $(MAKEFILE_LIST)))
endif

#If not defined, layers directories names are defaulted to implicit names;
__MB_IDIR__ := $(__AB_IDIR__)/mboard
__CH_IDIR__ := $(__AB_IDIR__)/chip
__PR_IDIR__ := $(__AB_IDIR__)/proc

ifndef MOTHERBOARD_DIR_NAME
__MB_EDIR__ := $(__AB_EDIR__)/mboard
else
__MB_EDIR__ := $(__AB_EDIR__)/$(MOTHERBOARD_DIR_NAME)
endif

ifndef CHIP_DIR_NAME
__CH_EDIR__ := $(__AB_EDIR__)/chip
else
__CH_EDIR__ := $(__AB_EDIR__)/$(CHIP_DIR_NAME)
endif

ifndef PROC_DIR_NAME
__PR_EDIR__ := $(__AB_EDIR__)/proc
else
__PR_EDIR__ := $(__AB_EDIR__)/$(PROC_DIR_NAME)
endif


#-------------------------------------------------------------- toolchain flags

#Toolchain programs may require hardware related information; 
# The following variables will contain this information;
CC_FLAGS :=
LD_FLAGS :=
AR_FLAGS :=
OC_FLAGS :=


#-------------------------------------------------------------- target makefile

#Include the motherboard makefile, that will include all other layers;
#If the motherboard doesn't exist, an error will occur;
include $(__MB_IDIR__)/$(MOTHERBOARD_NAME)


#--------------------------------------------------------- arch variables check

#Arch makefiles must mandatorily have defined :
# - __TC_TYPE__ : the toolchain type variable;
# - LD_MMAP_DIR : the directory where the target chip's memory map linker
#   script "memory_map.ld" resides;

ifndef __TC_TYPE__
$(error Arch make units did not define the toolchain type;)
endif

ifndef LD_MMAP_DIR
$(error Arch make units did not define the memory map file directory;)
endif


#--------------------------------------------------------- toolchain definition

#include the toolchain file, that will define all toolchain variables;
include $(__AB_IDIR__)/toolchains.mk


#------------------------------------------------------------- toolchain checks

#arch makefiles must define the toolchain, namely : 
# - CC : the C compiler;
# - LD : the elf linker;
# - AR : the elf archiver;
# - OC : the elf manipulator;

ifndef CC
$(error arch make units did not define the C compiler;)
endif

ifndef LD
$(error arch make units did not define the elf linker;)
endif

ifndef AR
$(error arch make units did not define the elf archiver;)
endif

ifndef OC
$(error arch make units did not define the elf manipulator;)
endif


