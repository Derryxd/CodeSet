function stationform(fid,locat,V,lev)
%��������matlab�����������ת��gradsվ�����ݣ�������ʽstation(fid,locat,V,lev)
%fidΪ��Ҫ�������������ݵĵ�ַ���ļ���
%locat��վ�㾭γ����������һ����վ��ţ��ڶ����Ǿ��ȣ���������γ��
%V����Ҫ���Ƶ��������飬��һά��վ�㣬�ڶ�ά�ǲ�Σ�����ά�Ǳ���������ά��ʱ��
%lev�Ǳ��������Ĳ�Σ���1000 950 ... �����Ϊ��Ϣlev�ĵ�һ��ֵ���е����дΪ1���޵����дΪ0
siznum=size(V); %��ȡվ������
if length(siznum)<4
   siznum(length(siznum)+1:4)=1; 
end
y=fopen(fid,'w');%������д������
for k4=1:siznum(4)       
tim=0.0;%��������ʱ��
nlev=siznum(2);%�ܲ���
nflag=lev(1);%�Ƿ��е�������
 for k1=1:siznum(1)
    fwrite(y,strcat(num2str(locat(k1,1)),'  d'),'8*char');
    fwrite(y,locat(k1,3),'float');
    fwrite(y,locat(k1,2),'float');
    fwrite(y,tim,'float');
    fwrite(y,nlev,'int');
    fwrite(y,nflag,'int');
   %д���������
    for k5=1:siznum(3)
       fwrite(y,V(k1,1,k5,k4),'float');
    end
   %д��߿�����
	for k2=2:length(lev)
	  fwrite(y,lev(k2),'float');
	  for k3=1:siznum(3)
	    fwrite(y,V(k1,k2,k3,k4),'float');
	  end
	end
	
    
 end
 %��ʱ�ν���
 fwrite(y,strcat(num2str(locat(k4,1)),'  d'),'8*char');
 fwrite(y,0,'float');
 fwrite(y,0,'float');
 fwrite(y,0,'float');
 fwrite(y,0,'int');
 fwrite(y,0,'int');
end
%return
%дctl�ļ�
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
uiopen(ctlname);%��ctl�ļ�

end
