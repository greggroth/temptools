function varargout = findequilfigure(varargin)
% FINDEQUILFIGURE MATLAB code for findequilfigure.fig
%      FINDEQUILFIGURE, by itself, creates a new FINDEQUILFIGURE or raises the existing
%      singleton*.
%
%      H = FINDEQUILFIGURE returns the handle to a new FINDEQUILFIGURE or the handle to
%      the existing singleton*.
%
%      FINDEQUILFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDEQUILFIGURE.M with the given input arguments.
%
%      FINDEQUILFIGURE('Property','Value',...) creates a new FINDEQUILFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before findequilfigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to findequilfigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help findequilfigure

% Last Modified by GUIDE v2.5 29-Jun-2011 16:04:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @findequilfigure_OpeningFcn, ...
                   'gui_OutputFcn',  @findequilfigure_OutputFcn, ...
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


% --- Executes just before findequilfigure is made visible.
function findequilfigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to findequilfigure (see VARARGIN)

% Choose default command line output for findequilfigure
handles.output = hObject;

% Setup Variables
handles.bloodT = str2double(get(handles.bloodT,'String'));
handles.airT = str2double(get(handles.airT,'String'));
handles.maxtime = str2double(get(handles.maxtime,'String'));
handles.steprate = str2double(get(handles.stepspersecond,'String'));
handles.strucfilename = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes findequilfigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = findequilfigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function bloodT_Callback(hObject, eventdata, handles)
% hObject    handle to bloodT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bloodT as text
%        str2double(get(hObject,'String')) returns contents of bloodT as a double
handles.bloodT = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function bloodT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bloodT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function airT_Callback(hObject, eventdata, handles)
% hObject    handle to airT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints:  returns contents of airT as text
%        str2double(get(hObject,'String')) returns contents of airT as a double
handles.airT = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function airT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to airT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%  Data Files
% --- Executes on button press in loadstruc.
function loadstruc_Callback(hObject, eventdata, handles)
% hObject    handle to loadstruc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename path index] = uigetfile('*.mat');
switch index
    case 0
        return
    case 1
        oldDir = cd(path);
        load(filename);
        if exist('headdata','var')
            handles.headdata = headdata;
            handles.strucfilename = filename;
            set(handles.confirmHead,'Visible','on')
            set(handles.confirmHead,'String',filename)
        else
        warndlg('The dataset could not be found within that *.mat file.  Please select one that contains a variable named ''headdata''.')
        end
end
cd(oldDir);
guidata(hObject, handles);


function maxtime_Callback(hObject, eventdata, handles)
% hObject    handle to maxtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxtime as text
%        str2double(get(hObject,'String')) returns contents of maxtime as a double
handles.maxtime = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function maxtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stepspersecond_Callback(hObject, eventdata, handles)
% hObject    handle to stepspersecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stepspersecond as text
%        str2double(get(hObject,'String')) returns contents of stepspersecond as a double
handles.steprate = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function stepspersecond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepspersecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startcalc.
function startcalc_Callback(hObject, eventdata, handles)
% hObject    handle to startcalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if ~ischar(handles.strucfilename)
    warndlg('A filename for the structual head data has not been specified')
else
    nt = handles.maxtime*handles.steprate;
    tic
    tempCalcEquillibrium(handles.headdata,handles.bloodT,handles.airT,5,1,0,0);
    t = toc;
    esttime = round(((nt/5)*t)/3600);
    timenotice = questdlg(['The calculation could require as long as ' num2str(esttime,3) ' hours to complete if it allowed to go to the max time.  Usually, equillibrium temperatures can be determined in around 2 hours, depending on your computer.'],'Estimated Time','Continue','Cancel','Continue');
    switch timenotice
        case 'Continue'
            equillibriumT.dat = tempCalcEquillibrium(handles.headdata,handles.bloodT,handles.airT,nt,handles.maxtime);
            equillibriumT.tolerence = 1e-5;  %  This is hardcoded, but should be an argument in the future
            uisave('equillibriumT','tt_equilibriumT.mat')
        case 'Cancel'
            return
    end
end
