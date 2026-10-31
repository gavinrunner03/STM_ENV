# STM_ENV
STM32 Baremetal Environment Template

## Building firmware

Put C source files under `src/` and headers under `include/`. The Makefile
compiles all `.c` files in `src/` and its subdirectories with
`arm-none-eabi-gcc`.

Pass the CPU flags and linker script for your STM32 when building, for example:

```sh
make MCU_FLAGS="-mcpu=cortex-m4 -mthumb" LDSCRIPT=path/to/linker-script.ld
```

The linker script, startup code, and any required libraries are specific to
your MCU and project. The default output is `build/firmware.elf`; use `make
hex` or `make bin` to also create Intel HEX or raw binary output. Run `make
clean` to remove generated files.
