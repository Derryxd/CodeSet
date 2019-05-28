#include <cstdlib>
#include <iostream>
#include <string>

using namespace std;

struct MyStruct
{
	double height;
	double weight;
	int age;
};

int main()
{

    //a) 一个整型数（ An integer）
    int a;
    //b) 一个指向整型数的指针（ A pointer to an integer）
    int *b;
    //c) 一个指向指针的的指针，它指向的指针是指向一个整型数（ A pointer to a pointer to an integer）
    int **c;
    //d) 一个有 10 个整型数的数组（ An array of 10 integers）
    int d[10];
    //e) 一个有 10 个指针的数组，该指针是指向一个整型数的（ An array of 10 pointers to integers）
    int *e[10]
    //f) 一个指向有 10 个整型数数组的指针（ A pointer to an array of 10 integers）
    int (*f)[10];
    //g) 一个指向函数的指针，该函数有一个整型参数并返回一个整型数（ A pointer to a functionthat takes an integer as an argument and returns an integer）
    int *g(int);
    //h) 一个有 10 个指针的数组，该指针指向一个函数，该函数有一个整型参数并返回一个整型数（ An array of ten pointers to functions that take an integer argument and return an integer 
    int (*h[10])(int);

	
	//create MyStruct variable
//  MyStruct cp,PC,a,b,c,d,e,f,g,h,i,j;
	struct MyStruct cp = { 168.5,70.2,25 };
	struct MyStruct PC = { 175,65};
	struct MyStruct a = { 1,1,1 };
	struct MyStruct b = { 2,2,2 };
	struct MyStruct c = { 3,3,3 };
	struct MyStruct d = { 4,4,4 };
	struct MyStruct e = { 5,5,5 };
	struct MyStruct f = { 6,6,6 };
	struct MyStruct g = { 7,7,7 };
	struct MyStruct h = { 8,8,8 };
	struct MyStruct i = { 9,9,9 };
	struct MyStruct j = { 10,10,10 };
	cout << "Enter PC's age :";
	cin >> PC.age;
	cout << "cp's age is " << cp.age << " and PC's age is " << PC.age << " ." <<  endl;
	cout <<"cp at "<< &cp << " and PC at " << &PC<<endl;
	cout << "cp.height at " << &cp.height<<endl;
	cout << "cp.age at " << &cp.age<<endl<<endl;
	
	//create MyStruct pointer variable
	MyStruct * cp1=&cp;
	cout << "*cp's age is "<< cp1->age << " and *cp's weight is " <<cp1->weight<<" ." << endl << endl;
	
	//create MyStruct array
	MyStruct cp2[2] = {cp,PC};
	MyStruct cp22[3][5] = { { a,b,c,d,e },{ f,g,h,i,j},{ a,b,c,d,e } };
	cout << "cp2's age is " <<cp2[0].age<<" ." << endl;
	cout << "cp2's age is " <<cp2->age << " ." << endl;
	cout << "cp2[1].age's age is " << cp2[1].age << " ." << endl;
	cout << "cp2[1].weight's weight is " << cp2[1].weight << " ." << endl;
	cout << "cp2[1].height's height is " << cp2[1].height << " ." << endl << endl;
	

// 设p是指向结构体变量的数组，则可以通过以下的方式，调用指向的那个结构体中的成员：
// （1）结构体变量.成员名。如，stu.num。
// （2）(*p).成员名。如，(*p).num。
// （3）p->成员名。如，p->num。

	//create MyStruct pointer array
	const MyStruct *cp3[4] = {&cp,&PC,cp2,cp1};
	const MyStruct(*cp5)[5];
	cp5 = cp22;
	cp5++;
	cout << "*cp5[0]'s age is " << (*cp5)[0].age << '.' << endl;			
	cout << "*cp5[1]'s age is " << (*cp5)[1].age << '.' << endl;	  		
	cout << "*cp5[1]'s age is " << cp5[1]->age << " ." << endl;			
	cout << "*cp5[0]'s age is " << (*cp5)->age << " ." << endl;			
	cout << "*cp3[0]'s age is " << (*cp3)[0].age << " ." << endl;		
	cout << "*cp3[0]'s age is " << (*cp3)->age << " ." << endl;			
	cout << "*cp3[0]'s age is " << cp3[0]->age << " ." << endl;			
	cout << "*cp3[0]'s height is " << (*cp3)->height << " ." << endl;	
	cout << "*cp3[0]'s age is " << cp3[0]->age << " ." << endl;
	cout << "*cp3[1]'s age is " << cp3[1]->age << " ." << endl;
	cout << "*cp3[2]'s age is " << cp3[2]->age << " ." << endl;
	cout << "*cp3[3]'s age is " << cp3[3]->age << " ." << endl << endl;

// “->”称为指向运算符。
// p->n 得到p指向的结构体变量中的成员n的值。
// p->n++ 得到p指向的结构体变量中的成员n的值，用完该值后使它加1。
// ++p->n 得到p指向的结构体变量中的成员n的值，并使之加1，然后再使用它。

	//create MyStruct array pointer
	const MyStruct **cp4 = cp3;
	cout << "**cp4's age is " << (**cp4).age << " ." << endl;
	cout << "**cp4's age is " << (*cp4)[0].age << " ." << endl;
	cout << "**cp4's age is " <<(*(cp4+1))->age << " ." << endl;  
	cout << "**cp4's age is " << (*cp4)->age << " ." << endl;
	cout << "**cp4's age is " << (*cp4)->height << " ." << endl;
	cout << "**cp4's age is " << (*cp4)->weight << " ." << endl;

// 链表有一个“头指针”变量，图中以head表示，它存放一个地址。该地址指向一个元素。链表中的每一个元素称为“结点”，每个结点都应包括两个部分：
// 一是用户需要用的实际数据，
// 二是下一个结点的地址。

// 可以看到链表中各元素在内存中的存储单元可以是不连续的。要找某一元素，可以先找到上一个元素，根据它提供的下一元素地址找到下一个元素。
// 可以看到，这种链表的数据结构，必须利用结构体变量和指针才能实现。
// 可以声明一个结构体类型，包含两种成员，一种是用户需要用的实际数据，另一种是用来存放下一结点地址的指针变量。


	// system("pause");
	pause();
	return 0;
}