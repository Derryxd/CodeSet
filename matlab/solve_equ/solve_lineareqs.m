%% ������Է�����
%�ҳ�ʽA/B���൱��A*inv(B)���ڣ����ʽA\B�����൱��inv��A��*B
tic
x1=A\b;
t1=toc;
display(strcat('method1����ʱ�䣺',num2str(t1),'��'));
%method1����ʱ�䣺0.088615��
tic
x2=inv(A)*b;
t2=toc;
display(strcat('method2����ʱ�䣺',num2str(t2),'��'));
%method2����ʱ�䣺0.14868��
tic
[RA,RB,n,X]=gaus(A,b);
t3=toc;
display(strcat('method3����ʱ�䣺',num2str(t3),'��'));
%method3����ʱ�䣺20.6034��
