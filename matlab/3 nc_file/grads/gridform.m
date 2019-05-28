function gridform(fid,varargin)
%grads�������ת������������CTL�ļ���������ʽ��
%                gridform(fid,...)
%fidΪ��Ҫ�����dat�����ļ�λ��(�ַ�������'...'����д��Ҫת���ı�����','����
%���б���Ҫ�����Ϊ�����ȡ�γ�ȡ���Ρ�ʱ��˳�����е���ά����,�Ҹ�άά����ϢҪ����ͬ
%
%�����Ҫ��ctl�ļ�����ֱ�ӻس���������ctl������ctl��Ҫ���ȡCTL�ļ��б����������н������Զ���CTL�ļ���
%CTL�ļ�Ĭ�������������ļ�λ�á����⡢ȱ������Ϣ
%��������ļ�����д�ռ�ά����ʱ�κ��޸ı������Ϣ
%
%����ʾ��:
%gridform('D:\myitem\addtion\mytry\data.dat',uwnd,vwnd);
%>>please input the name of CTL file:D:\mytry.ctl
%>>input the variablename of NO.1:uwnd
%>>input the variablename of NO.2:vwnd
%
%�����У�����������D:\myitem\addtion\mytry�Ķ������ļ�data.dat
%��D�̸�Ŀ¼�µ�CTL�ļ����ļ��б���Ϊuwnd��vwnd


%�洢������ϢΪ�������ļ�
varnum=size(varargin,2);
m=size(varargin{1});
c=length(m);
p=ones(1,6);
p(4)=varnum;
if c>3
    p(1:3)=m(1:3);
    p(5:c+1)=m(4:c);
else
    p(1:c)=m; 
end
grid=nan(p);
for i=1:varnum
    grid(:,:,:,i,:,:)=varargin{i};
end
fid2=fopen(fid,'w');
fwrite(fid2,grid,'single');

%�����������ctl���������return���ע�ͼ���
%return

%дctl�ļ�
ctlname=input('please input the name of CTL file:','s');
    if isempty(ctlname)
       fclose all;
       return 
    end
ctl=fopen(ctlname,'wt');
fprintf(ctl,'dset ');
fprintf(ctl,'%s\n',fid);
fprintf(ctl,'%s \n','title my data');
fprintf(ctl,'%s \n','undef -9999.0');
fprintf(ctl,'%s ','xdef');
fprintf(ctl,'%s \n',strcat(int2str(p(1)),' linear'));
fprintf(ctl,'%s ','ydef');
fprintf(ctl,'%s \n',strcat(int2str(p(2)),' linear'));
fprintf(ctl,'%s ','zdef');
fprintf(ctl,'%s \n',strcat(int2str(p(3)),' levels'));
fprintf(ctl,'%s ','tdef');
fprintf(ctl,'%s \n',strcat(int2str(p(5)),' linear'));
fprintf(ctl,'%s ','edef');
fprintf(ctl,'%s \n',strcat(int2str(p(6)),' linear'));
fprintf(ctl,'%s ','vars');
fprintf(ctl,'%s \n',int2str(p(4)));
for i=1:p(4)
    varname=input(strcat('input the name of variable NO.',int2str(i),':'),'s');
    fprintf(ctl,'%s ',varname);
    fprintf(ctl,'%s\n',strcat(int2str(p(3)),' 99'));
end
fprintf(ctl,'%s\n','endvars');
fclose all;
uiopen(ctlname);%��ctl�ļ�
end

