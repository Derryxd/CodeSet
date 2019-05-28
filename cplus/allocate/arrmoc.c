#include <math.h>
#include <stdlib.h>
#include <stdio.h>

void arrmoc_()
{
    int i,j,k;
    int r,c;   //row and column
    int block; //3th dimension
    int value = 1;
    r = 2;
    c = 3;
    block = 2;


    // three dimensional dynamic array
    // method one: 用数组指针形式申请一个三维数组
    printf("----------method one------------\n");
    int (*arr1)[c][block] = (int(*)[c][block])malloc(sizeof(int)*r*c*block);
    for( i=0;i<r;i++) {
 	for (j=0;j<c;j++) {
	    for (k=0;k<block;k++) {
                 *(*(*(arr1+i)+j)+k) = value++ ;
		 printf("values[%d][%d][%d] = %d\n",i,j,k,arr1[i][j][k]);
		 printf("&arr1[%d][%d][%d] = %p\n", i,j,k,&arr1[i][j][k]);
 	     }
	}
    }
    free(arr1);
    
    // method two: 利用三级指针申请一个三维数组。思路是先申请后分配
    printf("\n\n");
    printf("----------method two------------\n");
    int ***arr2 = NULL ;
    int **pp = NULL ; 
    int *p = NULL ;
    arr2 = (int***)malloc(r*sizeof(int**));
    pp = (int**)malloc(r*c*sizeof(int*));
    p = (int*)malloc(r*c*block*sizeof(int));
    value = 1;
    //for (i=0; i<r*c*block; i++) {
    //    printf("p=%p\n",p++);
    //}
    for (i=0;i<r;i++) { 
 	    arr2[i] = pp + i*c ; //三维元素存二维地址
	    for (j=0;j<c;j++) {
            arr2[i][j] = p + j*block; //二维元素存一维地址
         }
        p = p + r*block ; 
    }
    for (i=0;i<r;i++) {
        for (j=0;j<c;j++) {
            for (k=0;k<block;k++) {
 		*(*(*(arr2+i)+j)+k) = value++;
                printf("values[%d][%d][%d] = %d\n",i,j,k,arr2[i][j][k]);
                printf("&arr2[%d][%d][%d] = %p\n", i,j,k,&arr2[i][j][k]);
	    }
	}
    }
    //free(arr2);
    printf("p=%p\n",p);
    printf("pp=%p\n",pp);
    printf("arr2=%p\n",arr2);
    //free(pp);
    //free(p);

    // method three: 利用三级指针申请一个三维数组。思路是一边申请一边分配(地址不是连续的)  
    printf("\n\n");
    printf("----------method three------------\n");
    value = 1;
    int ***arr3 = NULL ;
    arr3 = (int***)malloc(r*sizeof(int**));
    for (i=0;i<r;i++) {
        arr3[i] = (int**)malloc(c*sizeof(int*));
        for (j=0;j<c;j++) {
            arr3[i][j] = (int*)malloc(block*sizeof(int));
        }
    }
    for (i=0;i<r;i++) {
        for (j=0;j<c;j++) {
            for (k=0;k<block;k++) { 
                *(*(*(arr3+i)+j)+k) = value++;
                printf("values[%d][%d][%d] = %d\n",i,j,k,arr3[i][j][k]);
                printf("&arr3[%d][%d][%d] = %p\n", i,j,k,&arr3[i][j][k]);
            }
        }   
    }   
    free(arr3);
    printf("\n\n");

return;
}


void arr2d_()
{
    int i,j,k;
    int r,c;   //row and column
    int block; //3th dimension
    int value = 1;
    r = 2;
    c = 3;
    block = 2;
    // 使用二级指针赋值二维动态数组
    int **a;
    a = (int**)malloc(r*sizeof(int*));
    for (i=0;i<r;i++) {
        a[i] = (int*)malloc(c*sizeof(int));
    } 
    for (i=0;i<r;i++) {
        for (j=0;j<c;j++) {
            a[i][j] = i+j;
        }
    }
    printf("value for second rank pointer:\n");
    for (i=0;i<r;i++) {
        for (j=0;j<c;j++) {
            printf("%d\t",a[i][j]);
        }
        printf("\n");
    }
   printf("address for second rank pointer:\n");
    for (i=0;i<r;i++) {
        for (j=0;j<c;j++) {
            printf("%d\t%p\t\n",i*c+j,&a[i][j]);
        }
    }
    
    //使用一级指针赋值二维动态数组
    int *b;
    b = (int*)malloc(c*r*sizeof(int));
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            b[i*c+j] = i + j;
        }
        
    }
   printf("value for first rank pointer:\n");
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            printf("%d\t",b[i*c+j]);
        }
        printf("\n");
    }
   printf("address for first rank pointer:\n");
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            printf("%d\t%p\t\n",i*c+j,&b[i*c+j]);
        }
    }

    //fix array
    int cc[r][c];
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            cc[i][j] = a[i][j];
        }
    }
   printf("value for fix array:\n");
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            printf("%d\t",cc[i][j]);
        }
        printf("\n");
    }
   printf("address for fix array:\n");
    for (i=0;i<r;i++){
        for (j=0;j<c;j++){
            printf("%d\t%p\t\n",i*c+j,&cc[i][j]);
        }
    }
   free(a);
   free(b);
}
     
