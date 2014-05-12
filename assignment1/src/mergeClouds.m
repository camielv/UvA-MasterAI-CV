function [ fullTargetCloud, TR, TT, error ] = mergeClouds(fullBaseCloud, targetCloudName, sampleMethod, sampleSize)

% Sample part of clouds for point matching
%[fullBaseCloud, baseCloudIds]   = sample(baseCloudName, 'none', sampleSize);
%baseCloud      = fullBaseCloud(baseCloudIds, :);
baseCloud = fullBaseCloud;

[fullTargetCloud, targetCloudIds] = sample(targetCloudName, sampleMethod, sampleSize);
targetCloud    = fullTargetCloud(targetCloudIds, :);

% Save up initial cloud so that we can move it later.
originalTargetCloud = targetCloud;

% Total rotation
TR = eye(3,3);
% Total translation
TT = zeros(1,3);

% Init flann
computeClosestCloud([], baseCloud, 1);

% Init loop variables
counter = 0;
maxCounter = 30;
error = 1;

while ( error > 0.0012 && counter < maxCounter )
    waitbar(counter/maxCounter);
    
    % COMPUTE BASE MATCH CLOUD, TARGET SELECTS, WE PICK FROM BASECLOUD
    baseMatchCloud = computeClosestCloud(targetCloud, baseCloud, 0);
    
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
