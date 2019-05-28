%% data
num = 1e5;  %1e4:һ����
a=repmat({'1','2','3'},[num 1]);
b=repmat(1:3,[num 1]);
c=b*2;
d=b.^2;
%% ��һ�ַ���:fprintf
tic
formatSpec = ['%s\t' repmat('%.3f\t',[1 3]) '\n'];
for j=1:3
    s = ['num' num2str(j) '.txt'];
    fid=fopen(s,'w');
%     fprintf(fid,'%s\t\n',a{:,i});             %ͷ������text
%     fprintf(fid,'%f\t%f\n',[b(:,i) c(:,i)]);  %��������data�����
    for i=1:num
%       or:  fprintf(fid,'%s\t%f\t%f\n',a{i,j},b(i,j),c(i,j));
        fprintf(fid,formatSpec,a{i,j},b(i,j),c(i,j),d(i,j));
    end
end
fclose('all');
toc
%Elapsed time is 0.613627 seconds.---- һ�������ʱ��(Ĭ��)
%Elapsed time is 6.012241 seconds.---- ʮ�������ʱ��
%Elapsed time is 58.957567 seconds.----- ���������ʱ�䣺��������
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
titles = {'date','speed','SD','turbul_select'};
% titles = {'date','speed','SD'};
for i=1:3
    files = ['num' num2str(i*1000) '.txt'];
    T = cell2table([a(:,i) num2cell([b(:,i) c(:,i) d(:,i)])],'VariableNames',titles);
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










