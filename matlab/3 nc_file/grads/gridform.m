function gridform(fid,varargin)
%grads格点数据转换函数并生成CTL文件，函数形式：
%                gridform(fid,...)
%fid为需要保存的dat数据文件位置(字符串），'...'内填写需要转换的变量，','隔开
%其中变量要求必须为按经度、纬度、层次、时次顺序排列的四维变量,且各维维数信息要求相同
%
%如果在要求ctl文件名处直接回车，则不生成ctl，生成ctl会要求获取CTL文件中变量名，运行结束后自动打开CTL文件，
%CTL文件默认设置了数据文件位置、标题、缺测数信息
%须继续在文件中填写空间维数、时次和修改标题等信息
%
%函数示例:
%gridform('D:\myitem\addtion\mytry\data.dat',uwnd,vwnd);
%>>please input the name of CTL file:D:\mytry.ctl
%>>input the variablename of NO.1:uwnd
%>>input the variablename of NO.2:vwnd
%
%本例中，函数生成在D:\myitem\addtion\mytry的二进制文件data.dat
%和D盘根目录下的CTL文件，文件中变量为uwnd和vwnd


%存储变量信息为二进制文件
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

%如果不想生成ctl，将下面的return解除注释即可
%return

%写ctl文件
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
uiopen(ctlname);%打开ctl文件
end

