clear all
clc
% fseek(fileID, offset, origin)
% [A,count] = fread(fileID,sizeA,precision,skip,machinefmt)
%%
fileID = fopen('nine.bin','w');
fwrite(fileID,magic(5),'integer*4');
fclose(fileID);
fileID = fopen('nine.bin');
a=fread(fileID,'*int32')
frewind(fileID);
a1=fread(fileID,'1*int32',8)
magic(5)
frewind(fileID);
b=fread(fileID,[5,2],'1*int32',4)
frewind(fileID);
b1=fread(fileID,[5,5],'1*int32',8)
frewind(fileID);
c=fread(fileID,2,'int32=>float')
fclose(fileID);
%%
% Create files test1.dat and test2.dat
% Each character uses 8 bits (1 byte)
fid1 = fopen('test1.dat', 'w+');
fwrite(fid1, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
fid2 = fopen('test2.dat', 'w+');
fwrite(fid2, 'Second File');
% Seek to the 10th byte ('J'), read 5
fseek(fid1, 9, 'bof');
A = fread(fid1, 5, 'uint8=>char');
tell1=ftell(fid1)
fclose(fid1);
% Append to test2.dat
fseek(fid2, 0, 'eof');
fwrite(fid2, A);
tell2=ftell(fid2)
fclose(fid2);
%% 
x = 0:.1:1;
A = [x; exp(x)];
fileID = fopen('exp.txt','w');
fprintf(fileID,'%6s %12s\n','x','exp(x)');
fprintf(fileID,'%6.2f %12.8f\n',A);
fclose(fileID);
%%
clear 
clc
fid1 = fopen('test1.bin', 'w+');
AA='ABCDEFGHIJKLMNOPQRSTUVWXYZaaaa';
c=reshape(AA,[6 5])
for j=1:5
    for i=1:6
        fwrite(fid1,c(i,j) ,'char');
    end
end
% fseek(fid1, 9, 'bof');
frewind(fid1);
A = fread(fid1, 6, 'uint8=>char')
B = fread(fid1, [6,3], 'uint8=>char')
tell1=ftell(fid1)
fclose(fid1);