TARGET_ARCH := teensy_35

TOOLCHAIN_SCRIPT := 1

include arch_builder.mk

.PHONY : bite
bite:
	@echo $(TC_CC)
	@echo $(TC_LD)
	@echo $(TC_AR)
	@echo $(TC_OC)
	@echo $(TC_OD)
	@echo $(TC_RD)
