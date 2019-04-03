
#If the arm_none_eabi toolchain must be used :
ifeq ($(tc__type),ARM_NONE_EABI)

$(tc__prefix)CC := /usr/bin/arm-none-eabi-gcc
$(tc__prefix)LD := /usr/bin/arm-none-eabi-ld
$(tc__prefix)AR := /usr/bin/arm-none-eabi-ar
$(tc__prefix)OC := /usr/bin/arm-none-eabi-objcopy
$(tc__prefix)OD := /usr/bin/arm-none-eabi-objdump
$(tc__prefix)RE := /usr/bin/arm-none-eabi-readelf

endif


#If the arm_none_eabi toolchain must be used :
ifeq ($(tc__type),GCC_X86)

$(tc__prefix)CC := /usr/bin/gcc
$(tc__prefix)LD := /usr/bin/ld
$(tc__prefix)AR := /usr/bin/ar
$(tc__prefix)OC := /usr/bin/objcopy
$(tc__prefix)OD := /usr/bin/objdump
$(tc__prefix)RE := /usr/bin/readelf

endif



