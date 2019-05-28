%% data
num = 1e3;  %1e4:һ����
a=repmat({'1','2','3'},[num 1]);
b=single(repmat([1/3,1/6,1/8],[num 1]));
c=b*2;
%% ��һ�ַ���:fprintf
% tic
% formatSpec = ['%s\t' repmat('%.3f\t',[1 2]) '\n'];
% for j=1:3
%     s = ['num' num2str(j) '.txt'];
%     fid=fopen(s,'w');
% %     fprintf(fid,'%s\t\n',a{:,i});             %ͷ������text
% %     fprintf(fid,'%f\t%f\n',[b(:,i) c(:,i)]);  %��������data�����
%     for i=1:num
%         fprintf(fid,'%s\t%f\t%f\n',a{i,j},b(i,j),c(i,j));
%         %or: fprintf(fid,formatSpec,a{i,j},b(i,j),c(i,j));
%     end
% end
% fclose('all');
% toc
% %Elapsed time is 0.613627 seconds.---- һ�������ʱ��(Ĭ��)
% %Elapsed time is 6.012241 seconds.---- ʮ�������ʱ��
% %Elapsed time is 58.957567 seconds.----- ���������ʱ�䣺��������
%% �ڶ��ַ���: dlmwrite or csvwrite��ʱ���ɹ�������
% tic
% for i=1:3
%     files = ['num' num2str(i*10) '.txt'];
%     %dlmwrite(filename,M,delimiter,row,col)
%     dlmwrite(files,[b(:,i) c(:,i)],'delimiter','\t','precision','%.3f','coffset',1)
%              %��tabΪ�����������ΪС��λ3λ���е�ƫ����Ϊ1���ӵڶ��п�ʼ�����
%     dlmwrite(files,char(a{:,i}),'delimiter','\t')  %�Ḳ����һ������
%              %'append' %����ò�����ֻ������һ�м������
% end
% toc
% %Elapsed time is 1.710419 seconds.---- һ���У����ʱ�䶼��ࣩ����������
%% �����ַ���:table
tic
% titles = {'date','speed','SD','turbul_select'};
titles = {'date','speed','SD'};

for i=1:1
    files = ['num' num2str(i*1000) '.txt'];
    T = cell2table([a(:,i) num2cell([b(:,i) c(:,i)])],'VariableNames',titles);
    % C=mat2cell(b,ones(sizeRow,1),ones(numVar,1));  %sizeRow=num;numVar=2;
    writetable(T,files,'Delimiter','\t')
end
toc
%Elapsed time is 0.343657 seconds.---- һ���У���������
%��ȱ�㣺
%ʱ����죬�������ռ��һЩ�ڴ�(�Һ�table����ռ�ý�cell�٣�ԼΪcell������֮һ)
%����ȱ���ǣ��������ʱ���Ƹ�ʽ��Ĭ�ϱ������7��С��
%% �����ַ���:xlswrite
%�����excelȻ�����������ת��txt��������vba��excel��д��
%����μ�IO_xls��'txt����ת��Ϊxls�����෴.doc'

%% read: or importdata
filename='string.txt';
fileID = fopen(filename);
C = textscan(fileID,repmat('%s',[1,4]));
fclose(fileID);
a=char(C{:,4});
for i=1:size(a,1)
    [~,file,suf]=fileparts(a(i,:));
    files{i}=cellstr(file);
    suffix{i}=cellstr(suf);
end
clearvars suf file

%% ��ȡ�����ĵ�txt�����ڲ��ж���ָ���
fid=fopen('11.txt','r','n','utf-8');
title = fgetl(fid);
title = split(title)';
content = textscan(fid,'%s%s','delimiter','\t');
name = content{1};
point= content{2};
point= split(cellstr(point),',');
[m,n]= size(point);
temp = char(point{:});
numl = str2num(temp);
numl = reshape(numl,[m n]);
fullCont = cat(1,title,[name point]);
fclose(fid);





