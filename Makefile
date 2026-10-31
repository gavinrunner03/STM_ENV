# STM32F103C8 Blue Pill. Run with: make
# Place linker_script.ld in the project root.
.DEFAULT_GOAL := all
TARGET := firmware
BUILD := build
PREFIX ?= arm-none-eabi-
CC := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
SIZE := $(PREFIX)size

# Add CMSIS include directories here if your source uses CMSIS headers.
INCLUDES := -Iinc
CPPFLAGS += -DSTM32F103xB $(INCLUDES)
CPU := -mcpu=cortex-m3 -mthumb -mfloat-abi=soft
CFLAGS += $(CPU) -std=c11 -Og -g3 -Wall -Wextra \
          -ffunction-sections -fdata-sections -MMD -MP
ASFLAGS := $(CPU) -g3
LDSCRIPT := linker_script.ld
LDFLAGS += $(CPU) -T$(LDSCRIPT) --specs=nosys.specs \
           -Wl,--gc-sections -Wl,-Map=$(BUILD)/$(TARGET).map
LDLIBS += -Wl,--start-group -lc -lm -Wl,--end-group

# Collect files directly under src/. Supports .s and preprocessed .S.
C_SOURCES := $(wildcard src/*.c)
ASM_SOURCES := $(wildcard src/*.s)
ASMPP_SOURCES := $(wildcard src/*.S)
OBJECTS := $(patsubst src/%.c,$(BUILD)/%.o,$(C_SOURCES)) \
           $(patsubst src/%.s,$(BUILD)/%.o,$(ASM_SOURCES)) \
           $(patsubst src/%.S,$(BUILD)/%.o,$(ASMPP_SOURCES))
DEPS := $(OBJECTS:.o=.d)

.PHONY: all clean size
all: $(BUILD)/$(TARGET).elf $(BUILD)/$(TARGET).bin $(BUILD)/$(TARGET).hex

$(BUILD)/$(TARGET).elf: $(OBJECTS) $(LDSCRIPT) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) $(LDLIBS) -o $@
	$(SIZE) $@

$(BUILD)/$(TARGET).bin: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BUILD)/$(TARGET).hex: $(BUILD)/$(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

$(BUILD)/%.o: src/%.c Makefile
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: src/%.s Makefile
	mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

$(BUILD)/%.o: src/%.S Makefile
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(ASFLAGS) -MMD -MP -c $< -o $@

size: $(BUILD)/$(TARGET).elf
	$(SIZE) $<

clean:
	rm -rf $(BUILD)

-include $(DEPS)
