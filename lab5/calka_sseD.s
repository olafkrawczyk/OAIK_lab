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
    .double 1
zero:
    .double 0
dwa:
    .double 2
prec2:
	.int 1000000
.bss
    .comm result, 4
.text
    .global calka_sd
    .type calka_sd, @function
calka_sd:
    pushq %rbp
    movq %rsp, %rbp
    
   	#Obliczenie dx całki z zadaną dokładnością
	movsd  end, %xmm0	          # przekazanie górnej granicy do rejestru xmm0
    movsd begin, %xmm1
    subsd %xmm1, %xmm0
    cvtsi2sd prec2, %xmm1
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

    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
    movq $1000000, %r10
    movsd zero, %xmm2
loop2:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq %r10, %rbx
    je l_ex2

    #obliczanie wartosci funkcji 1/x w danym punkcie 
    movsd jeden, %xmm1
    divsd %xmm0, %xmm1
    addsd %xmm1, %xmm2
    addsd %xmm3, %xmm0
 
    incq %rbx 
    jmp loop2 

l_ex2:
    #mnożenie sum przez dx i przekazanie dalej wyniku
    mulsd %xmm3, %xmm2
    movsd %xmm2, %xmm0
    
    movq $0, %rax

    movq %rbp,%rsp
    popq %rbp
    ret
