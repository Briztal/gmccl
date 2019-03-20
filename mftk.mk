

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

#If $1 is empty, an error is reported, printing $2;
define EMPTY_ERROR
ifeq ($1,)
$$(error $2)
endif
endef

#If $1 is nonempty, an error is reported, printing $2;
define NEMPTY_ERROR
ifeq ($1,)
$$(error $2)
endif
endef


#If the variable $1 is defined, specific error message;
REQ_NDEF_VAR = $(call DEF_ERROR,$1,In $2 : variable $1 already defined)

#If the variable $1 is not defined, specific error message;
REQ_DEF_VAR = $(call NDEF_ERROR,$1,In $2 : variable $1 not defined)

#If $1 is empty, specific error message;
REQ_NEMPTY = $(call EMPTY_ERROR,$1,In $2 : $1 not defined)

#If $1 is non empty, specific error message;
REQ_EMPTY = $(call NEMPTY_ERROR,$1,In $2 : variable $1 not defined)



#-------------------------------------------------------------- var undefinition

define UNDEF_VAR
undefine $1

endef

define UNDEF_LIST
$(foreach TMP,$($1),$(call UNDEF_VAR,$(TMP)))
endef


#-------------------------------------------------------------- utils operations

# Registers a makefile utility;
#
# parameters :
#  1 : the name of the utility;
#  2 : the path to the utility's entry makefile;
#
# defined vars :
#  __UTIL_$(1)___PATH__
#  __UTIL_$(1)__VARS__
#TODO MERGE CHECK ON VARIABLES (EMPTY AND ONE WORD)
define UTIL_REGISTER

#Check that the name of the utility is not empty;
ifeq ($(1),)
$$(error, In UTIL_REGISTER : empty node name)
endif

#check that the node name is valid;
ifneq ($(words $(1)),1)
$$(error in UTIL_REGISTER : invalid variable name $(2))
endif

#Check that the name of the utility is valid;
ifneq ($(findstring __,$(1)),)
$$(error In UTIL_REGISTER : double underscore in node name)
endif

#Check that the name of the makefile path is not empty;
ifeq ($(2),)
$$(error, In UTIL_REGISTER : empty path name)
endif

#Check that the utility's entry makefile path is not defined;
ifdef __UTIL_$(1)___PATH__
$$(error In UTIL_REGISTER : path variable already defined)
endif

#Check that the util variable list is not defined;
ifdef __UTIL_$(1)___NAMES__
$$(error In UTIL_REGISTER : names variable already defined)
endif

#Initialise the couple of variables;
__UTIL_$(1)___PATH__ := $(2)
__UTIL_$(1)___NAMES__ :=

endef


#Include the build nodes registration file;
include $(__MFTK_RDIR__)/build_utils.mk

#Registration macro is not to be used anymore;
undefine UTIL_REGISTER



# Define a variable for a makefile utility;
#  checks that the variable is not already defined, and if it is not, checks
#  that the value is empty, and if not, defines it, marks it exportable,
#  and adds it to the util's variable list;
#
# parameters
#  1 : the name of the util;
#  2 : the name of the variable;
#  3 : the value of the variable;
#
# defined vars :
#  $(1)
#
# used vars :
#  __UTIL_$(1)___PATH__
#  __UTIL_$(1)___NAMES__
#
define UTIL_DEF_VAR

#Check that the utility exists;
ifndef __UTIL_$(1)___PATH__
$$(error in UTIL_DEF_VAR : utility path variable not defined)
endif

#Check that the variable name is not empty
ifeq ($(2),)
$$(error in UTIL_DEF_VAR : empty variable name)
endif

#check that the variable name is valid;
ifneq ($(words $(2)),1)
$$(error in UTIL_DEF_VAR : invalid variable name $(2))
endif

#Check that the variable is not defined;
ifdef $(2)
$$(error in UTIL_DEF_VAR : variable already defined)
endif

#If the value of the variable is empty, error;
ifeq ($(3),)
$$(error in UTIL_DEF_VAR : the empty variable value)
endif

#Add the variable to the util's variable list;
__UTIL_$(1)___NAMES__ += $(2)

#define the variable;
$(2) := $(3)

endef


