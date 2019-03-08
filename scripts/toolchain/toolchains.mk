#
# TODO DOC
#


#If the arm_none_eabi toolchain must be used :
ifeq ($(__TC_TYPE__),ARM_NONE_EABI)

# names for the compiler programs
CC := /usr/bin/arm-none-eabi-gcc
LD := /usr/bin/arm-none-eabi-ld
AR := /usr/bin/arm-none-eabi-ar
OC := /usr/bin/arm-none-eabi-objcopy
OD := /usr/bin/arm-none-eabi-objdump
RD := /usr/bin/arm-none-eabi-readelf

endif



