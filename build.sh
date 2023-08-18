#!/bin/bash
sudo apt-get install mtools
GCC_CROSSCOMPILER="/home/paul/Desktop/x86_64-gcc-13.2.0-nolibc-x86_64-linux/gcc-13.2.0-nolibc/x86_64-linux/bin/x86_64-linux-gcc"
nasm -felf32 Bootstrap.asm -o Bootstrap.o
"$GCC_CROSSCOMPILER"-c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
gcc --no-pie -m32 -c -ffreestanding  Kernel.c -o Kernel.o
gcc -T linker.ld -o myos.bin --no-pie -m32 -ffreestanding -O2 -nostdlib Bootstrap.o Kernel.o
if grub-file --is-x86-multiboot myos.bin; then
  echo multiboot confirmed
  mkdir -p isodir/boot/grub
  cp myos.bin isodir/boot/myos.bin
  cp grub.cfg isodir/boot/grub/grub.cfg
  grub-mkrescue -o myos.iso isodir
else
  echo the file is not multiboot
fi
qemu-system-i386 -cdrom myos.iso