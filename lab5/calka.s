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
prec:
	.int 1000000
.bss
    .comm result, 4
.text
    .global main
    .type main, @function
main:
   	#Obliczenie dx całki z zadaną dokładnością
	movd  end, %xmm0	          # przekazanie górnej granicy do rejestru xmm0
	subss begin, %xmm0 
	divss prec, %xmm0
    
    #Obliczanie środka prostokątów, który będzie naszym punktem odniesienia
	movl  $2, %edi
    movd %edi, %xmm1
    divss  %xmm1,%xmm0
    addss  begin, %xmm0

    #petla wykonujaca obliczenia wartosci funkcji 
    movq $0, %rbx
	movl $0, %edi
	movd %edi, %xmm2 #miejsce na wynik calkowania

loop:
    # Ilość obrotów pętli zależy od parametru przekazanego w rdi
    cmpq prec, %rbx
    je l_ex

    #obliczanie wartosci funkcji 1/x w danym punkcie 
	movl $1, %edi
   	movd %edi, %xmm1                    #zaladowanie jedynki
    divss %xmm0, %xmm1
	
	addss %xmm1, %xmm2        			    #dzielimy jedynkę przez aktualny punkt
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
