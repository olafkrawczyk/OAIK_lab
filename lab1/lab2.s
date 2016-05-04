.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.bss
.comm text_buff, 1024
.comm out_str, 1024


.text
.global main

main: 
#Pobranie tekstu ze standardowego wejscia
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $text_buff, %rsi
movq $1024, %rdx

syscall



movq text_buff(,1), %rax
movq $2, %rbx
#div %rbx  

movq %rax, out_str(,1)



# Wypisywanie zawartosci out_str
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $out_str, %rsi
movq $1, %rdx

syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
