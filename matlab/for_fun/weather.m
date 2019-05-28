function weather()
clear all
close all
cityid='101010100';     %北京   天津：101030100
if ~exist('myweather.html','file')
    fid=fopen('myweather.html','w');
    str='<html>\r\n<body>\r\n<table>\r\n<tr>\r\n<td>\r\n <div align="center">';
    fprintf(fid,str);
    str=['<iframe src="http://m.weather.com.cn/m/pn11/weather.htm?id=',cityid,'T" ',...
    'width="490" height="50" marginwidth="0" marginheight="0" hspace="0" ',...
    'vspace="0" frameborder="0" scrolling="no">\r\n</iframe>\r\n</div>\r\n<div>\r\n'];
    fprintf(fid,str);
    %% 实况温度模块
    str=['<IFRAME name=surf src="http://flash.weather.com.cn/sk2/shikuang.swf?',...
    'id=',cityid,'" frameBorder=0 width=625 scrolling=no height=240>\r\n</IFRAME>\r\n</div>'];
    fprintf(fid,str);
    %% 全国天气模块
    str=['<iframe src="http://flash.weather.com.cn/wmaps/index.swf?url1=http%%3A%%2F%%',...
    '2Fwww%%2Eweather%%2Ecom%%2Ecn%%2Fweather%%2F&url2=%%2Eshtml&from=cn" width="625" ',...
    'height="457" marginwidth="0" marginheight="0" hspace="0" vspace="0" ',...
    'frameborder="0" scrolling="no">\r\n</iframe>\r\n</td>\r\n<td halign="center" valign="top"> '];
    fprintf(fid,str);
    %-------------------微博模块------------------------------------------
    % str=['\r\n<div>\r\n<iframe width="300" height="550" class="share_self"  frameborder="0" '...
    % 'scrolling="no" src="http://widget.weibo.com/weiboshow/index.php?',...
    % 'language=&width=0&height=550&fansRow=2&ptype=1&speed=0&skin=1&isTitle=1&nobo',...
    % 'rder=1&isWeibo=1&isFans=1&uid=2152932322&verifier=13d43368&dpc=1">\r\n</iframe>\r\n</div>\r\n'];
    % fprintf(fid,str);
    %-------------------------------------------------------------

    str='</td>\r\n</tr>\r\n</table>\r\n</body>\r\n</html>';
    fprintf(fid,str);
    fclose(fid);
end   %end if exist('myweather.html','file');
pause(.1);
figure('numbertitle','off','menu','none','name','matlab天气查看器','pos',[100 100 700 600]);
myweb=actxcontrol('Shell.Explorer.2',[0 0 700  600]);
myweb.Navigate([pwd '/myweather.html']);
end