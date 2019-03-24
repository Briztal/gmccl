
include mftk.mk

$(eval $(call UTIL_DEF_VAR,toolchain,TC__TARGET,teensy_35))

$(eval $(call UTIL_CALL,toolchain))


$(eval $(call UTIL_DEF_VAR,arch_info,AI__TARGET,teensy_35))

$(eval $(call UTIL_CALL,arch_info))


all:

	@echo $(CC)
	@echo $(LD)
	@echo $(AR)
	@echo $(OC)
	@echo $(OD)
	@echo $(RD)
	@echo $(CFLAGS)
	@echo $(LDFLAGS)
	@echo $(MEM_FLASH_ORIGIN)
	@echo $(MEM_FLASH_SIZE)
	@echo $(MEM_RAM_ORIGIN)
	@echo $(MEM_RAM_SIZE)
	@echo $(PROC_ENDIANNESS)
	@echo $(PROC_IBUS_SIZE)
	@echo $(PROC_DBUS_SIZE)
