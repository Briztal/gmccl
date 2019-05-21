#------------------------------------------------------------------- directories

#Report mftk is used and provided;
export __MFTK__ := $(lastword $(MAKEFILE_LIST))

#Determine mftk's internal directory
__MFTK_IDIR__ =  $(dir $(__MFTK__))internal

#TODO USE $0 INSTEAD OF FUNCTION NAME 
#TODO USE $0 INSTEAD OF FUNCTION NAME 
#TODO USE $0 INSTEAD OF FUNCTION NAME 
#TODO USE $0 INSTEAD OF FUNCTION NAME 
#TODO USE $0 INSTEAD OF FUNCTION NAME 
#TODO USE $0 INSTEAD OF FUNCTION NAME 


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
mftk.require_defined = $(call mftk.ndef_error,$1,In $2 : variable $1 not defined)

#If the variable $1 is defined, specific error message;
mftk.require_undefined = $(call mftk.def_error,$1,In $2 : variable $1 already defined)

#If $1 is empty, is not a single word, or has leading or trailing whitespaced,
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

define mftk.undefine_var
undefine $1
endef

define mftk.undefine_list
$(foreach TMP,$($1),$(eval $(call mftk.undefine_var,$(TMP))))
endef

# Registers a makefile utility;
#
# parameters :
#  1 : the name of the utility;
#  2 : the path to the utility's entry makefile;
#
# defined vars :
#  __UTIL_$1_PATH__
#  __UTIL_$1__VARS__

define mftk.utility.register

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,mftk.utility.register,utility name)

#Check that the makefile path is a valid word;
$(call mftk.check_word,$2,mftk.utility.register,makefile path)

#Check that the utility's entry makefile path variable is not defined;
$(call mftk.require_undefined,__UTIL_$1_PATH__,mftk.utility.register)

#Check that the utility's variable list is not defined;
$(call mftk.require_undefined,__UTIL_$1_NAMES__,mftk.utility.register)

#Initialize the couple of variables;
__UTIL_$1_PATH__ := $2
__UTIL_$1_NAMES__ :=

endef

# Fails if a makefile utility is not registered;
#
# parameters :
#  1 : the name of the utility;
#
# used vars :
#  __UTIL_$1_PATH__
define mftk.utility.require

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,mftk.utility.require,utility name))

#If the utility path is not defined, fail;
$(call mftk.require_defined,__UTIL_$1_PATH__,in mftk.utility.require : module $1 not registered;)

endef

#Register build utilities;
include $(__MFTK_IDIR__)/auto_utils.mk


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
define mftk.utility.define_var

#Check that the utility name is a valid word;
$(call mftk.check_word,$1,mftk.utility.define_var,utility name)

#Check that the utility exists;
$(call mftk.require_defined,__UTIL_$1_PATH__,mftk.utility.define_var)

#Check that the variable name is a valid word;
$(call mftk.check_word,$2,mftk.utility.define_var,variable name)

#Check that the variable don't already exist;
$(call mftk.require_undefined,$2,mftk.utility.define_var)

#Check that the variable value is not empty;
$(call mftk.empty_error,$2,mftk.utility.define_var,variable value)

#Add the variable to the utility's variable list;
__UTIL_$1_NAMES__ += $2

#define the variable;
$2 := $3

endef

# Execute a makefile utility;
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
define mftk.utility.execute

#Check that the utility name is a valid word;
$(call mftk.check_word,$1,mftk.utility.execute,utility name)

#Check that the utility exists;
$(call mftk.require_defined,__UTIL_$1_PATH__,mftk.utility.execute)

#include the entry makefile of the utility;
include $(__UTIL_$1_PATH__)

#If the utility's variable list is not empty :
ifneq ($(__UTIL_$1_NAMES__),)

#Undefine all variables in the list; Eval ensures that it is done sequentially;
$$(eval $$(call mftk.undefine_list,__UTIL_$1_NAMES__))

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

define mftk.node.register

#Check that the node name is a valid word;
$(call mftk.check_word,$1,mftk.node.register,node name)

#Check that the makefile path is a valid word;
$(call mftk.check_word,$2,mftk.node.register,makefile path)

#Check that the node is not already defines;
$(call mftk.require_undefined,__NODE_$1_PATH__,mftk.node.register)

#Define the path variable;
__NODE_$1_PATH__ := $2

endef


#Register build nodes;
include $(__MFTK_IDIR__)/auto_nodes.mk

#Registration macros are useless now, they are undefined;
undefine mftk.node.register



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
#  __NODE_$1_PATH__ : the node's entry makefile path;
#  __NODE_$1_$2_NAMES__ : the list of variables names;
#  __NODE_$1_$2_DEFS__ : the list of variables definitions;
#
define mftk.node.define_var

#Check that the node name is a valid word;
$(call mftk.check_word,$1,mftk.node.define_var,node name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$2,mftk.node.define_var,variabel set name)

#Check that the variable name is a valid word;
$(call mftk.check_word,$3,mftk.node.define_var,variable name)

#Check that the node is registered;
$(call mftk.require_defined,__NODE_$1_PATH__,mftk.node.define_var)

#Check that the variable does not exist;
ifneq ($(findstring $3,__NODE_$1_$2_NAMES__),)
$$(error in mftk.node.define_var : variable $3 already defined))
endif

#Check that the variable value is not empty;
$(call mftk.empty_error,$4,mftk.node.define_var,variable value)

#If the names list doesn't exist, define it;
ifndef __NODE_$1_$2_NAMES__
__NODE_$1_$2_NAMES__ :=
endif

#If the def list doesn't exist, define it;
ifndef __NODE_$1_$2_DEFS__
__NODE_$1_$2_DEFS__ :=
endif

#Add the variable name to the names list;
__NODE_$1_$2_NAMES__ += $3

#Add the variable definition to the def list;
__NODE_$1_$2_DEFS__ += $3=$4

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
define mftk.node.check

#Check that the node name is a valid word;
$(call mftk.check_word,$1,mftk.node.call,node name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$2,mftk.node.call,variabel set name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$3,mftk.node.call,variabel name)

#Check that the node is registered;
$(call mftk.require_defined,__NODE_$1_PATH__,mftk.node.call)

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
define mftk.node.call
$(eval $(call mftk.node.check,$1,$2,$3))
$(MAKE) -f $(__NODE_$1_PATH__) $2 $(__NODE_$1_$3_DEFS__) $4
endef


#----------------------------------------------------------------- Undefinitions
#Registration macros are not to be used anymore;
undefine mftk.utility.register
undefine mftk.node.register

#The root directory is not to be used anymore;
undefine __MFTK_IDIR__
