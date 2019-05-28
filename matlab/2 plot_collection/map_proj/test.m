clear;clc;close all;
m=480;n=1440;
% load geoid
%ɫ��
load color24
%��γ��
ratio=0.25;
x=m:-1:1;y=1:n;
lat=(ratio*x-60.125)';lat=repmat(lat,[1,n]);
lon=(ratio*y-0.125)  ;lon=repmat(lon,[m,1])-180;
%����
fid=fopen('tmax_sum_LST.dat','r');
A=fread(fid,[n,m],'float');
A(A==-9999)=-1;
A=A';
fclose(fid);
%����X
n=1;m=480*n;
X=zeros(m,3);
X(:,1)=lat(1:m);
X(:,2)=lon(1:m)-180;
X(:,3)=A(1:m);
X(X==-9999)=-1;
X(X==1)=-1;
X(X~=-1)=1;
clearvars fid ratio x y
%% ��ͼ
B=shaperead('landareas.shp','UseGeoCoords',true);
R=[4 59.875 0.125];%R=[cells/degree northern_latitude_limit western_longitude_limit]
%
gcf=figure;
h1=axesm('MapProjection','lambcyln');framem; gridm;%�ȼ��ڣ�axesm('lambcyln','grid','on','frame','on')
% axesm('mercator','MapLatLimit',[-70 80])
set(h1,'Position',[-0.1,0.1,1.2,1]);%[left bottom width height]�����û������units����ֵ��ʾ������
cmap=colormap(color24);
axis off
geoshow(A,R,'DisplayType','mesh');
hold on
% geoshow([B.Lat],[B.Lon],'DisplayType', 'polygon','FaceColor','none');
geoshow([B.Lat],[B.Lon],'Color','black');
hcb = colorbar('southoutside');
set(hcb,'Position',[0.25,0.1,0.5,0.1])
set(get(hcb,'Xlabel'),'String','���ˮʱ�̷ֲ���')
hold off
print(gcf,'-dtiffn','abc.tif') %����Ϊ''��ʽ��ͼƬ����ǰ·�� 
%
% figure
% h2=axesm('lambcyln','grid','on','frame','on')
% set(h2,'Position',[-0.1,0.1,1.2,1]);axis off
% geoshow(reshape(X(:,3),480,n),R,'DisplayType','texturemap');
% hold on
% geoshow([B.Lat],[B.Lon],'Color','black');
% hold off
% %% ������svm
% n = length(X);%����������
% y = X(:,3);%����־
% X = X(:,1:2);
% TOL = 0.0001;%����Ҫ��
% C = 1;%����������ʧ������Ȩ��
% b = 0;%��ʼ���ýؾ�b
% Wold = 0;%δ����aʱ��W(a)
% Wnew = 0;%����a���W(a)
% for i = 1 : 50%��������־Ϊ1����-1
%     y(i) = -1;
% end
% a = zeros(n,1);%����a
% for i = 1 : n%�����ʼ��a,a����[0,C]
%         a(i) = 0.2;
% end
% %Ϊ�򻯼��㣬�����ظ�������еļ���
% K = ones(n,n);
% for i = 1 :n%���K���󣬱���֮��ļ���
%     for j = 1 : n
%         K(i,j) = k(X(i,:),X(j,:));
%     end
% end
% sum = zeros(n,1);%�м����������֮��ļ��㣬sum(k)=sigma a(i)*y(i)*K(k,i);
% for k = 1 : n
%     for i = 1 : n
%         sum(k) = sum(k) + a(i) * y(i) * K(i,k);
%     end
% end
% 
% while 1%��������
%     
% %����ʽѡ��
% n1 = 1;%��ʼ����n1,n2����ѡ���2����
% n2 = 2;
% %n1���յ�һ��Υ��KKT�����ĵ�ѡ��
% while n1 <= n
%     if y(n1) * (sum(n1) + b) == 1 && a(n1) >= C && a(n1) <=  0
%          break;
%     end
%     if y(n1) * (sum(n1) + b) > 1 && a(n1) ~=  0
%            break;
%     end
%     if y(n1) * (sum(n1) + b) < 1 && a(n1) ~=C
%           break;
%     end
%      n1 = n1 + 1;              
% end
% %n2�������|E1-E2|��ԭ��ѡȡ
% E1 = 0;
% E2 = 0;
% maxDiff = 0;%�����������
% E1 = sum(n1) + b - y(n1);%n1�����
% for i = 1 : n
%     tempSum = sum(i) + b - y(i);
%     if abs(E1 - tempSum)> maxDiff
%         maxDiff = abs(E1 - tempSum);
%         n2 = i;
%         E2 = tempSum;
%     end
% end
% 
% %���½��и���
% a1old = a(n1);
% a2old = a(n2);
% KK = K(n1,n1) + K(n2,n2) - 2*K(n1,n2);
% a2new = a2old + y(n2) *(E1 - E2) / KK;%�����µ�a2
% %a2��������Լ������
% S = y(n1) * y(n2);
% if S == -1
%     U = max(0,a2old - a1old);
%     V = min(C,C - a1old + a2old);
% else
%     U = max(0,a1old + a2old - C);
%     V = min(C,a1old + a2old);
% end
% if a2new > V
%     a2new = V;
% end
% if a2new < U
%     a2new = U;
% end
% a1new = a1old + S * (a2old - a2new);%�����µ�a1
% a(n1) = a1new;%����a
% a(n2) = a2new;
% 
% %���²���ֵ
% sum = zeros(n,1);
% for k = 1 : n
%     for i = 1 : n
%         sum(k) = sum(k) + a(i) * y(i) * K(i,k);
%     end
% end
% Wold = Wnew;
% Wnew = 0;%����a���W(a)
% tempSum = 0;%��ʱ����
% for i = 1 : n
%     for j = 1 : n
%     tempSum= tempSum + y(i )*y(j)*a(i)*a(j)*K(i,j);
%     end
%     Wnew= Wnew+ a(i);
% end
% Wnew= Wnew - 0.5 * tempSum;
% %���¸���b��ͨ���ҵ�ĳһ��֧������������
% support = 1;%֧�����������ʼ��
% while abs(a(support))< 1e-4 && support <= n
%     support = support + 1;
% end
% b = 1 / y(support) - sum(support);
% %�ж�ֹͣ����
% if abs(Wnew/ Wold - 1 ) <= TOL
%     break;
% end
% end
% %������������ԭ���࣬�������������svm������
% for i = 1 : n
%     fprintf('��%d��:ԭ��� ',i);
%     if i <= 50
%         fprintf('-1');
%     else
%         fprintf(' 1');
%     end
%     fprintf('    �б���ֵ%f      ������',sum(i) + b);
%     if abs(sum(i) + b - 1) < 0.5
%         fprintf('1\n');
%     else if abs(sum(i) + b + 1) < 0.5
%             fprintf('-1\n');
%         else
%             fprintf('�������\n');
%         end
%     end
% end
% 
