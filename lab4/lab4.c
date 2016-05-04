#include <stdio.h>

double calka_s(int dokladnosc);
void set_fpu(int tryb, int tryb_zaokr);
unsigned short get_fpu();


int main( int argc, char * argv[]){
    double ret_val;
    int i,j,k;
    unsigned short fpucw;

    for (i = 100; i < 1000000001; i *= 10){
       printf("---------------\n");
       printf("Ilosc przedzialow: %d\n", i);
       for(j = 1; j < 5; j++){ 
        switch(j){
            case 1:
                printf("RD: Round to nearest\n");
                break;
            case 2:
                printf("RD: Round to down\n");
                break;
            case 3:
                printf("RD: Round to up\n");
                break;
            case 4:
                printf("RD: Truncate\n");
                break;
        }
       for(k = 1; k < 4; k++){ 
        switch(k){
            case 1:
                printf("\tPC: single precision\n");
                set_fpu(j,k);
                break;
            case 2:
                printf("\tPC: double precision\n");
                set_fpu(j,k);
                break;
            case 3:
                printf("\tPC: Double extended\n");
                set_fpu(j,k);
                break;
        }
        fpucw = get_fpu();
        ret_val = calka_s(i);
        printf("\t\tCalka: %f\n", ret_val);
        printf("\t\tFPU CW: %04hx\n", fpucw);  
       }
       }

    }
}
