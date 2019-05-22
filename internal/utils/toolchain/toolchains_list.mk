
#If the arm_none_eabi toolchain must be used :
ifeq ($(toolchain.type),ARM_NONE_EABI)

$(toolchain.prefix)CC := /usr/bin/arm-none-eabi-gcc
$(toolchain.prefix)LD := /usr/bin/arm-none-eabi-ld
$(toolchain.prefix)AR := /usr/bin/arm-none-eabi-ar
$(toolchain.prefix)OC := /usr/bin/arm-none-eabi-objcopy
$(toolchain.prefix)OD := /usr/bin/arm-none-eabi-objdump
$(toolchain.prefix)RE := /usr/bin/arm-none-eabi-readelf

endif


#If the arm_none_eabi toolchain must be used :
ifeq ($(toolchain.type),GCC_X86)

$(toolchain.prefix)CC := /usr/bin/gcc
$(toolchain.prefix)LD := /usr/bin/ld
$(toolchain.prefix)AR := /usr/bin/ar
$(toolchain.prefix)OC := /usr/bin/objcopy
$(toolchain.prefix)OD := /usr/bin/objdump
$(toolchain.prefix)RE := /usr/bin/readelf

endif



