
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������Ŷȼ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


premin=floor(min(se));%�������ֵ����
premax=ceil(max(se));%�������ֵ����
edges(:,1)=[premin 1 1.5 2 2.5 3 premax];%���ݷ��飬ע���ɸ������飬Ҳ�ɸ����������ɳ�����Զ�����

phat=gamfit(se);
disp('Gamma')
[h,p,stats] = chi2gof(se,'edges',edges,'cdf',{@gamcdf,phat(1),phat(2)},'alpha',0.10)%���ж�������ߣ�������
% alpha �� Significance level for the test. The default is 0.05.
%[h,p,stats] = chi2gof(se,'cdf',{@gamcdf,phat(1),phat(2)},'alpha',0.10)

disp('Gaussian')
[h,p,stats] = chi2gof(se,'edges',edges,'cdf',{@normcdf,mean(se),std(se)},'alpha',0.01)

disp('Gamma')
obscounts=[sum(se>=edges(1)&se<edges(2)) sum(se>=edges(2)&se<edges(3))...
    sum(se>=edges(3)&se<edges(4)) sum(se>=edges(4)&se<edges(5))...
    sum(se>=edges(5)&se<edges(6)) sum(se>=edges(6)&se<=edges(7))];%�۲�������
prob=gamcdf(edges,phat(1),phat(2));%����ÿ�����ֵ�����ۼƸ��ʣ�����Ϊgamma�ֲ�
probint=prob(2:length(prob))-prob(1:(length(prob)-1));%����ÿ�����ڵĸ���ֵ
expcounts=sum(obscounts)*probint;%�������۷ֲ�ÿ���ڸ���
[h,p,st] = chi2gof(se,'edges',edges,'expected',expcounts,'nparams',2,'alpha',0.01)

