__AB_TARGET_ARCH__ := teensy_35

__AB_SCRIPT_BUILD_ENV__ := 1

__AB_SCRIPT_EXTERNAL__ := ./test_.mk

include arch_builder.mk


.PHONY : test
test : test_
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
