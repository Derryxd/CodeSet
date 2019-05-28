//#include "mod.h"
#include <stdio.h>
extern int ii ;
extern int jj ;
//extern float __mod_MOD_at[2][3];  //编译正确，但结果会产生错误，原因未知
extern float **__mod_MOD_at;        //编译正确，但会产生段错误  
void use2p_() 
{
   int i,j;
   float k = 100;
   
   for (j=0; j<jj; j++) {
     for (i=0; i<ii; i++) {
      *(*(__mod_MOD_at+j)+i) = k;
      //__mod_MOD_at[j][i] = k;
      printf("use_value:   %f\t", __mod_MOD_at[j][i] ) ;
      printf("use_address: %p\t", &__mod_MOD_at[j][i] ) ;
      //printf("use_value:   %f\t", *(*(__mod_MOD_at+j)+i) ) ;
      //printf("use_address:   %p\t",__mod_MOD_at+j*ii+i ) ;
      // __mod_MOD_at = __mod_MOD_at+1; 
       k++;
     }
     printf("\n");
   }
    printf("k=%f\n ",k);
          // __mod_MOD_at[0][0] = k;
}
