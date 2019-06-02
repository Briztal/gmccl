#mftk.mk - mftk - GPLV3, copyleft 2019 Raphael Outhier;


#------------------------------------------------------------------------- debug

#$1 : the error namespace
#$2 : the error log
define mftk.error
$$(error In $1 - $2)
endef

#--------------------------------------------------------------------- mftk init

#If mftk has already been provided :
ifndef __MFTK__

#Log
$(info [MFTK] initializing the environment.)

#Report mftk is used and provided;
__MFTK__ := $(abspath $(lastword $(MAKEFILE_LIST)))

else

#If the previous definition was at another location;
ifneq ($(abspath $(lastword $(MAKEFILE_LIST))),$(__MFTK__))

#Fail, this should not happen.
$(error [MFTK] : previous initialization was at another location)

endif

#Log
$(info [MFTK] re-initializing the environment.)

endif

#------------------------------------------------------------------- directories

#Determine mftk's internal directory
mftk.internal_dir := $(dir $(__MFTK__))internal

#Determine the working directory;
.wdir := $(abspath .)

#Update the working directory variable;
define mftk.update_wdir
.wdir := $$(abspath .)
endef

#------------------------------------------------------------------------ checks

#If the variable $1 is not defined, an error related to $2 is thrown;
define mftk.check.def
ifndef $1
$(call mftk.error,$2,variable $1 not defined)
endif
endef

#If the variable $1 is not defined, an error related to $2 is thrown;
define mftk.check.ndef
ifdef $1
$(call mftk.error,$2,variable $1($($1)) already defined)
endif
endef

#If $1 is not defined or empty, an error related to $2 is thrown;
define mftk.check.nempty
ifeq ($1,)
$(call mftk.error,$2,value $1($($1)) already defined)
endif
endef


#If $1 is empty, is not a single word, or has leading or trailing whitespaces,
#an error related to $2 is thrown;
define mftk.check.word
ifeq ($1,)
$(call mftk.error,$2,empty value)
endif
ifneq ($(words $1),1)
$(call mftk.error,$2,multi-word value ($1))
endif
ifneq (_$1_,_$(strip $1)_)
$(call mftk.error,$2,whitespace around value ($1))
endif
endef

#If $1 is not a valid word, or contains the character '.', 
#an error related to $2 is thrown;
define mftk.check.name
$(call mftk.check.word,$1,$2,$3)
ifneq ($(findstring .,$1),)
$(call mftk.error,$2,'.' in value ($1))
endif
endef

#If variable whose name is $1 does not contain an absolute path, an error is
# reported relatively to context $2;
define mftk.check.path
$(call mftk.check.word,$1,$2.$0,variable $1)
ifeq ($(filter /%,path $($1)),)
$(call mftk.error,$2,value does not contain an absolute path ($($1)))
endif
endef

#---------------------------------------------------------------

#$1 : name
#$2 : expected vars list
#$3 : error context
define mftk.exec_entry
$(eval $(call mftk.print_namespace,$1))
$(eval $(call mftk.check.namespace,$1,$2,$3))
endef

#$1 : name
#$2 : expected vars list
define mftk.util.entry
$(call mftk.exec_entry,$1, $2, $0)
endef

#$1 : name
#$2 : expected vars list
define mftk.node.entry
$(call mftk.exec_entry,$1, $2, $0)
endef

#--------------------------------------------------------------- build utilities

define mftk.undefine_namespace
$(foreach TMP,$(filter $1.%,$(.VARIABLES)),$$(eval undefine $(TMP)))
endef

define mftk.print_namespace
$(foreach TMP,$(sort $(filter $1.%,$(.VARIABLES))),$$(info .  $(TMP) : $$($(TMP))))
endef

#$1 : namespace
#$2 : list of required variables
#$3 : context
define mftk.check.namespace
$(foreach TMP,$2,$(eval $(call mftk.check.def,$1.$(TMP),$3)))
endef

#----------------------------------------------------------------- namespace ops

# Registers a makefile by defining its path variable;
#
# parameters :
# 1 : the name of the utility;
# 2 : the path to the utility's entry makefile;
define mftk.utility.register

#Check that the utility name is a valid name;
$(call mftk.check.name,$1,$0)

#Check that the makefile path is a valid word;
$(call mftk.check.word,$2,$0)

#Check that the utility's entry makefile path variable is not defined;
$(call mftk.check.ndef,mftk.utils.$1.path,$0)

#Initialize the couple of variables;
mftk.utils.$1.path := $2

endef

# Fails if a makefile utility is not registered, by checking if a path variable
# has been defined for the provided utility name;
# parameters :
# 1 : the name of the utility;
define mftk.utility.require

