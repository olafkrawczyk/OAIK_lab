#include <stdio.h>
#include "rdtsc.c"

double calka_s(int dokladnosc);
// Parametry set fpu:
// precyzja:
// 	1 - single precision
//	2 - double prec
//	3 - extended double precision
//	tryb zaokraglen:
//	1 - round to nearest
//	2 - round to down
//	3 - round to uo
//	4 - truncate
//
void set_fpu(int tryb_zaokr, int precyzja);
unsigned short get_fpu();

const int N = 1000000;

double getDurationAVG(int precision){
	// Zwraca uśredniony wynik czasu potrzeny do obliczenia calki za pomoca fpu
	// Wynik podany jest w cyklach procesora
	// dla zadanej precyzji 1 - single 2 - double
	// Wynik jest uśredniany na podstawie 100 pomiarów
	long long int start, end;
	long long int sumDuration = 0;
    double ret_val;
	int i;
	
	for (i = 0; i < 100; i++){
	set_fpu(1, precision);
	start = rdtsc();
  	ret_val = calka_s(N);
	end = rdtsc();
	sumDuration += end - start;
	}

	printf(" Calka: %f\n", ret_val);
	double dur = (double) sumDuration/100;
	return dur;
}
int main( int argc, char * argv[]){
    double duration;
    int i;

	printf("\n");
	printf("PC: single precision\n");
	duration = getDurationAVG(1);
  	printf("Duration: %f\n", duration);	
	printf("\n");
	printf("PC: double precision\n");
	duration = getDurationAVG(2);
  	printf("Duration: %f\n\n", duration);	
}
