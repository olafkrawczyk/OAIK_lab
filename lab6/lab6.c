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
	int i,j;
	long long int start, stop;
	float **matrix;
	float *vec, *tmp;


	srand(time(NULL));
	
	vec = malloc(sizeof(float)*n);
	matrix = malloc(sizeof(float*)*n);
	for (i = 0; i < n; i++){
		matrix[i] = malloc(sizeof(float) *n);
	}
		
	genMatrix(matrix, n);
	genVec(vec, n);
	printMat(matrix,n);

	printf("----- normal mull ----\n");
	tmp = mullAsUsual(matrix, vec, n);
	printVec(tmp, n);
	printf("\n----- new mull ----\n");
	tmp = mullNewWay(matrix, vec, n);
	printVec(tmp, n);
	printf("\n");


	for (i = 2; i < 1025; i*2){
		for(j = 0; j < 10; j++){
			
		}
	}
}
