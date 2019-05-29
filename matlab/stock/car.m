%% [选取回归变量]
%注意num不一样，所以先读取对应的mat文件
%判断序列是否大于120并读取变量（若小于120则读取全部）
tic
for i=1:num
    a_num(i)=data_single(i).order(end);
    ag_sh(i).X=data_single(i).raw(31:120*(a_num(i)>120)+end*(a_num(i)<120),3);
    ag_sh(i).Y=data_single(i).raw(31:120*(a_num(i)>120)+end*(a_num(i)<120),2);
    ag_sh(i).result(:,1)=data_single(i).order(1:30);
    ag_sh(i).result(:,2)=data_single(i).raw(1:30,2);
    ag_sh(i).result(:,3)=data_single(i).raw(1:30,3);
    [B(:,i),~,~,~,STATS(:,i)] = regress(ag_sh(i).Y,[ones(90*(a_num(i)>120)+(a_num(i)-30)*(a_num(i)<120),1) ag_sh(i).X]);
    ag_sh(i).result(:,4)=repmat(B(1,i),[30,1]).*ones(30,1)+repmat(B(2,i),[30,1]).*ag_sh(i).result(:,3);
    ag_sh(i).result(:,5)=ag_sh(i).result(:,2)-ag_sh(i).result(:,4);
    ag_sh(i).result(:,7)=ag_sh(i).result(:,2)-ag_sh(i).result(:,3);
    for j=1:30
        ag_sh(i).result(j,6)=sum(ag_sh(i).result(1:j,5));
        ag_sh(i).result(j,8)=sum(ag_sh(i).result(1:j,7));
    end    
end    
toc
%Elapsed time is 0.303488 seconds.
a_vari={'第几个交易日', '个股涨跌幅(Y)', '指数涨跌幅(X)','预期收益率', '超额收益率', '累计超额收益率', '超额报酬率', '累计超额报酬率(M)'};

%%
%输出
tic
cd E:\360data\重要数据\桌面\data
mkdir car                                      
cd E:\360data\重要数据\桌面\data\car
for i=1:num
    xlswrite([filename{i}],a_vari,1,'A1');
    xlswrite([filename{i}],ag_sh(i).result,1,'A2');
end
toc





