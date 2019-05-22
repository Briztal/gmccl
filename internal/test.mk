
include ../mftk.mk

$(eval $(call mftk.utility.define,toolchain,tc__target,teensy_35))

$(eval $(call mftk.utility.execute,toolchain))


$(eval $(call mftk.utility.define,arch_info,ai__target,teensy_35))

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
