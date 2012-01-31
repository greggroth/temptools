function varargout = SliceBrowserOverlay(varargin)
%SLICEBROWSEROVERLAY M-file for SliceBrowserOverlay.fig
%       SliceBrowserOverlay is an interactive viewer of 3D volumes, 
%       it shows 3 perpendicular slices (XY, YZ, ZX) with 3D pointer.
%   Input:  a) VOLUME - a 3D matrix with volume data
%           b) VOLUME - a 4D matrix with volume data over time
%   Control:
%       - Clicking into the window changes the location of 3D pointer.
%       - 3D pointer can be moved also by keyboard arrows.
%       - Pressing +/- will switch to next/previous volume.
%       - Pressing 1,2,3 will change the focus of current axis.
%       - Pressing 'e' will print the location of 3D pointer.
%       - Pressing 'c' switches between color-mode and grayscale.
%   Example of usage:
%       load mri.dat
%       volume = squeeze(D);
%       SliceBrowserOverlay(volume);
%
% Author: Marian Uhercik, CMP, CTU in Prague
% Web: http://cmp.felk.cvut.cz/~uhercik/3DSliceViewer/3DSliceViewer.htm
% Last Modified by 05-Aug-2008
% Documentation generated GUIDE:
%
%SLICEBROWSEROVERLAY M-file for SliceBrowserOverlay.fig
%      SLICEBROWSEROVERLAY, by itself, creates a new SLICEBROWSEROVERLAY or raises the existing
%      singleton*.
%
%      H = SLICEBROWSEROVERLAY returns the handle to a new SLICEBROWSEROVERLAY or the handle to
%      the existing singleton*.
%
%      SLICEBROWSEROVERLAY('Property','Value',...) creates a new SLICEBROWSEROVERLAY using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to SliceBrowserOverlay_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      SLICEBROWSEROVERLAY('CALLBACK') and SLICEBROWSEROVERLAY('CALLBACK',hObject,...) call the
%      local function named CALLBACK in SLICEBROWSEROVERLAY.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SliceBrowserOverlay



% Last Modified by GUIDE v2.5 17-Aug-2011 14:04:38

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SliceBrowserOverlay_OpeningFcn, ...
                   'gui_OutputFcn',  @SliceBrowserOverlay_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


%% --- Executes just before SliceBrowserOverlay is made visible.
function SliceBrowserOverlay_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for SliceBrowserOverlay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SliceBrowserOverlay wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if (length(varargin) <=0)
    error('Input volume has not been specified.');
end;

volume = varargin{1};
%  Varargin guide:
%   1       2        3         4             5    
%  volume  dataset  headdata  activeRegion  alph

if length(varargin) == 2     % for just head
    dataset = varargin{2};
    headdata = 1;
    activeRegionSwitch = 0;
    activeRegion = 0;
    alph = 0;
elseif length(varargin) == 3  % for head and temperature     overlay
    dataset = varargin{2};
    headdata = varargin{3};
    activeRegionSwitch = 0;
    activeRegion = 0;
    alph = 0;
elseif length(varargin) == 4  % for head, temp, act region   
    dataset = varargin{2};
    headdata = varargin{3};
    activeRegionSwitch = 1;
    activeRegion = varargin{4};
    alph = 0;
elseif length(varargin) == 5  % to do an overlay
    dataset = varargin{2};
    headdata = varargin{3};
    activeRegionSwitch = 1;
    activeRegion = varargin{4};
    alph = varargin{5};
else                          % who knows
    dataset = 1;
    headdata = 1;
    activeRegionSwitch = 0;
    activeRegion = 0;
    alph = 0;
end
% stop my code


if (ndims(volume) ~= 3 && ndims(volume) ~= 4)
    error('Input volume must have 3 or 4 dimensions.');
end;

handles.volume = volume;
handles.dataset = dataset;
handles.headdata = headdata;
handles.activeRegion = activeRegion;
handles.activeRegionSwitch = activeRegionSwitch;
handles.alph = alph;
handles.viewgm = 0;
handles.viewwm = 0;
handles.viewhead = 0;
handles.viewroi = 0;
handles.show_lines = 0;

handles.color_mode = 1;
if (size(volume,4) ~= 3)
    handles.color_mode = 1;
end;

% set main wnd title
set(gcf, 'Name', 'Slice Viewer')

% init 3D pointer
vol_sz = size(volume); 
if (ndims(volume) == 3)
    vol_sz(4) = 1;
