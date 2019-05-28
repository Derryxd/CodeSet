
%% 
% %Import data from spreadsheet
% tic
% % Import the data, extracting spreadsheet dates in MATLAB datenum format
% [~, ~, untitled] = xlsread('E:\360data\重要数据\桌面\data\sh\sh000001.csv','sh000001','A2:A6382');
% [~, ~, raw0_0, dateNums0_0] = xlsread('E:\360data\重要数据\桌面\data\sh\sh000001.csv','sh000001','B2:B6382','',@convertSpreadsheetDates);
% [~, ~, raw0_1, dateNums0_1] = xlsread('E:\360data\重要数据\桌面\data\sh\sh000001.csv','sh000001','I2:I6382','',@convertSpreadsheetDates);
% raw = [raw0_0,raw0_1];
% dateNums = [dateNums0_0,dateNums0_1];
% % Replace date strings by MATLAB datenums
% R = ~cellfun(@isequalwithequalnans,dateNums,raw) & cellfun('isclass',raw,'char'); % Find Excel dates
% raw(R) = dateNums(R);
% % Replace non-numeric cells with 0.0
% R = cellfun(@(x) ~isnumeric(x) || isnan(x),raw); % Find non-numeric cells
% raw(R) = {nan}; % Replace non-numeric cells
% % Create output variable
% data(1).raw = cell2mat(raw);
% data(1).index_code = untitled;
% % Clear temporary variables
% clearvars raw dateNums raw0_0 dateNums0_0 raw0_1 dateNums0_1 R untitled;
% data(1).raw = sortrows(data(1).raw,1);
% toc
% %Elapsed time is 3.595726 seconds.

%%
% %1）是使用matlab的texetread函数批量导入里面全部是纯数值的文本
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB数据的导入导出以及试验的数据\MATLAB批量导入文件\*.txt');
% filename = cellstr(getfilename);
% %将字符型数组转换为cell型数组,相当于str2cell,但是matlab中没有后面一个函数
% num = length(filename);%得到所有txt文件的个数
% stock(num) = struct('Name',filename(num),'Data',textread(filename{num}));
% %使用struct关键字建立结构体
% %注意filename(num)与filename{num}所得到的结果是不同的，前者有一对''
% for ii=1:num-1
%     stock(ii) = struct('Name',filename(ii),'Data',textread(filename{ii}));
% end
%注意到这里面的结构体数组不需要提前声明，通过循环便可以建立起来

% %2）使用xlsread批量导入excel文件,xlsread可以导入xlsx类型的文件
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB数据的导入导出以及试验的数据\MATLAB批量导入文件\*.xlsx');
% filename = cellstr(getfilename);
% %将字符型数组转换为cell型数组,相当于str2cell,但是matlab中没有后面一个函数
% num = length(filename);%得到所有txt文件的个数
% [data,text]=xlsread(filename{num});
% stock{num}={filename{num},data,text};
% %注意{}是用来建立元胞数组的,stock名字后面跟的是{}，xlsread(filename{num})默认只返回数值型的数据
% %注意filename(num)与filename{num}所得到的结果是不同的，前者有一对''
% for ii=1:num-1
%     [data,text]=xlsread(filename{ii});
%     stock{ii}={filename{ii},data,text};
% end

% %3)导入text文本里面既有数值也有字符串，这个相对来说有些麻烦
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB数据的导入导出以及试验的数据\MATLAB批量导入文件\字符串与数值夹杂的文本文件\*.txt');
% filename = cellstr(getfilename);
% %将字符型数组转换为cell型数组,相当于str2cell,但是matlab中没有后面一个函数
% filenum = length(filename);%得到所有txt文件的个数,当心变量名不要重复了
% r=0;
% x=0;
% fid = fopen(filename{filenum},'rt');
% % Loop through data file until we get a -1 indicating EOF
% while(x~=(-1))
% x=fgetl(fid);
% r=r+1;
% end
% r = r-1;
% disp(['Number of rows = ' num2str(r)])
% %注意文本中的空行也会引起行数的增加。
% frewind(fid);
% for i = 1:r
% name = fscanf(fid,'%s',1);% Filter out string at beginning of line
% num = fscanf(fid,'%f %f %f %f %f %f\n',6)'; % Read in numbers
% if(i==1)
% names = name; % Add 1st text string
% result = num; % Add 1st row
% else
% names = char(names,name); % Add next string
% result = [result;num]; % Add additional rows
% end
% end
% %stock{filenum} = {filename{filenum},result,names};
% stock(filenum) = struct('Name',filename(filenum),'Data',result,'time',names);
% fclose(fid);
% %使用元胞数组和结构体的数组的方法均可以实现，要注意实现的方式上有略微的差异
% %使用struct关键字建立结构体
% %注意filename(num)与filename{num}所得到的结果是不同的，前者有一对''
% for ii=1:filenum-1
%         r=0;
%         x=0;
%         fid = fopen(filename{ii},'rt');
%         % Loop through data file until we get a -1 indicating EOF
%         while(x~=(-1))
%         x=fgetl(fid);
%         r=r+1;
%         end
%         r = r-1;
%         disp(['Number of rows = ' num2str(r)])
%         %注意文本中的空行也会引起行数的增加。
%         frewind(fid);
%         for i = 1:r
%         name = fscanf(fid,'%s',1);% Filter out string at beginning of line
%         num = fscanf(fid,'%f %f %f %f %f %f\n',6)'; % Read in numbers
%         if(i==1)
%         names = name; % Add 1st text string
%         result = num; % Add 1st row
%         else
%         names = char(names,name); % Add next string
%         result = [result;num]; % Add additional rows
%         end
%         end
%         %stock{filenum} = {filename{filenum},result,names};
%         stock(ii) = struct('Name',filename(ii),'Data',result,'time',names);
%         fclose(fid);
% end

%%
% %xlsread读数据
% xlsstr={};
% xlsdata={};
% a=dir;        %读入目录下文件信息存储为结构体形式
% b=struct2cell(a);  %将格式转为cell形式
% c=b(1,:);        %取出其中文件名单元
% [h,l]=size(c);   %计算文件个数
% jj=0;             %xls文件数
% for ii=1:l
%     if strfind(c{ii},'.xls')    %如果是xls文件格式 注意括号要使用cell的括号
%         jj=jj+1;
%         [xlsdata{jj},xlsstr{jj}]=xlsread(c{ii}); 
%     end
% end

%%
% %textread读数据
% for i = 1:10
%     [a,b,c,d]=textread([num2str(i+2005) '.txt'],'%f%f%f%f');
%     data_hour(:,:,i)=[a,b,c,d];
%     data_hour(data_hour==-9999)=nan;
% end

%%
% %textscan读数据
% fid = fopen('stock_data.csv');
% %读首行
% N=23;
% formatSpec='%s';
% data = textscan(fid,formatSpec,N,'delimiter',',');  
% data=(data{1})';
% %读全部
% data = textscan(fid,[repmat('%s',[1,23])],'delimiter',',','CollectOutput',1);
% data=data{1};
% fclose(fid);

%%
% %测试输出速度
% a1=data(1:10000,1);
% a2=char(data(1:10000,1));
% tic
% xlswrite('1.xlsx',a1,1,'A1');
% toc
% %Elapsed time is 4.252252 seconds.
% tic
% xlswrite('2.xlsx',cellstr(a2),1,'A1');
% toc
% %Elapsed time is 5.388217 seconds.
% %输出时间差不多，用字符可以节省内存存储（内存占有空间差一个量级），但比较麻烦操作；



















