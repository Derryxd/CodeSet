%Initialize Matlab Parallel Computing Enviornment by Xaero | Macro2.cn
CoreNum=2; %�趨����CPU�����������ҵĻ�����˫�ˣ�����CoreNum=2
if matlabpool('size')<=0 %�жϲ��м��㻷���Ƿ���Ȼ����
    matlabpool('open','local',CoreNum); %����δ���������������л���
else
    disp('Already initialized'); %˵�����л����Ѿ�������
end

%example3 - deal with same Data by different parameters  
%add different values to same array Data  
Data = 1:100;  
spmd  
    switch labindex  
        case 1  
            Data = Data+1;%lab 1��������ֶ���1  
        case 2  
            Data = Data+2;%lab 2��������ֶ���2  
    end  
end  
% print Data{1} & Data{2} for checking  
fprintf('%d\t',Data{1});%Horizontal tab  
fprintf('%d\t',Data{2}); 