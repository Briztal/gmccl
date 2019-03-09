#
# Variables updated by the script :

#---------------------------------------------------------------- variables init

#All variables updated by the script are reset;
TC_CC :=
TC_LD :=
TC_AR :=
TC_OC :=
TC_OD :=
TC_RE :=
TC_CFLAGS :=
TC_LDFLAGS :=
MEM_FLASH_ORIGIN :=
MEM_FLASH_SIZE :=
MEM_RAM_ORIGIN :=
MEM_RAM_SIZE :=
PROC_IBUS_SIZE :=
PROC_DBUS_SIZE :=
PROC_ENDIANNESS :=


#------------------------------------------------------------- arch_builder call

#Provide the external directory;
__EDIR__ := $(__AB_DIR__)/scripts/build_env

#Include arch_entry to initialise variables;
include $(__AB_DIR__)/arch_entry.mk


#---------------------------------------------------------- arch variables check

#Arch makefiles must mandatorily have defined the build_env type;
ifndef __TC_TYPE__
$(error makefiles did not define the toolchain type)
endif


#Flags ckecks are skipped, as flags can be null;


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


#---------------------------------------------------------- build_env definition

#include the build_env file, that will define all build_env related variables;
include $(__AB_DIR__)/scripts/build_env/toolchains_list.mk


#-------------------------------------------------------------- build_env checks


#arch makefiles must define the build_env, namely :
# - TC_CC : the C compiler;
# - TC_LD : the elf linker;
# - TC_AR : the elf archiver;
# - TC_OC : (objcopy) the elf copier;
# - TC_OD : (objdump) the elf dumper;
# - TC_RD : (readelf) the elf reader;


ifndef TC_CC
$(error the toolchain makefile did not define TC_CC (compiler))
endif

ifndef TC_LD
$(error the toolchain makefile did not define TC_LD (linker))
endif

ifndef TC_AR
$(error the toolchain makefile did not define TC_AR (archiver))
endif

ifndef TC_OC
$(error the toolchain makefile did not define TC_OC (objcopy))
endif

ifndef TC_OD
$(error the toolchain makefile did not define TC_OD (objdump))
endif

ifndef TC_RD
$(error the toolchain makefile did not define TC_RD (readelf))
endif


ifndef TC_RD
$(error the toolchain makefile did not define TC_RD (readelf))
endif

