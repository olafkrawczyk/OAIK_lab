#PRZEZNACZENIE PROGRAMU:
# Program konwertuje liczbę podaną przez użytownika (z STDIN) z postaci szesnastkowej
# do postaci binarnej
##############################
# Stałe wykorzysane w programie
SYS_EXIT = 1
SYS_WRITE = 1
SYS_READ = 3 
EXIT_SUCC = 0
STDOUT = 1
STDIN = 0

.data
.equ HEXBUFLN, 64 # długość przyjmowanej liczby hex
.equ BINBUFLN, 256 # bufor wyjściowy przeznaczony na postać binarną 4 razy większy
                   # ponieważ na jeden znak w hex przypadają 4 w kodzie binarnym
#Sekcja buforów

.bss
.comm HEXBUF, HEXBUFLN  # Bufor do którego wpiszemy pobrane dane 
.comm BINBUF, BINBUFLN  # Bufor wyjściowy

.text
.global _start
_start:
    # Główna funkcja programu
    # Wykorzystane rejestry:
    # %eax przechowuje ilość znaków które należy przetworzyć
    # %edi przechowuje indeksy znaków z bufora wejściowego
    # %r15d zawiera indeksy z bufora wyjściowego
    # %14d przechowuje rozmiar bufora wyjściowego


    #Wczytujemy liczbę z STDIN
    movl $SYS_READ, %eax    #wywołanie systemowego read
    movl $STDIN, %ebx       #źródło stdin
    movl $HEXBUF, %ecx      #bufor do którego wczytujemy
    movl $HEXBUFLN, %edx    #ilosc wczytanych znakow
    int $0x80
    
    decl %eax      # dekrementujemy wartość rejestru %eax, tak aby nie brać pod uwagę
                   # znaku nowej linii \n
    movl %eax, %edi #kopiujemy wartość rejestru eax do e
                   # W r15d, r14d przechowujemy dlugosc slowa wyjsciowego
    movl %eax, %r9d # zapisujemy eax
    imull $4, %eax # mnożymy ilość przyjętych znaków, tak żeby odpowiadała ilości
                   # znaków przekodowanej postaci
    movl %eax, %r15d  #do wyliczania miejsca w buforze wyj
    decl %r15d #zachowujemy indeksy w buforze wyjsciowym
    movl %eax, %r14d  # dla funkcji wypisujacej
    movl %r9d, %eax #odzyskujemy eax
    decl %edi   # czyszczenie edi, edi jako iterator
    loop:
        # Pętla przechodząca wspak przez kolejne wpisane znaki
        # od pobranej wartości odejmujemy $0x30 w celu określenia czy mamy do czynienia
        # z liczbą (0..9) czy literą. 
        # Jeżeli badany znak jest literą (A..F) należy dodatkowo odjąć $7
        # aby uzyskać wartość liczbową odpowiadającą literze w hex np. A = 10
        #Używane rejestry:
        # %edi zawiera aktualnie badany indeks
        # %bl aktualnie badany znak
        cmpl $0, %eax
        je exit

        movb HEXBUF(,%edi,1), %bl
        subb $0x30, %bl
        cmpb $9, %bl    # sprawdzamy czy mamy do czynienia z cyfra czy litera
        movl $0, %r8d   # zerujemy licznik obrotow petli dzielacej /2
        jg pre_litera
   cyfra:
        # Dla każdego zbadanego znaku wykonujemy 4 przesunięcia bitowe w prawo
        # odpowiada to dzieleniu przez 2. Wartość przesuniętego bitu odpowiada 
        # wartośći flagi przeniesienia. Fakt ten wykorzystujemy do wypisania 1 lub 0
        # w buforze wyjściowym
        cmpl $4, %r8d
        je next  # po wykonaniu czterech iteracji pobieramy następną liczbę
        shrb %bl # przesunięcie bitowe w prawo
        jc jeden
   zero:
        # Instrukcje w zero, jeden mają identyczną konstrukcję. Różnią się jedynie
        # wpisywaną wartością do rejestru odpowiednio 0 i 1. Instrukcje przenoszą
        # jeden bajt o odpowiedniej wartości do bufora wyjściowego. Wpisywanie odbywa 
        # się od końca, tj. miejsce o indeksie 0 zostanie zapełnione w ostatnim kroku
        movb $'0', BINBUF(,%r15d,1)
        decl %r15d # dekrementacja licznika indeksów
        incl %r8d  # inkrementacja licznika zliczającego ilość przesunięć bitowych
        jmp cyfra 
   jeden:
        movb $'1', BINBUF(,%r15d,1)
        decl %r15d
        incl %r8d
        jmp cyfra
   pre_litera: # Uzyskanie odpowiedniej wartości dla znaku
        subb $7, %bl  # uzyskujemy wartość 10 dla A, 11 dla B itd.
        jmp cyfra     # po uzyskaniu wartości odpowiadającej literze możemy ją
                      # potraktować jak cyfrę wykonując te same kroki
   next:
        decl %eax
        decl %edi
        jmp loop
   exit:
        movb $'\n', BINBUF(,%r14d,1)
        incl %r14d
        movq $SYS_WRITE, %rax
        movq $STDOUT, %rdi
        movq $BINBUF, %rsi
        movq %r14, %rdx
        syscall
        
    movl $SYS_EXIT, %eax
    movl $EXIT_SUCC, %ebx
    int $0x80

