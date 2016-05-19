#Zmiany
# - dopisać pobieranie dokładnosci przez paramter
#  
# Program obliczający z całkę 1/x od 0.001 do 1000 z zadaną dokładnością
# wyniki całkowania przy rozszerzonej precyzji oraz zaokragladniu do najbliższej
# są identyczne do zwracanych przez wolframalpha.com
#----------------------------------------------------------------
# Stała dokładność oraz operacje wykonywane na float
# obliczenia wykonywane są równolegle 


.data
f_string:
    .string "Calka: %f\n"
begin:
	.float 0.001
end:
	.float 1000
jeden:
    .float 1,1,1,1
zero:
    .float 0,0,0,0
dwa:
    .float 2
cztery:
    .float 4
prec3:
	.int 1000000
.bss
    .comm dx, 16
    .comm temp, 16

.text
    .global calka_SIMDf
    .type calka_SIMDf, @function

calka_SIMDf:
    pushq %rbp
    movq %rsp, %rbp
    
   	#Obliczenie dx całki z zadaną dokładnością
	movss  end, %xmm0	          # przekazanie górnej granicy do rejestru xmm0
    movss begin, %xmm1            # dolna granica  
    subss %xmm1, %xmm0            # odejmujemy dolna granice od gorej uzyskujc przedzial calkow
    cvtsi2ss prec3, %xmm1          # konwersja int na ss
	divss %xmm1, %xmm0            # dzielimy przedzial przez dokladnosc uzyskujac dx


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
    
    # Budujemy wektor przechowujacy kolejne cztery punkty dla ktorych obliczymy wart. funkcji
    
    movss cztery, %xmm5
    movss %xmm3, %xmm4
    mulss %xmm5, %xmm4

    movq $0, %rbx
int_loop:
    cmpq $4, %rbx
    je int_end

    movss %xmm0, temp(,%rbx,4)
    movss %xmm4, dx(,%rbx,4)
    addss %xmm3, %xmm1

    incq %rbx
    jmp int_loop

int_end:

    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
    movq $1000000, %rax
    shrq $2, %rax   #ilosc wymaganych obliczen zmniejszy się czterokrotnie, nalezy odpowiednio 
                    #zmodyfikowac ilosc obrotow glownej petli obliczajaccej calke (prec/4)

    movss zero, %xmm2
    movups temp, %xmm0
    movups dx, %xmm4
loop:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq %rax, %rbx
    je l_ex

    #obliczanie wartosci funkcji 1/x w danym punkcie 
    movups jeden, %xmm1
    divps %xmm0, %xmm1
    addps %xmm1, %xmm2
    addps %xmm4, %xmm0
 
    incq %rbx 
    jmp loop 

l_ex:
    #mnożenie sum przez dx i przekazanie dalej wyniku
    movups %xmm2, temp
    movups zero, %xmm0
    
    movq $0, %rbx
sum_loop: 
    cmpq $4, %rbx
    je sum_end
    addss temp(,%rbx,4), %xmm0
    incq %rbx
    jmp sum_loop 
sum_end:
   
    mulss %xmm3, %xmm0 

    movq %rbp,%rsp
    popq %rbp
    ret
