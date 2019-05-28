#include <cstdlib>
#include <iostream> 
#include <fstream>
#include <string>
#include <cstring>

using namespace std;

int main()
{
	string fileName,name,s_file,site_type,site_name,site_cooradinate_X, site_cooradinate_Y;
	unsigned int position_len;

	//cout << "请输入文件路径：";
	//cin>>name;
	//fileName = "E:\\信息\\"+name;
	fileName = "/THFS/home/iap-rlk-1/xzm/站资料.txt";
	ifstream  inFile;
	// ofstream  outFile("/THFS/home/iap-rlk-1/xzm/站名信息.txt",ios::app);
	ofstream  outFile("/THFS/home/iap-rlk-1/xzm/站名信息.txt",ios::ate);
	inFile.open(fileName.c_str());   //用文件输入流读入文件名为filename这个文件
									 //c_str是string类的一个函数，可以把string类型变量转换成char*变量,open()要求的是一个char*字符串

	if (!inFile) {
		cerr << "打开文件失败" << endl;
		return -1;
	}

	outFile << "站点类型" << " 站名 " << "精度 " << "纬度" << endl;
	
    if(!outFile)
    {
        cout<<"txt文件打开失败!"<<endl;
        exit(0);
    }
    while(!inFile.eof())
    {       
    	getline(inFile, s_file);  //将txt文件（infile)存入string类s_file中
        // inFile.getline(s_file);
        cout << s_file << endl;
        // outFile.write(s_file,strlen(s_file));//写二进制中，把字符串str1全部写到yyy.yyy中   
    }
    cout << s_file.size() << endl;

	// int st = s_file.find(",\"name\":\"", 0);
	// while (st<(s_file.size() - 100))    //s_file.size()用于计算s_file字符串的长度，当st小于(s_file.size() - 100)时停止循环
	// {
	// 	size_t f1 = s_file.find(",\"name\":\"", st);
	// 	size_t f2 = s_file.find("value", st);
	// 	size_t f3 = s_file.find("coordinates", st);
	// 	size_t f4 = s_file.find(",", f3);
	// 	size_t f5 = s_file.find("]}}", f3);
		
	// 	//site_type = s_file.substr(f2-4, 4);  //计算站点类型的起点、长度（一个汉字占两个字符）
	// 	site_name = s_file.substr(f1 + 9, f2 - 3-(f1+9));  //计算站名的起点、长度（一个汉字占两个字符）
	// 	site_cooradinate_X = s_file.substr(f3 + 14, f4 - (f3 + 14));//计算X坐标的起点、长度
	// 	site_cooradinate_Y = s_file.substr(f4 + 1, f5 - (f4 + 1));//计算Y坐标的起点、长度
	// 	position_len = (s_file.substr(f1, f5 - f1 + 50)).size();   //计算从position到pisition的距离
	// 	outFile  << "江阴水位站 " << site_name << " " << site_cooradinate_X << " " << site_cooradinate_Y <<endl;

	// 	st += position_len;
	// }

	inFile.close();
	outFile.close();

	return 0;
}