end;
pointer3dt = floor(vol_sz/2)+1;
handles.pointer3dt = pointer3dt;
handles.vol_sz = vol_sz;
% INIT save position to workspace
setappdata(0,'pos',handles.pointer3dt)

plot3slices(hObject, handles);

% stores ID of last axis window 
% (0 means that no axis was clicked yet)
handles.last_axis_id = 0;

% Update handles structure
guidata(hObject, handles);


%% --- Outputs from this function are returned to the command line.
function varargout = SliceBrowserOverlay_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on mouse press over axes background.
function Subplot1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the XY slice

% UPDATED FOR ZX SLICE
% disp('Subplot1:BtnDown');
pt=get(gca,'currentpoint');
%{
orig:
xpos=round(pt(1,2)); 
ypos=round(pt(1,1));
zpos = handles.pointer3dt(3);
%}
xpos=round(pt(1,1)); 
zpos=round(pt(1,2));
ypos = handles.pointer3dt(2);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 1;
% save position to workspace
setappdata(0,'pos',handles.pointer3dt)
% Update handles structure
guidata(hObject, handles);

%% --- Executes on mouse press over axes background.
function Subplot2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the YZ slice

% UPDATED FOR ZY SLICE

%disp('Subplot2:BtnDown');
pt=get(gca,'currentpoint');
%{
xpos=round(pt(1,2)); 
zpos=round(pt(1,1));
ypos = handles.pointer3dt(2);
%}
zpos=round(pt(1,2));
ypos=round(pt(1,1)); 
xpos = handles.pointer3dt(1);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 2;
% save position to workspace
setappdata(0,'pos',handles.pointer3dt)
% Update handles structure
guidata(hObject, handles);

%% --- Executes on mouse press over axes background.
function Subplot3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Subplot3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% This object contains the XZ slice

% UPDATED FOR YX SLICE

%disp('Subplot3:BtnDown');
pt=get(gca,'currentpoint');
%{
zpos=round(pt(1,2)); 
ypos=round(pt(1,1));
xpos = handles.pointer3dt(1);
%}
ypos=round(pt(1,2)); 
xpos=round(pt(1,1));
zpos = handles.pointer3dt(3);
tpos = handles.pointer3dt(4);
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% store this axis as last clicked region
handles.last_axis_id = 3;
% save position to workspace
setappdata(0,'pos',handles.pointer3dt)
% Update handles structure
guidata(hObject, handles);

%% --- Executes on key press with focus on SliceBrowserFigure and no controls selected.
function SliceBrowserFigure_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to SliceBrowserFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp('SliceBrowserFigure_KeyPressFcn');
curr_char = int8(get(gcf,'CurrentCharacter'));
if isempty(curr_char)
    return;
end;

xpos = handles.pointer3dt(1);
ypos = handles.pointer3dt(2);
zpos = handles.pointer3dt(3); 
tpos = handles.pointer3dt(4); 
% Keys:
% - up:   30
% - down:   31
% - left:   28
% - right:   29
% - '1': 49
% - '2': 50
% - '3': 51
% - 'e': 101
% - plus:  43
% - minus:  45
switch curr_char
    case 99 % 'c'
        handles.color_mode = 1 - handles.color_mode;
        if (handles.color_mode ==1 && size(handles.volume,4) ~= 3)
            handles.color_mode = 1;
        end;
        
    case 30
        switch handles.last_axis_id
            case 1
                zpos = zpos +1;
            case 2
                zpos = zpos +1;
            case 3
                ypos = ypos +1;
            case 0
        end;
    case 31
        switch handles.last_axis_id
            case 1
                zpos = zpos -1;
            case 2
                zpos = zpos -1;
            case 3
                ypos = ypos -1;
            case 0
        end;
    case 28
        switch handles.last_axis_id
            case 1
                xpos = xpos -1;
            case 2
                ypos = ypos -1;
            case 3
                xpos = xpos -1;
            case 0
        end;
    case 29
        switch handles.last_axis_id
            case 1
                xpos = xpos +1;
            case 2
                ypos = ypos +1;
            case 3
                xpos = xpos +1;
            case 0
        end;
    case 43
        % plus key
        tpos = tpos+1;
    case 45
        % minus key
        tpos = tpos-1;
    case 49
        % key 1
        handles.last_axis_id = 1;
    case 50
        % key 2
        handles.last_axis_id = 2;
    case 51
        % key 3
        handles.last_axis_id = 3;
    case 101
        disp(['[' num2str(xpos) ' ' num2str(ypos) ' ' num2str(zpos) ' ' num2str(tpos) ']']);
    otherwise
        return
