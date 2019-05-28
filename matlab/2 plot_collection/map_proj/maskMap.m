function maskMap(shapefile, masktype, varargin)
    %  ��������ͼ�ν��а׻�
    %  ���������
    %      shapefile  :  shapefile�ļ��� �ַ����ͻ�Ԫ����
    %              ΪԪ������ʱ��ͨ��ָ�����ʡ�ݵ�shp�ļ����а׻���
    %              ����Ҫ�׻�����ʡ������ʡ��������ʡ��ʹ��Ԫ������׻����ʡ�ݣ���Ҫ�ֶ�����й��߽��ͼ
    %              shapefile = {'path\����ʡ.shp', 'path\����ʡ.shp', 'path\������ʡ.shp'}
    %                  ����pathΪshp�ļ�����·��
    %       masktype  : �߼�ֵ��
    %           true  :  ����������а׻�
    %                ��ѡ������
    %                    longitudes �� ͼ�εľ��ȷ�Χ����Ԫ�������� ��ֵ�͡�
    %                    latitudes  :  ͼ�ε�γ�ȷ�Χ����Ԫ�������� ��ֵ�͡�
    %                    multiprovinces : Ԫ�����顣
    %                    ����ָ��Ҫ�׻��Ķ������ʹ�ô˲�����ҪshapefileΪ�ַ�����Ҫ����ʡ������
    %                    �˴�������ʹ�� bou2_4p.shp ���а׻�
    %                              ����Ҫ�׻�����ʡ������ʡ��������ʡ����
    %                         multipro = {'����ʡ','����ʡ','������ʡ'}
    %                    reversemask  :  ָ��Ҫ�׻����� multiprovinces Ԫ����ָ����������
    %                                  Ԫ����ָ������������Ĳ��֡� �߼�ֵ��
    %                                true  :  ��ʾ�׻�Ԫ����ָ�������� Ĭ��ֵ��
    %                                false :  ��ʾ�׻�Ԫ����ָ����������Ĳ��֡�
    %           false :  �������ڽ��а׻�
    %      �����ѡ����ֵ�ԣ�
    %           facecolor :  ����ָ���׻��������ɫ�� Ĭ��Ϊ��ɫ�� �ַ��ͻ���ֵ�͡�
    %                        ȡֵΪ 'none'ʱ���������á���ֵ��ʱΪRGB��Ԫ�顣
    %           edgecolor :  ָ���ı߽��ߵ���ɫ�� Ĭ��Ϊ��ɫ�� �ַ��ͻ���ֵ�͡�ͬ�ϡ�
    %           linewidth :  �߽��߿�ȡ� Ĭ��Ϊ1. ��ֵ�͡�
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
            error('��ָ����γ�ȷ�Χ��')
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
            % ��ȡָ���Ķ��ʡ�ݵı߽��
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
                        error('��ѡʡ�� %s ����ָ����shp�ļ��л�ʡ��������',provinces{ii})
                    end
                end
                if p.Results.reversemask
                    maskindex = ~maskindex;  % ָ��ʡ�������ʡ����shapefile�е�����
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
        %�˴�edgecolor����Ϊnone������facecolor����ֵ��ʧЧ
        patch('Faces', f, 'Vertices', v, 'FaceColor', p.Results.facecolor, 'edgecolor', 'none');
        mapshow(long ,lati, 'color', p.Results.edgecolor, 'linewidth', p.Results.linewidth);
        set(gca, 'xlim', p.Results.longitudes,'ylim', p.Results.latitudes)
    else
        if ischar(p.Results.shapefile)
            mapshow(p.Results.shapefile,'displaytype','polygon','facecolor',p.Results.facecolor,'edgecolor',p.Results.edgecolor,'linewidth',p.Results.linewidth)
        else
            error('��֧�ֵ��ļ��׻���')
        end
    end
    end