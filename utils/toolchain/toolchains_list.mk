
#If the arm_none_eabi toolchain must be used :
ifeq ($(TC__TYPE),ARM_NONE_EABI)

CC := /usr/bin/arm-none-eabi-gcc
LD := /usr/bin/arm-none-eabi-ld
AR := /usr/bin/arm-none-eabi-ar
OC := /usr/bin/arm-none-eabi-objcopy
OD := /usr/bin/arm-none-eabi-objdump
RE := /usr/bin/arm-none-eabi-readelf

endif



