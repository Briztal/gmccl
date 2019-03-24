

#----------------------------------------------------------- prerequisites check
#TODO VARIABLES CHECKUP, CONTENT, SPACES, WORDS

#If the target was not provided, fail;
$(eval $(call REQ_DEF_VAR,AI__TARGET,build_base))


#---------------------------------------------------------------- variables init

#All variables updated by the script are reset;
MEM_FLASH_ORIGIN :=
MEM_FLASH_SIZE :=
MEM_RAM_ORIGIN :=
MEM_RAM_SIZE :=
PROC_IBUS_SIZE :=
PROC_DBUS_SIZE :=
PROC_ENDIANNESS :=


#--------------------------------------------------------------- local variables

#Our curent directory;
AI__CDIR := $(dir $(lastword $(MAKEFILE_LIST)))


#--------------------------------------------------------------- cross make call

#Cross make is used, with the arch environment;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__ENV,arch))

#Provide the external directory;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__EXT_DIR,$(AI__CDIR).))

#Transfer the target;
$(eval $(call UTIL_DEF_VAR,cross_make,CM__TARGET,$(AI__TARGET)))

#Call cross make;
$(eval $(call UTIL_CALL,cross_make))


#---------------------------------------------------------- arch variables check


#Memory related variables must have been defined;

ifndef MEM_FLASH_ORIGIN
$(error makefiles did not define the flash origin)
endif

ifndef MEM_FLASH_SIZE
$(error makefiles did not define the flash size)
endif

ifndef MEM_RAM_ORIGIN
$(error makefiles did not define the ram origin)
endif

ifndef MEM_RAM_SIZE
$(error makefiles did not define the ram size)
endif


#Proc related variables must have been defined;

ifndef PROC_IBUS_SIZE
$(error makefiles did not define the instruction bus size)
endif

ifndef PROC_DBUS_SIZE
$(error makefiles did not define the data bus size)
endif

ifndef PROC_ENDIANNESS
$(error makefiles did not define the processor endianness)
endif


#----------------------------------------------------------------------- cleanup

undefine AI__CDIR
