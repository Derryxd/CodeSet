srcDir=uigetdir('Choose source directory.'); %获得选择的文件夹
cd(srcDir);
allnames=struct2cell(dir('*.jpg')); %只处理8位的bmp文件
[k,len]=size(allnames); %获得jpg文件的个数
aviobj = avifile('video','compression','none');
for i=1:len
    %逐次取出文件
    name=allnames{1,i};
    I=imread(name); %读取文件
%     I1(:,:,1)=I;
%     I1(:,:,2)=I;
%     I1(:,:,3)=I;
    aviobj = addframe(aviobj,I);
end
aviobj = close(aviobj);