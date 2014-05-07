function [ resultTargetCloud ] = mergeClouds(fullBaseCloud, targetCloudName, sampleMethod, sampleSize)

% Sample part of clouds for point matching
%[fullBaseCloud, baseCloudIds]   = sample(baseCloudName, 'none', sampleSize);
%baseCloud      = fullBaseCloud(baseCloudIds, :);
baseCloud = fullBaseCloud;

[fullTargetCloud, targetCloudIds] = sample(targetCloudName, sampleMethod, sampleSize);
targetCloud    = fullTargetCloud(targetCloudIds, :);
ttargetCloud = targetCloud';
Np = size(ttargetCloud,2);
Nt = size(fullTargetCloud,1);

% Final transformation matrix to conform otherCloud to coordinate system of
% baseCloud
transformResult = eye(size(fullBaseCloud, 2) + 1);

% Init flann
computeClosestCloud([], baseCloud, 1);

counter = 0;
maxCounter = 5;

error = 1;
errors = zeros(1,maxCounter);

TT = zeros(3,1);
TR = eye(3,3);

while ( error > 0.0012 && counter < maxCounter )
    %waitbar(counter/50);
    
    % COMPUTE BASE MATCH CLOUD, TARGET SELECTS, WE PICK FROM BASECLOUD
    baseMatchCloud = computeClosestCloud(targetCloud, baseCloud, 0);
    
    % SHIFT BASE MATCH TO ORIGIN
    baseMatchCentroid = computeCentroid(baseMatchCloud);
    baseMatchCloudPrime = translateCloud(baseMatchCloud, -baseMatchCentroid);

    % SHIFT TARGET TO ORIGIN
    targetCentroid = computeCentroid(targetCloud);
    targetCloudPrime = translateCloud(targetCloud, -targetCentroid);

    % A Matrix
    %A = baseMatchCloudPrime' * targetCloudPrime
    A = targetCloudPrime' * baseMatchCloudPrime;
    
    % SVD decomposition
    [U, ~, V] = svd(A);

    % Rotation Matrix
    R = U * V'

    % Translation Matrix
    T = baseMatchCentroid - targetCentroid * R;

    % Accumulate transforms to apply to whole cloud later
    transform = [R T'; zeros(1, size(transformResult, 2) - 1) 1];
    transformResult = transform * transformResult;
    
    TR = R' * TR;
    TT = R' * TT + T';
    
    % MOVE TARGET CLOUD
    % targetCloud = translateCloud((R * targetCloud')', T);
    targetCloud = (TR * ttargetCloud + repmat(TT, 1, Np))';
    
    % COMPUTE ERROR, DISTANCE BETWEEN NEW TARGET AND OLD MATCH
    error = mean( sqrt( sum( (baseMatchCloud - targetCloud).^2, 2 )))
    errors(counter+1) = error;

    counter = counter + 1;
end

%plot([1:maxCounter], errors);
%figure;

% Transform result with homogeneous coordinates
%resultTargetCloud = transformResult * [fullTargetCloud'; ones(1, size(fullTargetCloud, 1))];
% Cut off homogeneous coordinates.
%resultTargetCloud = resultTargetCloud(1:size(resultTargetCloud, 1) - 1, :);
%resultTargetCloud = resultTargetCloud';

resultTargetCloud = (TR * fullTargetCloud' + repmat(TT, 1, Nt))';
end
