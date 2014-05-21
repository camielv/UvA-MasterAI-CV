function [resultCloud] = cumulativeMergeCloudSet(filename, sampleMethod, sampleSize, matchMethod, startNr, stepNr, endNr)
% MERGECLOUDSET Load and merge point cloud datasets
%    [ALLCLOUDS, TRARR, TTARR] = MERGECLOUDSET(FILENAME, SAMPLEMETHOD,
%    SAMPLESIZE, MATCHMETHOD, START, STEP, END) loads point cloud datasets
%    using START:STEP:END filtering and saves the resulting merged set to a
%    file (a random subset of it to allow for visualization efforts). The
%    function returns also the set of uniquely merged point clouds
%    ALLCLOUDS and the rotation and translation matrices TRARR and TTARR
%    used in the process. SAMPLEMETHOD and SAMPLESIZE are parameters used
%    for the merging of individual clouds. SAMPLEMETHOD can be either
%    'none', 'random' (not 'normal'). If it is not 'none', then SAMPLESIZE
%    identifies the number of samples that are extracted. MATCHMETHOD can
%    be either 'brute' or 'flann' and determines how we look for close
%    points.

% Default sampleSize value
if nargin < 1
    filename = 'mergedCloud.pcd';
end

if nargin < 2
    sampleMethod = 'random';
end

if nargin < 3
    sampleSize = 8000;
end

if nargin < 4
    matchMethod = 'flann';
end

if nargin < 5
    startNr = 0;
    stepNr = 1;
    endNr = 65;
end

frameIDs = startNr:stepNr:endNr;
n = numel(frameIDs);

% Variable for all clouds
cloudIDs = cell(n,1);

% Get all cloud IDs
for i=1:n,
    cloudIDs{i} = sprintf('%.10d', frameIDs(i));
end

% Here we hold all clouds
resultCloud = readCloud(cloudIDs{1}, true);

% Loop over all cloud paths
for i=2:n,
    frameIDs(i)
    [newCloud, TR, TT, error] = mergeClouds(resultCloud, cloudIDs{i}, sampleMethod, sampleSize, matchMethod);
    % The following is not exactly super-efficient since we move lots of
    % points at every iteration, but it is easier than changing all the
    % functions. We reverse-rotate the big cloud and then add the new
    % cloud.
    resultCloud = translateCloud( resultCloud / TR, -TT );
    resultCloud = [resultCloud ; newCloud ];
    
    disp(error);
end

resultIDs = randsample(size(resultCloud,  1), sampleSize * n);
% Save resultCloud to pcd file
savepcd(filename, resultCloud(resultIDs,:)');
end