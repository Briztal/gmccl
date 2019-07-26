
include ../mftk.mk

$(eval $(call mftk.utility.define,tc,target,teensy35))

$(eval $(call mftk.utility.execute,tc))


$(eval $(call mftk.utility.define,arch_info,target,teensy35))

$(eval $(call mftk.utility.execute,arch_info))


all:

	@echo $(CC)
	@echo $(LD)
	@echo $(AR)
	@echo $(OC)
	@echo $(OD)
	@echo $(RE)
	@echo $(CFLAGS)
	@echo $(LDFLAGS)
	@echo $(MEM_FLASH_ORIGIN)
	@echo $(MEM_FLASH_SIZE)
	@echo $(MEM_RAM_ORIGIN)
	@echo $(MEM_RAM_SIZE)
	@echo $(PROC_ENDIANNESS)
	@echo $(PROC_IBUS_SIZE)
	@echo $(PROC_DBUS_SIZE)
