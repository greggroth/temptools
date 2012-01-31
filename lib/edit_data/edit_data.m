function varargout = edit_data(varargin)
% EDIT_DATA MATLAB code for edit_data.fig
%      EDIT_DATA, by itself, creates a new EDIT_DATA or raises the existing
%      singleton*.
%
%      H = EDIT_DATA returns the handle to a new EDIT_DATA or the handle to
%      the existing singleton*.
%
%      EDIT_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDIT_DATA.M with the given input arguments.
%
%      EDIT_DATA('Property','Value',...) creates a new EDIT_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edit_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edit_data

% Last Modified by GUIDE v2.5 25-Aug-2011 15:39:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edit_data_OpeningFcn, ...
                   'gui_OutputFcn',  @edit_data_OutputFcn, ...
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


% --- Executes just before edit_data is made visible.
function edit_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edit_data (see VARARGIN)

% Choose default command line output for edit_data
handles.output = hObject;

handles.view_direction = 1;
handles.new_val_box = 0;

switch length(varargin)
    case 1  
        if ndims(varargin{1}) == 2      % 2D data
            handles.dataset = varargin{1};
            set(handles.slice_slider,'Enable','off');
        elseif ndims(varargin{1}) == 3  % 3D data
            handles.dataset = varargin{1};
            set(handles.slice_slider,'Min',1,'Max',size(handles.dataset,3), 'Value',round(size(handles.dataset,3)/2));
            set(handles.slice_slider_display, 'String', round(size(handles.dataset,3)/2));
        end
    otherwise  % in the case that no inputs are given
        handles.dataset = [1];
        set(handles.slice_slider,'Enable','off');
        set(handles.slice_slider,'Min',1,'Max',10);
end


plotslice(hObject, handles)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes edit_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edit_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slice_slider_Callback(hObject, eventdata, handles)
% hObject    handle to slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = round(get(hObject,'Value'));
set(hObject, 'Value', val);
set(handles.slice_slider_display,'String',get(hObject,'Value'))
plotslice(hObject, handles)

% --- Executes during object creation, after setting all properties.
function slice_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9], 'StepSize', [1 1]);
end
% addlistener(hObject,'ContinuousValueChange', {@slider_drag, handles});




% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

curr_char = int8(get(gcf,'CurrentCharacter'));
slider_val = get(handles.slice_slider, 'Value');
slider_min = get(handles.slice_slider, 'Min');
slider_max = get(handles.slice_slider, 'Max');

if isempty(curr_char)
    return
end

switch curr_char
    case 28   % left arrow
        if slider_val > slider_min
            slider_val = slider_val - 1;
        end
    case 29   % right arrow
        if slider_val < slider_max
            slider_val = slider_val + 1;
        end
    case 122  % z  for undo
        if ndims(handles.dataset)==3
            handles.dataset(handles.old_coordinate(1),handles.old_coordinate(2),handles.old_coordinate(3)) = handles.old_val;
        end
            
end

set(handles.slice_slider, 'Value', slider_val);
set(handles.slice_slider_display, 'String', num2str(slider_val));

plotslice(hObject, handles)
guidata(hObject, handles);




% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)



if eventdata.EventName == 'SelectionChanged'
    switch get(eventdata.NewValue, 'Tag')
        case 'radio_yx'
            handles.view_direction = 1;
            set(handles.slice_slider,'Min',1,'Max',size(handles.dataset,3),'Value',round(size(handles.dataset,3)/2));
            set(handles.slice_slider_display, 'String', round(size(handles.dataset,3)/2));
        case 'radio_zy'
            handles.view_direction = 2;
            set(handles.slice_slider,'Min',1,'Max',size(handles.dataset,1),'Value',round(size(handles.dataset,1)/2));
            set(handles.slice_slider_display, 'String', round(size(handles.dataset,1)/2));
        case 'radio_zx'
            handles.view_direction = 3;
            set(handles.slice_slider,'Min',1,'Max',size(handles.dataset,2),'Value',round(size(handles.dataset,2)/2));
            set(handles.slice_slider_display, 'String', round(size(handles.dataset,2)/2));
    end
end

plotslice(hObject, handles);
guidata(hObject, handles);


function plotslice(hObject, handles)
%  Plot the data

if ~isempty(handles.dataset)&&(ndims(handles.dataset)==3)
    data = handles.dataset;
    slider_pos = get(handles.slice_slider, 'Value');
    
    switch handles.view_direction
        case 1  % yx
            plot_data = squeeze(data(:,:,slider_pos));
        case 2  % zy
            plot_data = squeeze(data(slider_pos,:,:));
        case 3  % zx
            plot_data = squeeze(data(:,slider_pos,:));
    end
        
    
    imagesc(permute(plot_data,[2 1]))
    set(gca, 'yDir', 'normal')
