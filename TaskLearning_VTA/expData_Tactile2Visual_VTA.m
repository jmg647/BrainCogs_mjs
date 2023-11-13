function [ dirs, expData ] = expData_Tactile2Visual_VTA(dirs)

%PURPOSE: Create data structure for imaging tiff files and behavioral log files
%AUTHOR: MJ Siniscalchi 230918
%
%INPUT ARGUMENTS
%   data_dir:    The base directory to which the raw data are stored.  
%
%OUTPUT VARIABLES
%   dirs:        The subfolder structure within data_dir to work with
%   expData:     Info regarding each experiment

dirs.data = fullfile(dirs.root,'tactile2visual-vta','data'); 
dirs.notebook = fullfile(dirs.root,'tactile2visual-vta','notebook'); 
dirs.results = fullfile(dirs.root,'tactile2visual-vta','results');
dirs.summary = fullfile(dirs.root,'tactile2visual-vta','summary');
dirs.figures = fullfile(dirs.root,'tactile2visual-vta','figures');

%% First VTA Cohort (N=2)

% Initialize structure
expData = struct('sub_dir',[],'subjectID',[],'mainMaze',[],...
    'excludeBlock',[],'npCorrFactor',[]);

% Session metadata
i=1;

expData(i).sub_dir = '230911-m103-test'; 
expData(i).subjectID = "mjs20_103";
expData(i).mainMaze = 7;
expData(i).npCorrFactor = 0.3;

% i = i+1;
% expData(i).sub_dir = '230911-m103-maze7'; 
% expData(i).subjectID = "mjs20_103";
% expData(i).mainMaze = 7;
% expData(i).npCorrFactor = 0.3;
% i = i+1;
% expData(i).sub_dir = '230911-m105-maze7'; 
% expData(i).subjectID = "mjs20_105";
% expData(i).mainMaze = 7;
% expData(i).npCorrFactor = 0.3;



