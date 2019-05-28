function tf = has_rectangle(a)
s = size(a,1);
n=find(a==1);
row=mod(n,s);row(row==0)=s;   %i:row index
col=ceil(n/s);                %j:column index
ra=combntns(row,4);
cb=combntns(col,4);
num=0;m=zeros(2,4,length(ra));
for i=1:length(ra(:,1))
    m(:,:,i)=[ra(i,:);cb(i,:)];
    c=sort(m(:,:,i),2);
    if c(1,1)==c(1,2)&&c(1,3)==c(1,4)&&c(2,1)==c(2,2)&&c(2,3)==c(2,4)
        num=num+1;
    end
end
if num
    tf = true;
else
    tf = false;
end
        