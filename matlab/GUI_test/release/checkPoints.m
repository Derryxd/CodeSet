function varargout = checkPoints(varargin)
% CHECKPOINTS MATLAB code for checkPoints.fig
%      CHECKPOINTS, by itself, creates a new CHECKPOINTS or raises the existing
%      singleton*.
%
%      H = CHECKPOINTS returns the handle to a new CHECKPOINTS or the handle to
%      the existing singleton*.
%
%      CHECKPOINTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHECKPOINTS.M with the given input arguments.
%
%      CHECKPOINTS('Property','Value',...) creates a new CHECKPOINTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before checkPoints_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to checkPoints_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help checkPoints

% Last Modified by GUIDE v2.5 26-Feb-2018 23:54:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @checkPoints_OpeningFcn, ...
                   'gui_OutputFcn',  @checkPoints_OutputFcn, ...
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


% --- Executes just before checkPoints is made visible.
function checkPoints_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to checkPoints (see VARARGIN)

% Choose default command line output for checkPoints
handles.output = hObject;

% fin = fopen('point.txt','r','n','utf-8');  %读取有中文的txt，采用'n'参数定义字体格式
% str = fgetl(fin);
% [str1 str2 str3 str4] = strread(str,'%s %s %s %s','delimiter',' ');
% xingming(1)=str1;
% 
% counter=2;
% 
% while feof(fin)==0
%     str = fgetl(fin);
%     [name,yuwen,shuxue,yingyu] = strread(str,'%s %d %d %d','delimiter',' ');
%     xingming(counter) = name;
%     chengji(counter-1,:)=[yuwen shuxue yingyu];
%     counter = counter+1;
% end
% set(handles.listbox1,'string',xingming);
% handles.chengji=chengji;
% fclose(fin);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes checkPoints wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = checkPoints_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

value = get(hObject,'value')-1;
set(handles.edit1,'string',num2str(handles.chengji(value,:)));
% set(handles.edit1,'string',handles.chengji(value,:));


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.xlsx','Excel Files(*.xlsx)';...
    '*.xls','Excel Files old(*.xls)';...
    '*.txt','Txt Files(*.txt)';'*.*','All Files(*.*)'},'Choose a File');
L = length(FileName);

if L<5
    errordlg('Wrong File','File Open Error');
    return;
end

% test = FileName(1,L-3:L);
[FileNameSplit,mark] = split(FileName,'.');
test = [mark{1} FileNameSplit{2}];

switch test
    case '.txt'
        str = [PathName FileName];
        set(handles.edit2,'string',str);
        fin = fopen(str,'r','n','utf-8');  %读取有中文的txt，采用'n'参数定义字体格式
        str = fgetl(fin);
        [str1,str2,str3,str4] = strread(str,'%s %s %s %s','delimiter',' ');
        xingming(1)=str1;
        counter=2;
        %进度条
        h = waitbar(0,'请稍等，正在开始读取文件...');
        while feof(fin)==0
            str = fgetl(fin);
            [name,yuwen,shuxue,yingyu] = strread(str,'%s %d %d %d','delimiter',' ');
            xingming(counter) = name;
            chengji(counter-1,:)=[yuwen shuxue yingyu];
            counter = counter+1;
            waitbar(counter/6,h,'请等待...');  %假设总数为6
        end
        waitbar(1,h,'已完成');
        pause(2);
        set(handles.listbox1,'string',xingming);
        handles.chengji=chengji;
        fclose(fin);
        delete(h);
        guidata(hObject,handles);
    case {'.xls','.xlsx'}
        str = [PathName FileName];
        set(handles.edit2,'string',str);
        h = waitbar(0,'请稍等，正在开始读取文件...');
        [chengji,xingming]=xlsread(str);
        waitbar(1,h,'已完成');
        pause(2);
        delete(h);
        set(handles.listbox1,'string',xingming(:,1));
        handles.chengji=chengji;
        guidata(hObject,handles);
    otherwise
        errordlg('Wrong File','File Open Error');
        %msgbox('xxxx') %另一种表示方法
        return;
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text2.
function text2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text3.
function text3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text4.
function text4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc
clear 
close(gcf);
