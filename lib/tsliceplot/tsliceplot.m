function varargout = tsliceplot(varargin)
% TSLICEPLOT MATLAB code for tsliceplot.fig
%      TSLICEPLOT, by itself, creates a new TSLICEPLOT or raises the existing
%      singleton*.
%
%      H = TSLICEPLOT returns the handle to a new TSLICEPLOT or the handle to
%      the existing singleton*.
%
%      USAGE:  tsliceplot(tempRes,tempEquil)
%
%      TSLICEPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TSLICEPLOT.M with the given input arguments.
%
%      TSLICEPLOT('Property','Value',...) creates a new TSLICEPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tsliceplot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tsliceplot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tsliceplot

% Last Modified by GUIDE v2.5 28-Jun-2011 10:06:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tsliceplot_OpeningFcn, ...
                   'gui_OutputFcn',  @tsliceplot_OutputFcn, ...
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


% --- Executes just before tsliceplot is made visible.
function tsliceplot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tsliceplot (see VARARGIN)

% Choose default command line output for tsliceplot
handles.output = hObject;

if length(varargin) ~= 2
    error('myApp:argChk','The function cannot handle more or less than 2 inputs.  See the help documentation for more information about inputs.')
end

handles.temp = varargin{1};
handles.equil = varargin{2};

switch ndims(handles.equil)
    case 3
        [xmax ymax zmax] = size(handles.equil);
    case 4
        [unused xmax ymax zmax] = size(handles.equil);
    otherwise
        error('Input ''equil'' must have either 3 or 4 dimensions');
end

xstart = round(xmax/2);
ystart = round(ymax/2);
zstart = round(zmax/2);

handles.xmax = xmax;
handles.ymax = ymax;
handles.zmax = zmax;

set(handles.xpoint,'String',xstart);
set(handles.ypoint,'String',ystart);
set(handles.zpoint,'String',zstart);
    
handles.xstate = 1;
handles.ystate = 0;
handles.zstate = 0;

% Default: plot along x-direction
set(handles.plotalongx,'Value',1);
set(handles.xpoint,'Enable','off');
set(handles.xu,'Enable','off');
set(handles.xd,'Enable','off');

% Checks to see if SliceBrowser is already open and if it, sets the
% starting coordinate to whatever the pointer is at in SliceBrowser
p = getappdata(0,'pos');
if size(p,1) == 0
    setappdata(0,'pos',0);  %  creates 'pos' for the getcoordinatesfromSliceBrowser business
elseif size(p,2) == 4
    set(handles.xpoint,'String',p(1));
    set(handles.ypoint,'String',p(2));
    set(handles.zpoint,'String',p(3));
end
   
handles.view = 3;
plotit(hObject, handles) 

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes tsliceplot wait for user response (see UIRESUME)
% uiwait(handles.tsliceplot);


% --- Outputs from this function are returned to the command line.
function varargout = tsliceplot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xpoint_Callback(hObject, eventdata, handles)
% hObject    handle to xpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xpoint as text
%        str2double(get(hObject,'String')) returns contents of xpoint as a double
guidata(hObject, handles);
plotit(hObject, handles)

