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

% Last Modified by GUIDE v2.5 19-Sep-2019 14:39:24

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
ReadPos('../data_Xuyen/rs11_XRD_map.xlsx','RS11-Position')
ReadXRD('../data_Xuyen/NIST_xrd_data_converted_to_2_theta/RS11_xrd (converted).xlsx','Sheet1');
ReadXRF2;
%ReadXRD('../XRD/RS5H.xlsm','RS5H');
%ReadXRF;
ReadIMP('../data_Xuyen/4_point/RS11_20190509083509','RS11_20190509083509');

axes1_CreateFcn;

[pic,map,alpha] = imread('wafer_img.png');
axes(handles.wafer_img);
bg = imshow(pic);
set(bg,'AlphaData',alpha)

% Generate checkboxes
global pos_num;
global cbx;
cbx = zeros(1,121);
y_pos = 40;
for i = 1:11
    x_pos = 20;
    for j = 1:11
        cbx((i - 1)*11 + j) = uicontrol('Style','checkbox',...
                                        'String',num2str(pos_num(i,j)),...
                                        'tag',['Checkbox',num2str((i - 1)*11 + j)],...
                                        'value',0,...
                                        'Position',[x_pos,y_pos,30,15]);
        set(cbx((i - 1)*11 + j),'BackgroundColor','c')
        x_pos = x_pos + 45;
    end
    y_pos = y_pos + 40;
end

% Hide checkboxes out of bound
HideCheckboxOutbound;
%global outbounds;
%outbounds = [1,2,3,8,9,10,11,12,19,20,21,30,40,70,71,80,81,82,89,90,91,92,93,98,99,100];
%for i = 1:length(outbounds)
%   set(cbx(outbounds(i)),'Visible','off'); 
%end

set(handles.sortPanel,'Visible','off');
set(handles.thresholdPanel2,'Visible','off');
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


function HideCheckboxOutbound
    global pos_num;
    global cbx;
    for i = 1:11
       for j = 1:11
          if pos_num(i,j) == 0
              set(cbx((i - 1)*11 + j),'Visible','off'); 
          end
       end
    end
end


% Hint: place code in OpeningFcn to populate axes1

function HideWaferPage(handles)
  
global cbx;
for i = 1:121
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
global pos_num;
for i = 1:11
    for j = 1:11
        if pos_num(i,j) > 0
            set(cbx((i - 1)*11 + j),'Visible','on'); 
        end
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
global cbx;

point_num = 0;
record = zeros(1,121);

for i = 1:121
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

record(point_num + 1:121) = [];
xrd_value = get(handles.xrd_checkbox, 'value');
xrf_value = get(handles.xrf_checkbox, 'value');
res_value = get(handles.res_checkbox, 'value');

if xrd_value == 1
    if xrf_value == 1
        PlotXRDandXRF_Bar2(handles,record,point_num);
        HideWaferPage(handles);
        set(handles.thresholdPanel,'Visible','on');
        set(handles.thresholdPanel2,'Visible','on');
    else
        PlotXRD(handles,record,point_num);
    end
end

if res_value == 1
   if xrf_value == 1
       PlotRESandXRF_Bar(record,point_num);
       HideWaferPage(handles);
       set(handles.thresholdPanel,'Visible','on');
       set(handles.thresholdPanel2,'Visible','on');
   else
       PlotRes(record,point_num);
   end
end

end


% --- Executes on button press in all_btn.
function all_btn_Callback(hObject, eventdata, handles)
% hObject    handle to all_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cbx;
global pos_num;

for i = 1:11
    for j = 1:11
        if pos_num(i,j) > 0
            set(cbx((i - 1)*11 + j),'Value',1); 
        end
    end
end

end

% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)
% hObject    handle to clear_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cbx;
global pos_num;

for i = 1:11
    for j = 1:11
        if pos_num(i,j) > 0
            set(cbx((i - 1)*11 + j),'Value',0); 
        end
    end
end

end


function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

end


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double

end


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double

end


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double

end


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double

end


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

end


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double

end


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double

end


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double

end


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double

end


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double

end


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double

end


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in res_checkbox.
function res_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to res_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of res_checkbox

end


% --- Executes on button press in sort_btn.
function sort_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.sortPanel,'Visible','on');

end


% --- Executes on button press in sort_res_btn.
function sort_res_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_res_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_imp;
global cbx;

[sorted,index] = sort(data_imp,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.res_checkbox,'Value',1);
set(handles.sortPanel,'Visible','off');

end

% --- Executes on button press in sort_zn_btn.
function sort_zn_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_zn_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_znka;
global cbx;

[sorted,index] = sort(data_znka,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.sortPanel,'Visible','off');

end

% --- Executes on button press in sort_mn_btn.
function sort_mn_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_mn_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_mnka;
global cbx;

[sorted,index] = sort(data_mnka,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.sortPanel,'Visible','off');

end

% --- Executes on button press in sort_ni_btn.
function sort_ni_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_ni_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_nika;
global cbx;

[sorted,index] = sort(data_nika,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.sortPanel,'Visible','off');

end

% --- Executes on button press in sort_mg_btn.
function sort_mg_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_mg_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_mgka;
global cbx;

