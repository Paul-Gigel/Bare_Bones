MBALIGN		equ 1 << 0
MBMEMINFO	equ 1 << 1
MBFLAGS		equ MBALIGN|MBMEMINFO
MAGIC		equ 0x1BADB002
CHECKSUM	equ -(MAGIC + MBFLAGS)

SECTION .multiboot
ALIGN 4
	dd MAGIC
	dd MBFLAGS
	dd CHECKSUM

SECTION .bss
ALIGN 16						; needs to 16 bytes aligned (see System V ABI)
stack_bottom:
	resb 16384					; reserve 16 KiB
stack_top:

SECTION .text
GLOBAL _start:function (_start.end - _start)
_start:
	mov esp, stack_top				; initialize the stack
	; here is a good place for init
	EXTERN kernel_main
	call kernel_main
	cli
.hang:
	hlt
	jmp .hang
.end:
