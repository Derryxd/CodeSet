%Ѱ�Ҷ�����ڵ�����ֵ����������ǰ������Сʱ��ֵ�浽�����С�
%Ŀ�ģ�����Դ����ʱ�õġ��ҵ���������A�����ߵ�ʱ�̣����ҳ�ǰ��ʱ��λ����١�������ʱ��ͼ�ͷ���frequencyõ��ͼ��
data=importdata('C:\Users\lixingyu\Desktop\ᓽ�����\���ݴ���\ͬ������\4502#20170429-20171107-matlab.txt');
text=data.textdata;
number=(20:20:100);
a= text(number);
m=0;
for j=1:length(number);
    m=m+1;
    for i=1:length(text);
        if strcmpi(text{i},a{m}); %�ж��ַ����Ƿ���ȣ�text1==a������
            Lia=ismember(text,a);  %���������ҵ�ĳ�ַ�����Ӧ���±꣬����ֵΪ�߼�һά���顣����ֱ����find���ַ���
            b=find(Lia~=0);    %���������ҳ���0���±꣬��������a��λ�á�
        end
    end
end
disp(b);

%��һ�����ݷֳ�n��ʱ���
scale=6; %ʱ���Сʱ�ı���
hour=3;%ѡ��ǰ���3��Сʱ����
n=0;%��һ�����ݷֳ�n��ʱ���
for i=1:2
%     if i==1;
        if (b(i+1)-b(i))<=scale*hour;%��ⳬ����׼�ߵ�ʱ���ǲ��ǻ�������18h���ڵ�
            time1b=b(i)-18;
            time1e=b(i+1)+18;
    %         band(n+1)=n+1;
    %         n=n+1;
        else
            time1b=b(i)-18;
            time1e=b(i)+18;
            time2b=b(i)-18;
            time2e=b(i)+18;%���Ӧ�ò���������´�ѭ��ʱ�ٿ���û�к���һ�����ӵ�һ��
%             band{n+1,1}=time1b
%             band{n+1,1}=[band{2,2} time1e]
            band{n+1,1}=[time1b(1):time1e(end)];
    %         band{n+2,1}=[time2b,time1e];
    %         band(n+1)=i;
    %         n=n+1;
        end
%     end
%     if i>=1;
%         if (b(i)-b(i-1))<=scale*hour;
%             time2e=
%         end
%     end
end
  disp(band)      
        
%ʱ������timeband1��ʱ����ص�timeband2
% timeband%ѡ�����ڻ�ͼ��ʱ���


%��ÿ��ʱ��ν��и�ֵ
% for i=1:length(b)
% b(1)