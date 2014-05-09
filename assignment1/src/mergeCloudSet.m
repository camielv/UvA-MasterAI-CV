function [] = mergeCloudSet(filename, sampleSize)

% Default sampleSize value
if nargin < 1
    filename = 'ihatematlab.pcd';
end


if nargin < 2
    sampleSize = 5000;
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
resultCloud = readCloud(cloudIDs{1});
result = resultCloud;

% Loop over all cloud paths
for i=2:n,
    i
    %H = waitbar(0, ['Adding frame ' num2str(i)]);
    % Get cloud merging results
    result = mergeClouds(result, cloudIDs{i}, 'normal', sampleSize);
    % Add cloud merging result to resultCloud
    resultCloud = [resultCloud; result];
    %close(H);
end

% Save resultCloud to pcd file
savepcd(filename, resultCloud');
end