[sorted,index] = sort(data_mgka,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.sortPanel,'Visible','off');

end

% --- Executes on button press in sort_co_btn.
function sort_co_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sort_co_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global pos_num;
global data_coka;
global cbx;

[sorted,index] = sort(data_coka,'descend');
points_num = str2double(get(handles.sort_num,'String'));

index_cnt = 1;
sorted_cnt = 0;

while (sorted_cnt < points_num) && (index_cnt <= 121)
    
    if mod(index(index_cnt),11) == 0
        row_index = floor(index(index_cnt)/11);
        col_index = 11;
    else
        row_index = floor(index(index_cnt)/11) + 1;
        col_index = mod(index(index_cnt),11);
    end
    
    % Check if the corresponding checkbox out of bound
    if pos_num(row_index,col_index) > 0
        set(cbx(index(index_cnt)),'Value',1);
        sorted_cnt = sorted_cnt + 1;
    end
    index_cnt = index_cnt + 1;
    
end

set(handles.sortPanel,'Visible','off');

end


% --- Executes on button press in pushbutton35.
function pushbutton35_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton36.
function pushbutton36_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton37.
function pushbutton37_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton39.
function pushbutton39_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton40.
function pushbutton40_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

end



function co_min_Callback(hObject, eventdata, handles)
% hObject    handle to co_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of co_min as text
%        str2double(get(hObject,'String')) returns contents of co_min as a double
set(hObject,'ForegroundColor','k');

end


% --- Executes during object creation, after setting all properties.
function co_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to co_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function mg_min_Callback(hObject, eventdata, handles)
% hObject    handle to mg_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mg_min as text
%        str2double(get(hObject,'String')) returns contents of mg_min as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function mg_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mg_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function zn_min_Callback(hObject, eventdata, handles)
% hObject    handle to zn_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zn_min as text
%        str2double(get(hObject,'String')) returns contents of zn_min as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function zn_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zn_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function ni_min_Callback(hObject, eventdata, handles)
% hObject    handle to ni_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ni_min as text
%        str2double(get(hObject,'String')) returns contents of ni_min as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function ni_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ni_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function mn_min_Callback(hObject, eventdata, handles)
% hObject    handle to mn_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mn_min as text
%        str2double(get(hObject,'String')) returns contents of mn_min as a double
set(hObject,'ForegroundColor','k');

end


% --- Executes during object creation, after setting all properties.
function mn_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mn_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function co_max_Callback(hObject, eventdata, handles)
% hObject    handle to co_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of co_max as text
%        str2double(get(hObject,'String')) returns contents of co_max as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function co_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to co_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function mg_max_Callback(hObject, eventdata, handles)
% hObject    handle to mg_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mg_max as text
%        str2double(get(hObject,'String')) returns contents of mg_max as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function mg_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mg_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function mn_max_Callback(hObject, eventdata, handles)
% hObject    handle to mn_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mn_max as text
%        str2double(get(hObject,'String')) returns contents of mn_max as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function mn_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mn_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function ni_max_Callback(hObject, eventdata, handles)
% hObject    handle to ni_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ni_max as text
%        str2double(get(hObject,'String')) returns contents of ni_max as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function ni_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ni_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


function zn_max_Callback(hObject, eventdata, handles)
% hObject    handle to zn_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zn_max as text
%        str2double(get(hObject,'String')) returns contents of zn_max as a double
set(hObject,'ForegroundColor','k');

end

% --- Executes during object creation, after setting all properties.
function zn_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zn_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in back_btn2.
function back_btn2_Callback(hObject, eventdata, handles)
% hObject    handle to back_btn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.thresholdPanel2,'Visible','off');
set(handles.thresholdPanel,'Visible','off');
ShowWaferPage(handles);

end


% --- Executes on button press in co_btn.
function co_btn_Callback(hObject, eventdata, handles)
% hObject    handle to co_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold2(handles,'co');
end

% --- Executes on button press in mg_btn.
function mg_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mg_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold2(handles,'mg');
end

% --- Executes on button press in mn_btn.
function mn_btn_Callback(hObject, eventdata, handles)
% hObject    handle to mn_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold2(handles,'mn');
end

% --- Executes on button press in ni_btn.
function ni_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ni_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold2(handles,'ni');
end

% --- Executes on button press in zn_btn.
function zn_btn_Callback(hObject, eventdata, handles)
% hObject    handle to zn_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotXRF_Threshold2(handles,'zn');
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



function sort_num_Callback(hObject, eventdata, handles)
% hObject    handle to sort_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sort_num as text
%        str2double(get(hObject,'String')) returns contents of sort_num as a double

end

% --- Executes during object creation, after setting all properties.
function sort_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sort_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function angle_min_Callback(hObject, eventdata, handles)
% hObject    handle to angle_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_min as text
%        str2double(get(hObject,'String')) returns contents of angle_min as a double

end

% --- Executes during object creation, after setting all properties.
function angle_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end



function angle_max_Callback(hObject, eventdata, handles)
% hObject    handle to angle_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angle_max as text
%        str2double(get(hObject,'String')) returns contents of angle_max as a double

end


% --- Executes during object creation, after setting all properties.
function angle_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angle_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end
