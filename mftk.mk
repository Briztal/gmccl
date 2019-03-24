#------------------------------------------------------------------- directories

#Define the mftk root directory;
__MFTK_RDIR__ := $(dir $(lastword $(MAKEFILE_LIST))).


#------------------------------------------------------------------ error report

#If the variable $1 is not defined, an error is reported, printing $2
define DEF_ERROR
ifdef $1
$$(error $2)
endif
endef

#If the variable $1 is not defined, an error is reported, printing $2
define NDEF_ERROR
ifndef $1
$$(error $2)
endif
endef


#If the variable $1 is defined, specific error message;
REQ_NDEF_VAR = $(call DEF_ERROR,$1,In $2 : variable $1 already defined)

#If the variable $1 is not defined, specific error message;
REQ_DEF_VAR = $(call NDEF_ERROR,$1,In $2 : variable $1 not defined)


define WORD_CHECK
ifeq ($1,)
$$(error in $2 : empty $3)
endif
ifneq ($(words $1),1)
$$(error in $2 : multi word $3)
endif
ifneq ($1,$(strip $(1)))
$$(error in $2 : whitespace around $3)
endif
endef

#If $1 is empty, specific error message
define EMPTY_ERROR
ifeq ($1,)
$$(error in $2 : empty $3)
endif
endef

#-------------------------------------------------------------- var undefinition

define UNDEF_VAR
undefine $1

endef

define UNDEF_LIST
$(foreach TMP,$($1),$(call UNDEF_VAR,$(TMP)))
endef


#---------------------------------------------------------- utilities operations

# Registers a makefile utility;
#
# parameters :
#  1 : the name of the utility;
#  2 : the path to the utility's entry makefile;
#
# defined vars :
#  __UTIL_$1_PATH__
#  __UTIL_$1__VARS__

define UTIL_REGISTER

#Check that the utility name is a valid word;
$$(eval $$(call WORD_CHECK,$1,UTIL_REGISTER,utility name))

#Check that the makefile path is a valid word;
$$(eval $$(call WORD_CHECK,$2,UTIL_REGISTER,makefile path))

#Check that the utility's entry makefile path is not defined;
$$(eval $$(call REQ_NDEF_VAR,__UTIL_$1_PATH__,UTIL_REGISTER))

#Check that the utility's variable list is not defined;
$$(eval $$(call REQ_NDEF_VAR,__UTIL_$1_NAMES__,UTIL_REGISTER))

#Initialize the couple of variables;
__UTIL_$(1)_PATH__ := $(2)
__UTIL_$(1)_NAMES__ :=

endef


#Include the build nodes registration file;
include $(__MFTK_RDIR__)/build_utils.mk

#Registration macro is not to be used anymore;
undefine UTIL_REGISTER



# Define a variable for a makefile utility;
#  checks that the variable is not already defined, and if it is not, checks
#  that the value is empty, and if not, defines it, marks it exportable,
#  and adds it to the utility's variable list;
#
# parameters
#  1 : the name of the utility;
#  2 : the name of the variable;
#  3 : the value of the variable;
#
# defined vars :
#  $1
#
# used vars :
#  __UTIL_$1_PATH__
#  __UTIL_$1_NAMES__
#
define UTIL_DEF_VAR

#Check that the utility name is a valid word;
$$(eval $$(call WORD_CHECK,$1,UTIL_DEF_VAR,utility name))

#Check that the utility exists;
$$(eval $$(call REQ_DEF_VAR,__UTIL_$1_PATH__,UTIL_DEF_VAR))

#Check that the variable name is a valid word;
$$(eval $$(call WORD_CHECK,$2,UTIL_DEF_VAR,variable name))

#Check that the variable don't already exist;
$$(eval $$(call REQ_NDEF_VAR,$2,UTIL_DEF_VAR))

#Check that the variable value is not empty;
$$(eval $$(call EMPTY_ERROR,$2,UTIL_DEF_VAR,variable value))

#Add the variable to the utility's variable list;
__UTIL_$1_NAMES__ += $2

#define the variable;
$2 := $3

endef


# Call a makefile utility;
#  Verifies that the path variable is defined, and if so, calls a sub-make,
#  targeting the utility's entry makefile, then undefined all variables of the
#  utility;
#
# parameters :
#  1 : the name of the utility;
#
# used vars :
#  __UTIL_$1_PATH__
#  __UTIL_$1_NAMES__
#
define UTIL_CALL

#Check that the utility name is a valid word;
$$(eval $$(call WORD_CHECK,$1,UTIL_CALL,utility name))

#Check that the utility exists;
$$(eval $$(call REQ_DEF_VAR,__UTIL_$1_PATH__,UTIL_CALL))

#include the entry makefile of the utility;
include $(__UTIL_$1_PATH__)

