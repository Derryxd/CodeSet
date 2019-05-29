%% 求解线性方程组
%右除式A/B，相当于A*inv(B)对于，左除式A\B，则相当于inv（A）*B
tic
x1=A\b;
t1=toc;
display(strcat('method1计算时间：',num2str(t1),'秒'));
%method1计算时间：0.088615秒
tic
x2=inv(A)*b;
t2=toc;
display(strcat('method2计算时间：',num2str(t2),'秒'));
%method2计算时间：0.14868秒
tic
[RA,RB,n,X]=gaus(A,b);
t3=toc;
display(strcat('method3计算时间：',num2str(t3),'秒'));
%method3计算时间：20.6034秒
