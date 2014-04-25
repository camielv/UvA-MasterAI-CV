function [ resultCloud ] = mergeCloudSet(cloudSetPath, sampleSize)

% Default sampleSize value
if nargin < 2
    sampleSize = 1000;
end

% Start and end frame number
startNr = 0;
endNr = 9;
n = endNr - startNr + 1;

% Variable for all clouds
cloudIDs = cell(n,1);

% Get all cloud IDs
for i=1:n,
    cloudIDs{i} = sprintf('%.10d', i-1+startNr);
end

% Result cloud placeholder
resultCloud = [];

% Get initial cloud
baseCloud = readPcd([cloudSetPath, filesep, cloudIDs{1}, '.pcd']);
% Cut (hopefully useless) 4th dimension
baseCloud = baseCloud(:, 1:3);


% Loop over all cloud paths
for i=2:n,
    i
    % Get other cloud
    otherCloud = readPcd([cloudSetPath, filesep, cloudIDs{n}, '.pcd']);
    % Cut (hopefully useless) 4th dimension
    otherCloud = otherCloud(:, 1:3);
    
    % Get cloud merging results
    result = mergeClouds(baseCloud, otherCloud, sampleSize);
    % Add cloud merging result to resultCloud
    resultCloud = [resultCloud, result];
    
    % Set the other cloud as the new baseCloud
    baseCloud = otherCloud;
end

% Save resultCloud to pcd file


end