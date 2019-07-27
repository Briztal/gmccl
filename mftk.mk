#_.mk - mftk - GPLV3, copyleft 2019 Raphael Outhier.


#------------------------------------------------------------------------- debug

#$1 : the error namespace
#$2 : the error log
define _.error
$$(error In $1 - $2)
endef

#--------------------------------------------------------------------- mftk init

#If mftk has already been provided :
ifndef __MFTK__

#Log
$(info [MFTK] initializing the environment.)

#Report mftk is used and provided.
__MFTK__ := $(abspath $(lastword $(MAKEFILE_LIST)))

else

#If the previous definition was at another location.
ifneq ($(abspath $(lastword $(MAKEFILE_LIST))),$(__MFTK__))

#Fail, this should not happen.
$(error [MFTK] : previous initialization was at another location)

endif

#Log
$(info [MFTK] re-initializing the environment.)

endif

#------------------------------------------------------------------- directories

#Determine mftk's internal directory
_.internal_dir := $(dir $(__MFTK__))internal

#Determine the working directory.
.wdir := $(abspath .)

#Update the working directory variable.
define _.update_wdir
.wdir := $$(abspath .)
endef

#------------------------------------------------------------------------ checks

#If the variable $1 is not defined, an error related to $2 is thrown.
define _.check.def
ifndef $1
$(call _.error,$2,variable $1 not defined)
endif
endef

#If the variable $1 is not defined, an error related to $2 is thrown.
define _.check.ndef
ifdef $1
$(call _.error,$2,variable $1($($1)) already defined)
endif
endef

#If $1 is not defined or empty, an error related to $2 is thrown.
define _.check.nempty
ifeq ($1,)
$(call _.error,$2,value $1($($1)) already defined)
endif
endef


#If $1 is empty, is not a single word, or has leading or trailing whitespaces,
#an error related to $2 is thrown.
define _.check.word
ifeq ($1,)
$(call _.error,$2,empty value)
endif
ifneq ($(words $1),1)
$(call _.error,$2,multi-word value ($1))
endif
ifneq (_$1_,_$(strip $1)_)
$(call _.error,$2,whitespace around value ($1))
endif
endef

#If $1 is not a valid word, or contains the character '.', 
#an error related to $2 is thrown.
define _.check.name
$(call _.check.word,$1,$2)
ifneq ($(findstring .,$1),)
$(call _.error,$2,'.' in value ($1))
endif
endef

#If variable whose name is $1 does not contain an absolute path, an error is
# reported relatively to context $2.
define _.check.path
$(call _.check.word,$1,$2.$0)
ifeq ($(filter /%,path $($1)),)
$(call _.error,$2,value does not contain an absolute path ($($1)))
endif
endef

#----------------------------------------------------------------------- entries

#$1 : name
#$2 : expected vars list
#$3 : error context
define _.exec_entry
$(eval $(call _.print_namespace,$1))
$(eval $(call _.check.namespace,$1,$2,$3))
endef

#$1 : name
#$2 : expected vars list
define _.util.entry
$(call _.exec_entry,$1, $2, $0)
endef

#$1 : name
#$2 : expected vars list
define _.node.entry
$(call _.exec_entry,$1, $2, $0)
endef

#----------------------------------------------------------------- namespace ops
define _.undefine_namespace
$(foreach TMP,$(filter $1.%,$(.VARIABLES)),$$(eval undefine $(TMP)))
endef

define _.print_namespace
$(foreach TMP,$(sort $(filter $1.%,$(.VARIABLES))),$$(info .  $(TMP) : $$($(TMP))))
endef

#$1 : namespace
#$2 : list of required variables
#$3 : context
define _.check.namespace
$(foreach TMP,$2,$(eval $(call _.check.def,$1.$(TMP),$3)))
endef

#-------------------------------------------------------------------- cross make

# recursive tree-inclusion function.
# $1 : targets dependencies variables namespace.
# $2 : current target.
# $3 : external directory.
# $4 : current inclusion history.
define _.cm._
$(call _.check.word,$2,$0)
ifeq ($(findstring  $2 ,$($1)),)
$(call _.error,$0,$2 is not a declared target of $1)
endif
ifneq ($(findstring  $2 ,$4),)
$(call _.error,$0,$4:$2 cyclic dependency)
endif
$$(info including $3/$2.mk)
-include $3/$2.mk
$(foreach dep,$($1.$2),$$(eval $$(call $0,$1,$(dep),$3,$4 $2)))
endef

# multi-platform makefile inclusion (cross-make).
# $1 : entry platform.
# $2 : external directory.
define _.cm

#Check the entry platform is not null.
$(call _.check.word,$1,$0)

#Path check.
$(call _.check.path,$2,$0)

#Call the tree includer, targeting platforms of the arch (_a) tree.
$(call _.cm._,_a,$1,$2,)

endef

#Include the arch (_a) tree.
include internal/arch.mk

#--------------------------------------------------------------- build utilities