elseif ~isempty(handles.dataset)&&(ndims(handles.dataset)==2)
    plot_data = handles.dataset;
    imagesc(permute(plot_data,[2 1]))
    set(gca, 'yDir', 'normal')
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes_handle = findobj(hObject, 'Type', 'axes');
slider_pos = get(handles.slice_slider, 'Value');

% Only support figures with 1 axes
if (isempty(axes_handle) || (numel(axes_handle) > 1)) 
    % None or too many axes to draw into
    return;
end

% Format the text string
curr_point = get(axes_handle, 'CurrentPoint');
position = [round(curr_point(1,2)) round(curr_point(1,1))];

xlim = get(axes_handle, 'XLim');
ylim = get(axes_handle, 'YLim');


if ((xlim(1)<position(2))&&(position(2)<xlim(2)))&&((ylim(1)<position(1))&&(position(1)<ylim(2)))
    %  Clicked inside
    if ndims(handles.dataset)==3
        switch handles.view_direction
            case 1
                cur_value = handles.dataset(position(2),position(1),slider_pos);
            case 2
                cur_value = handles.dataset(slider_pos,position(2),position(1));
            case 3
                cur_value = handles.dataset(position(2),slider_pos,position(1));
        end
    elseif ndims(handles.dataset)==2
        cur_value = handles.dataset(position(2), position(1));
    else
        return
    end
    handles.old_val = cur_value;
    
    if handles.new_val_box == 0
        new_val = input(['Old value was ' num2str(cur_value) '.  Set new value: ']);
    else
        new_val = handles.new_val_box;
    end

    if isnumeric(new_val)
        if ndims(handles.dataset)==3
            switch handles.view_direction
                case 1
                    handles.dataset(position(2),position(1),slider_pos) = new_val;
                    handles.old_coordinate = [position(2),position(1),slider_pos];
                case 2
                    handles.dataset(slider_pos,position(2),position(1)) = new_val;
                    handles.old_coordinate = [slider_pos,position(2),position(1)];
                case 3
                    handles.dataset(position(2),slider_pos,position(1)) = new_val;
                    handles.old_coordinate = [position(2),slider_pos,position(1)];
            end
        elseif ndims(handles.dataset)==2
            handles.dataset(position(2), position(1)) = new_val;
            handles.old_coordinate = [position(2), position(1)];
        else
            disp('input was not a number')
            return
        end
    end
end
plotslice(hObject, handles);
guidata(hObject, handles);



% --- Executes on button press in finish.
function finish_Callback(hObject, eventdata, handles)
% hObject    handle to finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.dataset;

filename = ['edited_' datestr(now,'mm-dd-yy_HH_MM') '.mat'];
save(filename, 'data')
disp(['File Saved as ' filename])


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes_handle = findobj(hObject, 'Type', 'axes');
slider_pos = get(handles.slice_slider, 'Value');

% Only support figures with 1 axes
if (isempty(axes_handle) || (numel(axes_handle) > 1)) 
    % None or too many axes to draw into
    return;
end

% Format the text string
curr_point = get(axes_handle, 'CurrentPoint');
position = [round(curr_point(1,2)) round(curr_point(1,1))];

xlim = get(axes_handle, 'XLim');
ylim = get(axes_handle, 'YLim');

if ((xlim(1)<position(2))&&(position(2)<xlim(2)))&&((ylim(1)<position(1))&&(position(1)<ylim(2)))
    %  hover inside
    if ndims(handles.dataset)==3
        switch handles.view_direction
            case 1
                cur_value = handles.dataset(position(2),position(1),slider_pos);
            case 2
                cur_value = handles.dataset(slider_pos,position(2),position(1));
            case 3
                cur_value = handles.dataset(position(2),slider_pos,position(1));
        end
    elseif ndims(handles.dataset)==2
        cur_value = handles.dataset(position(2), position(1));
    else
        return
    end

    set(handles.status_box, 'String', ['(' num2str(position(2)) ', ' num2str(position(1)) ')    current value: ' num2str(cur_value)]);

end
plotslice(hObject, handles);
guidata(hObject, handles);



function new_val_box_Callback(hObject, eventdata, handles)
% hObject    handle to new_val_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of new_val_box as text
%        str2double(get(hObject,'String')) returns contents of new_val_box as a double
handles.new_val_box = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function new_val_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to new_val_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
