function varargout = findtempactivation(varargin)
% FINDTEMPACTIVATION MATLAB code for findtempactivation.fig
%      FINDTEMPACTIVATION, by itself, creates a new FINDTEMPACTIVATION or raises the existing
%      singleton*.
%
%      H = FINDTEMPACTIVATION returns the handle to a new FINDTEMPACTIVATION or the handle to
%      the existing singleton*.
%
%      FINDTEMPACTIVATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDTEMPACTIVATION.M with the given input arguments.
%
%      FINDTEMPACTIVATION('Property','Value',...) creates a new FINDTEMPACTIVATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findtempactivation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findtempactivation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findtempactivation

% Last Modified by GUIDE v2.5 01-Jul-2011 13:04:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findtempactivation_OpeningFcn, ...
                   'gui_OutputFcn',  @findtempactivation_OutputFcn, ...
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


% --- Executes just before findtempactivation is made visible.
function findtempactivation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findtempactivation (see VARARGIN)

% Choose default command line output for findtempactivation
handles.output = hObject;

%  Get starting values defined on the figure
handles.headdata = 1;
handles.equil = 1;
handles.metabolism = str2double(get(handles.metab,'String'));
handles.bloodflow = str2double(get(handles.flow,'String'));
handles.start = str2double(get(handles.startstep,'String'));
handles.stop = str2double(get(handles.stopstep,'String'));
handles.bloodT = str2double(get(handles.bloodTbox,'String'));
handles.airT = str2double(get(handles.airTbox,'String'));
handles.tmax = str2double(get(handles.tmaxbox,'String'));
handles.stepf = str2double(get(handles.stepfbox,'String'));
handles.savestepf = str2double(get(handles.savestepfbox,'String'));
handles.flowDat = 0;
handles.metabDat = 0;

updatestatictext(hObject,handles);

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes findtempactivation wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function updatestatictext(hObject,handles) 

startt = handles.start/handles.stepf;
stopt = handles.stop/handles.stepf;
totalsteps = (handles.stepf*handles.tmax)/handles.savestepf;
actDur = stopt-startt;
total = handles.stepf*handles.tmax;

set(handles.startt,'String',[num2str(startt,3) ' s']);
set(handles.stopt,'String',[num2str(stopt,3) ' s']);
set(handles.totalsavedsteps,'String',[num2str(totalsteps,3) ' steps saved']);
set(handles.actDuration,'String',[num2str(actDur,3) ' s']);
set(handles.totalsteps,'String',total);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = findtempactivation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





%%  Load Datasets
% --- Executes on button press in loadhead.
function loadhead_Callback(hObject, eventdata, handles)
% hObject    handle to loadhead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Head Structure Data','../');
if ~path  % if user selects 'cancel'
    return
end
oldDir = cd(path);
load(filename);
if exist('headdata','var')
    if isa(headdata,'struct')   % compatible with both ways of storing the data
        handles.headdata = headdata.dat;
    else 
        handles.headdata = headdata;
    end
    %handles.strucfilename = filename;
    set(handles.confirmHead,'Visible','on')
else
    warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''headdata''.')
end
cd(oldDir);
guidata(hObject, handles);

% --- Executes on button press in loadEquil.
function loadEquil_Callback(hObject, eventdata, handles)
% hObject    handle to loadEquil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Equillibrium Data','..');
switch index
    case 0
        return
    case 1
        oldDir = cd(path);
        load(filename);
        if exist('equillibriumT','var')
            if isa(equillibriumT,'struct')    % compatible with both ways of storing the data
                handles.equil = equillibriumT.dat;
            else
                handles.equil = equillibriumT;
            end
            set(handles.confirmEquil,'Visible','on')
        else
            warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''equillibriumT''.')
        end
        cd(oldDir);
    otherwise
        return
end
guidata(hObject, handles);

