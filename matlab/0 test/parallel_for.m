
%%
% %Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
% CoreNum=2; %设定机器CPU核心数量，我的机器是双核，所以CoreNum=2
% if matlabpool('size')<=0 %判断并行计算环境是否已然启动
%     matlabpool('open','local',CoreNum); %若尚未启动，则启动并行环境
% else
%     disp('Already initialized'); %说明并行环境已经启动。
% end

%%
% %传统方式计算
% tic
% c1=1;
% for i = 1:500
%    c1 = c1+max(eig(rand(i,i)));
% end
% t1 = toc;
% %parfor并行方式计算
% matlabpool open;
% tic
% c2=1;
% parfor ii = 1:500
%   c2 = c2+max(eig(rand(ii,ii)));
% end
% t2 = toc;
% matlabpool close;
% %结果对比
% display(strcat('parfor并行计算时间：',num2str(t2),'秒'));
% display(strcat('客户端串行计算时间：',num2str(t1),'秒'));
% %parfor并行计算时间：47.5089秒
% %客户端串行计算时间：78.4629秒

%%
% %在parfor中执行的语句，如果是写操作，则不能相互访问或者改写不同的i执行的结果。
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
% %parfor是不可以多层嵌套的，比如下面这样:
% parfor i = 1:M
%     parfor j = 1:N
%     end
% end
% 
% %只有将其中一个改为for:
% parfor i = 1:M for i = 1:N ; end end
% %或者：
% for i = 1:M parfor i = 1:N ; end end
% 
% %但是这样就不能发挥并行的威力，可以这样：
% parfor k = 1:M*N
%     i = mod(k-1, M) + 1;
%     j = floor(k-1/M) + 1;
% end

%%
% %不可以修改循环变量：
% parfor i = 1:N
%    i = i + 1;
%    a(i) = i;
% end
% %Error: Assigning to the loop variable "i" of a parfor is not allowed.

% %当写操作时， 矩阵下标的访问只能是i，或者是i加减一个常数。
% %如果使用嵌套循环的循环变量来引用矩阵，那么必须用直接的下标形式，不可以用表达式：
% A = zeros(4, 11);
% parfor i = 1:4
%    for j = 1:10
%       A(i, j + 1) = i + j;
%    end
% end
% %Error: The variable A in a parfor cannot be classified.
% %可以改成：
% A = zeros(4, 11);
% parfor i = 1:4
%    for j = 2:11
%       A(i, j) = i + j + 1;
%    end
% end

% %如果在嵌套循环中引用了矩阵，那么在parfor-loop中就不可以再其他地方再使用：
% A = zeros(4, 10);
% parfor i = 1:4
%     for j = 1:10
%         A(i, j) = i + j;
%     end
%     disp(A(i, 1))
% end
% %是不允许的。可以改成：
% A = zeros(4, 10);
% parfor i = 1:4
%     v = zeros(1, 10);
%     for j = 1:10
%         v(j) = i + j;
%     end
%     disp(v(1))
%     A(i, :) = v;
% end


