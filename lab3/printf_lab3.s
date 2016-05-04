#Program wykorzystuje funckję printf z biblioteki języka C
#za jej pomocą wypisuje na STDIN ciąg znaków Hello world

.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

hello:
.ascii "Hello wrold\n\0"

.bss

.text
.global main

main: 

movl $hello, %edi
movl $0, %eax
call printf

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
