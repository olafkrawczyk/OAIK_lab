# Algorytm postępowania w przypadku zmiany słowa sterującego FPU
# 1. Pobrać aktualne słowo sterujące
# 2. Wyzerować żądane bity np. 10 i 11 przez wykonanie operacji AND 111..00..111
# 3. Ustawienie bitów operacją OR 0000..10..00
# Instrukcje sterujące:
# fldcw - załadowanie słowa sterującego do zmiennej
# fstcw - pobranie aktualnego słowa sterującego 
#
# Pierwszy parametr funkcji w rdi:
#         1 - rd to nearest
#         2 - rd down
#         3 - rd up
#         4 - rd to zero
# Drugi parametr w rsi:
#         1 - single precision
#         2 - double precision
#         3 - extended double precision

.data
    old_cw:
        .byte 0x00, 0x00
    new_cw:
        .byte 0x00, 0x00
.text
    .globl set_fpu	
	.type	set_fpu, @function
set_fpu:
    # Zapisanie na stos rbp 
	pushq	%rbp
	movq	%rsp, %rbp
    
    # Instrukcje decyzyjne:

    cmpq $1, %rdi
    je set_rd_near
    cmpq $2, %rdi
    je set_rd_down 
    cmpq $3, %rdi
    je set_rd_up
    cmpq $4, %rdi
    je set_rd_trun
 
    set_rd_near:
        finit
        jmp set_prec

    set_rd_down:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xF3FF, %bx
         or  $0x400, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp set_prec 
    
    set_rd_up:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xF3FF, %bx
         or  $0x800, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp set_prec 
    
    set_rd_trun:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xF3FF, %bx
         or  $0xC00, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp set_prec 
    
    set_prec:

    cmpq $1, %rsi
    je set_pc_single
    cmpq $2, %rsi
    je set_pc_double 
    cmpq $3, %rsi
    je set_pc_doub_ex

    set_pc_single:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xFCFF, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp exit 

    set_pc_double:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xFCFF, %bx
         or  $0x200, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp exit 

    set_pc_doub_ex:
         fstcw old_cw 
         movw  old_cw, %bx
         and $0xFCFF, %bx
         or  $0x300, %bx
         movw %bx, new_cw
         fldcw new_cw
         jmp exit 
exit:
    popq %rbp
    ret
