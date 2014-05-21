function [ fullTargetCloud, TR, TT, error ] = mergeClouds(baseCloud, targetCloudName, sampleMethod, sampleSize, matchMethod)
% MERGECLOUDS Load a cloud and compute transforms to match other cloud.
%    [ LOADEDCLOUD, TR, TT, ERROR ] = MERGECLOUDS( BASECLOUD, CLOUDNAME,
%    SAMPLEMETHOD, SAMPLESIZE, MATCHMETHOD) loads the cloud identified by
%    CLOUDNAME, and computes the rotation matrix TR and translation matrix
%    TT needed to match it to BASECLOUD with error ERROR. SAMPLEMETHOD
%    identifies the method used to sample points from the loaded cloud for
%    the matching (BASECLOUD is not sampled). SAMPLEMETHOD can be 'none',
%    'random' or 'normal'. SAMPLESIZE is the number of samples that the
%    SAMPLEMETHOD should return, and has no effect if SAMPLEMETHOD is
%    'none'. MATCHMETHOD can be either 'brute' or 'flann' and determines
%    how we find the closest points.

[fullTargetCloud, targetCloudIds] = sample(targetCloudName, sampleMethod, sampleSize);
targetCloud    = fullTargetCloud(targetCloudIds, :);

% Save up initial cloud so that we can move it later.
originalTargetCloud = targetCloud;

% Total rotation
TR = eye(3,3);
% Total translation
TT = zeros(1,3);

% Init flann if needed
computeClosestCloud([], baseCloud, matchMethod, 1);

% Init loop variables
counter = 0;
if strcmp(matchMethod, 'flann')
    maxCounter = 30;
else
    maxCounter = 10;
end
error = 1;

while ( error > 0.0012 && counter < maxCounter )
    waitbar(counter/maxCounter);
    
    % COMPUTE BASE MATCH CLOUD, TARGET SELECTS, WE PICK FROM BASECLOUD
    baseMatchCloud = computeClosestCloud(targetCloud, baseCloud, matchMethod, 0);
    
    % DISCARD TOO FAR AWAY POINTS
    % distances = sqrt( sum( (baseMatchCloud - targetCloud).^2, 2 ));
    % ids = distances < 0.0100;
    % leanBaseMatchCloud = baseMatchCloud(ids, :);
    % targetCloud = targetCloud(ids, :);
    
    % SHIFT BASE MATCH TO ORIGIN
    baseMatchCentroid = computeCentroid(baseMatchCloud);
    baseMatchCloudPrime = translateCloud(baseMatchCloud, -baseMatchCentroid);

    % SHIFT TARGET TO ORIGIN
    targetCentroid = computeCentroid(targetCloud);
    targetCloudPrime = translateCloud(targetCloud, -targetCentroid);

    % A Matrix
    A = targetCloudPrime' * baseMatchCloudPrime;
    
    % SVD decomposition
    [U, ~, V] = svd(A);

    % Rotation Matrix
    R = U * V';

    % Translation Matrix
    T = baseMatchCentroid - targetCentroid * R;

    % Add Rotation and Translation matrix up
    TR = TR * R;
    TT = translateCloud(TT * R, T);

    % Compute new target cloud by moving the original using the final
    % transformation matrices.
    targetCloud = translateCloud(originalTargetCloud * TR, TT);
    
    % COMPUTE ERROR, DISTANCE BETWEEN NEW TARGET AND OLD MATCH
    error = mean( sqrt( sum( (baseMatchCloud - targetCloud).^2, 2 )));

    counter = counter + 1;
end
end
