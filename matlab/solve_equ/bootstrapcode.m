
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bootstrap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


sa=std(log(se))
nboot=10000;
bootstat = bootstrp(nboot,@(x)[std(log(x))],se);
bmin=floor(min(bootstat)*100)/100;
bmax=ceil(max(bootstat)*100)/100;
intnum=50;
delta=(bmax-bmin)/intnum;
x=(bmin:delta:bmax);
y(1:length(x))=0;
for i=2:length(x)
    y(i)=sum(bootstat>=x(i-1)&bootstat<x(i));
end
stairs(x,y)
ci = bootci(nboot,{@(x)[std(log(x))],se},'alpha',0.05)
% hist(bootstat)