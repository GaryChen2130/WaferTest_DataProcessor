function varargout = wafer_gui(varargin)
% WAFER_GUI MATLAB code for wafer_gui.fig
%      WAFER_GUI, by itself, creates a new WAFER_GUI or raises the existing
%      singleton*.
%
%      H = WAFER_GUI returns the handle to a new WAFER_GUI or the handle to
%      the existing singleton*.
%
%      WAFER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAFER_GUI.M with the given input arguments.
%
%      WAFER_GUI('Property','Value',...) creates a new WAFER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wafer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wafer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wafer_gui

% Last Modified by GUIDE v2.5 06-Aug-2019 20:05:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wafer_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @wafer_gui_OutputFcn, ...
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
end


% --- Executes just before wafer_gui is made visible.
function wafer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wafer_gui (see VARARGIN)

% Read XRD and XRF data
ReadXRD('../XRD/RS5H.xlsm','RS5H');
ReadXRF;
ReadIMP('../IMP/PR15_IMP.xlsm','PR15_20190412132247');

axes1_CreateFcn;

[pic,map,alpha] = imread('wafer_img.png');
axes(handles.wafer_img);
bg = imshow(pic);
set(bg,'AlphaData',alpha)

% Generate checkboxes
global cbx;
cbx = zeros(1,100);
y_pos = 40;
for i = 1:10
    x_pos = 20;
    for j = 1:10
        cbx((i - 1)*10 + j) = uicontrol('Style','checkbox',...
                                        'String','',...
                                        'tag',['Checkbox',num2str((i - 1)*10 + j)],...
                                        'value',0,...
                                        'Position',[x_pos,y_pos,15,15]);
        x_pos = x_pos + 50;
    end
    y_pos = y_pos + 45;
end

% Hide checkboxes out of bound
global outbounds;
outbounds = [1,2,3,8,9,10,11,12,19,20,21,30,40,70,71,80,81,82,89,90,91,92,93,98,99,100];
for i = 1:length(outbounds)
   set(cbx(outbounds(i)),'Visible','off'); 
end

set(handles.thresholdPanel,'Visible','off');

% Choose default command line output for wafer_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes wafer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

end


% --- Outputs from this function are returned to the command line.
function varargout = wafer_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end



% Hint: place code in OpeningFcn to populate axes1

function HideWaferPage(handles)
  
global cbx;
for i = 1:100
    set(cbx(i), 'Visible','off');
end

axes(handles.wafer_img);
cla;
set(handles.wafer_img,'Visible','off');
set(handles.uipanel1,'Visible','off'); 

end

function ShowWaferPage(handles)

[pic,map,alpha] = imread('wafer_img.png');
axes(handles.wafer_img);
bg = imshow(pic);
set(bg,'AlphaData',alpha)
set(handles.wafer_img,'xTick',[]);
set(handles.wafer_img,'ytick',[]);

global cbx;
global outbounds;
for i = 1:100
    if ~ismember(i,outbounds)
       set(cbx(i),'Visible','on'); 
    end
end

set(handles.wafer_img,'Visible','on');
set(handles.uipanel1,'Visible','on');

end


% --- Executes on button press in xrd_checkbox.
function xrd_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to xrd_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xrd_checkbox
end


% --- Executes on button press in xrf_checkbox.
function xrf_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to xrf_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xrf_checkbox
end


% --- Executes on button press in next_btn.
function next_btn_Callback(hObject, eventdata, handles)
% hObject    handle to next_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Find which points are clicked
global point_num;
global record;
point_num = 0;
record = zeros(1,100);
global cbx;
for i = 1:100
    value = get(cbx(i), 'value');
    if value == 1
        point_num = point_num + 1;
        record(point_num) = i;
    end
end

if point_num == 0
    fprintf('Please select at least 1 point.\n')
    return
end

record(point_num + 1:100) = [];
xrd_value = get(handles.xrd_checkbox, 'value');
xrf_value = get(handles.xrf_checkbox, 'value');