#Check that the utility name is a valid name;
$(call mftk.check.name,$1,$0))

#If the utility path is not defined, fail;
$(call mftk.check.def,mftk.utils.$1.path,\
  in $0 : utility $1 not registered;)

endef

#Register build utilities;
include $(mftk.internal_dir)/auto_utils.mk

# Defines a variable in the namespace of an utility;
# parameters
# 1 : the name of the utility;
# 2 : the name of the variable;
# 3 : the value of the variable;
define mftk.utility.define

#Check that the utility name is a valid word;
$(call mftk.check.word,$1,$0)

#Check that the utility exists;
$(call mftk.check.def,mftk.utils.$1.path,$0)

#Check that the variable name is a valid word;
$(call mftk.check.word,$2,$0)

#Check that the variable don't already exist;
$(call mftk.check.ndef,$2,$0)

#Check that the variable value is not empty;
$(call mftk.check.nempty,$3,$0)

#define the variable;
$1.$2 := $3

endef

# Includes the makefile of the utility, and undefines all variables in the
# namespace of this utility;
#
# parameters :
# 1 : the name of the utility;
define mftk.utility.execute

#Check that the utility name is a valid word;
$(call mftk.check.word,$1,$0,utility name)

#Check that the utility exists;
$(call mftk.check.def,mftk.utils.$1.path,$0)

#Log;
$$(info [MFTK] entering utility $1)

#include the entry makefile of the utility;
include $(mftk.utils.$1.path)/$1.mfu

#Log;
$$(info [MFTK] leaving utility $1)

#Undefine all variables in the list;
$(call mftk.undefine_namespace,$1)

endef

#------------------------------------------------------------------- build nodes

# Registers a build node by defining its parh variable;
#
# parameters :
# 1 : the name of the node;
# 2 : the path to the node's entry makefile;
define mftk.node.register

#Check that the node name is a valid word;
$(call mftk.check.word,$1,$0,node name)

#Check that the makefile path is a valid word;
$(call mftk.check.word,$2,$0,makefile path)

#Check that the node is not already defines;
$(call mftk.check.ndef,mftk.nodes.$1.path,$0)

#Define the path variable;
mftk.nodes.$1.path := $2

endef

#Register build nodes;
include $(mftk.internal_dir)/auto_nodes.mk

# Adds a variable definition in a node for a given execution by defining the
# variable in the namespace of the node's execution id;;
#
# parameters :
# 1 : the name of the node;
# 2 : the node's execution identifier;
# 3 : the name of the variable to define;
# 4 : the value of the variable to define;
define mftk.node.define

#Check that the node name is a valid word;
$(call mftk.check.word,$1,$0,node name)

#Check that the execution identifier is a valid word;
$(call mftk.check.word,$2,$0,execution identifier)

#Check that the variable name is a valid word;
$(call mftk.check.word,$3,$0,variable name)

#Check that the node is registered;
$(call mftk.check.def,mftk.nodes.$1.path,$0)

#Check that the variable does not exist;
$(call mftk.check.ndef,$1.$2.$3,$0)

#Define the variable;
$1.$2.$3 := $4

endef

# Executes all possible name checks before calling a build node;
#
# parameters :
# 1 : the name of the node;
# 2 : the node's execution identifier;
define mftk.node.execute_check

#Check that the node name is a valid word;
$(call mftk.check.word,$1,$0,node name)

#Check that the execution identifier is a valid word;
$(call mftk.check.word,$2,$0,execution identifier)

#Check that the node is registered;
$(call mftk.check.def,mftk.nodes.$1.path,$0)

endef

# Calls a build node, providing definitions in the required list;
# calls the previous check function before, and calls a sub make;
# This function is made to be called from a rule;
# Only the sub make call command is displayed;
#
# parameters :
# 1 : the name of the node;
# 2 : the node's execution identifier;
# 3 : the name of the rule to execute;
# 4 : optional make parameters;
define mftk.node.execute
$(eval $(call mftk.node.execute_check,$1,$2))
@echo
@echo [MFTK] entering module $1.
$(MAKE) -C $(mftk.nodes.$1.path) -f $1.mfn $3 $4 __MFTK__='$(__MFTK__)'\
 $(foreach TMP,$(filter $1.$2.%,$(.VARIABLES)),$(subst .$2,,$(TMP))='$($(TMP))')
@echo [MFTK] leaving module $1.
endef

#----------------------------------------------------------------- undefinitions

#Registration macros are not to be used anymore;
undefine mftk.utility.register
undefine mftk.node.register

#The root directory is not to be used anymore;
undefine mftk.internal_dir

#----------------------------------------------------------------- undefinitions

$(info [MFTK] done intializing.)
