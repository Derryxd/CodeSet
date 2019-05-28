#include<iostream>
#include<string>

using namespace std;

struct MyStruct
{
double height;
double weight;
int age;
};

int main()
{
//create MyStruct variable
MyStruct cp,PC;
cp = { 168.5,70.2,25 };
PC = { 175,65};
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
cout << "cp2's age is " <<cp2[0].age<<" ." << endl;
cout << "cp2's age is " <<cp2->age << " ." << endl;
cout << "cp2[1].age's age is " << cp2[1].age << " ." << endl;
cout << "cp2[1].weight's weight is " << cp2[1].weight << " ." << endl;
cout << "cp2[1].height's height is " << cp2[1].height << " ." << endl << endl;

//create MyStruct pointer array
const MyStruct *cp3[4] = {&cp,&PC,cp2,cp1};
const MyStruct (*cp5)[4] = {};
cout << "*cp3[0]'s age is " << (*cp3)[0].age << " ." << endl;
cout << "*cp3[0]'s age is " << (*cp3)->age << " ." << endl;
cout << "*cp3[0]'s age is " << cp3[0]->age << " ." << endl;
cout << "*cp3[0]'s height is " << (*cp3)->height << " ." << endl;
cout << "*cp3[0]'s age is " << cp3[0]->age << " ." << endl;
cout << "*cp3[1]'s age is " << cp3[1]->age << " ." << endl;
cout << "*cp3[2]'s age is " << cp3[2]->age << " ." << endl;
cout << "*cp3[3]'s age is " << cp3[3]->age << " ." << endl << endl;

//create MyStruct array pointer
const MyStruct **cp4 = cp3;
cout << "**cp4's age is " << (**cp4).age << " ." << endl;
cout << "**cp4's age is " << (*cp4)[0].age << " ." << endl;
cout << "**cp4's age is " <<(*(cp4+1))->age << " ." << endl;  
cout << "**cp4's age is " << (*cp4)->age << " ." << endl;
cout << "**cp4's age is " << (*cp4)->height << " ." << endl;
cout << "**cp4's age is " << (*cp4)->weight << " ." << endl;
return 0;
}