if xrd_value == 1
    if xrf_value == 1
        PlotXRDandXRF_Bar(record,point_num);
        HideWaferPage(handles);
        set(handles.thresholdPanel,'Visible','on');
    else
        PlotXRD(record,point_num);
    end
end

end


% --- Executes on button press in all_btn.
function all_btn_Callback(hObject, eventdata, handles)
% hObject    handle to all_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cbx;
global outbounds;

for i = 1:100
    if ~ismember(i,outbounds)
       set(cbx(i),'Value',1); 
    end
end

end

% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cbx;
global outbounds;

for i = 1:100
    if ~ismember(i,outbounds)
       set(cbx(i),'Value',0); 
    end
end

end



function ba_min_Callback(hObject, eventdata, handles)
% hObject    handle to ba_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ba_min as text
%        str2double(get(hObject,'String')) returns contents of ba_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ba_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ba_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function hf_min_Callback(hObject, eventdata, handles)
% hObject    handle to hf_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hf_min as text
%        str2double(get(hObject,'String')) returns contents of hf_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function hf_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hf_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function zr_min_Callback(hObject, eventdata, handles)
% hObject    handle to zr_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zr_min as text
%        str2double(get(hObject,'String')) returns contents of zr_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function zr_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zr_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function ti_min_Callback(hObject, eventdata, handles)
% hObject    handle to ti_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ti_min as text
%        str2double(get(hObject,'String')) returns contents of ti_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ti_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ti_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function ta_min_Callback(hObject, eventdata, handles)
% hObject    handle to ta_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ta_min as text
%        str2double(get(hObject,'String')) returns contents of ta_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ta_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ta_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function mo_min_Callback(hObject, eventdata, handles)
% hObject    handle to mo_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mo_min as text
%        str2double(get(hObject,'String')) returns contents of mo_min as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function mo_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mo_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function ba_max_Callback(hObject, eventdata, handles)
% hObject    handle to ba_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ba_max as text
%        str2double(get(hObject,'String')) returns contents of ba_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ba_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ba_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function hf_max_Callback(hObject, eventdata, handles)
% hObject    handle to hf_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hf_max as text
%        str2double(get(hObject,'String')) returns contents of hf_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function hf_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hf_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function mo_max_Callback(hObject, eventdata, handles)
% hObject    handle to mo_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mo_max as text
%        str2double(get(hObject,'String')) returns contents of mo_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function mo_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mo_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function ta_max_Callback(hObject, eventdata, handles)
% hObject    handle to ta_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ta_max as text
%        str2double(get(hObject,'String')) returns contents of ta_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ta_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ta_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function ti_max_Callback(hObject, eventdata, handles)
% hObject    handle to ti_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ti_max as text
%        str2double(get(hObject,'String')) returns contents of ti_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function ti_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ti_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function zr_max_Callback(hObject, eventdata, handles)
% hObject    handle to zr_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zr_max as text
%        str2double(get(hObject,'String')) returns contents of zr_max as a double
set(hObject,'ForegroundColor','k');
end


% --- Executes during object creation, after setting all properties.
function zr_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zr_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in ba_btn.
function ba_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ba_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'ba');
end


% --- Executes on button press in hf_btn.
function hf_btn_Callback(hObject, eventdata, handles)
% hObject    handle to hf_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'hf');
end


% --- Executes on button press in mo_btn.
function mo_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mo_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'mo');
end


% --- Executes on button press in ta_btn.
function ta_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ta_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'ta');
end


% --- Executes on button press in ti_btn.
function ti_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ti_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'ti');
end


% --- Executes on button press in zr_btn.
function zr_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zr_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold(handles,'zr');
end


% --- Executes on button press in back_btn.
function back_btn_Callback(hObject, eventdata, handles)
% hObject    handle to back_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thresholdPanel,'Visible','off');
ShowWaferPage(handles);
end
