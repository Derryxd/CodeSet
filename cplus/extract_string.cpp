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

	//cout << "�������ļ�·����";
	//cin>>name;
	//fileName = "E:\\��Ϣ\\"+name;
	fileName = "/THFS/home/iap-rlk-1/xzm/վ����.txt";
	ifstream  inFile;
	// ofstream  outFile("/THFS/home/iap-rlk-1/xzm/վ����Ϣ.txt",ios::app);
	ofstream  outFile("/THFS/home/iap-rlk-1/xzm/վ����Ϣ.txt",ios::ate);
	inFile.open(fileName.c_str());   //���ļ������������ļ���Ϊfilename����ļ�
									 //c_str��string���һ�����������԰�string���ͱ���ת����char*����,open()Ҫ�����һ��char*�ַ���

	if (!inFile) {
		cerr << "���ļ�ʧ��" << endl;
		return -1;
	}

	outFile << "վ������" << " վ�� " << "���� " << "γ��" << endl;
	
    if(!outFile)
    {
        cout<<"txt�ļ���ʧ��!"<<endl;
        exit(0);
    }
    while(!inFile.eof())
    {       
    	getline(inFile, s_file);  //��txt�ļ���infile)����string��s_file��
        // inFile.getline(s_file);
        cout << s_file << endl;
        // outFile.write(s_file,strlen(s_file));//д�������У����ַ���str1ȫ��д��yyy.yyy��   
    }
    cout << s_file.size() << endl;

	// int st = s_file.find(",\"name\":\"", 0);
	// while (st<(s_file.size() - 100))    //s_file.size()���ڼ���s_file�ַ����ĳ��ȣ���stС��(s_file.size() - 100)ʱֹͣѭ��
	// {
	// 	size_t f1 = s_file.find(",\"name\":\"", st);
	// 	size_t f2 = s_file.find("value", st);
	// 	size_t f3 = s_file.find("coordinates", st);
	// 	size_t f4 = s_file.find(",", f3);
	// 	size_t f5 = s_file.find("]}}", f3);
		
	// 	//site_type = s_file.substr(f2-4, 4);  //����վ�����͵���㡢���ȣ�һ������ռ�����ַ���
	// 	site_name = s_file.substr(f1 + 9, f2 - 3-(f1+9));  //����վ������㡢���ȣ�һ������ռ�����ַ���
	// 	site_cooradinate_X = s_file.substr(f3 + 14, f4 - (f3 + 14));//����X�������㡢����
	// 	site_cooradinate_Y = s_file.substr(f4 + 1, f5 - (f4 + 1));//����Y�������㡢����
	// 	position_len = (s_file.substr(f1, f5 - f1 + 50)).size();   //�����position��pisition�ľ���
	// 	outFile  << "����ˮλվ " << site_name << " " << site_cooradinate_X << " " << site_cooradinate_Y <<endl;

	// 	st += position_len;
	// }

	inFile.close();
	outFile.close();

	return 0;
}

