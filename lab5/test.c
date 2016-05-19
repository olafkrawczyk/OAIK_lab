#include <stdio.h>

double calka_SIMDd();
float calka_SIMDf();
float calka_sf();
double calka_sd();

int main()
{
    double result_sd;
    float  result_sf;
    double result_SSEsd;
    float  result_SSEsf;
  
    result_sd = calka_SIMDd();
    printf("Calka SIMD sd: %f\n", result_sd);

    result_sf = calka_SIMDf();
    printf("Calka SIMD sf: %f\n", result_sf);
    result_SSEsd = calka_sd();
    printf("Calka sd: %f\n", result_SSEsd);
    result_SSEsf = calka_sf();
    printf("Calka sf: %f\n", result_SSEsf);
}
