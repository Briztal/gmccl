
#If the arm_none_eabi toolchain must be used :
ifeq ($(tc.type),ARM_NONE_EABI)

$(tc.prefix)CC := /usr/bin/arm-none-eabi-gcc
$(tc.prefix)LD := /usr/bin/arm-none-eabi-ld
$(tc.prefix)AR := /usr/bin/arm-none-eabi-ar
$(tc.prefix)OC := /usr/bin/arm-none-eabi-objcopy
$(tc.prefix)OD := /usr/bin/arm-none-eabi-objdump
$(tc.prefix)RE := /usr/bin/arm-none-eabi-readelf

endif


#If the arm_none_eabi toolchain must be used :
ifeq ($(tc.type),GCC_X86)

$(tc.prefix)CC := /usr/bin/gcc
$(tc.prefix)LD := /usr/bin/ld
$(tc.prefix)AR := /usr/bin/ar
$(tc.prefix)OC := /usr/bin/objcopy
$(tc.prefix)OD := /usr/bin/objdump
$(tc.prefix)RE := /usr/bin/readelf

endif



