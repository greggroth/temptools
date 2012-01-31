function [ ] = writeT_to_nii( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Setup
switch length(varargin)
    case 4  % 0
        [file_name file_path file_index] = uigetfile('*.mat','Temperature Data');
        switch file_index
            case 0
                return
            case 1 
                old_path = cd(file_path);
                load(file_name,'actResult');
        end
        [equil_name equil_path equil_index] = uigetfile('*.mat','Equillibtium Data');
        switch equil_index
            case 0
                return
            case 1 
                load(fullfile(equil_path,equil_name),'equillibriumT');
        end
        [exp_name exp_path exp_index] = uigetfile('*.nii','Sample NIFTI');
        switch exp_index
            case 0
                return
            case 1 
                exp_nii = load_nii(fullfile(exp_path,exp_name));
        end
    case 3
        % load(varargin{1},'actResult');
        actResult = varargin{1};
        % load(varargin{2},'equillibriumT');
        equillibriumT = varargin{2};
        % exp_nii = load_nii(varargin{3});
        exp_nii = varargin{3};
    otherwise
        return
end

tMax = size(actResult.dat,1);

mkdir('NIFTI'); 
old_path = cd('NIFTI');

statusbar = waitbar(0,'Initializing');
for i=1:tMax
    try
        waitbar(i/tMax,statusbar,sprintf('%d%%',round((i/tMax)*100)));
    catch err
        return
    end
    
    exp_nii.img = squeeze(actResult.dat(i,:,:,:)-equillibriumT(1,:,:,:));
    save_nii(exp_nii,['temp_' sprintf('%04.0f',i) '.nii']);
end

close(statusbar)
cd(old_path)

