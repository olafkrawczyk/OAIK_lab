#Zmiany
# - dopisać pobieranie dokładnosci przez paramter
#  
# Program obliczający z całkę 1/x od 0.001 do 1000 z zadaną dokładnością
# wyniki całkowania przy rozszerzonej precyzji oraz zaokragladniu do najbliższej
# są identyczne do zwracanych przez wolframalpha.com

.data
f_string:
    .string "Calka: %f\n"
begin:
	.float 0.001
end:
	.float 1000
.bss
    .comm result, 4
.text
    .global calka_s
    .type calka_s, @function
calka_s:
   	#Obliczenie dx całki z zadaną dokładnością
	fld  end	          # przekazanie górnej granicy
	fsub begin	          # odejmujemy początek od końca uzyskując przedział
    pushq %rdi            # przekazanie do funkcji dokladnosci podanej w parametrze
    fildq (%rsp)          # przekazujemy dokładność do FPU przez pamięć
	popq %r15
    fdivrp %st(0), %st(1)  # dzielenie dlugosci przedzialu przez dokladnosc, rozdzielczosc
                           # dx przechowywana jest w rejestrze R7 fpu
    
    #Obliczanie środka prostokątów, który będzie naszym punktem odniesienia
    pushq $2
    fildq (%rsp)
    popq %r15
    fdivr %st(1),%st(0)
    fadd begin

    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
    fldz            #miejsce na wynik koncowy na stosie jednostki fpu

loop:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq %rdi, %rbx
    je l_ex

    #obliczanie wartosci funkcji 1/x w danym punkcie 
    fld1                    #zaladowanie jedynki
    fdiv %st(2)             #dzielimy jedynkę przez aktualny punkt
    faddp %st(0), %st(1)    #uzyskany wynik dodajemy do otrzymanych wczescniej
    fld %st(2)               
    faddp %st(0), %st(2)    #zwiekszamy punkt w ktorym wyliczamy wartosc calki o dx
 
    incq %rbx 
    jmp loop 

l_ex:
    #mnożenie sum przez dx i przekazanie dalej wyniku
    fmul %st(2), %st(0)
    fsts result             # obliczoną wartość całki przekazujemy do bufora
    movss result, %xmm0     # przenosimy wynik do xmm0, tak żeby wypisać go printf'em
    cvtps2pd %xmm0, %xmm0   # magiczne konwersje
    finit                   # przywrócenie stanu FPU
    ret
