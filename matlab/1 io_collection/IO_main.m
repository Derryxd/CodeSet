
%% 
% %Import data from spreadsheet
% tic
% % Import the data, extracting spreadsheet dates in MATLAB datenum format
% [~, ~, untitled] = xlsread('E:\360data\��Ҫ����\����\data\sh\sh000001.csv','sh000001','A2:A6382');
% [~, ~, raw0_0, dateNums0_0] = xlsread('E:\360data\��Ҫ����\����\data\sh\sh000001.csv','sh000001','B2:B6382','',@convertSpreadsheetDates);
% [~, ~, raw0_1, dateNums0_1] = xlsread('E:\360data\��Ҫ����\����\data\sh\sh000001.csv','sh000001','I2:I6382','',@convertSpreadsheetDates);
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
% %1����ʹ��matlab��texetread����������������ȫ���Ǵ���ֵ���ı�
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB���ݵĵ��뵼���Լ����������\MATLAB���������ļ�\*.txt');
% filename = cellstr(getfilename);
% %���ַ�������ת��Ϊcell������,�൱��str2cell,����matlab��û�к���һ������
% num = length(filename);%�õ�����txt�ļ��ĸ���
% stock(num) = struct('Name',filename(num),'Data',textread(filename{num}));
% %ʹ��struct�ؼ��ֽ����ṹ��
% %ע��filename(num)��filename{num}���õ��Ľ���ǲ�ͬ�ģ�ǰ����һ��''
% for ii=1:num-1
%     stock(ii) = struct('Name',filename(ii),'Data',textread(filename{ii}));
% end
%ע�⵽������Ľṹ�����鲻��Ҫ��ǰ������ͨ��ѭ������Խ�������

% %2��ʹ��xlsread��������excel�ļ�,xlsread���Ե���xlsx���͵��ļ�
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB���ݵĵ��뵼���Լ����������\MATLAB���������ļ�\*.xlsx');
% filename = cellstr(getfilename);
% %���ַ�������ת��Ϊcell������,�൱��str2cell,����matlab��û�к���һ������
% num = length(filename);%�õ�����txt�ļ��ĸ���
% [data,text]=xlsread(filename{num});
% stock{num}={filename{num},data,text};
% %ע��{}����������Ԫ�������,stock���ֺ��������{}��xlsread(filename{num})Ĭ��ֻ������ֵ�͵�����
% %ע��filename(num)��filename{num}���õ��Ľ���ǲ�ͬ�ģ�ǰ����һ��''
% for ii=1:num-1
%     [data,text]=xlsread(filename{ii});
%     stock{ii}={filename{ii},data,text};
% end

% %3)����text�ı����������ֵҲ���ַ�������������˵��Щ�鷳
% getfilename=ls('C:\Users\Administrator\Desktop\MATLAB���ݵĵ��뵼���Լ����������\MATLAB���������ļ�\�ַ�������ֵ���ӵ��ı��ļ�\*.txt');
% filename = cellstr(getfilename);
% %���ַ�������ת��Ϊcell������,�൱��str2cell,����matlab��û�к���һ������
% filenum = length(filename);%�õ�����txt�ļ��ĸ���,���ı�������Ҫ�ظ���
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
% %ע���ı��еĿ���Ҳ���������������ӡ�
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
% %ʹ��Ԫ������ͽṹ�������ķ���������ʵ�֣�Ҫע��ʵ�ֵķ�ʽ������΢�Ĳ���
% %ʹ��struct�ؼ��ֽ����ṹ��
% %ע��filename(num)��filename{num}���õ��Ľ���ǲ�ͬ�ģ�ǰ����һ��''
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
%         %ע���ı��еĿ���Ҳ���������������ӡ�
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
% %xlsread������
% xlsstr={};
% xlsdata={};
% a=dir;        %����Ŀ¼���ļ���Ϣ�洢Ϊ�ṹ����ʽ
% b=struct2cell(a);  %����ʽתΪcell��ʽ
% c=b(1,:);        %ȡ�������ļ�����Ԫ
% [h,l]=size(c);   %�����ļ�����
% jj=0;             %xls�ļ���
% for ii=1:l
%     if strfind(c{ii},'.xls')    %�����xls�ļ���ʽ ע������Ҫʹ��cell������
%         jj=jj+1;
%         [xlsdata{jj},xlsstr{jj}]=xlsread(c{ii}); 
%     end
% end

%%
% %textread������
% for i = 1:10
%     [a,b,c,d]=textread([num2str(i+2005) '.txt'],'%f%f%f%f');
%     data_hour(:,:,i)=[a,b,c,d];
%     data_hour(data_hour==-9999)=nan;
% end

%%
% %textscan������
% fid = fopen('stock_data.csv');
% %������
% N=23;
% formatSpec='%s';
% data = textscan(fid,formatSpec,N,'delimiter',',');  
% data=(data{1})';
% %��ȫ��
% data = textscan(fid,[repmat('%s',[1,23])],'delimiter',',','CollectOutput',1);
% data=data{1};
% fclose(fid);

%%
% %��������ٶ�
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
% %���ʱ���࣬���ַ����Խ�ʡ�ڴ�洢���ڴ�ռ�пռ��һ�������������Ƚ��鷳������



















