
#Proc compiler options;
CFLAGS += -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

#Proc linker options
LDFLAGS += --specs=nano.specs -mfloat-abi=hard -mfpu=fpv4-sp-d16