#If the utility's variable list is not empty :
ifneq ($(__UTIL_$1_NAMES__),)

#Undefine all variables in the list;
$$(eval $$(call UNDEF_LIST,__UTIL_$1_NAMES__))

#Reset the list;
__UTIL_$1_NAMES__ :=

endif

endef


#------------------------------------------------------------------- build nodes


# Registers a build node
#
# parameters :
#  1 : the name of the node;
#  2 : the path to the node's entry makefile;
#
# used variables :
#  __NODE_$1_PATH__ : the path to the node's entry makefile;
#

define NODE_REGISTER

#Check that the node name is a valid word;
$$(eval $$(call WORD_CHECK,$1,NODE_REGISTER,node name))

#Check that the makefile path is a valid word;
$$(eval $$(call WORD_CHECK,$2,NODE_REGISTER,makefile path))

#Check that the node is not already defines;
$$(eval $$(call REQ_NDEF_VAR,__NODE_$1_PATH__,NODE_REGISTER))

#Define the path variable;
__NODE_$1_PATH__ := $2

endef


#Include the build utilities registration file;
include $(__MFTK_RDIR__)/build_nodes.mk

#Registration macros are useless now, they are undefined;
undefine NODE_REGISTER



# Adds a variable definition in a node variable set;
#  It first checks that the value of the variable to define
#  is not null, and then if required, defines names and def
#  lists, and then, saves name and definition;
#  No name must contain two consecutive double underscores (__);
#
# parameters :
#  1 : the name of the node;
#  2 : the name of the node variable set;
#  3 : the name of the variable to define;
#  4 : the value of the variable to define;
#
# used variables :
#  __NODE_$1_$2_NAMES__ : the list of variables names;
#  __NODE_$1_$2_DEFS__ : the list of variables definitions;
#
define NODE_ADD_DEF

#Check that the node name is a valid word;
$$(eval $$(call WORD_CHECK,$1,NODE_ADD_DEF,node name))

#Check that the variable set name is a valid word;
$$(eval $$(call WORD_CHECK,$2,NODE_ADD_DEF,variabel set name))

#Check that the variable set name is a valid word;
$$(eval $$(call WORD_CHECK,$3,NODE_ADD_DEF,variable name))

#Check that the node is registered;
$$(eval $$(call REQ_DEF_VAR,$3,NODE_ADD_DEF))

#Check that the variable does not exist;
$$(eval $$(call REQ_NDEF_VAR,__NODE_$1_PATH__,NODE_ADD_DEF))

#Check that the variable value is not empty;
$$(eval $$(call EMPTY_ERROR,$4,NODE_ADD_DEF,variable value))


##If the names list doesn't exist, define it;
ifndef __NODE_$1_$2_NAMES__
__NODE_$1_$2_NAMES__ :=
endif

#If the def list doesn't exist, define it;
ifndef __NODE_$1_$2_DEFS__
__NODE_$1_$2_DEFS__ :=
endif

#Add the variable name to the names list;
__NODE_$1__$2_NAMES__ += $3

#Add the variable definition to the def list;
__NODE_$1_$2_DEFS__ += $3=$(4)

endef


# Executes some checks before calling a build node;
#  Checks that names are valid, and that the node's path
#  variable exists;
#
# parameters :
#  1 : the name of the node;
#  2 : the name of the rule to execute;
#  3 : the name of the node variable set;
#
# used variables :
#  __NODE_$1_PATH__ : the path to the node's entry makefile;
#
define NODE_CALL_CHECK

#Check that the node name is a valid word;
$$(eval $$(call WORD_CHECK,$1,NODE_CALL,node name))

#Check that the variable set name is a valid word;
$$(eval $$(call WORD_CHECK,$2,NODE_CALL,variabel set name))

#Check that the variable set name is a valid word;
$$(eval $$(call WORD_CHECK,$3,NODE_CALL,variabel name))

#Check that the node is registered;
$$(eval $$(call REQ_DEF_VAR,__NODE_$1_PATH__,NODE_CALL))

endef


# Calls a build node, providing definitions in the required list;
#  calls the previous check function before, and calls a sub make;
#
#  This function is made to be called from a rule;
#  Only the sub make call command is displayed;
#
# parameters :
#  1 : the name of the node;
#  2 : the name of the rule to execute;
#  3 : the name of the node variable set;
#  4 : optional make parameters;
#
# used variables :
#  __NODE_$1_PATH__ : the path to the node's entry makefile;
#  __NODE_$1__$3_DEFS__ : the list of variables definitions;
#
define NODE_CALL
@$$(eval $$(call NODE_CALL_CHECK,$1,$2,$3))
$(MAKE) -f $(__NODE_$1_PATH__) $2 $(__NODE_$1_$3_DEFS__) $(4)
endef
