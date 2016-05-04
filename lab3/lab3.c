#include <stdio.h>
#include "rdtsc.c"
#include <time.h>
//Program uruchamia funkcje napisane w asemblerze mojPrtf oraz mojScf
//Funkcje mojPrtf oraz mojScf zawarte są w plikach .s
//mojPrtf wyswietla trzy różne typy danych (int, char, float)

// mojScf uruchamia scanf kolejno dla 
// char
// float
// int

void mojPrtf();
void mojScf(int *i, float *f, char *c);
int main(){
	long long int start, end;
	double time;
    
    int i;
    float f;
    char c;

	start = rdtsc(); // Rozpoczynamy pomiar czasu dla printf
	mojPrtf();
	end = rdtsc();	// Koniec pomiaru czasu
	time = ((double) (end - start)) / CLOCKS_PER_SEC;
	printf("Funkcja as_printf: %f ms\n", time/10);

	start = rdtsc(); // Rozpoczynamy pomiar czasu dla printf
    printf("int:\t%d\ndouble:\t%f\nchar:\t%c\n", 69, 4.666, 'c');
	end = rdtsc();	// Koniec pomiaru czasu
	time = ((double) (end - start)) / CLOCKS_PER_SEC;
	printf("Funkcja printf: %f ms\n", time/10);
	

	start = rdtsc(); // Rozpoczynamy pomiar czasu dla printf
	mojScf(&i, &f, &c);
	end = rdtsc();	// Koniec pomiaru czasu
	time = ((double) (end - start)) / CLOCKS_PER_SEC;
	printf("Funkcja scanf: %f ms\n", time/10);
    printf("Wynik scf:\nint:\t%d\ndouble:\t%f\nchar:\t%c\n", i, f, c);
    return 0;
}
