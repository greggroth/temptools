function [ ] = combineBOLD( varargin )
%combineBOLD Combines all nifti files in a directory to one *.mat file
%   In order to visualize BOLD data (espicially a time series), all of the
%   datasets must be conbined and saved as a *.mat file under a variable
%   named actResults

%%  Setup
fold_name = uigetdir;
if ~fold_name
    return
end

old_fold = cd(fold_name);
file_list = dir('*.nii');
file_count = length(file_list);

statusbar = waitbar(0,'Initializing');

s = loadNII(file_list(1).name);
actResult.dat = zeros([file_count size(s)]);
actResult.dat(1,:,:,:) = s;

for i=2:file_count
    try
        waitbar(i/file_count,statusbar,sprintf('%d%%',round((i/file_count)*100)));
    catch err
        return
    end
    actResult.dat(i,:,:,:) = loadNII(file_list(i).name);
end

actResult.likelymaxslice = 0;

save('CombinedBOLD.mat','actResult');

cd(old_fold)
close(statusbar)

end

