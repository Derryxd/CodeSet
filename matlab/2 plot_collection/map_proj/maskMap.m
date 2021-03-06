function maskMap(shapefile, masktype, varargin)
    %  对所绘制图形进行白化
    %  输入参数：
    %      shapefile  :  shapefile文件。 字符串型或元胞型
    %              为元胞数组时可通过指定多个省份的shp文件进行白化。
    %              比如要白化江苏省，江西省，黑龙江省。使用元胞数组白化多个省份，需要手动添加中国边界地图
    %              shapefile = {'path\江苏省.shp', 'path\江西省.shp', 'path\黑龙江省.shp'}
    %                  其中path为shp文件所在路径
    %       masktype  : 逻辑值。
    %           true  :  对区域外进行白化
    %                可选参数：
    %                    longitudes ： 图形的经度范围，二元素向量。 数值型。
    %                    latitudes  :  图形的纬度范围，二元素向量。 数值型。
    %                    multiprovinces : 元胞数组。
    %                    用于指定要白化的多个区域。使用此参数需要shapefile为字符型且要包含省份名称
    %                    此处建议大家使用 bou2_4p.shp 进行白化
    %                              比如要白化江苏省，江西省，黑龙江省，则
    %                         multipro = {'江苏省','江西省','黑龙江省'}
    %                    reversemask  :  指定要白化的是 multiprovinces 元胞中指定的区域还是
    %                                  元胞中指定的区域以外的部分。 逻辑值。
    %                                true  :  表示白化元胞中指定的区域。 默认值。
    %                                false :  表示白化元胞中指定区域以外的部分。
    %           false :  对区域内进行白化
    %      共享可选参数值对：
    %           facecolor :  用于指定白化区域的颜色。 默认为白色。 字符型或数值型。
    %                        取值为 'none'时，不起作用。数值型时为RGB三元组。
    %           edgecolor :  指定的边界线的颜色。 默认为黑色。 字符型或数值型。同上。
    %           linewidth :  边界线宽度。 默认为1. 数值型。
    %%
    p = inputParser;
    validShape = @(x) ischar(x) || iscell(x);
    validLLFcn = @(x) isvector(x) && length(x) == 2;
    validFaceFcn = @(x) (ischar(x) && ~strcmp(x, 'none')) || (isvector(x) && length(x) == 3);
    validEdgeFcn = @(x) ischar(x) || (isvector(x) && length(x) == 3);
    defaultLon = [];  defaultLat = []; defaultProv = {}; defaultReve = true;
    defaultFace = 'w';  defaultLine = 'k';  defaultWidth = 1;

    addRequired(p, 'shapefile', validShape)
    addRequired(p, 'masktype', @islogical);
    addParameter(p, 'longitudes', defaultLon, validLLFcn);
    addParameter(p, 'latitudes', defaultLat, validLLFcn);
    addParameter(p, 'multiprovinces', defaultProv, @iscell);
    addParameter(p, 'reversemask', defaultReve, @islogical);
    addParameter(p, 'facecolor', defaultFace, validFaceFcn)
    addParameter(p, 'edgecolor', defaultLine, validEdgeFcn)
    addParameter(p, 'linewidth', defaultWidth, @isnumeric)

    parse(p, shapefile, masktype, varargin{:});

    if p.Results.masktype
        longitudes = p.Results.longitudes;
        latitudes = p.Results.latitudes;
        if isempty(longitudes) || isempty(latitudes)
            error('需指定经纬度范围！')
        end
        loninc = longitudes(1):longitudes(end);
        latinc = latitudes(1):latitudes(end);
        lone = ones(1,length(latinc)-2)*longitudes(end);
        lons = ones(1,length(latinc)-1)*longitudes(1);
        lats = ones(1,length(loninc)-1)*latitudes(1);
        late = ones(1,length(loninc)-2)*latitudes(end);
        LON = [loninc lone loninc(end:-1:1) lons NaN];
        LAT = [lats latinc late latinc(end:-1:1) NaN];
        [LON,LAT] = poly2cw(LON,LAT);
       
        if ischar(p.Results.shapefile)
            s = shaperead(p.Results.shapefile);
            if isfield(s,'NAME')
                allprovs = {s.NAME}';
                allprovnum = length(allprovs);
                maskindex = zeros(allprovnum,1);
            elseif isfield(s,'NAME99')
                allprovs = {s.NAME99}';
                allprovnum = length(allprovs);
                maskindex = zeros(allprovnum,1);
            end
            long = [s.X];  lati = [s.Y];
            % 获取指定的多个省份的边界点
            if ~isempty(p.Results.multiprovinces)
                provinces = p.Results.multiprovinces;
                pronum = length(p.Results.multiprovinces);
                for ii = 1:pronum
                    sindex = strfind(allprovs, provinces{ii});
                    if any(cell2mat(sindex))
                        for jj = 1: allprovnum
                            if isempty(sindex{jj}) ; sindex{jj} = 0; end;
                        end
                        maskindex = maskindex | cell2mat(sindex);
                    else
                        error('所选省份 %s 不在指定的shp文件中或省份名错误！',provinces{ii})
                    end
                end
                if p.Results.reversemask
                    maskindex = ~maskindex;  % 指定省份以外的省份在shapefile中的索引
                end
                LON = [LON s(maskindex).X];
                LAT = [LAT s(maskindex).Y];
            end
        elseif iscell(p.Results.shapefile)
            s = shaperead(p.Results.shapefile{1});
            long = s.X;  lati = s.Y;
            for jj = 2:length(p.Results.shapefile)
                s = shaperead(p.Results.shapefile{jj});
                [long, lati] = polybool('union',long,lati, s.X, s.Y);
            end
        end
       
        [xc, yc] = polybool('xor', LON,LAT , long, lati);
        [f, v] = poly2fv(xc, yc);
        %此处edgecolor必须为none，否则facecolor属性值将失效
        patch('Faces', f, 'Vertices', v, 'FaceColor', p.Results.facecolor, 'edgecolor', 'none');
        mapshow(long ,lati, 'color', p.Results.edgecolor, 'linewidth', p.Results.linewidth);
        set(gca, 'xlim', p.Results.longitudes,'ylim', p.Results.latitudes)
    else
        if ischar(p.Results.shapefile)
            mapshow(p.Results.shapefile,'displaytype','polygon','facecolor',p.Results.facecolor,'edgecolor',p.Results.edgecolor,'linewidth',p.Results.linewidth)
        else
            error('仅支持单文件白化！')
        end
    end
    end