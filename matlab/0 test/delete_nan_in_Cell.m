%%Matlabɾ��cell������ȫΪNaN���к���
%�����ɾȥ����nan���л��У���all��Ϊsum
b = {1 1 1 1 NaN; 1 1 NaN NaN NaN; NaN NaN NaN NaN NaN};  
%%ɾ��ȫΪNaN����  
b(:,find(all(cellfun(@(x) isnan(x),b))))=[];  
%%ɾ��ȫΪNaN����  
b(find(all(cellfun(@(x) isnan(x),b),2)),:)=[];  