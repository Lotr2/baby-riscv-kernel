#!/bin/bash
set -xue

QEMU=qemu-system-riscv32

# Path to clang and compiler flags
CC=/c/msys64/mingw64/bin/clang  # Ubuntu users: use CC=clang
CFLAGS="-std=c11 -O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fno-stack-protector -ffreestanding -nostdlib"
LDFLAGS="-m elf32lriscv -Tkernel.ld -Map=kernel.map"
# Build the kernel
$CC $CFLAGS -c -o kernel.o kernel.c
$CC $CFLAGS -c -o common.o common.c
ld.lld $LDFLAGS -o kernel.elf kernel.o common.o

# Start QEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot \
    -kernel kernel.elf