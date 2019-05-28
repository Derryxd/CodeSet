function stationform(fid,locat,V,lev)
%函数用于matlab单层地面数据转换grads站点数据，函数形式station(fid,locat,V,lev)
%fid为所要建立二进制数据的地址和文件名
%locat是站点经纬度向量，第一列是站点号，第二列是经度，第三列是纬度
%V是需要绘制的数据数组，第一维是站点，第二维是层次，第三维是变量，第四维是时间
%lev是变量包含的层次，如1000 950 ... 地面层为信息lev的第一个值，有地面层写为1，无地面层写为0
siznum=size(V); %获取站点数量
if length(siznum)<4
   siznum(length(siznum)+1:4)=1; 
end
y=fopen(fid,'w');%按次序写入数据
for k4=1:siznum(4)       
tim=0.0;%给定整点时间
nlev=siznum(2);%总层数
nflag=lev(1);%是否有地面数据
 for k1=1:siznum(1)
    fwrite(y,strcat(num2str(locat(k1,1)),'  d'),'8*char');
    fwrite(y,locat(k1,3),'float');
    fwrite(y,locat(k1,2),'float');
    fwrite(y,tim,'float');
    fwrite(y,nlev,'int');
    fwrite(y,nflag,'int');
   %写入地面数据
    for k5=1:siznum(3)
       fwrite(y,V(k1,1,k5,k4),'float');
    end
   %写入高空数据
	for k2=2:length(lev)
	  fwrite(y,lev(k2),'float');
	  for k3=1:siznum(3)
	    fwrite(y,V(k1,k2,k3,k4),'float');
	  end
	end
	
    
 end
 %该时次结束
 fwrite(y,strcat(num2str(locat(k4,1)),'  d'),'8*char');
 fwrite(y,0,'float');
 fwrite(y,0,'float');
 fwrite(y,0,'float');
 fwrite(y,0,'int');
 fwrite(y,0,'int');
end
%return
%写ctl文件
ctlname=input('please input the name of CTL file:','s');
if isempty(ctlname)
    fclose all;
    return 
end
ctl=fopen(ctlname,'wt');
fprintf(ctl,'dset ');
fprintf(ctl,'%s\n',fid);
fprintf(ctl,'%s \n','title my data');
fprintf(ctl,'%s \n','dtype station');
fprintf(ctl,'%s \n','undef -999.0');
fprintf(ctl,'%s ','stnmap');
[filepath name]=fileparts(fid);
fprintf(ctl,'%s \n',strcat(filepath,name,'.map'));
fprintf(ctl,'%s ','tdef');
fprintf(ctl,'%s \n',strcat(int2str(siznum(4)),' linear'));
fprintf(ctl,'%s ','vars');
fprintf(ctl,'%s \n',int2str(siznum(3)));
for i1=1:siznum(3)
    varname=input(strcat('input the name of variable NO.',int2str(i1),':'),'s');
    fprintf(ctl,'%s ',varname);
    fprintf(ctl,'%s\n','lev(0 if lev(1)data) 99');
end
fprintf(ctl,'%s\n','endvars');
fclose all;
uiopen(ctlname);%打开ctl文件

end