end;
handles.pointer3dt = [xpos ypos zpos tpos];
handles.pointer3dt = clipointer3d(handles.pointer3dt,handles.vol_sz);
plot3slices(hObject, handles);
% Update handles structure
guidata(hObject, handles);

%% --- Plots all 3 slices XY, YZ, XZ into 3 subplots
function [sp1,sp2,sp3,sp4] = plot3slices(hObject, handles)
% pointer3d     3D coordinates in volume matrix (integers)

handles.pointer3dt;
size(handles.volume);

% value3dt needs to be fixed to return the right value.
value3dt = handles.volume(handles.pointer3dt(1), handles.pointer3dt(2),handles.pointer3dt(3));
% value3dt = handles.volume(handles.pointer3dt(1), handles.pointer3dt(2), (size(handles.volume,3)-handles.pointer3dt(3)), handles.pointer3dt(4));

text_str = ['X: ' int2str(handles.pointer3dt(1)) ...
           '  Y: ' int2str(handles.pointer3dt(2)) ...
           '  Z: ' int2str(handles.pointer3dt(3)) ...
           '       value:  ' num2str(value3dt)];
set(handles.pointer3d_info, 'String', text_str);
guidata(hObject, handles);

%{
ORIGIONAL FROM ABOVE
text_str = ['[X:' int2str(handles.pointer3dt(1)) ...
           ', Y:' int2str(handles.pointer3dt(2)) ...
           ', Z:' int2str(handles.pointer3dt(3)) ...
           ', Time:' int2str(handles.pointer3dt(4)) '/' int2str(handles.vol_sz(4)) ...
           '], value:' num2str(value3dt)];
%}

%{
ORIGIONAL FROM BELOW.  Changed to fix the projections to match convention
    sliceXY = squeeze(handles.volume(:,:,handles.pointer3dt(3),:));
    sliceYZ = squeeze(handles.volume(handles.pointer3dt(1),:,:,:));
    sliceXZ = squeeze(handles.volume(:,handles.pointer3dt(2),:,:));

    max_xyz = max([ max(sliceXY(:)) max(sliceYZ(:)) max(sliceXZ(:)) ]);
    min_xyz = min([ min(sliceXY(:)) min(sliceYZ(:)) min(sliceXZ(:)) ]);
    clims = [ min_xyz max_xyz ];
%}

if (handles.color_mode ==1)
    
    %{
    % Origional
    sliceXY = squeeze(handles.volume(:,:,handles.pointer3dt(3),:));
    sliceYZ = squeeze(handles.volume(handles.pointer3dt(1),:,:,:));
    sliceXZ = squeeze(handles.volume(:,handles.pointer3dt(2),:,:));
    %}
    
   % MY ADDITON
   %  I redid the slices in order to have projections that match with other
   %  fMRI viewers
    sliceZX = permute(squeeze(handles.volume(:,handles.pointer3dt(2),:,:)),[2 1]);
    sliceZY = permute(squeeze(handles.volume(handles.pointer3dt(1),:,:,:)),[2 1]);
    sliceYX = permute(squeeze(handles.volume(:,:,handles.pointer3dt(3),:)),[2 1]);
   
   
    max_xyz = max([ max(sliceZX(:)) max(sliceZY(:)) max(sliceYX(:)) ]);
    min_xyz = min([ min(sliceZX(:)) min(sliceZY(:)) min(sliceYX(:)) ]);
    % clims = [ 10 38 ];
    clims = [ min_xyz max_xyz ];
else
    disp('something went terriblly wrong.  initiaing self-destruct . . . please wait.')
    sliceXY = squeeze(handles.volume(:,:,handles.pointer3dt(3),handles.pointer3dt(4)));
    sliceYZ = squeeze(handles.volume(handles.pointer3dt(1),:,:,handles.pointer3dt(4)));
    sliceXZ = squeeze(handles.volume(:,handles.pointer3dt(2),:,handles.pointer3dt(4)));

    max_xyz = max([ max(sliceXY(:)) max(sliceYZ(:)) max(sliceXZ(:)) ]);
    min_xyz = min([ min(sliceXY(:)) min(sliceYZ(:)) min(sliceXZ(:)) ]);
    clims = [ min_xyz max_xyz ];
