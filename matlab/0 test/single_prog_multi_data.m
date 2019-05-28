%Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
CoreNum=2; %设定机器CPU核心数量，我的机器是双核，所以CoreNum=2
if matlabpool('size')<=0 %判断并行计算环境是否已然启动
    matlabpool('open','local',CoreNum); %若尚未启动，则启动并行环境
else
    disp('Already initialized'); %说明并行环境已经启动。
end

%example3 - deal with same Data by different parameters  
%add different values to same array Data  
Data = 1:100;  
spmd  
    switch labindex  
        case 1  
            Data = Data+1;%lab 1上面的数字都加1  
        case 2  
            Data = Data+2;%lab 2上面的数字都加2  
    end  
end  
% print Data{1} & Data{2} for checking  
fprintf('%d\t',Data{1});%Horizontal tab  
fprintf('%d\t',Data{2}); 