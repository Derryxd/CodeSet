%% xlsread
%num = xlsread(filename,sheet,xlRange,'basic')
tic
cd E:\360data\重要数据\桌面\data\sh                       %到该路径下
getfilename=ls('E:\360data\重要数据\桌面\data\sh\*.csv') ;%读取所有的csv文件名
filename = cellstr(getfilename);                         %将字符型数组转换为cell型数组
num = length(filename);                                  %得到所有csv文件的个数
for i=1:num
    [~,~,untitled] = xlsread(filename{i});               %读取资料并保存为cell型数组
    data_single(i).stock = untitled(2:end,1);            %股票名称
    data_single(i).date = untitled(2:end,3);             %交易日期
    data_single(i).raw(:,1)=datenum(data_single(i).date);%将日期转化为数字
    temp=untitled(2:end,13);
    data_single(i).raw(:,2)=cell2mat(temp);              %涨跌幅，将cell型数组转换为矩阵，类别为双精度
    data_single(i).raw = sortrows(data_single(i).raw,1); %日期排序，并同时更改涨跌幅的顺序
    data_single(i).date=cellstr(datestr(data_single(i).raw(:,1),26));%将数字转化回日期,采用第26种日期格式，类别为元胞
    clearvars temp untitled;                             %清除临时变量
end
toc
%% 
cd E:\guangdong\test\stat_hour
tic
for i=1:m
     %极值
    a_temp={'注：极值，统计从2006年至2015年的极大值和极小值，湿度的极大值和降水的极小值意义不大'};
    xlswrite([name{i} '.xlsx'],a_temp, 'extreme', 'A1')   ;
    a_temp={'极大值'};
    xlswrite([name{i} '.xlsx'], a_temp, 'extreme', 'A2')   ;
    xlswrite([name{i} '.xlsx'], a_extreme, 'extreme', 'B2')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'extreme', ['A' num2str(2*j+1)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).time_max(j,:),'extreme', ['B' num2str(2*j+1)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).maximum(j,:) ,'extreme', ['B' num2str(2*j+2)])  ;  
    end
    a_temp={'极小值'};
    xlswrite([name{i} '.xlsx'], a_temp, 'extreme', 'A12')   ;
    xlswrite([name{i} '.xlsx'], a_extreme, 'extreme', 'B12')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'extreme', ['A' num2str(2*j+11)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).time_min(j,:),'extreme', ['B' num2str(2*j+11)])  ;  
        xlswrite([name{i} '.xlsx'],stat_hour(i).minimum(j,:) ,'extreme', ['B' num2str(2*j+12)])  ;  
    end
    %偏差
    a_temp={'注：偏差（距平），将2006年至2015年的整点数据排成一列，并减去均值'};
    xlswrite([name{i} '.xlsx'],a_temp, 'deviation', 'A1')   ;
    xlswrite([name{i} '.xlsx'],a_vari, 'deviation', 'A2')   ;
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).deviation,'deviation','A3')  ;     
    %同化所需系数
    a_temp={'注：同化所需系数：含均值、范数、离散度；而矩阵左下角为相关系数，右上角为协方差，对角线为方差（即范数）'};
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
    a_temp={'Correlation coefficient(左下角) & Covariance(右上角)'};
    xlswrite([name{i} '.xlsx'],a_temp, 'assimilation analysis', 'A7')   ;
    xlswrite([name{i} '.xlsx'],a_vari, 'assimilation analysis', 'B8')   ;
    for j=1:4
        xlswrite([name{i} '.xlsx'],a_vari(j),'assimilation analysis', ['A' num2str(j+8)])  ;
    end
    xlswrite([name{i} '.xlsx'],stat_assimilation_hour(i).correlation,'assimilation analysis','B9')  ;
end
toc