end;
%  MY CODE
%  Adds slices to be used to countour plots
if size(handles.headdata) ~= 1
    headzx = permute(squeeze(handles.headdata(:,handles.pointer3dt(2),:)),[2 1]);
    headzy = permute(squeeze(handles.headdata(handles.pointer3dt(1),:,:)),[2 1]);
    headyx = permute(squeeze(handles.headdata(:,:,handles.pointer3dt(3))),[2 1]);
    
    alphzx = abs(sliceZX)>handles.alph;
    alphzy = abs(sliceZY)>handles.alph;
    alphyx = abs(sliceYX)>handles.alph;
end
if handles.activeRegionSwitch
    regzx = permute(squeeze(handles.activeRegion(:,handles.pointer3dt(2),:)),[2 1]);
    regzy = permute(squeeze(handles.activeRegion(handles.pointer3dt(1),:,:)),[2 1]);
    regyx = permute(squeeze(handles.activeRegion(:,:,handles.pointer3dt(3))),[2 1]);
end
%  END MY CODE

% sliceZY = squeeze(permute(sliceYZ, [2 1 3]));
% sliceYX = squeeze(flipud(permute(sliceYX, [2 1 3])));



%{ 
% corrections
sliceXY = squeeze(rot90(sliceXY));
sliceXZ = squeeze(rot90(sliceXZ));
sliceZY = squeeze(flipdim(rot90(sliceZY, 2), 2));
%}

dataset = handles.dataset;
viewgm = handles.viewgm;
viewwm = handles.viewwm;
viewhead = handles.viewhead;
viewroi = handles.viewroi;

activeRegionSwitch = handles.activeRegionSwitch;

[tmax xmax ymax zmax] = size(dataset);

sp1 = subplot(2,2,1);  % orginally (2,2,1)
sc(headzx, 'gray');
hold on  %  the next couple lines adds a contour plot to show the structural data
imagesc(sliceZX,'AlphaData',alphzx,clims)
colormap(jet)
if viewgm && max(unique(headzx==11)) % if checkbox is checked and there is a possible contour line
    contour(headzx==11,1,'-w'); %  Gray Matter
end
if viewwm && max(unique(headzx==15))
    contour(headzx==15,1,'-c'); %  White Matter
end
if viewhead && max(unique(headzx==3))
    contour(headzx==3,1,'-r');  %  Cancellous bone
end
if activeRegionSwitch && logical(max(unique(regzx))) && viewroi
    contour(regzx,1,'-y');
end

