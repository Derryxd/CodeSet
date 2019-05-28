%% data
num = 1e3;  %1e4:一万行
a=repmat({'1','2','3'},[num 1]);
b=single(repmat([1/3,1/6,1/8],[num 1]));
c=b*2;
%% 第一种方法:fprintf
% tic
% formatSpec = ['%s\t' repmat('%.3f\t',[1 2]) '\n'];
% for j=1:3
%     s = ['num' num2str(j) '.txt'];
%     fid=fopen(s,'w');
% %     fprintf(fid,'%s\t\n',a{:,i});             %头三行是text
% %     fprintf(fid,'%f\t%f\n',[b(:,i) c(:,i)]);  %后三行是data，否决
%     for i=1:num
%         fprintf(fid,'%s\t%f\t%f\n',a{i,j},b(i,j),c(i,j));
%         %or: fprintf(fid,formatSpec,a{i,j},b(i,j),c(i,j));
%     end
% end
% fclose('all');
% toc
% %Elapsed time is 0.613627 seconds.---- 一万行输出时间(默认)
% %Elapsed time is 6.012241 seconds.---- 十万行输出时间
% %Elapsed time is 58.957567 seconds.----- 百万行输出时间：线性增长
%% 第二种方法: dlmwrite or csvwrite暂时不成功，弃用
% tic
% for i=1:3
%     files = ['num' num2str(i*10) '.txt'];
%     %dlmwrite(filename,M,delimiter,row,col)
%     dlmwrite(files,[b(:,i) c(:,i)],'delimiter','\t','precision','%.3f','coffset',1)
%              %以tab为间隔符，精度为小数位3位，列的偏移量为1（从第二列开始输出）
%     dlmwrite(files,char(a{:,i}),'delimiter','\t')  %会覆盖上一句的输出
%              %'append' %加入该参数，只会从最后一行继续输出
% end
% toc
% %Elapsed time is 1.710419 seconds.---- 一万行（输出时间都差不多）：线性增长
%% 第三种方法:table
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
%Elapsed time is 0.343657 seconds.---- 一万行：线性增长
%优缺点：
%时间更快，但会额外占用一些内存(幸好table类型占用较cell少，约为cell的三分之一)
%最大的缺点是，不能输出时控制格式，默认保留最多7个小数
%% 第四种方法:xlswrite
%输出到excel然后用软件批量转成txt，或者用vba在excel中写宏
%具体参见IO_xls和'txt批量转换为xls及其相反.doc'

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

%% 读取含中文的txt，且内部有多个分隔符
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





