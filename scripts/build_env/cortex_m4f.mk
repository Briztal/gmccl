
#Proc compiler options;
TC_CFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

#Proc linker options
TC_LDFLAGS += --specs=nano.specs -mfloat-abi=hard -mfpu=fpv4-sp-d16



