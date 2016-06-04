#include <stdio.h>
#include "rdtsc.c"
#include <stdlib.h>
#include <time.h>

const int MAX_VAL = 1000;

void genMatrix(float ** mat, int n){
	/* Funkcja wypelniajaca macierz losowymi liczbami z zakresu 0 - 
	 * MAX_VAL - 1, które rzutowane są na float
	 */
	
	int i, j;

	for (i = 0; i < n; i++){
		for (j = 0; j < n; j++){
			mat[i][j] = (float)(rand() % MAX_VAL);
		}
	}

}
void genVec(float *vec, int n){
	/* Funkcja wypełniajaca wektor losowymi liczbami z zakresu 
	 * 0 - (MAX_VAL -1)
	 *
	 */
	
	int j;
	for (j = 0; j < n; j++){
		vec[j] = (float)(rand() % MAX_VAL);
	}
}
float* mullAsUsual(float **mat, float *vec, int n){
	// Mnozenie macierzy przez wektor zgodnie z definicja
	// wiersz * kolumna 
	int i, j;
	float *result = calloc(n,sizeof(float));
	float sum = 0;

	for (i = 0; i < n; i++){
		for (j = 0; j < n; j++){
			result[i]+= mat[i][j] * vec[j];
		}
	}
	return result;
}

float * mullNewWay(float **mat, float *vec, int n){
	// Mnozenie macierzy przez wektor nowym sposobem 
	int i, j;
	float *result = calloc(n,sizeof(float));
	float sum = 0;
	
	for (i = 0; i < n; i++){
		for (j = 0; j < n; j++){
			result[j]+= mat[j][i] * vec[i];
		}
	}
	return result;
}
void printMat(float **matrix, int n){
	int i,j;
	for (i = 0; i < n; i++){
		for(j = 0; j < n; j++){
			printf("%.2f ", matrix[i][j]);
		}
		printf("\n");
	}
}

void printVec(float *vec, int n){
	int j;	
	for(j = 0; j < n; j++){
		printf("%.2f ", vec[j]);
	}
}
int main(){
	int n = 5;
	int testN = 10;
	int i,j,k;
	long long int start, stop;
    double timeNormal, timeNew; // zmienne przechowujace czasy wykonania dla mnozen
                               // w tradycyjny sposób oraz nowy
	float **matrix;
	float *vec, *tmp;


	srand(time(NULL));

    //Pętla wykonująca mnożenia dla rozmiarów 
    //od 2 do 1024  z postępem geometrycznym 2
    //

    for (j = 2; j < 2049; j*=2){
    timeNormal = 0;
    timeNew = 0;

       for(k = 0; k < 10; k++){ 
        	vec = malloc(sizeof(float)*j);
        	matrix = malloc(sizeof(float*)*j);

        	for (i = 0; i < j; i++){
        		matrix[i] = malloc(sizeof(float) *j);
        	}

        	genMatrix(matrix, j);
        	genVec(vec, j);

            start = rdtsc();
            tmp = mullAsUsual(matrix, vec, j);
            stop = rdtsc();
            timeNormal += (double)(stop - start);

            start = rdtsc();
            tmp = mullNewWay(matrix, vec, j);
            stop = rdtsc();
            timeNew += (double)(stop - start);
        }
        
       //Wyswietlenie wynikow
       
       printf("Czas wykoniania tradycyjnego mnozenia dla n = %d: \t%.2f\n",j, timeNormal/10);
       printf("Czas wykoniania nowego mnozenia dla n = %d:\t \t%.2f\n",j, timeNew/10);
       printf("\n");
    }    
		

/*	printMat(matrix,n);

	printf("----- normal mull ----\n");
	tmp = mullAsUsual(matrix, vec, n);
	printVec(tmp, n);
	printf("\n----- new mull ----\n");
	tmp = mullNewWay(matrix, vec, n);
	printVec(tmp, n);
	printf("\n");

*/

}
