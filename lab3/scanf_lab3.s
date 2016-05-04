#Program wykorzystuje funckję scanf z biblioteki języka C
#za jej pomocą wczytuje 10 znaków z STDIN

.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
str:
	.string "%s"

hello:
.ascii "Hello wrold\n\0"

.bss
.comm scf_buf, 10
.text
.global main

main: 

movq $str, %rdi
movq $scf_buf, %rsi
movq $0, %rax
call scanf

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
