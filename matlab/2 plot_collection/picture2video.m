srcDir=uigetdir('Choose source directory.'); %���ѡ����ļ���
cd(srcDir);
allnames=struct2cell(dir('*.jpg')); %ֻ����8λ��bmp�ļ�
[k,len]=size(allnames); %���jpg�ļ��ĸ���
aviobj = avifile('video','compression','none');
for i=1:len
    %���ȡ���ļ�
    name=allnames{1,i};
    I=imread(name); %��ȡ�ļ�
%     I1(:,:,1)=I;
%     I1(:,:,2)=I;
%     I1(:,:,3)=I;
    aviobj = addframe(aviobj,I);
end
aviobj = close(aviobj);