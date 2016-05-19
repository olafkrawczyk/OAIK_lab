#Zmiany
# - dopisać pobieranie dokładnosci przez paramter
#  
# Program obliczający z całkę 1/x od 0.001 do 1000 z zadaną dokładnością
# wyniki całkowania przy rozszerzonej precyzji oraz zaokragladniu do najbliższej
# są identyczne do zwracanych przez wolframalpha.com
#----------------------------------------------------------------
# Stała dokładność oraz operacje wykonywane na float

.data
f_string:
    .string "Calka: %f\n"
begin:
	.float 0.001
end:
	.float 1000
jeden:
    .float 1
zero:
    .float 0
dwa:
    .float 2
prec:
	.int 1000000
.bss
    .comm result, 4
.text
    .global calka_sf
    .type calka_sf, @function
calka_sf:
    pushq %rbp
    movq %rsp, %rbp
    
   	#Obliczenie dx całki z zadaną dokładnością
	movss  end, %xmm0	          # przekazanie górnej granicy do rejestru xmm0
    movss begin, %xmm1
    subss %xmm1, %xmm0
    cvtsi2ss prec, %xmm1
	divss %xmm1, %xmm0

    #Obliczanie środka prostokątów, który będzie naszym punktem odniesienia
    movss dwa, %xmm1
    movss %xmm0, %xmm3              #zapisanie długosci przedziału
    divss  %xmm1,%xmm0              #dzielimy dlugosc przedzialu przez 2 
    addss  begin, %xmm0             #dodajemy poczatek obszaru calkowania
    
    #Po tych operacjach w xmm3 przechowujemy dlugosc przedzialu, która będziemy dodawali
    #podczas kolejnych iteracji
    #W xmm0 przechowujemy srodek figury
    # w xmm1 bedziemy trzymac wartosc w aktualnie obliczonym punkcie
    # w xmm2 będzie suma obliczonych już elementów 
    # w xmm3 przechowujemy dlugosc przedzialu


    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
    movq $1000000, %rax
    movss zero, %xmm2
loop:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq %rax, %rbx
    je l_ex

    #obliczanie wartosci funkcji 1/x w danym punkcie 
    movss jeden, %xmm1
    divss %xmm0, %xmm1
    addss %xmm1, %xmm2
    addss %xmm3, %xmm0
 
    incq %rbx 
    jmp loop 

l_ex:
    #mnożenie sum przez dx i przekazanie dalej wyniku
    mulss %xmm3, %xmm2
    movss %xmm2, %xmm0
    
    movq %rbp,%rsp
    popq %rbp
    ret
