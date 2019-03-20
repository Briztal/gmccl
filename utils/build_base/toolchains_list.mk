

#If the arm_none_eabi toolchain must be used :
ifeq ($(__TC_TYPE__),ARM_NONE_EABI)

TC_CC := /usr/bin/arm-none-eabi-gcc
TC_LD := /usr/bin/arm-none-eabi-ld
TC_AR := /usr/bin/arm-none-eabi-ar
TC_OC := /usr/bin/arm-none-eabi-objcopy
TC_OD := /usr/bin/arm-none-eabi-objdump
TC_RD := /usr/bin/arm-none-eabi-readelf

endif



