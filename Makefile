# Name of your final output binary files
TARGET = firmware

# Directory configurations
SRCDIR = src
INCDIR = inc
BUILDDIR = build

# Compiler and toolchain definitions (Matches your Docker environment)
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# Physical Microcontroller Specs (STM32F103 / Blue Pill Cortex-M3 architecture)
MCU = -mcpu=cortex-m3 -mthumb

# Compilation Flags (tells compiler where header files are, sets no optimizations for easy debugging, enables warnings)
CFLAGS = $(MCU) -I$(INCDIR) -O0 -g3 -Wall

# Linker Flags (tells compiler to use YOUR custom linker script and optimizes unused code segments)
LDFLAGS = $(MCU) -T linker_script.ld --specs=nano.specs -Wl,--gc-sections

# Automatically find all .c source files inside your src/ directory
SOURCES = $(wildcard $(SRCDIR)/*.c)

# Automatically generate matching .o object file paths inside the build/ directory
OBJECTS = $(patsubst $(SRCDIR)/%.c, $(BUILDDIR)/%.o, $(SOURCES))

# The default rule that runs when you just type 'make'
all: $(BUILDDIR)/$(TARGET).elf $(BUILDDIR)/$(TARGET).bin

# Rule 1: Compile every individual .c file into a temporary .o object file
$(BUILDDIR)/%.o: $(SRCDIR)/%.c | $(BUILDDIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule 2: Link all temporary object files together into the final execution binary using your linker script
$(BUILDDIR)/$(TARGET).elf: $(OBJECTS)
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SIZE) $@

# Rule 3: Convert that heavy execution binary into a raw, tiny .bin file you can flash to the chip
$(BUILDDIR)/$(TARGET).bin: $(BUILDDIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

# Rule 4: Create the build directory if it doesn't already exist
$(BUILDDIR):
	mkdir -p $(BUILDDIR)

# Rule 5: A clean command to wipe out all compiled files so you can start completely fresh
clean:
	rm -rf $(BUILDDIR)
