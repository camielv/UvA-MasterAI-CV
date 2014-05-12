function [resultCloud, TRarr, TTarr] = mergeCloudSet(filename, sampleSize)

% Default sampleSize value
if nargin < 1
    filename = 'ihatematlab.pcd';
end


if nargin < 2
    sampleSize = 8000;
end

% Start and end frame number
startNr = 1;
endNr = 65;

n = endNr - startNr + 1;

% Variable for all clouds
cloudIDs = cell(n,1);

% Get all cloud IDs
for i=1:n,
    cloudIDs{i} = sprintf('%.10d', i-1+startNr);
end

% Init memory
resultCloud = cell(1,n);
TRarr = zeros(3, 3, n);
TTarr = zeros(1, 3, n);

% Here we hold all clouds while we wait for rotate/translate them.
resultCloud{1} = readCloud(cloudIDs{1}, true);

% Loop over all cloud paths
for i=2:n,
    i
    % Get cloud merging results
    [resultCloud{i}, TRarr(:, :, i), TTarr(:, :, i), error] = mergeClouds(resultCloud{i-1}, cloudIDs{i}, 'normal', sampleSize);
    error
end

% Finally merge everything
result = [];
TR = eye(3,3);
TT = zeros(1,3);
for i=1:n-1
    result = [result; translateCloud(resultCloud{i} * TR, TT)];
    TR = TRarr(:, :, i+1) * TR;
    TT = translateCloud(TTarr(:, :, i+1) * TR, TT);
end
result = [result; translateCloud(resultCloud{n} * TR, TT)];

resultIDs = randsample(size(result,  1), sampleSize * (endNr - startNr));
% Save resultCloud to pcd file
savepcd(filename, result(resultIDs,:)');
end
