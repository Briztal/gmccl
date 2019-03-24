#
# TODO Document the project;
#


#----------------------------------------------------------- prerequisites check

#TODO VARIABLES CHECKUP, CONTENT, SPACES, WORDS

#If the environment was not provided, fail;
$(eval $(call REQ_DEF_VAR,CM_ENV,cross_make))

#If the external directory was not provided, fail;
$(eval $(call REQ_DEF_VAR,CM_EXT_DIR,cross_make))

#If the target is not provided, fail;
$(eval $(call REQ_DEF_VAR,CM_TARGET,cross_make))


#TODO REMAKE THIS
__AB_IDIR__ := $(dir $(lastword $(MAKEFILE_LIST)))environments/$(CM_ENV)
__AB_EDIR__ := $(CM_EXT_DIR)


#--------------------------------------------------------------- target makefile

#Include the target makefile, that will include all internal and external
# dependencies; If the target doesn't exist, an error will occur;
include $(__AB_IDIR__)/$(CM_TARGET).mk


#----------------------------------------------------------------------- cleanup

undefine __AB_IDIR__
undefine __AB_RDIR__
