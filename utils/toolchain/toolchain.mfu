

#----------------------------------------------------------- prerequisites check
#TODO VARIABLES CHECKUP, CONTENT, SPACES, WORDS

#If the target was not provided, fail;
$(eval $(call REQ_DEF_VAR,TC__TARGET,toolchain))


#---------------------------------------------------------------- variables init

#All variables updated by the script are reset;
TC__TYPE :=
export CC :=
export LD :=
export AR :=
export OC :=
export OD :=
export RE :=
export CFLAGS :=
export LDFLAGS :=

#--------------------------------------------------------------- local variables

#Our curent directory;
TC__CDIR := $(dir $(lastword $(MAKEFILE_LIST)))


#--------------------------------------------------------------- cross make call

#Cross make is used, with the arch environment;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__ENV,arch))

#Provide the external directory;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__EXT_DIR,$(TC__CDIR).))

#Transfer the target;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__TARGET,$(TC__TARGET)))

#Call cross make;
$(eval $(call UTIL_CALL,cross_make))


#---------------------------------------------------------- arch variables check

#Arch makefiles must mandatorily have defined the toolchain type;
ifndef TC__TYPE
$(error makefiles did not define the toolchain type)
endif



#---------------------------------------------------------- toolchain definition

#include the toolchain file, that will define all toolchain related variables;
include $(TC__CDIR)toolchains_list.mk


#-------------------------------------------------------------- toolchain checks

#arch makefiles must define the toolchain, namely :
# - CC : the C compiler;
# - LD : the elf linker;
# - AR : the elf archiver;
# - OC : (objcopy) the elf copier;
# - OD : (objdump) the elf dumper;
# - RD : (readelf) the elf reader;


ifndef CC
$(error the toolchain makefile did not define CC (C compiler))
endif

ifndef LD
$(error the toolchain makefile did not define LD (elf linker))
endif

ifndef AR
$(error the toolchain makefile did not define AR (archiver))
endif

ifndef OC
$(error the toolchain makefile did not define OC (objcopy))
endif

ifndef OD
$(error the toolchain makefile did not define OD (objdump))
endif

ifndef RE
$(error the toolchain makefile did not define RE (readelf))
endif


#----------------------------------------------------------------------- cleanup

undefine TC__CDIR
undefine TC__TYPE
