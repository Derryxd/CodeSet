//#include "mod.h"
#include <stdio.h>
int ii = 3;
int jj = 2;
extern float *__mod_MOD_at;  //用一级指针，地址连续
void use1p_() 
{
   int i,j;
   float k = 10;
   
   for (j=0; j<jj; j++) {
     for (i=0; i<ii; i++) {
      *(__mod_MOD_at+j*ii+i) = k;
      printf("use_value:   %f\t", *(__mod_MOD_at+j*ii+i) ) ;
      printf("use_address: %p\t", (__mod_MOD_at+j*ii+i) ) ;
       k++;
     }
     printf("\n");
   }
    printf("k=%f\n ",k);
          // __mod_MOD_at[0][0] = k;
}
