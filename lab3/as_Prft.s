#Funkcja wyswietlajaca trzy typy danych
#1. int, double oraz char za pomocą funkcji bibliotecznej języka C
#printf pobiera kolejno następujące parametry:
# wypisywany string zawierający specyfikatory
# liczbę typu integer wypisywaną na pierwszej pozycji
# liczbę typu double wypisywaną na drugiej pozycji 
# znak char wypisywany jako ostatni
 
str_out:
	.string	"int:\t%d\ndouble:\t%f\nchar:\t%c\n" #string formatujący wyświetlane liczby
double_out:
    .double 4.666                   #wartość double 
	
.text
	.globl	mojPrtf
	.type	mojPrtf, @function
mojPrtf:
	pushq	%rbp                    #zapisujemy wartość %rbp na stosie, żeby po wykonaniu
                                    #funkcji można było ją odzyskać
	
    movq	%rsp, %rbp              #wskaźnik stosu zapisujemy w rbp, w razie potrzeby 
                                    #posłuży nam do pobierania wartości ze stosu
	movl	$99, %edx               #przekazujemy trzeci parametr przez %edx
	movsd	double_out, %xmm0 #wartość double przekazujemy przez rejestr %xmm0, który
                                    #zgodnie z abi służy do przekazywania wartości typu float
	movl	$69, %esi               #int jako drugi argument przekazujemy przez %esi
	movl	$str_out, %edi          #string formatujący przekazujemy jako pierwszy parametr
                                    #za pomocą %edi
	movl	$1, %eax
	call	printf                  #wywołanie funkcji printf
	popq	%rbp                    #przywrócenie wartości rbp
	ret                             #skok do return adress
