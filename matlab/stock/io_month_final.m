% %%
% % %ע��num��һ���������ȶ�ȡ��Ӧ��mat�ļ�
% % tic
% % for i=1:1
% %     data_month(i).stock = data_month_re(i).one(:,2);               %��Ʊ����
% %     data_month(i).date  = data_month_re(i).one(:,1);               %��������
% %     data_month(i).raw(:,1)=datenum(data_month(i).date);            %������ת��Ϊ����
% %     data_month(i).raw(:,2)=data_month_re(i).two(:,5);              %�����ǵ���
% %     data_month(i).raw = sortrows(data_month(i).raw,1);             %�������򣬲�ͬʱ�����ǵ�����˳��
% %     data_month(i).date=cellstr(datestr(data_month(i).raw(:,1),26));%������ת��������,���õ�26�����ڸ�ʽ�����ΪԪ��
% %     data_month(i).order(:,1)=(1:1:size(data_month(i).raw,1));      %�ڼ���������
% % end
% % % clearvars data_month_re;   
% % toc
% % %Elapsed time is 160.448768 seconds.
% 
% %%
% %����Ӧ�������ڵĴ���ָ��������ƥ��
% %�󲿷ֹ�Ʊ�����߶���2017/1/20�����ݣ�������ָ��û��
% tic
% for i=1:num
%     [C,IA,IB] = intersect(data_month(i).date,data_market.date); 
%     len=size(C,1);
% %   data_month(i).raw(len,:)=[];
%     data_month(i).raw(1:len,3)= data_market.index(IB);
%     data_month(i).raw(end,3)=-9999*(len<size(data_month(i).raw,1))+data_month(i).raw(end,3)*(len==size(data_month(i).raw,1));
%     data_month(i).raw(data_month(i).raw==-9999)=nan;
%     clearvars IA IB C temp len;
% end
% toc
% %Elapsed time is 32.815836 seconds.

%%
%���
tic
cd E:\360data\��Ҫ����\����\data
mkdir month_re                                      
cd E:\360data\��Ҫ����\����\data\month_re
a_vari={'��������', '��������', '�����ǵ���', 'ָ���ǵ���','�ڼ���������'};
for i=1:num
    temp=unique(data_month(i).stock);
    %�������
    xlswrite([temp{1} '.csv'],a_vari,1,'A1');
    %����ַ�������
    xlswrite([temp{1} '.csv'],[data_month(i).stock data_month(i).date],1,'A2');
    %���˫��������
    xlswrite([temp{1} '.csv'],[data_month(i).raw(:,2) data_month(i).raw(:,3) data_month(i).order],1,'C2');
    clearvars temp;
end
toc
%Elapsed time is 3.851542 seconds.


%Elapsed time is 3517.977483 seconds.