
%%
% %（1）
% tic
% [~,~,untitled] = xlsread('stock_data.csv');
% data_all=untitled(2:end,:);
% title=untitled(1,:);
% clearvars untitled;
% toc
% %Elapsed time is 68.860000 seconds.

% %（2）都存为字符型，精度会降低
% tic
% fid = fopen('stock_data.csv');
% data = textscan(fid,[repmat('%s',[1,23])],'delimiter',',','CollectOutput',1);
% fclose(fid);
% data=data{1};
% clearvars fid;
% toc
% %Elapsed time is 10.643599 seconds.

% %将数据分成三部分，将cell转化为其他格式，减少内存使用空间
% data_month.one=data_all(:,1:2);
% data_month.two=cell2mat(data_all(:,3:17));
% data_month.three=data_all(:,18:end);
% clearvars data_all;

%%
% %参考（1）
% fid = fopen('stock_data.csv');
% data = textscan(fid,formatSpec,N,'HeaderLines',1,'CollectOutput',1);  %需要设置formatSpec,N
% data = data{1}; %有多种类型的话要另外编写赋值
% %用时快，但是要设置format比较麻烦

% %参考（2）
% str = fileread('train_x.csv');
% idx = str==10;                  % 换行符'\n'的ASCII码为10
% str = str(find(idx,1)+1:end);   % 移除首行表头信息
% data = reshape(sscanf(char(uint16(str).*uint16(str~=','&str~='"')),'%f'),...
%     [],sum(idx)-1).';           %例子中带有分隔符,和"

% %参考（3）
% tic
% RecName = '1.csv'; % 设定文件名称，支持csv/txt等格式
% RecStore = datastore(RecName,'ReadVariableNames',true); % 设定是否读取变量名
% %RecStore.Delimiter = ','; % 设定分隔符
% RecStore.NumHeaderLines = 1; % 设定首行行数，如果第一行也是数据就生成0
% RecStore.ReadSize = 'file'; % 设定读取规模
% RecTab = readall(RecStore); % 读取数据
% toc

%%
% %拆分
% tic
% [stock_name,idata,ic] = unique(data_month.one(:,2));
% num=length(stock_name);
% data_month_re(1).one=data_month.one(1:idata(1),:);
% data_month_re(1).two=data_month.two(1:idata(1),:);
% data_month_re(1).three=data_month.three(1:idata(1),:);
% for i=2:num
%     data_month_re(i).one=data_month.one(idata(i-1)+1:idata(i),:);
%     data_month_re(i).two=data_month.two(idata(i-1)+1:idata(i),:);
%     data_month_re(i).three=data_month.three(idata(i-1)+1:idata(i),:);
% end
% clearvars ic idata data_month
% toc 
% %Elapsed time is 0.536059 seconds.

%%
% %输出
% tic
% cd E:\360data\重要数据\桌面\data
% mkdir month_re1
% cd E:\360data\重要数据\桌面\data\month_re1
% parfor i=1:100
%     xlswrite([stock_name{i} '.xlsx'],title,1,'A1');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).one,1,'A2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).two,1,'C2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).three,1,'R2');
% end
% t1=toc;
% tic
% cd E:\360data\重要数据\桌面\data
% mkdir month_re2
% cd E:\360data\重要数据\桌面\data\month_re2
% for i=1:100
%     xlswrite([stock_name{i} '.xlsx'],title,1,'A1');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).one,1,'A2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).two,1,'C2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).three,1,'R2');
% end
% t2=toc;
% display(strcat('parfor并行计算时间：',num2str(t1),'秒'));
% display(strcat('客户端串行计算时间：',num2str(t2),'秒'));

%%
% %设置并行
% %Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
% CoreNum=2; %设定机器CPU核心数量，我的机器是双核，所以CoreNum=2
% if matlabpool('size')<=0 %判断并行计算环境是否已然启动
%     matlabpool('open','local',CoreNum); %若尚未启动，则启动并行环境
% else
%     disp('Already initialized'); %说明并行环境已经启动。
% end
% matlabpool close;



