#include <stdio.h>
#include "rdtsc.c"

double calka_SIMDd();
float  calka_SIMDf();
float calka_sf();
double calka_sd();

double calka_s(int dokladnosc);
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
    double duration, start, end, wynikd;
    double sumDuration = 0;
    float wynikf = 0;
    int i;

	printf("\n");
	printf("PC: single precision\n");
	duration = getDurationAVG(1);
  	printf("Duration: %f\n", duration);	
	printf("\n");
	printf("PC: double precision\n");
	duration = getDurationAVG(2);
  	printf("Duration: %f\n\n", duration);	

    // Obliczenia dla SIMD double
    sumDuration = 0;
	for (i = 0; i < 100; i++){
	    start = rdtsc();
        wynikd = calka_SIMDd();
	    end = rdtsc();
	    sumDuration += end - start;
	}
    printf("\nSIMD (double) cykle: %f", sumDuration/100), 
    printf("\nWynik: %f", wynikd);    
    // Obliczenia dla SIMD float 
    sumDuration = 0;
	for (i = 0; i < 100; i++){
	    start = rdtsc();
        wynikf = calka_SIMDf();
	    end = rdtsc();
	    sumDuration += end - start;
	}
    printf("\nSIMD (float) cykle: %f", sumDuration/100), 
    printf("\nWynik: %f", wynikf);    
    // Obliczenia dla SSE double
    sumDuration = 0;
	for (i = 0; i < 100; i++){
	    start = rdtsc();
        wynikd = calka_sd();
	    end = rdtsc();
	    sumDuration += end - start;
	}
    printf("\nSSE (double) cykle: %f", sumDuration/100), 
    printf("\nWynik: %f", wynikd);    
    // Obliczenia dla SSE float
    sumDuration = 0;
	for (i = 0; i < 100; i++){
	    start = rdtsc();
        wynikf = calka_sf();
	    end = rdtsc();
	    sumDuration += end - start;
	}
    printf("\nSSE (float) cykle: %f", sumDuration/100), 
    printf("\nWynik: %f\n", wynikf);    
}