# Call a makefile utility;
#  Verifies that the path variable is defined, and if so, calls a sub-make,
#  targetting the util's entry makefile, then undefined all variables of the
#  util;
#
# parameters :
#  1 : the name of the util;
#
# used vars :
#  __UTIL_$(1)___PATH__
#  __UTIL_$(1)___NAMES__
#
define UTIL_CALL

#Check that the utility exists;
ifndef __UTIL_$(1)___PATH__
$$(error in UTIL_CALL : utility path variable not defined)
endif

#include the entry makefile of the utility;
include $(__UTIL_$(1)___PATH__)

#If the util's variable list is not empty :
ifneq ($(__UTIL_$(1)___NAMES__),)

#Undefine all variables in the list;
$(eval $(call UNDEF_LIST,__UTIL_$(1)___NAMES__))

#Reset the list;
__UTIL_$(1)___NAMES__ :=

endif

endef


#------------------------------------------------------------------- build nodes

#TODO CHECK FOR MULTI WORD NAMES

# Registers a build node
#
# parameters :
#  1 : the name of the node;
#  2 : the path to the node's entry makefile;
#
# used variables :
#  __NODE_$(1)___PATH__ : the path to the node's entry makefile;
#

define NODE_REGISTER

#Check that the name is not empty;
ifeq ($(1),)
$$(error In NODE_REGISTER : empty node name)
endif

#Check that the node name is valid;
ifneq ($(findstring __,$(1)),)
$$(error In NODE_REGISTER : double underscore in node name)
endif

#Check that the node is not already defined;
ifdef __NODE_$(1)___PATH__
$$(error In NODE_REGISTER : node $(1) already registered)
endif

#Check that the path is not empty;
ifneq ($(findstring __,$(1)),)
$$(error In NODE_REGISTER : empty makefile path)
endif

#Define the path variable;
__NODE_$(1)___PATH__ := $(2)

endef


#Include the build utilities registration file;
include $(__MFTK_RDIR__)/build_nodes.mk

#Registration macros are useless now, they are undefined;
undefine NODE_REGISTER



# Adds a variable definiton in a node variable set;
#  It first checks that the value of the variable to define
#  is not null, and then if required, defines names and defs
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
#  __NODE_$(1)___$(2)___NAMES__ : the list of variables names;
#  __NODE_$(1)___$(2)___DEFS__ : the list of variables definitons;
#
define NODE_ADD_DEF

#check that the variable name is valid;
ifneq ($(words $(3)),1)
$$(error In NODE_ADD_DEF : invalid variable name $(3))
endif

#Check that the value is not null;
ifeq ($(4),)
$$(error In NODE_ADD_DEF : null variable value)
endif

#Check that all variable names are valid;
ifneq ($(findstring __,$(1)$(2)$(3)),)
$$(error In NODE_ADD_DEF : double underscore in node, set or variable name)
endif

#Check that the variable does not exist;
ifneq ($(findstring $(3),$(__NODE_$(1)___$(2)___NAMES__)),)
$$(error In NODE_ADD_DEF : variable $(3) already exists)
endif

##If the names list doesn't exist, define it;
ifndef __NODE_$(1)___$(2)___NAMES__
__NODE_$(1)___$(2)___NAMES__ :=
endif

#If the defs list doesn't exist, define it;
ifndef __NODE_$(1)___$(2)___DEFS__
__NODE_$(1)___$(2)___DEFS__ :=
endif

#Add the variable name to the names list;
__NODE_$(1)__$(2)___NAMES__ += $(3)

#Add the variable definition to the def list;
__NODE_$(1)___$(2)___DEFS__ += $(3)=$(4)

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
#  __NODE_$(1)___PATH__ : the path to the node's entry makefile;
#
define NODE_CALL_CHECK

#Check that the variable does not exist;
ifneq ($(findstring __,$(1)$(2)$(3)),)
$$(error In NODE_CALL : double underscore in node, set or variable name)
endif

#If the node path variable is not defined, fail;
ifndef __NODE_$(1)___PATH__
$$(error In NODE_CALL : undefined node)
endif

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
#  __NODE_$(1)___PATH__ : the path to the node's entry makefile;
#  __NODE_$(1)__$(3)___DEFS__ : the list of variables definitons;
#
define NODE_CALL
@$(eval $(call NODE_CALL_CHECK,$(1),$(2),$(3)))
$(MAKE) -f $(__NODE_$(1)___PATH__) $(2) $(__NODE_$(1)___$(3)___DEFS__) $(4)
endef











