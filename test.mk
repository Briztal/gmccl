
include mftk.mk

$(eval $(call UTIL_DEF_VAR,build_base,BB_TARGET,teensy_35))

$(eval $(call UTIL_CALL,build_base))


$(eval $(call UTIL_DEF_VAR,arch_info,AI_TARGET,teensy_35))

$(eval $(call UTIL_CALL,arch_info))


all:
	@echo $(CC) $(MEM_FLASH_ORIGIN)
