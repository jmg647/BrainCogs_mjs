%%% get_imgPaths()
%
% Purpose: To include/exclude paths to imaging data in struct 'expData'
%           -This allows use of analysis_RuleSwitching.m to run selected analyses without storing 
%               all the processed imaging data. (eg, for analyzing results remotely) 
%
%---------------------------------------------------------------------------------------------------

function expData = get_imgPaths( dirs, expData, calculate, figures )

% Get ROI directories and define paths to imaging data
C = calculate;
F = figures;
if any([C.combined_data, C.cellF, F.FOV_mean_projection])
    for i = 1:numel(expData)
        list = dir(fullfile(dirs.data,expData(i).sub_dir,'ROI*'));
        expData(i).roi_dir = list.name; %Full path to ROI directory
        [~, paths] = iCorreFilePaths( dirs.data, expData(i).sub_dir, []);
        
        expData(i).raw_path = paths.raw;
        
        list = dir(fullfile(dirs.data,expData(i).sub_dir,'registered-chan1','*.tif'));
        expData(i).reg_path = {list(:).name}';
        
        %expData(i).mat_path = expData(idx).mat_path(:);
        %expData = get_imgPathnames(dirs,expData,i); %Get pathnames to raw, registered, and matfiles
    end
end