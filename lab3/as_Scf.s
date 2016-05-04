format_str:
	.string	"%i %f %c"
	.text
	.globl	mojScf
	.type	mojScf, @function
mojScf:
	pushq	%rbp
	movq	%rsp, %rbp
    
    pushq %rdx
    pushq %rsi
    pushq %rdi
    
    popq %rsi
    popq %rdx
    popq %rcx

	movq $format_str, %rdi
	movl $0, %eax
	call scanf
    popq %rbp
	ret

