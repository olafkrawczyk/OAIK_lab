#Zmiany
# - dopisać pobieranie dokładnosci przez paramter
#  
# Program obliczający z całkę 1/x od 0.001 do 1000 z zadaną dokładnością
# wyniki całkowania przy rozszerzonej precyzji oraz zaokragladniu do najbliższej
# są identyczne do zwracanych przez wolframalpha.com
#----------------------------------------------------
# Ta wersja programu oblicza całkę przy stałej dokładności 1000000. Wersja z double
.data
f_string:
    .string "Calka: %f\n"
begin:
	.double 0.001
end:
	.double 1000
jeden:
    .double 1,1
zero:
    .double 0,0
dwa:
    .double 2
bis:
    .double 2,2
prec:
	.int 1000000
.bss
    .comm dx, 16
    .comm temp, 16
    .comm delta, 16
.text
    .global calka_SIMDd
    .type calka_SIMDd, @function
calka_SIMDd:
    pushq %rbp
    movq %rsp, %rbp
    
   	#Obliczenie dx całki z zadaną dokładnością
	movsd  end, %xmm0	          # przekazanie górnej granicy do rejestru xmm0
    movsd begin, %xmm1
    subsd %xmm1, %xmm0
    cvtsi2sd prec, %xmm1
	divsd %xmm1, %xmm0

    #Obliczanie środka prostokątów, który będzie naszym punktem odniesienia
    movsd dwa, %xmm1
    movsd %xmm0, %xmm3              #zapisanie długosci przedziału
    divsd  %xmm1,%xmm0              #dzielimy dlugosc przedzialu przez 2 
    addsd  begin, %xmm0             #dodajemy poczatek obszaru calkowania
    
    #Po tych operacjach w xmm3 przechowujemy dlugosc przedzialu, która będziemy dodawali
    #podczas kolejnych iteracji
    #W xmm0 przechowujemy srodek figury
    # w xmm1 bedziemy trzymac wartosc w aktualnie obliczonym punkcie
    # w xmm2 będzie suma obliczonych już elementów 

    # Tworzymy wektor dwuelementowy potrzebny przy 
    # temp przechowuje kolejne dwa srodki prostokatow
    # dx przechowuje szerokosci prostokatow
    movq $0, %rbx
init_loop:
    cmpq $2, %rbx
    je init_end

    movsd %xmm0, temp(,%rbx, 8)
    movsd %xmm3, dx(,%rbx,8)    
    addsd %xmm3, %xmm0
    
    incq %rbx
    jmp init_loop 

init_end:


    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
    movq $1000000, %rdi
    shrq $2, %rdi
    movupd temp, %xmm0
    movupd dx, %xmm4
    movupd bis, %xmm5
    mulpd %xmm5, %xmm4
    movupd zero, %xmm2
loop2:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq %rdi, %rbx
    je l_ex2

    #obliczanie wartosci funkcji 1/x w danym punkcie 
    movupd jeden, %xmm1
    divpd %xmm0, %xmm1
    addpd %xmm1, %xmm2
    addpd %xmm4, %xmm0
 
    incq %rbx 
    jmp loop2 

l_ex2:
    
    movq $0, %rdi
    movupd %xmm2, temp 
    movsd temp(,%rdi, 8), %xmm0
    incq %rdi
    addsd temp(,%rdi, 8), %xmm0
    mulsd %xmm3, %xmm0 
    
    movq $0, %rax
    movq %rbp,%rsp
    popq %rbp
    ret
