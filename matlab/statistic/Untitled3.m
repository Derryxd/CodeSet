clear;close all;clc
% se: series
% pd: pdf information
% xx: x-axis
% yy: y-axis of pdf
figure
files={'RX5day_JJA-1960-2015.txt','RX5day_JJA-1960-1989.txt','RX5day_JJA-1990-2015.txt'};
plot_set = {'-k','--b','.r'};
for i=1:3
    %% read data
    fid = fopen(files{i},'r');
    se = textscan(fid,'%f');
    se = se{1};
    fclose(fid);
    % se(end/2:end)=[];  %delete second half
    %% parameter of distribution
    % Parameter in different distribution differ, so see the following website:
    % http://cn.mathworks.com/help/stats/pdf.html
    name = 'gamma';
    mu =mean(se);
    D=log(mu)-mean(log(se));
    alpha=(1+sqrt(1+4*D/3))/4/D;  %shape para
    beta=mu/alpha;                %scale para
    %% calculate the pdf
    %pd = makedist(name,parameters);
    pd = makedist(name,alpha,beta);
    y = pdf(pd,se);
    [xx,I]=sort(se);
    yy=y(I)*100;
    %% plot
%     figure(1)   %pdf plot
    plot(xx,yy,plot_set{i})
    ti = title('JJA');
    set(ti,'FontName','Times New Roman','FontSize',20,'FontWeight','bold')  %'FontAngle','italic'
    xlb = xlabel('RX5day');
    set(xlb,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    ylb = ylabel('pdf(%)');
    set(ylb,'FontName','Times New Roman','FontSize',14,'FontWeight','bold')
    ld = legend('1960-2015','1960-1989','1990-2015');
    hold on
    clearvars se
%     figure(2)   %histogram
%     % % x0=floor(min(se));  %superior limit
%     % % xt= ceil(max(se));  %inferior limit
%     % x0=22;xt=309;
%     % dx=5;
%     % x=x0:dx:xt;         %build the x axis
%     % N=length(se);
%     % p_hist=hist(se,x);
%     % bar(x,p_hist/N/dx*100)
%     % plot(x,p_hist/N/dx)
%     nbins=40;
%     h=histogram(se,nbins);
    %% output 
    outdata = [xx yy]';
    output_name = ['output' files{i}];
    fid = fopen(output_name,'w');
    fprintf(fid,'%f\t%f\n',outdata);
    fclose(fid);
end
