
%%
% %Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
% CoreNum=2; %�趨����CPU�����������ҵĻ�����˫�ˣ�����CoreNum=2
% if matlabpool('size')<=0 %�жϲ��м��㻷���Ƿ���Ȼ����
%     matlabpool('open','local',CoreNum); %����δ���������������л���
% else
%     disp('Already initialized'); %˵�����л����Ѿ�������
% end

%%
% %��ͳ��ʽ����
% tic
% c1=1;
% for i = 1:500
%    c1 = c1+max(eig(rand(i,i)));
% end
% t1 = toc;
% %parfor���з�ʽ����
% matlabpool open;
% tic
% c2=1;
% parfor ii = 1:500
%   c2 = c2+max(eig(rand(ii,ii)));
% end
% t2 = toc;
% matlabpool close;
% %����Ա�
% display(strcat('parfor���м���ʱ�䣺',num2str(t2),'��'));
% display(strcat('�ͻ��˴��м���ʱ�䣺',num2str(t1),'��'));
% %parfor���м���ʱ�䣺47.5089��
% %�ͻ��˴��м���ʱ�䣺78.4629��

%%
% %��parfor��ִ�е���䣬�����д�����������໥���ʻ��߸�д��ͬ��iִ�еĽ����
% parfor i = 1:12
%     a(i*2) = i*2;
% end
% %Error: The variable a in a parfor cannot be classified.
% % See Parallel for Loops in MATLAB, "Overview".

% parfor i = 1:12
%     a(i) = i*2;
%     fprintf(' %d',a(i));
% end
% fprintf('\n');
% %8 6 4 2 20 18 24
% %16 14 12 10 22

%%
% %parfor�ǲ����Զ��Ƕ�׵ģ�������������:
% parfor i = 1:M
%     parfor j = 1:N
%     end
% end
% 
% %ֻ�н�����һ����Ϊfor:
% parfor i = 1:M for i = 1:N ; end end
% %���ߣ�
% for i = 1:M parfor i = 1:N ; end end
% 
% %���������Ͳ��ܷ��Ӳ��е�����������������
% parfor k = 1:M*N
%     i = mod(k-1, M) + 1;
%     j = floor(k-1/M) + 1;
% end

%%
% %�������޸�ѭ��������
% parfor i = 1:N
%    i = i + 1;
%    a(i) = i;
% end
% %Error: Assigning to the loop variable "i" of a parfor is not allowed.

% %��д����ʱ�� �����±�ķ���ֻ����i��������i�Ӽ�һ��������
% %���ʹ��Ƕ��ѭ����ѭ�����������þ�����ô������ֱ�ӵ��±���ʽ���������ñ��ʽ��
% A = zeros(4, 11);
% parfor i = 1:4
%    for j = 1:10
%       A(i, j + 1) = i + j;
%    end
% end
% %Error: The variable A in a parfor cannot be classified.
% %���Ըĳɣ�
% A = zeros(4, 11);
% parfor i = 1:4
%    for j = 2:11
%       A(i, j) = i + j + 1;
%    end
% end

% %�����Ƕ��ѭ���������˾�����ô��parfor-loop�оͲ������������ط���ʹ�ã�
% A = zeros(4, 10);
% parfor i = 1:4
%     for j = 1:10
%         A(i, j) = i + j;
%     end
%     disp(A(i, 1))
% end
% %�ǲ�����ġ����Ըĳɣ�
% A = zeros(4, 10);
% parfor i = 1:4
%     v = zeros(1, 10);
%     for j = 1:10
%         v(j) = i + j;
%     end
%     disp(v(1))
%     A(i, :) = v;
% end


