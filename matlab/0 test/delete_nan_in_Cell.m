%%Matlab删除cell数组中全为NaN的行和列
%如果想删去存在nan的行或列，将all改为sum
b = {1 1 1 1 NaN; 1 1 NaN NaN NaN; NaN NaN NaN NaN NaN};  
%%删除全为NaN的列  
b(:,find(all(cellfun(@(x) isnan(x),b))))=[];  
%%删除全为NaN的行  
b(find(all(cellfun(@(x) isnan(x),b),2)),:)=[];  