% --- Executes during object creation, after setting all properties.
function xpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ypoint_Callback(hObject, eventdata, handles)
% hObject    handle to ypoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ypoint as text
%        str2double(get(hObject,'String')) returns contents of ypoint as a double
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes during object creation, after setting all properties.
function ypoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function zpoint_Callback(hObject, eventdata, handles)
% hObject    handle to zpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zpoint as text
%        str2double(get(hObject,'String')) returns contents of zpoint as a double
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes during object creation, after setting all properties.
function zpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xu.
function xu_Callback(hObject, eventdata, handles)
% hObject    handle to xu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(handles.xpoint,'String');
if eval(x)<handles.xmax
    set(handles.xpoint,'String',eval(x)+1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in yu.
function yu_Callback(hObject, eventdata, handles)
% hObject    handle to yu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y = get(handles.ypoint,'String');
if eval(y)<handles.ymax
    set(handles.ypoint,'String',eval(y)+1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in zu.
function zu_Callback(hObject, eventdata, handles)
% hObject    handle to zu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z = get(handles.zpoint,'String');
if eval(z)<handles.zmax
    set(handles.zpoint,'String',eval(z)+1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in xd.
function xd_Callback(hObject, eventdata, handles)
% hObject    handle to xd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = get(handles.xpoint,'String');
if eval(x)>0
    set(handles.xpoint,'String',eval(x)-1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in yd.
function yd_Callback(hObject, eventdata, handles)
% hObject    handle to yd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y = get(handles.ypoint,'String');
if eval(y)>0
    set(handles.ypoint,'String',eval(y)-1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in zd.
function zd_Callback(hObject, eventdata, handles)
% hObject    handle to zd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
z = get(handles.zpoint,'String');
if eval(z)>0
    set(handles.zpoint,'String',eval(z)-1);
end
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in plotalongx.
function plotalongx_Callback(hObject, eventdata, handles)
% hObject    handle to plotalongx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotalongx
%state = get(hObject,'Value');
%handles.xstate = state;
guidata(hObject, handles);
updatecheckboxes(hObject,handles,1)


% --- Executes on button press in plotalongy.
function plotalongy_Callback(hObject, eventdata, handles)
% hObject    handle to plotalongy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotalongy
%state = get(hObject,'Value');
%handles.ystate = state;
guidata(hObject, handles);
updatecheckboxes(hObject,handles,2)


% --- Executes on button press in plotalongz.
function plotalongz_Callback(hObject, eventdata, handles)
% hObject    handle to plotalongz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotalongz
%state = get(hObject,'Value');
%handles.zstate = state;
guidata(hObject, handles);
updatecheckboxes(hObject,handles,3)

%%  Keep all of the gui elements in order
function updatecheckboxes(hObject,handles,sender)
xstate = get(handles.plotalongx,'Value');
ystate = get(handles.plotalongy,'Value');
zstate = get(handles.plotalongz,'Value');

% if (xstate&&ystate)||(xstate&&zstate)||(ystate&&zstate)
%    error('An error has occured.  Only one check box can be selected')
% end


switch sender
    case 1
        if xstate
            set(handles.plotalongy,'Value',0);
            set(handles.plotalongz,'Value',0);
            set(handles.xpoint,'Enable','off');
            set(handles.xu,'Enable','off');
            set(handles.xd,'Enable','off');
            set(handles.ypoint,'Enable','on');
            set(handles.yu,'Enable','on');
            set(handles.yd,'Enable','on');
            set(handles.zpoint,'Enable','on');
            set(handles.zu,'Enable','on');
            set(handles.zd,'Enable','on');
        else 
            set(handles.xpoint,'Enable','on');
            set(handles.xu,'Enable','on');
            set(handles.xd,'Enable','on');
        end
    case 2
        if ystate
            set(handles.plotalongx,'Value',0);
            set(handles.plotalongz,'Value',0);
            set(handles.xpoint,'Enable','on');
            set(handles.xu,'Enable','on');
            set(handles.xd,'Enable','on');
            set(handles.ypoint,'Enable','off');
            set(handles.yu,'Enable','off');
            set(handles.yd,'Enable','off');
            set(handles.zpoint,'Enable','on');
            set(handles.zu,'Enable','on');
            set(handles.zd,'Enable','on');
        else 
            set(handles.ypoint,'Enable','on');
            set(handles.yu,'Enable','on');
            set(handles.yd,'Enable','on');
        end
    case 3
        if zstate
            set(handles.plotalongx,'Value',0);
            set(handles.plotalongy,'Value',0);
            set(handles.xpoint,'Enable','on');
            set(handles.xu,'Enable','on');
            set(handles.xd,'Enable','on');
            set(handles.ypoint,'Enable','on');
            set(handles.yu,'Enable','on');
            set(handles.yd,'Enable','on');
            set(handles.zpoint,'Enable','off');
            set(handles.zu,'Enable','off');
            set(handles.zd,'Enable','off');
        else 
            set(handles.zpoint,'Enable','on');
            set(handles.zu,'Enable','on');
            set(handles.zd,'Enable','on');
        end
    otherwise
        error('this should never happen');
end
guidata(hObject, handles);
plotit(hObject, handles)

%%  Plot the data
function plotit(hObject, handles)
xstate = get(handles.plotalongx,'Value');
ystate = get(handles.plotalongy,'Value');
zstate = get(handles.plotalongz,'Value');

x = eval(get(handles.xpoint,'String'));
y = eval(get(handles.ypoint,'String'));
z = eval(get(handles.zpoint,'String'));

temp = handles.temp;
initequil = handles.equil;
equil = zeros([1 size(temp,2) size(temp,3) size(temp,4)]);


if ndims(initequil) == 3
    equil(1,:,:,:) = initequil;
elseif ndims(initequil)==4
    equil = initequil;
else
    error('Input ''equil'' must have either 3 or 4 dimensions')
end

if xstate
    tem = squeeze(temp(:,:,y,z));
    equil = squeeze(equil(1,:,y,z));
    choice = 1;
elseif ystate
    tem = squeeze(handles.temp(:,x,:,z));
    equil = squeeze(equil(1,x,:,z));
    equil = permute(equil,[2 1]);
    choice = 2;
elseif zstate
    tem = squeeze(temp(:,x,y,:));
    equil = squeeze(equil(1,x,y,:));
    equil = permute(equil,[2 1]);
    choice = 3;
else
    %disp('No axes selected.  Switching to x-axis.')
    set(handles.plotalongx,'Value',1);
    updatecheckboxes(hObject,handles,1)
    return
end

%  2:  create x and y grids using size(tem) for lengths
[xmat ymat] = meshgrid(1:size(tem,2),1:size(tem,1));


diff = tem-repmat(equil,size(tem,1),1);

%  Likely source of error:  all of the data needs to be in double format or
%  else it wont plot.  So:
diff = double(diff);
%  and plot:
plothand = surf(xmat,ymat,diff);
rotate3d on
title('Temperature Change Along a Line Through Time','fontsize',18)
c = zlabel('Change in Temperature (^{\circ}C)');

switch choice
    case 1
        title(strcat('Temperature Change Along a Line Through Time, y = ',int2str(y),' and z = ',int2str(z)));
        a = ylabel('Time (steps)'); b = xlabel('X-Direction');
        set(handles.view1,'String','View along X-Temp Plane')
        set(handles.view3,'String','View along X-Time Plane')
        pointat = x;
    case 2
        title(strcat('Temperature Change Along a Line Through Time, x = ',int2str(x),' and z = ',int2str(z)));
        a = ylabel('Time (steps)'); b = xlabel('Y-Direction');
        set(handles.view1,'String','View along Y-Temp Plane')
        set(handles.view3,'String','View along Y-Time Plane')
        pointat = y;
    case 3
        title(strcat('Temperature Change Along a Line Through Time, x = ',int2str(x),' and y = ',int2str(y)));
        a = ylabel('Time (steps)'); b = xlabel('Z-Direction');
        set(handles.view1,'String','View along Z-Temp Plane')
        set(handles.view3,'String','View along Z-Time Plane')
        pointat = z;
    otherwise
        error('Error determining which set of plot labels to use');
end
%  Plane to show where pointer is
zlim = get(gca,'ZLim');
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
patch([pointat pointat pointat pointat],[ylim(1) ylim(1) ylim(2) ylim(2)],[zlim(1) zlim(2) zlim(2) zlim(1)],'r','FaceAlpha',0.15,'EdgeColor','r')


set(a,'fontsize',14);  %  Properties for ylabel
set(b,'fontsize',14);  %  Propertirs for xlabel
set(c,'fontsize',14);  %  Propertirs for zlabel
set(plothand,'MeshStyle','column');
colorbar;
view(handles.view);


% --- Executes on button press in view1.
function view1_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles   structure with handles and user data (see GUIDATA)
handles.view = [0 -1 0];
guidata(hObject, handles);
plotit(hObject, handles)

% --- Executes on button press in view2.
function view2_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles   structure with handles and user data (see GUIDATA)
handles.view = [-1 0 0];
guidata(hObject, handles);
plotit(hObject, handles)

% --- Executes on button press in view3.
function view3_Callback(hObject, eventdata, handles)
% hObject    handle to view4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.view = [0 0 1];
guidata(hObject, handles);
plotit(hObject, handles)

% --- Executes on button press in view4.
function view4_Callback(hObject, eventdata, handles)
% hObject    handle to view4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.view = 3;
guidata(hObject, handles);
plotit(hObject, handles)


% --- Executes on button press in btnsharepoints.
function btnsharepoints_Callback(hObject, eventdata, handles)
% hObject    handle to btnsharepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos = getappdata(0,'pos');
% disp(size(pos,2))
if size(pos,2) ~= 4
    warndlg('SliceBrowser must be open for this feature to work properly','SliceBrowser not detected')
end
if size(pos,2) == 4
    set(handles.xpoint,'String',pos(1));
    set(handles.ypoint,'String',pos(2));
    set(handles.zpoint,'String',pos(3));
end
guidata(hObject, handles);
plotit(hObject, handles)
