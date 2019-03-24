
include mftk.mk

$(eval $(call UTIL_DEF_VAR,toolchain,TC__TARGET,teensy_35))

$(eval $(call UTIL_CALL,toolchain))


$(eval $(call UTIL_DEF_VAR,arch_info,AI__TARGET,teensy_35))

$(eval $(call UTIL_CALL,arch_info))


all:
	@echo $(CC) $(MEM_FLASH_ORIGIN)
