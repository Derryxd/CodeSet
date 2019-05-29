function [h,p,kstat]=test_distribution(se,distribution,alpha_level,test)
%% test the sequence whether fits the specific distribution
%1、The distribution contain the following:
%   'normal'正态、'gamma'伽马、 'poisson'泊松、
%2、The default alpha is 0.05.
%3、The method of goodness-of-fit test include:
%   'chi2'卡方检验、'lilli'改进拟合优度检验
%4、Example：
%   [h,p,kstat]=test_distributon(se,'normal',0.05,'lilli')
%5、The meaning of output see the module below.
%   H=0 indicates that the null hypothesis ("the data are normally distributed")
%       cannot be rejected at the 5% significance level. 
%   H=1 indicates that the null hypothesis can be rejected at the 5% level.
%   P : p value
%   Kstat: the test statistic
%
% Code by Derry Liu , 14 Febrary 2017
% Modified on 14 March 2017
if nargin<2
    error(message('test_distributon:TooFewInputs'));
end
%% Pretreatment
%for data handling
x0=floor(min(se));  %superior limit
xt= ceil(max(se));  %inferior limit
dx=0.2;
x=x0:dx:xt;         %build the x axis
N=length(se);       %the size of the sequence
i=1:N;
pi=(i-1/3)/(N+1/3); %the quantiles of the sequence
[fi,xi]=ecdf(se);   %the empirical cdf
%basic parameter
mu=mean(se);        %mean value
sigma=std(se);      %standard deviation(N-1)
%for plot
LW=1.5;             %LineWidth
% %generate a time series
% n=100;
% se=randn(n,1);
%% Generate the specific distribution
%正态: f=(1/sigma*sqrt(2*pi))*exp(-(x-mu)^2/(2*sigma^2))
if strcmp(distribution,'normal') 
   %parameter & pdf
    y=normpdf(x,mu,sigma);
   %cumulative distribution funtion(cdf)
    fn=normcdf(xi,mu,sigma);
   %the quantiles of the distribution
    fit=norminv(pi,mu,sigma);
%伽马 f=(x/beta)^(alpha-1)*exp(-x/beta)/(beta*Gamma(alpha)); x,alpha,beta>0
elseif strcmp(distribution,'gamma')
   %parameter & pdf
    D=log(mu)-mean(log(se));
    alpha=(1+sqrt(1+4*D/3))/4/D;  %shape para
    beta=mu/alpha;                %scale para
    y=gammpdf(x,alpha,beta);
   %cumulative distribution funtion(cdf)
    fn=gamcdf(xi,alpha,beta);
   %the quantiles of the distribution
    fit=gaminv(pi,alpha,beta);
%泊松: f=lamda^x/factorial(x)*exp(-lamda); lamda>0
elseif strcmp(distribution,'poisson') 
   %parameter & pdf
    lamda=mu;
    y=poisspdf(x,lamda);
   %cumulative distribution funtion(cdf)
    fn=poisscdf(xi,lamda);
   %the quantiles of the distribution
    fit=poissinv(pi,lamda);
%指数: f=lamda*exp(-lamda*x); lamda>0
elseif strcmp(distribution,'exp') 
   %parameter & pdf
    lamda=1/mu;
    y=poisspdf(x,lamda);
   %cumulative distribution funtion(cdf)
    fn=poisscdf(xi,lamda);
   %the quantiles of the distribution
    fit=poissinv(pi,lamda);
%指数: f=lamda*exp(-lamda*x); lamda>0
elseif strcmp(distribution,'exp') 
   %parameter & pdf
    lamda=1/mu;
    y=poisspdf(x,lamda);
   %cumulative distribution funtion(cdf)
    fn=poisscdf(xi,lamda);
   %the quantiles of the distribution
    fit=poissinv(pi,lamda);
end
%% the histogram
figure(1)
p_hist=hist(se,x);
bar(x,p_hist/N/dx)
hold on 
plot(x,y,'g','LineWidth',LW)
xlabel('the data of sequence')
ylabel('frequency')
title('Histogram')
%% the Q-Q plot
figure(2)
R_se=sort(se);
scatter(R_se,fit,'or')
hold on
plot(x,x,'k')
% ylabel('正态分布拟合温度/\circC')
ylabel_name=strcat('the quantiles of a ',distribution,' distribution');
ylabel(ylabel_name)
xlabel('the quantiles of the sequence')
title('Q-Q Plot')
%% the empirical cumulative frequency distribution
figure(3)
stairs(xi,fi,'r')
hold on
plot(xi,fn,'k')
cdf_name=strcat(distribution,' cumulative distribution');
legend('emprical cumulative probability',cdf_name,'location','southeast')
legend('boxoff')
xlabel('variable of the sequence')
ylabel('cumulative frequency')
title('Empirical Cumulative Frequency Distribution')
%% the boxplot
figure(4)
boxplot(se)
xlabel('the quantiles of the sequence')
title('BoxPlot')
%% Chi-square test
if strcmp(test,'chi2')
    
end
%% Lilliefors

if strcmp(test,'lilli')
    if strcmp(distribution,'normal')
        distribution='norm';
    elseif strcmp(distribution,'exponential')
        distribution='exp';
    elseif strcmp(distribution,'extreme_value')
        distribution='ev';
    end
    if nargin==2
        [h,p,kstat] = lillietest(se,[],distribution);
    elseif nargin>2
        [h,p,kstat] = lillietest(se,alpha_level,distribution);
    end
end








