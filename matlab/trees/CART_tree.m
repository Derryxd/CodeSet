load fisheriris
t = classregtree(meas,species,...
'names',{'SL' 'SW' 'PL' 'PW'})
treetype = type(t)
view(t)
%%  Ô¤²âµÄÊµÀý
predicted = t([NaN NaN 4.8 1.6])