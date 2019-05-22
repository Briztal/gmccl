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
#  mftk.utils.$1.path
#  mftk.utils.$1.names

define mftk.utility.register

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,$0,utility name)

#Check that the makefile path is a valid word;
$(call mftk.check_word,$2,$0,makefile path)

#Check that the utility's entry makefile path variable is not defined;
$(call mftk.require_undefined,mftk.utils.$1.path,$0)

#Check that the utility's variable list is not defined;
$(call mftk.require_undefined,mftk.utils.$1.names,$0)

#Initialize the couple of variables;
mftk.utils.$1.path := $2
mftk.utils.$1.names :=

endef

# Fails if a makefile utility is not registered;
#
# parameters :
#  1 : the name of the utility;
#
# used vars :
#  mftk.utils.$1.path
define mftk.utility.require

#Check that the utility name is a valid name;
$(call mftk.check_name,$1,$0,utility name))

#If the utility path is not defined, fail;
$(call mftk.require_defined,mftk.utils.$1.path,in $0 : utility $1 not registered;)

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
#  mftk.utils.$1.path
#  mftk.utils.$1.names
#
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

#Add the variable to the utility's variable list;
mftk.utils.$1.names += $2

#define the variable;
$1.$2 := $3

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
#  mftk.utils.$1.path
#  mftk.utils.$1.names
#
define mftk.utility.execute

#Check that the utility name is a valid word;
$(call mftk.check_word,$1,$0,utility name)

#Check that the utility exists;
$(call mftk.require_defined,mftk.utils.$1.path,$0)

#include the entry makefile of the utility;
include $(mftk.utils.$1.path)

#If the utility's variable list is not empty :
ifneq ($(mftk.utils.$1.names),)

#Undefine all variables in the list; Eval ensures that it is done sequentially;
$$(eval $$(call mftk.undefine_list,mftk.utils.$1.names))

#Reset the list;
mftk.utils.$1.names :=

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
#  mftk.nodes.$1.path : the path to the node's entry makefile;
#

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
#  mftk.nodes.$1.path : the node's entry makefile path;
#  mftk.nodes.$1.$2.names : the list of variables names;
#  mftk.nodes.$1.$2.defs : the list of variables definitions;
#
define mftk.node.define

#Check that the node name is a valid word;
$(call mftk.check_word,$1,$0,node name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$2,$0,variable set name)

#Check that the variable name is a valid word;
$(call mftk.check_word,$3,$0,variable name)

#Check that the node is registered;
$(call mftk.require_defined,mftk.nodes.$1.path,$0)

#Check that the variable does not exist;
ifneq ($(findstring $3,mftk.nodes.$1.$2.names),)
$$(error in $0 : variable $3 already defined))
endif

#Check that the variable value is not empty;
$(call mftk.empty_error,$4,$0,variable value)

#If the names list doesn't exist, define it;
ifndef mftk.nodes.$1.$2.names
mftk.nodes.$1.$2.names :=
endif

#Add the variable name to the names list;
mftk.nodes.$1.$2.names += $3

#Add the variable definition to the def list;
mftk.nodes.$1.$2.defs += $1.$3=$4

endef


# Executes some checks before calling a build node;
#  Checks that names are valid, and that the node's path
#  variable exists;
#
# parameters :
#  1 : the name of the node;
#  2 : the name of the node variable set;
#
# used variables :
#  mftk.nodes.$1.path : the path to the node's entry makefile;
#
define mftk.node.execute_check

#Check that the node name is a valid word;
$(call mftk.check_word,$1,$0,node name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$2,$0,variable set name)

#Check that the variable set name is a valid word;
$(call mftk.check_word,$2,$0,variable name)

#Check that the node is registered;
$(call mftk.require_defined,mftk.nodes.$1.path,$0)

endef


# Calls a build node, providing definitions in the required list;
#  calls the previous check function before, and calls a sub make;
#
#  This function is made to be called from a rule;
#  Only the sub make call command is displayed;
#
# parameters :
#  1 : the name of the node;
#  2 : the name of the node variable set;
#  3 : the name of the rule to execute;
#  4 : optional make parameters;
#
# used variables :
#  mftk.nodes.$1.path : the path to the node's entry makefile;
#  mftk.nodes.$1.$2.defs : the list of variables definitions;
#
define mftk.node.execute
$(eval $(call mftk.node.execute_check,$1,$2))
$(MAKE) -f $(mftk.nodes.$1.path) $3 $(mftk.nodes.$1.$2.defs) __MFTK__=$(__MFTK__) $4
endef


#----------------------------------------------------------------- undefinitions

#Registration macros are not to be used anymore;
#undefine mftk.utility.register
#undefine mftk.node.register

#The root directory is not to be used anymore;
#undefine __MFTK_IDIR__
