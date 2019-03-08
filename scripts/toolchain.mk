
#The toolchain script only uses directroy inclusion;
__CED__ := 1

#Provide the external directory;
__EDIR__ := $(__AB_DIR__)/scripts/toolchain


#--------------------------------------------------------------- arch entry call

include $(__AB_DIR__)/arch_entry.mk


#---------------------------------------------------------- arch variables check

#Arch makefiles must mandatorily have defined :
# - __TC_TYPE__ : the toolchain type variable;
# - LD_MMAP_DIR : the directory where the target chip's memory map linker
#   script "memory_map.ld" resides;

ifndef __TC_TYPE__
$(error toolchain makefiles did not define the toolchain type)
endif

ifndef LD_MMAP_DIR
$(error toolchain makefiles did not define the memory map file directory)
endif


#---------------------------------------------------------- toolchain definition

#include the toolchain file, that will define all toolchain related variables;
include $(__AB_DIR__)/scripts/toolchain/toolchains_list.mk


#-------------------------------------------------------------- toolchain checks

#arch makefiles must define the toolchain, namely : 
# - TC_CC : the C compiler;
# - TC_LD : the elf linker;
# - TC_AR : the elf archiver;
# - TC_OC : (objcopy) the elf copier;
# - TC_OD : (objdump) the elf dumper;
# - TC_RD : (readelf) the elf reader;


ifndef TC_CC
$(error toolchain makefiles did not define TC_CC (compiler))
endif

ifndef TC_LD
$(error toolchain makefiles did not define TC_LD (linker))
endif

ifndef TC_AR
$(error toolchain makefiles did not define TC_AR (archiver))
endif

ifndef TC_OC
$(error toolchain makefiles did not define TC_OC (objcopy))
endif

ifndef TC_OD
$(error toolchain makefiles did not define TC_OD (objdump))
endif

ifndef TC_RD
$(error toolchain makefiles did not define TC_RD (readelf))
endif


