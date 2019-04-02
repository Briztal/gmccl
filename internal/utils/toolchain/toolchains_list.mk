
#If the arm_none_eabi toolchain must be used :
ifeq ($(TC__TYPE),ARM_NONE_EABI)

$(TC__PREFIX)CC := /usr/bin/arm-none-eabi-gcc
$(TC__PREFIX)LD := /usr/bin/arm-none-eabi-ld
$(TC__PREFIX)AR := /usr/bin/arm-none-eabi-ar
$(TC__PREFIX)OC := /usr/bin/arm-none-eabi-objcopy
$(TC__PREFIX)OD := /usr/bin/arm-none-eabi-objdump
$(TC__PREFIX)RE := /usr/bin/arm-none-eabi-readelf

endif


#If the arm_none_eabi toolchain must be used :
ifeq ($(TC__TYPE),GCC_X86)

$(TC__PREFIX)CC := /usr/bin/gcc
$(TC__PREFIX)LD := /usr/bin/ld
$(TC__PREFIX)AR := /usr/bin/ar
$(TC__PREFIX)OC := /usr/bin/objcopy
$(TC__PREFIX)OD := /usr/bin/objdump
$(TC__PREFIX)RE := /usr/bin/readelf

endif



