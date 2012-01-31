function varargout = temptools(varargin)
% temptools MATLAB code for temptools.fig
%      temptools, by itself, creates a new temptools or raises the existing
%      singleton*.
%
%      H = temptools returns the handle to a new temptools or the handle to
%      the existing singleton*.
%
%      temptools('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in temptools.M with the given input arguments.
%
%      temptools('Property','Value',...) creates a new temptools or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before temptools_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to temptools_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help temptools

% Last Modified by GUIDE v2.5 07-Jul-2011 09:46:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @temptools_OpeningFcn, ...
                   'gui_OutputFcn',  @temptools_OutputFcn, ...
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


% --- Executes just before temptools is made visible.
function temptools_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to temptools (see VARARGIN)

% Choose default command line output for temptools
handles.output = hObject;

% Change the directoy to the one with temptools
% fctPath = fileparts(which('temptools'));
% cd(fctPath)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes temptools wait for user response (see UIRESUME)
% uiwait(handles.temptools);


% --- Outputs from this function are returned to the command line.
function varargout = temptools_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b_loadNII.
function b_loadNII_Callback(hObject, eventdata, handles)
% hObject    handle to b_loadNII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fctDir = fileparts(which('initnii'));
oldDir = cd(fctDir);
initnii;
cd(oldDir);


% --- Executes on button press in b_findEquil.
function b_findEquil_Callback(hObject, eventdata, handles)
% hObject    handle to b_findEquil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fctDir = fileparts(which('findequilfigure'));
oldDir = cd(fctDir);
findequilfigure;
cd(oldDir);

% --- Executes on button press in b_calcMF.
function b_calcMF_Callback(hObject, eventdata, handles)
% hObject    handle to b_calcMF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fctDir = fileparts(which('BOLDtoMF'));
oldDir = cd(fctDir);
BOLDtoMF;
cd(oldDir);

% --- Executes on button press in b_findT.
function b_findT_Callback(hObject, eventdata, handles)
% hObject    handle to b_findT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fctDir = fileparts(which('findtempactivation'));
oldDir = cd(fctDir);
findtempactivation;
cd(oldDir);


% --- Executes on button press in b_vis.
function b_vis_Callback(hObject, eventdata, handles)
% hObject    handle to b_vis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fctDir = fileparts(which('visualize'));
oldDir = cd(fctDir);
visualize;
cd(oldDir);
