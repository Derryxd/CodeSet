%寻找多个日期的索引值，并返回其前后三个小时的值存到数组中。
%目的：风资源分析时用的。找到湍流大于A类曲线的时刻，并找出前后时间段画风速、湍流的时序图和风速frequency玫瑰图。
data=importdata('C:\Users\lixingyu\Desktop\釗姐任务\数据处理\同期数据\4502#20170429-20171107-matlab.txt');
text=data.textdata;
number=(20:20:100);
a= text(number);
m=0;
for j=1:length(number);
    m=m+1;
    for i=1:length(text);
        if strcmpi(text{i},a{m}); %判断字符串是否相等，text1==a不能用
            Lia=ismember(text,a);  %在数组中找到某字符串对应的下标，返回值为逻辑一维数组。不能直接用find找字符串
            b=find(Lia~=0);    %在数组中找出非0的下标，就是日期a的位置。
        end
    end
end
disp(b);

%把一组数据分成n个时间段
scale=6; %时序和小时的比例
hour=3;%选择前后的3个小时分析
n=0;%把一组数据分成n个时间段
for i=1:2
%     if i==1;
        if (b(i+1)-b(i))<=scale*hour;%检测超过标准线的时刻是不是互相连在18h以内的
            time1b=b(i)-18;
            time1e=b(i+1)+18;
    %         band(n+1)=n+1;
    %         n=n+1;
        else
            time1b=b(i)-18;
            time1e=b(i)+18;
            time2b=b(i)-18;
            time2e=b(i)+18;%这个应该不用输出，下次循环时再看有没有和下一个连接到一起。
%             band{n+1,1}=time1b
%             band{n+1,1}=[band{2,2} time1e]
            band{n+1,1}=[time1b(1):time1e(end)];
    %         band{n+2,1}=[time2b,time1e];
    %         band(n+1)=i;
    %         n=n+1;
        end
%     end
%     if i>=1;
%         if (b(i)-b(i-1))<=scale*hour;
%             time2e=
%         end
%     end
end
  disp(band)      
        
%时间段起点timeband1，时间段重点timeband2
% timeband%选择用于画图的时间段


%对每个时间段进行赋值
% for i=1:length(b)
% b(1)