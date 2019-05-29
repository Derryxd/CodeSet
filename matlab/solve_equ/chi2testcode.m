
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 卡方拟合优度检验
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


premin=floor(min(se));%求出数据值下限
premax=ceil(max(se));%求出数据值上限
edges(:,1)=[premin 1 1.5 2 2.5 3 premax];%数据分组，注：可给定分组，也可给出组数，由程序包自动分组

phat=gamfit(se);
disp('Gamma')
[h,p,stats] = chi2gof(se,'edges',edges,'cdf',{@gamcdf,phat(1),phat(2)},'alpha',0.10)%自行定义组界线，即组数
% alpha — Significance level for the test. The default is 0.05.
%[h,p,stats] = chi2gof(se,'cdf',{@gamcdf,phat(1),phat(2)},'alpha',0.10)

disp('Gaussian')
[h,p,stats] = chi2gof(se,'edges',edges,'cdf',{@normcdf,mean(se),std(se)},'alpha',0.01)

disp('Gamma')
obscounts=[sum(se>=edges(1)&se<edges(2)) sum(se>=edges(2)&se<edges(3))...
    sum(se>=edges(3)&se<edges(4)) sum(se>=edges(4)&se<edges(5))...
    sum(se>=edges(5)&se<edges(6)) sum(se>=edges(6)&se<=edges(7))];%观测分组个数
prob=gamcdf(edges,phat(1),phat(2));%计算每组界线值处的累计概率，本例为gamma分布
probint=prob(2:length(prob))-prob(1:(length(prob)-1));%计算每组组内的概率值
expcounts=sum(obscounts)*probint;%计算理论分布每组内个数
[h,p,st] = chi2gof(se,'edges',edges,'expected',expcounts,'nparams',2,'alpha',0.01)

