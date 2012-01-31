function varargout = visualize(varargin)
% VISUALIZE MATLAB code for visualize.fig
%      VISUALIZE, by itself, creates a new VISUALIZE or raises the existing
%      singleton*.
%
%      H = VISUALIZE returns the handle to a new VISUALIZE or the handle to
%      the existing singleton*.
%
%      VISUALIZE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE.M with the given input arguments.
%
%      VISUALIZE('Property','Value',...) creates a new VISUALIZE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualize_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualize_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualize

% Last Modified by GUIDE v2.5 30-Jun-2011 13:32:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_OutputFcn, ...
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


% --- Executes just before visualize is made visible.
function visualize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualize (see VARARGIN)

% Choose default command line output for visualize
handles.output = hObject;

handles.headdata = 0;
handles.temp = 0;
handles.roi_mask = 0;
handles.equil = 0;

handles.slice = str2double(get(handles.sliceBox,'String'));
handles.threshold = str2double(get(handles.otBox,'String'));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes visualize wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%  Load Files
% --- Executes on button press in loadstruc.
function loadstruc_Callback(hObject, eventdata, handles)
% hObject    handle to loadstruc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile({'*.mat','MAT-files (*.mat)';'*.nii','NIFTI File (*.nii)'},'Head Data','../');

switch index
    case 0    % if user selects 'cancel'
        return
    case 1
        oldDir = cd(path);
        load(filename);
        if exist('headdata','var')
            if isa(headdata,'struct')  % compatible with both ways of storing the data
            handles.headdata = headdata.dat;
            else
            handles.headdata = headdata;
            end
            %handles.strucfilename = filename;
            set(handles.confirmHead,'Visible','on')
            set(handles.loadtemp,'Enable','on')
            set(handles.plotaction,'Enable','on')
        else
            warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''headdata''.')
        end
        cd(oldDir);
    case 2
        oldDir = cd(path);
        handles.headdata = loadNII(filename);
        set(handles.confirmHead,'Visible','on')
        set(handles.loadtemp,'Enable','on')
        set(handles.plotaction,'Enable','on')
        cd(oldDir);
    otherwise
        return
end
guidata(hObject, handles);


% --- Executes on button press in loadtemp.
function loadtemp_Callback(hObject, eventdata, handles)
% hObject    handle to loadtemp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Temperature Data','../');
if ~path  % if user selects 'cancel'
    return
end
oldDir = cd(path);
load(filename);
if exist('actResult','var')
    if isa(actResult,'struct');   % compatible with both ways of storing the data
        handles.temp = actResult.dat;
        handles.slice = actResult.likelymaxslice;
        set(handles.sliceBox,'String',handles.slice);
    else
        handles.temp = actResult;
        if exist('likelymaxslice','var')
            handles.slice = likelymaxslice;
            set(handles.sliceBox,'String',handles.slice);
        end
    end
    %handles.strucfilename = filename;
    set(handles.confirmTemp,'Visible','on')
    set(handles.loadROI,'Enable','on')
else
    warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''actResult''.')
end
cd(oldDir);
guidata(hObject, handles);

% --- Executes on button press in loadROI.
function loadROI_Callback(hObject, eventdata, handles)
% hObject    handle to loadROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename path index] = uigetfile({'*.mat','MAT-files (*.mat)';'*.nii','NIFTI File (*.nii)'},'Region of Interest','../');

