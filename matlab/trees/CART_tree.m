load fisheriris
t = classregtree(meas,species,...
'names',{'SL' 'SW' 'PL' 'PW'})
treetype = type(t)
view(t)
%%  Ԥ���ʵ��
predicted = t([NaN NaN 4.8 1.6])