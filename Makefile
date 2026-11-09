# Makefile for UFCFWK-15-2 Worksheet 1 (An echo of Assembler)
#
#   make          build every program (same as "make all")
#   make task1    build a single program
#   make clean    remove object files and executables

CC       := gcc
NASM     := nasm
SRC      := src
# We build 32-bit binaries on a 64-bit machine
CFLAGS   := -m32
# 32-bit ELF object files; -I lets %include "asm_io.inc" be found in src/
ASMFLAGS := -f elf -I$(SRC)/

PROGS   := task1 task1_2 task2_welcome task2_sum task2_range
TARGETS := $(addprefix $(SRC)/,$(PROGS))

.PHONY: all clean $(PROGS)

# Default rule: build everything
all: $(TARGETS)

# "make task1" etc. as shorthand for "make src/task1"
$(PROGS): %: $(SRC)/%

# Link: program object + C driver + I/O library -> executable
$(TARGETS): $(SRC)/%: $(SRC)/%.o $(SRC)/driver.o $(SRC)/asm_io.o
	$(CC) $(CFLAGS) $^ -o $@

# Assemble: every .asm file depends on asm_io.inc, which it %includes
$(SRC)/%.o: $(SRC)/%.asm $(SRC)/asm_io.inc
	$(NASM) $(ASMFLAGS) $< -o $@

# Compile the C driver
$(SRC)/driver.o: $(SRC)/driver.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(SRC)/*.o $(addprefix $(SRC)/,$(PROGS))