# Registers a makefile by defining its path variable.
#
# parameters :
# 1 : the name of the utility.
# 2 : the path to the utility's entry makefile.
define _.utility.register

#Check that the utility name is a valid name.
$(call _.check.name,$1,$0)

#Check that the makefile path is a valid word.
$(call _.check.word,$2,$0)

#Check that the utility's entry makefile path variable is not defined.
$(call _.check.ndef,_.utils.$1.path,$0)

#Initialize the couple of variables.
_.utils.$1.path := $2

endef

# Fails if a makefile utility is not registered, by checking if a path variable
# has been defined for the provided utility name.
# parameters :
# 1 : the name of the utility.
define _.utility.require

#Check that the utility name is a valid name.
$(call _.check.name,$1,$0))

#If the utility path is not defined, fail.
$(call _.check.def,_.utils.$1.path,\
  in $0 : utility $1 not registered.)

endef

#Register build utilities.
include $(_.internal_dir)/auto_utils.mk

# Defines a variable in the namespace of an utility.
# parameters
# 1 : the name of the utility.
# 2 : the name of the variable.
# 3 : the value of the variable.
define _.utility.define

#Check that the utility name is a valid word.
$(call _.check.word,$1,$0)

#Check that the utility exists.
$(call _.check.def,_.utils.$1.path,$0)

#Check that the variable name is a valid word.
$(call _.check.word,$2,$0)

#Check that the variable don't already exist.
$(call _.check.ndef,$2,$0)

#Check that the variable value is not empty.
$(call _.check.nempty,$3,$0)

#define the variable.
$1.$2 := $3

endef

# Includes the makefile of the utility, and undefines all variables in the
# namespace of this utility.
#
# parameters :
# 1 : the name of the utility.
define _.utility.execute

#Check that the utility name is a valid word.
$(call _.check.word,$1,$0,utility name)

#Check that the utility exists.
$(call _.check.def,_.utils.$1.path,$0)

#Log.
$$(info [MFTK] entering utility $1)

#include the entry makefile of the utility.
include $(_.utils.$1.path)/$1.mfu

#Undefine all variables in the list.
$$(eval $$(call _.undefine_namespace,$1))

#Log.
$$(info [MFTK] leaving utility $1)

endef

#------------------------------------------------------------------- build nodes

# Registers a build node by defining its parh variable.
#
# parameters :
# 1 : the name of the node.
# 2 : the path to the node's entry makefile.
define _.node.register

#Check that the node name is a valid word.
$(call _.check.word,$1,$0)

#Check that the makefile path is a valid word.
$(call _.check.word,$2,$0)

#Check that the node is not already defines.
$(call _.check.ndef,_.nodes.$1.path,$0)

#Define the path variable.
_.nodes.$1.path := $2

endef

#Register build nodes.
include $(_.internal_dir)/auto_nodes.mk

# Adds a variable definition in a node for a given execution by defining the
# variable in the namespace of the node's execution id..
#
# parameters :
# 1 : the name of the node.
# 2 : the node's execution identifier.
# 3 : the name of the variable to define.
# 4 : the value of the variable to define.
define _.node.define

#Check that the node name is a valid word.
$(call _.check.word,$1,$0)

#Check that the execution identifier is a valid word.
$(call _.check.word,$2,$0)

#Check that the variable name is a valid word.
$(call _.check.word,$3,$0)

#Check that the node is registered.
$(call _.check.def,_.nodes.$1.path,$0)

#Check that the variable does not exist.
$(call _.check.ndef,$1.$2.$3,$0)

#Define the variable.
$1.$2.$3 := $4

endef

# Executes all possible name checks before calling a build node.
#
# parameters :
# 1 : the name of the node.
# 2 : the node's execution identifier.
define _.node.execute_check

#Check that the node name is a valid word.
$(call _.check.word,$1,$0)

#Check that the execution identifier is a valid word.
$(call _.check.word,$2,$0)

#Check that the node is registered.
$(call _.check.def,_.nodes.$1.path,$0)

endef

# Calls a build node, providing definitions in the required list.
# calls the previous check function before, and calls a sub make.
# This function is made to be called from a rule.
# Only the sub make call command is displayed.
#
# parameters :
# 1 : the name of the node.
# 2 : the node's execution identifier.
# 3 : the name of the rule to execute.
# 4 : optional make parameters.
define _.node.execute
$(eval $(call _.node.execute_check,$1,$2))
@echo
@echo [MFTK] entering module $1.
$(MAKE) -C $(_.nodes.$1.path) -f $1.mfn $3 $4 __MFTK__='$(__MFTK__)'\
 $(foreach TMP,$(filter $1.$2.%,$(.VARIABLES)),$(subst .$2,,$(TMP))='$($(TMP))')
@echo [MFTK] leaving module $1.
endef

#----------------------------------------------------------------- undefinitions

#Registration macros are not to be used anymore.
undefine _.utility.register
undefine _.node.register

#The root directory is not to be used anymore.
undefine _.internal_dir

#----------------------------------------------------------------- undefinitions

$(info [MFTK] done intializing.)
