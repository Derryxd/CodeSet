//#include "mod.h"
#include <stdio.h>
extern int ii ;  //3
extern int jj ;  //2
#define kk  3    //该宏用于声明以下数组指针（注：变量以及常量均不能用于声明数组指针）
extern float (*__mod_MOD_at)[kk];     //数组指针，fortran的动态数组本质为数组指针   
void usearrp_() 
{
   int i,j;
   float k = 100;
   for (j=0; j<jj; j++) {
     for (i=0; i<ii; i++) {
      //*(*(__mod_MOD_at+j)+i) = k;   //二级指针或数组形式均有效
      __mod_MOD_at[j][i] = k;
      printf("use_value:   %f\t", __mod_MOD_at[j][i] ) ;
      printf("use_address: %p\t", &__mod_MOD_at[j][i] ) ;
      //printf("use_value:   %f\t", *(*(__mod_MOD_at+j)+i) ) ;
      k++;
     }
     printf("\n");
   }
    printf("k=%f\n ",k);
}