switch index
    case 0  % cancel
        return
    case 1  % *.mat file
        oldDir = cd(path);
        load(filename);
        if exist('roi_mask','var')  % makes sure the variable exists in the file
            if ~isa(roi_mask,'logical') %isequal(unique(roi_mask),[0 1]')  % makes sure it's a binary array (even if it's not logical type)
                warndlg('The mask must be logical (0 and 1) for it to work properly.  Please select a different file')
                handles.roi_mask = 0;
                cd(oldDir);
                return
            end
            handles.roi_mask = logical(roi_mask);
            set(handles.confirmROI,'Visible','on');
            set(handles.sliceBox,'Enable','on');
            set(handles.sliceBoxText,'Enable','on');
            set(handles.loadequil,'Enable','on');
        else  % if the dataset isn't there
           warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''roi_mask''.')
        end
        cd(oldDir);
    case 2  % *.nii file
        oldDir = cd(path);
        handles.roi_mask = loadNII(filename);
        %{
        if ~isequal(unique(handles.roi_mask),[0 1]')
            warndlg('The mask must be logical (0 and 1) for it to work properly.  Please select a different file')
            handles.roi_mask = 0;
            cd(oldDir);
            return
        end
        %}
        handles.roi_mask = logical(handles.roi_mask);
        set(handles.confirmROI,'Visible','on');
        set(handles.sliceBox,'Enable','on');
        set(handles.sliceBoxText,'Enable','on');
        set(handles.loadequil,'Enable','on');   
        cd(oldDir);
end
        
guidata(hObject, handles);

% --- Executes on button press in loadequil.
function loadequil_Callback(hObject, eventdata, handles)
% hObject    handle to loadequil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Equillibrium Temperature','../');
if ~path  % if user selects 'cancel'
    return
end
oldDir = cd(path);
load(filename);
if exist('equillibriumT','var')
    if isa(equillibriumT,'struct')    % compatible with both ways of storing the data
        handles.equil = equillibriumT.dat;
    else
        handles.equil = equillibriumT;
    end
    set(handles.confirmEquil,'Visible','on')
    set(handles.otBox,'Enable','on')
    set(handles.otBoxText,'Enable','on')
    set(handles.button_showtsliceplot,'Enable','on')
else
    warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''equillibriumT''.')
end
cd(oldDir);
guidata(hObject, handles);

%%   Other boxes
function otBox_Callback(hObject, eventdata, handles)
% hObject    handle to otBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of otBox as text
%        str2double(get(hObject,'String')) returns contents of otBox as a double
handles.threshold = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function otBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to otBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sliceBox_Callback(hObject, eventdata, handles)
% hObject    handle to sliceBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliceBox as text
%        str2double(get(hObject,'String')) returns contents of sliceBox as a double
handles.slice = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliceBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%  Plot
% --- Executes on button press in plotaction.
function plotaction_Callback(hObject, eventdata, handles)
% hObject    handle to plotaction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strc_ok = get(handles.confirmHead,'Visible');
temp_ok = get(handles.confirmTemp,'Visible');
roi_ok = get(handles.confirmROI,'Visible');
equil_ok = get(handles.confirmEquil,'Visible');

%  Works out what to use for 'slice'
if handles.slice == 0
    slice = size(handles.temp,1);
else
    slice = handles.slice;
end

%  Decide which input is appropiate for the data provided    
switch [strc_ok temp_ok roi_ok equil_ok]
    case ['on' 'off' 'off' 'off']   %  Just head
        TempPlot(handles.headdata)
    case ['on' 'on' 'off' 'off']    %  head and temp
        TempPlot(handles.headdata,handles.temp)
    case ['on' 'on' 'on' 'off']     %  head, temp and region (plus slice)
        TempPlot(handles.headdata,handles.temp,handles.roi_mask,slice)
    case ['on' 'on' 'on' 'on']      %  head, temp, region(w/ slice) and equillibrium (w/threshold)
        TempPlot(handles.headdata,handles.temp,handles.roi_mask,slice,handles.equil,handles.threshold)
    otherwise
        warndlg('Not enought data is provided.  The items are listed in priority where each item requires that the previous be specified')
end

% --- Executes on button press in button_showtsliceplot.
function button_showtsliceplot_Callback(hObject, eventdata, handles)
% hObject    handle to button_showtsliceplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tsliceplot(handles.temp,handles.equil);
