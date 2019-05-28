% ���ߣ�moins
% ���ӣ�https://www.zhihu.com/question/27780598/answer/38098915
% ��Դ��֪��
% ����Ȩ���������С���ҵת������ϵ���߻����Ȩ������ҵת����ע��������

function ConwayGame
 
m = 25;
n = 25;
h = 1000;%��ֳ����
a = round(rand(m,n));%����m*n���������ʼֵ��0,1��50%
 
[xx,yy] = find(a==1);
for i=1:length(xx)
    rectangle('Position',[xx(i)-1,yy(i)-1,1,1],'FaceColor','g');
end
 
for k=1:h
    delete(gca);
    rectangle('Position',[0,0,m,n],'FaceColor','k');
    b = a(:,[end,1:end-1])+a(:,[2:end,1])+a([end,1:end-1],:)+a([end,1:end-1],[end,1:end-1])+...
        a([end,1:end-1],[2:end,1])+a([2:end,1],:)+a([2:end,1],[end,1:end-1])+a([2:end,1],[2:end,1]);
    c = zeros(m,n);
 
    [b2x,b2y] = find(b==2);
    for i=1:length(b2x)
        c(b2x(i),b2y(i)) = a(b2x(i),b2y(i));%��Χ���������->����״̬
    end
 
    [b3x,b3y] = find(b==3);
    for i=1:length(b3x)
        c(b3x(i),b3y(i)) = 1;%��Χ���������->��ֳ
    end
 
    [xx,yy] = find(c==1);
    for i=1:length(xx)
        rectangle('Position',[xx(i)-1,yy(i)-1,1,1],'FaceColor','g');
    end
    axis square;
    title(['Generation: ',num2str(k)]);
    pause(.1)
    a = c;
end