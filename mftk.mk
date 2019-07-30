#mftk.mk - mftk - GPLV3, copyleft 2019 Raphael Outhier.

#--------------------------------------------------------------------- mftk path

#Report mftk is used and provided.
MFTK := $(abspath $(lastword $(MAKEFILE_LIST)))

#------------------------------------------------------------------------- debug

#$1 : the error namespace
#$2 : the error log
define .error
$$(error In $1 - $2)
endef

#------------------------------------------------------------------------ checks

#If the variable $1 is not defined, an error related to $2 is thrown.
define .check_def
ifndef $1
$(call .error,$2,variable $1 not defined)
endif
endef

#If the variable $1 is not defined, an error related to $2 is thrown.
define .check_ndef
ifdef $1
$(call .error,$2,variable $1($($1)) already defined)
endif
endef

#If $1 is empty, is not a single word, or has leading or trailing whitespaces,
#an error related to $2 is thrown.
define .check_word
ifeq ($1,)
$(call .error,$2,empty value)
endif
ifneq ($(words $1),1)
$(call .error,$2,multi-word value ($1))
endif
ifneq (_$1_,_$(strip $1)_)
$(call .error,$2,whitespace around value ($1))
endif
endef

#If $1 is not a valid word, or contains the character '.', 
#an error related to $2 is thrown.
define .check_name
$(call .check_word,$1,$2)
ifneq ($(findstring .,$1),)
$(call .error,$2,'.' in value ($1))
endif
endef

#If $1 is not an absolute path, an error is reported relatively to context $2.
define .check_path
$(call .check_word,$1,$2)
ifeq ($(filter /%,path $1),)
$(call .error,$2, ($1) is not an absolute path))
endif
endef

#---------------------------------------------------------------------- multiple

#$1 : list of variables that must be defined
#$2 : context
define .check_defs
$(foreach TMP,$1,$(eval $(call .check_def,$(TMP),$2)))
endef

#$1 : list of variables that must be defined
#$2 : context
define .check_ndefs
$(foreach TMP,$1,$(eval $(call .check_ndef,$(TMP),$2)))
endef

#$1 : prefix of variables that must be undefined.
define .undef_all
$(foreach TMP,$(filter $1.%,$(.VARIABLES)),$$(eval undefine $(TMP)))
endef

#$1 : prefix of variables that must be printed.
define .print_all
$(foreach TMP,$(sort $(filter $1.%,$(.VARIABLES))),\
	$$(info .  $(TMP) : $$($(TMP))))
endef

#-------------------------------------------------------------------- cross make

# recursive tree-inclusion function.
# $1 : targets dependencies variables namespace.
# $2 : current target.
# $3 : external directory.
# $4 : current inclusion history.
define ._cm
$(call .check_word,$2,$0)
ifneq ($(findstring  $2 ,$4),)
$(call .error,$0,$4:$2 cyclic dependency)
endif
$$(info including $3/$2.mk)
-include $3/$2.mk
$(foreach dep,$($1.$2),$$(eval $$(call $0,$1,$(dep),$3,$4 $2)))
endef

# multi-arch makefile inclusion (cross-make).
# $1 : entry architecture.
# $2 : external directory.
define .cm

#Check the entry architecture is a valid word.
$(call .check_word,$1,$0)

#Check the external directory's path is a valid word.
$(call .check_word,$2,$0)

#Call the tree includer, targeting architectures of the arch (_a) tree.
$(call ._cm,_a,$1,$2,)

endef

#Include the arch (_a) tree.
include $(dir $(MFTK))arch.mk


$(info [MFTK] done intializing.)
