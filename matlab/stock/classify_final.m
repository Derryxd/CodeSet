
%%
% %��1��
% tic
% [~,~,untitled] = xlsread('stock_data.csv');
% data_all=untitled(2:end,:);
% title=untitled(1,:);
% clearvars untitled;
% toc
% %Elapsed time is 68.860000 seconds.

% %��2������Ϊ�ַ��ͣ����Ȼή��
% tic
% fid = fopen('stock_data.csv');
% data = textscan(fid,[repmat('%s',[1,23])],'delimiter',',','CollectOutput',1);
% fclose(fid);
% data=data{1};
% clearvars fid;
% toc
% %Elapsed time is 10.643599 seconds.

% %�����ݷֳ������֣���cellת��Ϊ������ʽ�������ڴ�ʹ�ÿռ�
% data_month.one=data_all(:,1:2);
% data_month.two=cell2mat(data_all(:,3:17));
% data_month.three=data_all(:,18:end);
% clearvars data_all;

%%
% %�ο���1��
% fid = fopen('stock_data.csv');
% data = textscan(fid,formatSpec,N,'HeaderLines',1,'CollectOutput',1);  %��Ҫ����formatSpec,N
% data = data{1}; %�ж������͵Ļ�Ҫ�����д��ֵ
% %��ʱ�죬����Ҫ����format�Ƚ��鷳

% %�ο���2��
% str = fileread('train_x.csv');
% idx = str==10;                  % ���з�'\n'��ASCII��Ϊ10
% str = str(find(idx,1)+1:end);   % �Ƴ����б�ͷ��Ϣ
% data = reshape(sscanf(char(uint16(str).*uint16(str~=','&str~='"')),'%f'),...
%     [],sum(idx)-1).';           %�����д��зָ���,��"

% %�ο���3��
% tic
% RecName = '1.csv'; % �趨�ļ����ƣ�֧��csv/txt�ȸ�ʽ
% RecStore = datastore(RecName,'ReadVariableNames',true); % �趨�Ƿ��ȡ������
% %RecStore.Delimiter = ','; % �趨�ָ���
% RecStore.NumHeaderLines = 1; % �趨���������������һ��Ҳ�����ݾ�����0
% RecStore.ReadSize = 'file'; % �趨��ȡ��ģ
% RecTab = readall(RecStore); % ��ȡ����
% toc

%%
% %���
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
% %���
% tic
% cd E:\360data\��Ҫ����\����\data
% mkdir month_re1
% cd E:\360data\��Ҫ����\����\data\month_re1
% parfor i=1:100
%     xlswrite([stock_name{i} '.xlsx'],title,1,'A1');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).one,1,'A2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).two,1,'C2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).three,1,'R2');
% end
% t1=toc;
% tic
% cd E:\360data\��Ҫ����\����\data
% mkdir month_re2
% cd E:\360data\��Ҫ����\����\data\month_re2
% for i=1:100
%     xlswrite([stock_name{i} '.xlsx'],title,1,'A1');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).one,1,'A2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).two,1,'C2');
%     xlswrite([stock_name{i} '.xlsx'],data_month_re(i).three,1,'R2');
% end
% t2=toc;
% display(strcat('parfor���м���ʱ�䣺',num2str(t1),'��'));
% display(strcat('�ͻ��˴��м���ʱ�䣺',num2str(t2),'��'));

%%
% %���ò���
% %Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
% CoreNum=2; %�趨����CPU�����������ҵĻ�����˫�ˣ�����CoreNum=2
% if matlabpool('size')<=0 %�жϲ��м��㻷���Ƿ���Ȼ����
%     matlabpool('open','local',CoreNum); %����δ���������������л���
% else
%     disp('Already initialized'); %˵�����л����Ѿ�������
% end
% matlabpool close;



