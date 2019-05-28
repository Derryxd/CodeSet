 #include <stdio.h>
int it = 3;
int jt = 2;
void findaddr_(float at[jt][it])
{
   int i,j;
   float s[2];
   float k;
   k = 0;
   s[0]=1;s[1]=2;
   //printf("%p\t%p\t\n",&s[0],&s[1]);
   for(j=0;j<jt;j++){
     for(i=0;i<it; i++){
       at[j][i] = k; 
       k++;
       printf("%p\n",&at[j][i]);
     }
  }
}
 
