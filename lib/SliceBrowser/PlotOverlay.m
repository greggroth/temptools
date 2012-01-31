function [ ] = PlotOverlay( bg, lay2, threshold ,tempdata,mask)
%PlotOverlay Wrapper for SliceBrowserOverlay
%   Use this function when you want a quick way of plotting a mask over a
%   background.  If the mask is already logical, then it can be used
%   without specifying a threshold value:
%       PlotOverlay(bg, mask)
%   Otherwise, the mask can be defined outside the function and reduced to
%   three dimensions

if nargin < 3, threshold = 0; end 
if nargin < 4, tempdata = 1;  end
if nargin < 5, mask = lay2;   end
if ndims(bg) ~= 3, error('input ''bg'' must have three dimensions'); end
if ndims(mask) ~= 3, error('input ''mask'' must have three dimensions'); end

% SliceBrowserOverlay(volume,dataset,headdata,activeregion,alph);
%  volume: data being plotted
%  dataset: data for time course
%  headdata: background data (also used for gm, head, and wm contours)
%  activeregion: contour for active region
%  alph: threshold for 'AlphaData'
SliceBrowserOverlay(lay2,tempdata,bg,mask,threshold);


end

