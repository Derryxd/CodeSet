function varargout = picturecrop(varargin)
% PICTURECROP M-file for picturecrop.fig
%      PICTURECROP, by itself, creates a new PICTURECROP or raises the existing
%      singleton*.
%
%      H = PICTURECROP returns the handle to a new PICTURECROP or the handle to
%      the existing singleton*.
%
%      PICTURECROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICTURECROP.M with the given input arguments.
%
%      PICTURECROP('Property','Value',...) creates a new PICTURECROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picturecrop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picturecrop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picturecrop

% Last Modified by GUIDE v2.5 08-Oct-2009 09:27:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picturecrop_OpeningFcn, ...
                   'gui_OutputFcn',  @picturecrop_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before picturecrop is made visible.
function picturecrop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picturecrop (see VARARGIN)

global pic_cut down;   
pic_cut=0;
down=0;

% Choose default command line output for picturecrop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picturecrop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = picturecrop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.gif','(*.bmp;*.jpg;*.gif)';'*.bmp','(*.bmp)';'*.jpg','(*.jpg)';'*.gif','(*.gif)';},'打开图片');

A=imread([pathname,filename]);
cla(handles.axes1);
axes(handles.axes1);
imshow(A);
handles.image=A;
guidata(hObject,handles);





% --- Executes on button press in crop.
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut;
pic_cut=1;

handles.begin_point=get(gca,'currentpoint'); %先初始化开始的点的坐标，否则程序会报错
guidata(hObject,handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newdata=handles.newdata;

 [file path]=uiputfile('*.jpg;','保存图像');
 filename=fullfile(path,file);     
 imwrite(newdata,filename);  


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pic_cut down;
down=1;
if pic_cut==1&&down==1
    begin_point=get(gca,'currentpoint'); %------按下鼠标左键时取得鼠标当前的坐标值-------
    handles.begin_point=begin_point;
end
guidata(hObject,handles);

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut down;
if pic_cut==1&&down==1
    begin_point=handles.begin_point;
    end_point=get(gca,'currentpoint'); %----------鼠标移动时取得鼠标当前的坐标值-------
    
    x0=begin_point(1,1);
    y0=begin_point(1,2);
    x=end_point(1,1);
    y=end_point(1,2);
    
    width=abs(x-x0);
    height=abs(y-y0);
    
   rect=[min(x,x0) min(y, y0) width height];
   
   if width*height~=0       
    data=handles.image;
    axes(handles.axes1);
    imshow(data);
    %------------用rectangle函数显示选中的图像截取区域------------------------
    rectangle('Position',rect,'edgecolor','r','LineWidth',2,'LineStyle','--');
    
    handles.rect=rect;
    guidata(hObject,handles);
   end
end
guidata(hObject,handles);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pic_cut down;

if pic_cut==1
    rect=handles.rect;
    data=handles.image;
    newdata=imcrop(data,rect);%------截取图像的选中区域---------

   cla;%----------取消图像上的矩形选中区域---------------
   axes(handles.axes1);
   imshow(newdata);

   pic_cut=0;
   down=0;
   handles.newdata=newdata;
   guidata(hObject,handles);
end