% --- Executes on button press in loadRegion.
function loadRegion_Callback(hObject, eventdata, handles)
% hObject    handle to loadRegion (see GCBO)
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
            if ~isequal(unique(roi_mask),[0 1]')  % makes sure it's a binary array (even if it's not logical type)
                warndlg('The mask must be logical (0 and 1) for it to work properly.  Please select a different file')
                handles.roi_mask = 0;
                cd(oldDir);
                return
            end
            handles.roi_mask = logical(roi_mask);
            set(handles.confirmROI,'Visible','on')
        else  % if the dataset isn't there
           warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''roi_mask''.')
        end
        cd(oldDir);
    case 2  % *.nii file
        oldDir = cd(path);
        handles.roi_mask = loadNII(filename);
        if ~isequal(unique(handles.roi_mask),[0 1]')
            warndlg('The mask must be logical (0 and 1) for it to work properly.  Please select a different file')
            handles.roi_mask = 0;
            cd(oldDir);
            return
        end
        handles.roi_mask = logical(handles.roi_mask);
        set(handles.confirmROI,'Visible','on')
        cd(oldDir);
end
        
guidata(hObject, handles);

% --- Executes on button press in loadMetab.
function loadMetab_Callback(hObject, eventdata, handles)
% hObject    handle to loadMetab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Metabolism Dataset');
switch index
    case 0
        return
    case 1
        oldDir = cd(path);
        load(filename);
        if exist('Expression1','var')  % makes sure the variable exists in the file
            handles.metabDat = Expression1;
            set(handles.confirmMetab,'Visible','on')
        elseif exist('m0001','var')    % if the file contains a matrix for each time step
            handles.metabDat = [path filename];
            set(handles.confirmMetab,'Visible','on')
        else  % if the dataset isn't there
           warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''Expression1''.')
        end
        cd(oldDir);
end

set(handles.metab,'Enable','off')
set(handles.flow,'Enable','off')
set(handles.startstep,'Enable','off')
set(handles.stopstep,'Enable','off')
set(handles.startt,'Enable','off')
set(handles.stopt,'Enable','off')
set(handles.actDuration,'Enable','off')
guidata(hObject, handles);

% --- Executes on button press in loadFlow.
function loadFlow_Callback(hObject, eventdata, handles)
% hObject    handle to loadFlow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat','Blood Flow Dataset','../');

switch index
    case 0
        return
    case 1
        oldDir = cd(path);
        load(filename);
        if exist('Expression1','var')  % makes sure the variable exists in the file
            handles.flowDat = Expression1;
            set(handles.confirmFlow,'Visible','on')
        elseif exist('f0001','var')    % if the file contains a matrix for each time step
            handles.flowDat = [path filename];
            set(handles.confirmFlow,'Visible','on')
        else  % if the dataset isn't there
           warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''Expression1''.')
        end
        cd(oldDir);
end

set(handles.metab,'Enable','off')
set(handles.flow,'Enable','off')
set(handles.startstep,'Enable','off')
set(handles.stopstep,'Enable','off')
set(handles.startt,'Enable','off')
set(handles.stopt,'Enable','off')
set(handles.actDuration,'Enable','off')

guidata(hObject, handles);


% --- Executes on button press in enable_genActPanel.
function enable_genActPanel_Callback(hObject, eventdata, handles)
% hObject    handle to enable_genActPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.metab,'Enable','on')
set(handles.flow,'Enable','on')
set(handles.startstep,'Enable','on')
set(handles.stopstep,'Enable','on')
set(handles.startt,'Enable','on')
set(handles.stopt,'Enable','on')
set(handles.actDuration,'Enable','on')
set(handles.confirmMetab,'Visible','off')
set(handles.confirmFlow,'Visible','off')
handles.flowDat = 0;
handles.metabDat = 0;
guidata(hObject, handles);


%%  Parameters
function metab_Callback(hObject, eventdata, handles)
% hObject    handle to metab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of metab as text
%        str2double(get(hObject,'String')) returns contents of metab as a double
handles.metabolism = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function metab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to metab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flow_Callback(hObject, eventdata, handles)
% hObject    handle to flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flow as text
%        str2double(get(hObject,'String')) returns contents of flow as a double
handles.bloodflow = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function flow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startstep_Callback(hObject, eventdata, handles)
% hObject    handle to startstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startstep as text
%        str2double(get(hObject,'String')) returns contents of startstep as a double
handles.start = str2double(get(hObject,'String'));

updatestatictext(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function startstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stopstep_Callback(hObject, eventdata, handles)
% hObject    handle to stopstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopstep as text
%        str2double(get(hObject,'String')) returns contents of stopstep as a double
handles.stop = str2double(get(hObject,'String'));

updatestatictext(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function stopstep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopstep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function bloodTbox_Callback(hObject, eventdata, handles)
% hObject    handle to bloodTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bloodTbox as text
%        str2double(get(hObject,'String')) returns contents of bloodTbox as a double
handles.bloodT = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bloodTbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bloodTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function airTbox_Callback(hObject, eventdata, handles)
% hObject    handle to airTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of airTbox as text
%        str2double(get(hObject,'String')) returns contents of airTbox as a double
handles.airT = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function airTbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to airTbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tmaxbox_Callback(hObject, eventdata, handles)
% hObject    handle to tmaxbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tmaxbox as text
%        str2double(get(hObject,'String')) returns contents of tmaxbox as a double
handles.tmax = str2double(get(hObject,'String'));

updatestatictext(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function tmaxbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tmaxbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function stepfbox_Callback(hObject, eventdata, handles)
% hObject    handle to stepfbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepfbox as text
%        str2double(get(hObject,'String')) returns contents of stepfbox as a double
handles.stepf = str2double(get(hObject,'String'));

updatestatictext(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function stepfbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepfbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function savestepfbox_Callback(hObject, eventdata, handles)
% hObject    handle to savestepfbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of savestepfbox as text
%        str2double(get(hObject,'String')) returns contents of savestepfbox as a double
handles.savestepf = str2double(get(hObject,'String'));
updatestatictext(hObject, handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function savestepfbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savestepfbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%  Calculate
% --- Executes on button press in calculate.
function calculate_Callback(hObject, eventdata, handles)
% hObject    handle to calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% tempCalcChangingMetabolismFlow(tissue,bloodT,airT,nt,tmax,pastCalc,start,stop,amplitudeMet,amplitudeFlow,region,savesteps)
headdata = handles.headdata;
bloodT = handles.bloodT;
airT = handles.airT;
tmax = handles.tmax;
equil = handles.equil;
metabDat = handles.metabDat;
flowDat = handles.flowDat;
savestepf = handles.savestepf;
roi_mask = handles.roi_mask;

howtocalc = 2*isscalar(metabDat)+isscalar(flowDat);  % sort of binary work around to help choose the case


switch howtocalc
    case 3
        nt = handles.stepf*handles.tmax;
        actResult.dat = tempCalcChangingMetabolismFlow(handles.headdata,handles.bloodT,handles.airT,nt,handles.tmax,handles.equil,handles.start,handles.stop,handles.metabolism,handles.bloodflow,handles.roi_mask,handles.savestepf);
        actResult.likelymaxslice = round(handles.stop/handles.savestepf);
        actResult.bloodT = handles.bloodT;
        actResult.airT = handles.airT;
        actResult.tmax = handles.tmax;
        actResult.stepf = handles.stepf;
        actResult.saveStepf = handles.savestepf;
        actResult.metabChange = handles.metab;
        actResult.flowChange = handles.flow;
        actResult.startStep = handles.start;
        actResult.stopStep = handles.stop;
        uisave({'actResult'},'tt_act_res.mat');
    case 0
        nt = handles.stepf*handles.tmax;
        %{
        if length(metabDat) ~= nt
            warndlg('The metabolism dataset needs to have an elements for every time step')
            return
        end
        if length(flowDat) ~= nt
            warndlg('The flow dataset needs to have an elements for every time step')
            return
        end
        %}
       
        
        actResult.dat = tempCalcDynMF(headdata,bloodT,airT,nt,tmax,equil,metabDat,flowDat,savestepf,roi_mask);
        % [c likelymax] = max(metabDat);
        % actResult.likelymaxslice = likelymax/handles.stepf;
        [c lmax] = max(actResult.dat(:));
        [likelymax x y z] = ind2sub(size(actResult.dat),lmax);
        actResult.likelymaxslice = round(likelymax/handles.stepf);
        actResult.bloodT = handles.bloodT;
        actResult.airT = handles.airT;
        actResult.tmax = handles.tmax;
        actResult.stepf = handles.stepf;
        actResult.savestepf = handles.savestepf;
        actResult.metabandflowdata = 'From Dataset';
        uisave({'actResult'},'tt_act_res.mat');
        %}
    case 2
        warndlg('Please specify a dataset for the metabolism')
        return
    case 1
        warndlg('Please specify a dataset for the blood flow')
        return    
    otherwise
        error('An error has occured while determining which calclulating function to use.  Please quit/reopen the figure')
end
