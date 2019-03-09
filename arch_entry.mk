#----------------------------------------------------------- prerequisites check

#If the target architecture is not provided, fail;
ifndef TARGET_ARCH
$(error The target architecture has not been provided)
endif

#If the arch builder root directory was not provided, fail;
ifndef __AB_DIR__
$(error The path of the arch builder root directory has not been provided)
endif

#If the external directory was not provided, fail;
ifndef __EDIR__
$(error The path of the external directory has not been provided)
endif

#------------------------------------------------------------ internal directory

#Define the arch internal directory;
__IDIR__ := $(__AB_DIR__)/arch


#--------------------------------------------------------------- target makefile

#Include the target arch makefile, that will include all internal and external
# dependencies;
#If the target doesn't exist, an error will occur;
include $(__IDIR__)/$(TARGET_ARCH).mk


#----------------------------------------------------------------------- cleanup

# TARGET_ARCH and __EDIR__ are undefined after each arch inclusion;
undefine __EDIR__
