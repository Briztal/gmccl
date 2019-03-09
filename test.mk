TARGET_ARCH := teensy_35

TOOLCHAIN_SCRIPT := 1

include arch_builder.mk

.PHONY : test_toolchain
test_toolchain:
	@echo $(TC_CC)
	@echo $(TC_LD)
	@echo $(TC_AR)
	@echo $(TC_OC)
	@echo $(TC_OD)
	@echo $(TC_RD)
	@echo $(TC_CFLAGS)
	@echo $(TC_LDFLAGS)
	@echo $(MEM_FLASH_ORIGIN)
	@echo $(MEM_FLASH_SIZE)
	@echo $(MEM_RAM_ORIGIN)
	@echo $(MEM_RAM_SIZE)
	@echo $(PROC_ENDIANNESS)
	@echo $(PROC_IBUS_SIZE)
	@echo $(PROC_DBUS_SIZE)
