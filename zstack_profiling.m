%% Process Z-stack profiles from 2-photon indicator imaging
% used to create a more accurate z-profile by aligning ROIs to their
% first inflection to account for tissue drift / uneveness / etc.

%% Clear workspace
clear;
close all;

%% Import file
[FileName, FilePath] = uigetfile( ...
       {'*.csv', 'CSV file (*.csv)'; ...
       '*.xlsx','New Excel (*.xlsx)'; ...
       '*.xls','Old Excel (*.xls)';
       '*.txt', 'Text file (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');
File = fullfile(FilePath, FileName);
[raw] = readmatrix(File);

fprintf('%s \n\n', FileName);         

%% take first derivative of raw Z profile to find inflection 
z = raw(:,1);
rois = raw(:,2:numel(raw(1,:)));

for n = 1:numel(rois(1,:))
    firstDeriv(:,n) = gradient(rois(:,n), z(:));
end

[~,max] = max(firstDeriv(1:100,:));     %find index (z plane) of inflection pt (= max 1st deriv value)

%% pad values to have inflection pt at z plane = 100 -> total z stack size = 600 
finalStackSize = 600;   % set final stack size -> value must be > stack size

startZeroPad = 100 - max;
endZeroPad = finalStackSize - (startZeroPad + length(rois));

padROIs = num2cell(rois, [1, numel(rois(:,n))]);

for n = 1:numel(rois(1,:))
    padROIs{:,n} = padarray(rois(:,n), startZeroPad(n), 0, 'pre');
    padROIs{:,n} = padarray(padROIs{:,n}, endZeroPad(n), 0, 'post');
end

alignedROIs = cell2mat(padROIs);

