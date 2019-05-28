%% xlsread
%num = xlsread(filename,sheet,xlRange,'basic')
tic
cd E:\360data\��Ҫ����\����\data\sh                       %����·����
getfilename=ls('E:\360data\��Ҫ����\����\data\sh\*.csv') ;%��ȡ���е�csv�ļ���
filename = cellstr(getfilename);                         %���ַ�������ת��Ϊcell������
num = length(filename);                                  %�õ�����csv�ļ��ĸ���
for i=1:num
    [~,~,untitled] = xlsread(filename{i});               %��ȡ���ϲ�����Ϊcell������
    data_single(i).stock = untitled(2:end,1);            %��Ʊ����
    data_single(i).date = untitled(2:end,3);             %��������
    data_single(i).raw(:,1)=datenum(data_single(i).date);%������ת��Ϊ����
    temp=untitled(2:end,13);
    data_single(i).raw(:,2)=cell2mat(temp);              %�ǵ�������cell������ת��Ϊ�������Ϊ˫����
    data_single(i).raw = sortrows(data_single(i).raw,1); %�������򣬲�ͬʱ�����ǵ�����˳��
    data_single(i).date=cellstr(datestr(data_single(i).raw(:,1),26));%������ת��������,���õ�26�����ڸ�ʽ�����ΪԪ��
    clearvars temp untitled;                             %�����ʱ����
end
toc
%% 
cd E:\guangdong\test\stat_hour
tic
for i=1:m
     %��ֵ
    a_temp={'ע����ֵ��ͳ�ƴ�2006����2015��ļ���ֵ�ͼ�Сֵ��ʪ�ȵļ���ֵ�ͽ�ˮ�ļ�Сֵ���岻��'};
    xlswrite([name{i} '.xlsx'],a_temp, 'extreme', 'A1')   ;
    a_temp={'����ֵ'};
    xlswrite([name{i} '.xlsx'], a_temp, 'extreme', 'A2')   ;
    xlswrite([name{i} '.xlsx'], a_extreme, 'extreme', 'B2')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'extreme', ['A' num2str(2*j+1)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).time_max(j,:),'extreme', ['B' num2str(2*j+1)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).maximum(j,:) ,'extreme', ['B' num2str(2*j+2)])  ;  
    end
    a_temp={'��Сֵ'};
    xlswrite([name{i} '.xlsx'], a_temp, 'extreme', 'A12')   ;
    xlswrite([name{i} '.xlsx'], a_extreme, 'extreme', 'B12')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'extreme', ['A' num2str(2*j+11)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).time_min(j,:),'extreme', ['B' num2str(2*j+11)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).minimum(j,:) ,'extreme', ['B' num2str(2*j+12)])  ;  
    end
    %ƫ��
    a_temp={'ע��ƫ���ƽ������2006����2015������������ų�һ�У�����ȥ��ֵ'};
    xlswrite([name{i} '.xlsx'],a_temp, 'deviation', 'A1')   ;
    xlswrite([name{i} '.xlsx'],a_vari, 'deviation', 'A2')   ;
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).deviation,'deviation','A3')  ;     
    %ͬ������ϵ��
    a_temp={'ע��ͬ������ϵ��������ֵ����������ɢ�ȣ����������½�Ϊ���ϵ�������Ͻ�ΪЭ����Խ���Ϊ�����������'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A1')   ;
    xlswrite([name{i} '.xlsx'],a_vari, 'assimilation analysis', 'B2')   ;
    a_temp={'mean value'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A3')   ;
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).mean_value,'assimilation analysis','B3')  ;
    a_temp={'norm'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A4')   ;
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).norm,'assimilation analysis','B4')  ;
    a_temp={'dispersion'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A5')   ;
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).dispersion,'assimilation analysis','B5')
    a_temp={'Correlation coefficient(���½�) & Covariance(���Ͻ�)'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A7')   ;
    xlswrite([name{i} '.xlsx'],a_vari, 'assimilation analysis', 'B8')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'assimilation analysis', ['A' num2str(j+8)])  ;
    end
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).correlation,'assimilation analysis','B9')  ;
end
toc