title('Slice ZX'); % was XY
ylabel('Z');xlabel('X');
if ~handles.show_lines
    line([handles.pointer3dt(1) handles.pointer3dt(1)], [0 size(handles.volume,3)]);
    line([0 size(handles.volume,1)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
end
%set(allchild(gca),'ButtonDownFcn',@Subplot1_ButtonDownFcn);
set(gca,'YDir','normal','Visible','on')
set(allchild(gca),'ButtonDownFcn','SliceBrowserOverlay(''Subplot1_ButtonDownFcn'',gca,[],guidata(gcbo))');
hold off

sp2 = subplot(2,2,2); % orginally (2,2,2)
sc(headzy,'gray')
hold on
imagesc(sliceZY, 'AlphaData',alphzy,clims);
colormap(jet)
%  the next couple lines adds a contour plot to show the structural data
if viewgm && max(unique(headzy==11))
    contour(headzy==11,1,'-w');
end
if viewwm && max(unique(headzy==11))
    contour(headzy==15,1,'-c');
end
if viewhead && max(unique(headzy==11))
    contour(headzy==3,1,'-r');
end
if activeRegionSwitch && logical(max(unique(regzy))) && viewroi
    contour(regzy,1,'-y');
end
%title('Slice ZY'); % was XZ
%ylabel('Z');xlabel('Y');
set(gca, 'XTickLabelMode', 'Manual')
set(gca, 'XTick', [])
set(gca, 'YTickLabelMode', 'Manual')
set(gca, 'YTick', [])

if ~handles.show_lines
    line([handles.pointer3dt(2) handles.pointer3dt(2)], [0 size(handles.volume,3)]);
    line([0 size(handles.volume,2)], [handles.pointer3dt(3) handles.pointer3dt(3)]);
end
    %set(allchild(gca),'ButtonDownFcn',@Subplot2_ButtonDownFcn);
set(gca,'YDir','normal','Visible','on')
set(allchild(gca),'ButtonDownFcn','SliceBrowserOverlay(''Subplot2_ButtonDownFcn'',gca,[],guidata(gcbo))');
hold off

sp3 = subplot(2,2,3); % orginally (2,2,3)
sc(headyx,'gray')
hold on
imagesc(sliceYX, 'AlphaData',alphyx,clims);
colormap(jet)
%  the next couple lines adds a contour plot to show the structural data
if viewgm && max(unique(headyx==11))
    contour(headyx==11,1,'-w');
end
if viewwm && max(unique(headyx==15))
    contour(headyx==15,1,'-c');
end
if viewhead && max(unique(headyx==3))
    contour(headyx==3,1,'-r');
end
if activeRegionSwitch && logical(max(unique(regyx))) && viewroi
    contour(regyx,1,'-y');
end
title('Slice YX'); % was ZY
ylabel('Y');xlabel('X');
if ~handles.show_lines
    line([handles.pointer3dt(1) handles.pointer3dt(1)], [0 size(handles.volume,2)]);
    line([0 size(handles.volume,1)], [handles.pointer3dt(2) handles.pointer3dt(2)]);
end
    %set(allchild(gca),'ButtonDownFcn',@Subplot3_ButtonDownFcn);
set(gca,'YDir','normal','Visible','on')

set(allchild(gca),'ButtonDownFcn','SliceBrowserOverlay(''Subplot3_ButtonDownFcn'',gca,[],guidata(gcbo))');
hold off

sp4 = subplot(2,2,4);
if dataset == 1  % crappy work around to keep it working when not using a time dataset
    plot(0);
else
    plot([1:2:360],dataset(:,handles.pointer3dt(1),handles.pointer3dt(2),handles.pointer3dt(3)));
end
hold on
title('Time Course');
ylabel('Temperature (C)');xlabel('Time (s)');
hold off


%dataset(t,handles.pointer3dt(1),handles.pointer3dt(2),handles.pointer3dt(3)))


function pointer3d_out = clipointer3d(pointer3d_in,vol_size)
pointer3d_out = pointer3d_in;
for p_id=1:4
    if (pointer3d_in(p_id) > vol_size(p_id))
        pointer3d_out(p_id) = vol_size(p_id);
    end;
    if (pointer3d_in(p_id) < 1)
        pointer3d_out(p_id) = 1;
    end;
end;


% --- Executes during object creation, after setting all properties.
function SliceBrowserFigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceBrowserFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function colormaps_Callback(hObject, eventdata, handles)
% hObject    handle to colormaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function jet_Callback(hObject, eventdata, handles)
% hObject    handle to jet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.color_mode = 


% --- Executes on button press in viewgm.
function viewgm_Callback(hObject, eventdata, handles)
% hObject    handle to viewgm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viewgm
handles.viewgm = get(hObject,'Value');
plot3slices(hObject, handles);
guidata(hObject, handles);


% --- Executes on button press in viewwm.
function viewwm_Callback(hObject, eventdata, handles)
% hObject    handle to viewwm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viewwm
handles.viewwm = get(hObject,'Value');
plot3slices(hObject, handles);
guidata(hObject, handles);


% --- Executes on button press in viewhead.
function viewhead_Callback(hObject, eventdata, handles)
% hObject    handle to viewhead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viewhead
handles.viewhead = get(hObject,'Value');
plot3slices(hObject, handles);
guidata(hObject, handles);


% --- Executes on button press in roi.
function roi_Callback(hObject, eventdata, handles)
% hObject    handle to roi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi
handles.viewroi = get(hObject,'Value');
plot3slices(hObject, handles);
guidata(hObject, handles);


% --- Executes on button press in plottc1.
function plottc1_Callback(hObject, eventdata, handles)
% hObject    handle to plottc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%{
dat = handles.dataset;
tmax = size(respos,1);

switch handles.last_axis_id
    case 1
        slice = squeeze(dat(1:tmax,:,handles.pointer3dt(2),handles.pointer3dt(3)));
        equil = squeeze(handles.
    case 2
        disp(2);
    case 3
        disp(3);
    otherwise
        return
end
[x y] = meshgrid(1:size(slice,2),1:size(slice,1));
        
figure;
x = [0:.1:pi];
plot(sin(x))
%}


% --- Executes on button press in toggle_lines.
function toggle_lines_Callback(hObject, eventdata, handles)
% hObject    handle to toggle_lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggle_lines
handles.show_lines =  get(hObject,'Value');
plot3slices(hObject, handles);
guidata(hObject, handles);


