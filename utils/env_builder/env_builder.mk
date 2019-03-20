#
# TODO Document the project;
#

#----------------------------------------------------------- prerequisites check

#If the target architecture is not provided, fail;
ifndef __AB_TARGET_ARCH__
$(error The target architecture has not been provided)
endif

#If the external directory was not provided, fail;
ifndef __AB_EXT_DIR__
$(error The path of the external directory has not been provided)
endif


#------------------------------------------------------------- directories names

#If the environments directory has not been provided, set the internal one;
ifndef __AB_ENV_DIR__
__AB_ENV_DIR__ := $(dir $(lastword $(MAKEFILE_LIST)))arch
endif


#--------------------------------------------------------------- target makefile

#Include the target arch makefile, that will include all internal and external
# dependencies;
#If the target doesn't exist, an error will occur;
include $(__AB_ENV_DIR__)/$(__AB_TARGET_ARCH__).mk


#----------------------------------------------------------------------- cleanup

#All used variables are undefined;
undefine __AB_TARGET_ARCH__
undefine __AB_ENV_DIR__
undefine __AB_EXT_DIR__
undefine __AB_SCRIPT_BUILD_ENV__
undefine __AB_SCRIPT_EXTERNAL__
