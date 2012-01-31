function varargout = initnii(varargin)
% INITNII MATLAB code for initnii.fig
%      INITNII, by itself, creates a new INITNII or raises the existing
%      singleton*.
%
%      H = INITNII returns the handle to a new INITNII or the handle to
%      the existing singleton*.
%
%      INITNII('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INITNII.M with the given input arguments.
%
%      INITNII('Property','Value',...) creates a new INITNII or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before initnii_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to initnii_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help initnii

% Last Modified by GUIDE v2.5 30-Jun-2011 14:09:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @initnii_OpeningFcn, ...
                   'gui_OutputFcn',  @initnii_OutputFcn, ...
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


% --- Executes just before initnii is made visible.
function initnii_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to initnii (see VARARGIN)

% Choose default command line output for initnii
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes initnii wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = initnii_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_loadniidirectory.
function button_loadniidirectory_Callback(hObject, eventdata, handles)
% hObject    handle to button_loadniidirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir;
if ~path
    return
end
handles.path = path;
% set(handles.headText,'String',handles.strucfilename)
set(handles.button_combinesegment,'Enable','on');
guidata(hObject, handles);


% --- Executes on button press in button_combinesegment.
function button_combinesegment_Callback(hObject, eventdata, handles)
% hObject    handle to button_combinesegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
headdata = ImportSegmentedT1(handles.path);
uisave('headdata','tt_headdata.mat');
close
