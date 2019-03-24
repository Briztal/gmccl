#
# TODO Document the project;
#


#----------------------------------------------------------- prerequisites check

#TODO VARIABLES CHECKUP, CONTENT, SPACES, WORDS

#If the environment was not provided, fail;
$(eval $(call REQ_DEF_VAR,CM__ENV,cross_make))

#If the external directory was not provided, fail;
$(eval $(call REQ_DEF_VAR,CM__EXT_DIR,cross_make))

#If the target is not provided, fail;
$(eval $(call REQ_DEF_VAR,CM__TARGET,cross_make))


#TODO REMAKE THIS
CM__INT_DIR := $(dir $(lastword $(MAKEFILE_LIST)))env/$(CM__ENV)

#--------------------------------------------------------------- target makefile

#Include the target makefile, that will include all internal and external
# dependencies; If the target doesn't exist, an error will occur;
include $(CM__INT_DIR)/$(CM__TARGET).mk


#----------------------------------------------------------------------- cleanup

undefine CM__INT_DIR
