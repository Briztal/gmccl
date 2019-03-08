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
__AB_DIR__ := $(dir $(lastword $(MAKEFILE_LIST))).


#----------------------------------------------------------------------- scripts

#If required, scripts are executed; This leads to the definition of several
# Makefile variables; See each script for detailed info;
# Scripts are :
#  - toolchain : selects the toolchain, compilation flags and memory map
#    directory for each supported architecture;
#  - external : external script, whose path is provided in the flag variable;

ifdef TOOLCHAIN_SCRIPT
include scripts/toolchain.mk
endif

ifdef EXTERNAL_SCRIPT
include $(EXTERNAL_SCRIPT)
endif


#----------------------------------------------------------------------- cleanup

#All used variables are undefined;
undefine __AB_DIR__
undefine TOOLCHAIN_SCRIPT
undefine PROCINFO_SCRIPT
undefine EXTERNAL_SCRIPT

