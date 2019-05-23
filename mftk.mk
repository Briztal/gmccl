#mftk.mk - mftk - GPLV3, copyleft 2019 Raphael Outhier;

#------------------------------------------------------------------- directories

#Report mftk is used and provided;
__MFTK__ := $(lastword $(MAKEFILE_LIST))

#Determine mftk's internal directory
__MFTK_IDIR__ =  $(dir $(__MFTK__))internal

#------------------------------------------------------------------ error report

#If the variable $1 is not defined, an error is reported, printing $2
define mftk.def_error
ifdef $1
$$(error $2)
endif
endef

#If the variable $1 is not defined, an error is reported, printing $2
define mftk.ndef_error
ifndef $1
$$(error $2)
endif
endef

#If $1 is not defined or empty, specific error message
define mftk.empty_error
ifeq ($1,)
$$(error in $2 : empty $3)
endif
endef

#If the variable $1 is not defined, specific error message;
define mftk.require_defined
$(call mftk.ndef_error,$1,In $2 : variable $1 not defined)
endef

#If the variable $1 is defined, specific error message;
define mftk.require_undefined
$(call mftk.def_error,$1,In $2 : variable $1 already defined)
endef

#If $1 is empty, is not a single word, or has leading or trailing whitespaces,
# an error is reported relatively to context ($2,$3)
define mftk.check_word
ifeq ($1,)
$$(error in $2 : empty $3)
endif
ifneq ($(words $1),1)
$$(error in $2 : multi word $3)
endif
ifneq (_$1_,_$(strip $1)_)
$$(error in $2 : whitespace around $3)
endif
endef

#If $1 is not a valid word, or contains the character '.', 
# an error is reported relatively to context ($2,$3)
define mftk.check_name
$(call mftk.check_word,$1,$2,$3)
ifneq ($(findstring .,$1),)
$$(error in $2 : '.' character in $3)
endif
endef

#--------------------------------------------------------------- build utilities

define mftk.undefine_namespace
$(foreach TMP,$(filter $1.%,$(.VARIABLES)),$$(eval undefine $(TMP)))
endef

# Registers a makefile by defining its path variable;
#
# parameters :
# 1 : the name of the utility;
# 2 : the path to the utility's entry makefile;
define mftk.utility.register

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,$0,utility name)

#Check that the makefile path is a valid word;
$(call mftk.check_word,$2,$0,makefile path)

#Check that the utility's entry makefile path variable is not defined;
$(call mftk.require_undefined,mftk.utils.$1.path,$0)

#Initialize the couple of variables;
mftk.utils.$1.path := $2

endef

# Fails if a makefile utility is not registered, by checking if a path variable
# has been defined for the provided utility name;
# parameters :
# 1 : the name of the utility;
define mftk.utility.require

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,$0,utility name))

#If the utility path is not defined, fail;
$(call mftk.require_defined,mftk.utils.$1.path,\
  in $0 : utility $1 not registered;)

endef

#Register build utilities;
include $(__MFTK_IDIR__)/auto_utils.mk


# Defines a variable in the namespace of an utility;
# parameters
# 1 : the name of the utility;
# 2 : the name of the variable;
# 3 : the value of the variable;
define mftk.utility.define

#Check that the utility name is a valid word;
$(call mftk.check_word,$1,$0,utility name)

#Check that the utility exists;
$(call mftk.require_defined,mftk.utils.$1.path,$0)

#Check that the variable name is a valid word;
$(call mftk.check_word,$2,$0,variable name)

#Check that the variable don't already exist;
$(call mftk.require_undefined,$2,$0)

#Check that the variable value is not empty;
$(call mftk.empty_error,$2,$0,variable value)

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
$(call mftk.check_word,$1,$0,utility name)

#Check that the utility exists;
$(call mftk.require_defined,mftk.utils.$1.path,$0)

#include the entry makefile of the utility;
include $(mftk.utils.$1.path)

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
$(call mftk.check_word,$1,$0,node name)

#Check that the makefile path is a valid word;
$(call mftk.check_word,$2,$0,makefile path)

#Check that the node is not already defines;
$(call mftk.require_undefined,mftk.nodes.$1.path,$0)

#Define the path variable;
mftk.nodes.$1.path := $2

endef

#Register build nodes;
include $(__MFTK_IDIR__)/auto_nodes.mk



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
$(call mftk.check_word,$1,$0,node name)

#Check that the execution identifier is a valid word;
$(call mftk.check_word,$2,$0,execution identifier)

#Check that the variable name is a valid word;
$(call mftk.check_word,$3,$0,variable name)

#Check that the node is registered;
$(call mftk.require_defined,mftk.nodes.$1.path,$0)

#Check that the variable does not exist;
$(call mftk.require_undefined,$1.$2.$3,$0)

#Check that the variable value is not empty;
$(call mftk.empty_error,$4,$0,variable value)

#Define the variable;
$1.$2.$3 = $4

endef


# Executes all possible name checks before calling a build node;
#
# parameters :
# 1 : the name of the node;
# 2 : the node's execution identifier;
define mftk.node.execute_check

#Check that the node name is a valid word;
$(call mftk.check_word,$1,$0,node name)

#Check that the execution identifier is a valid word;
$(call mftk.check_word,$2,$0,execution identifier)

#Check that the node is registered;
$(call mftk.require_defined,mftk.nodes.$1.path,$0)

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

$(MAKE) -f $(mftk.nodes.$1.path) $3 $4 __MFTK__=$(__MFTK__)\
  $(foreach TMP,$(filter $1.$2.%,$(.VARIABLES)),$(subst .$2,,$(TMP))=$($(TMP)))

endef


#----------------------------------------------------------------- undefinitions

#Registration macros are not to be used anymore;
undefine mftk.utility.register
undefine mftk.node.register

#The root directory is not to be used anymore;
undefine __MFTK_IDIR__
