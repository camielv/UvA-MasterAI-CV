function [ resultOtherCloud ] = mergeClouds(fullBaseCloud, fullOtherCloud, sampleSize)

% Final transformation matrix to conform otherCloud to coordinate system of
% baseCloud
rotationResult    = eye(size(fullBaseCloud,2));
translationResult = zeros(1, size(fullBaseCloud,2));

% Sample part of clouds for point matching
baseCloudIds  = randsample(size(fullBaseCloud,  1), sampleSize);
baseCloud     = fullBaseCloud(baseCloudIds, :);
otherCloudIds = randsample(size(fullOtherCloud, 1), sampleSize);
otherCloud    = fullOtherCloud(otherCloudIds, :);

% Compute base centroid
baseCentroid = computeCentroid(baseCloud);

% Create base cloud
baseCloudPrime = translateCloud(baseCloud, -baseCentroid);

% Create target cloud
[targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);

counter = 0;
while ( mean(minima) > 0.0012 && counter < 20 )
    % Compute centroid
    targetCentroid = computeCentroid(targetCloud);
    % Create target cloud
    targetCloudPrime = translateCloud(targetCloud, -targetCentroid);

    % Compute A matrix
    A = baseCloudPrime' * targetCloudPrime;

    % SVD decomposition
    [U, ~, V] = svd(A);

    % Rotation Matrix
    R = U * V';

    % Translation Matrix
    T = baseCentroid - targetCentroid * R;

    % Move Target Cloud
    otherCloud = translateCloud((R * otherCloud')', T);
    
    % Update final rotation matrix
    rotationResult    = rotationResult * R;
    translationResult = translationResult + T;

    % Compute new distance
    [targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);
    counter = counter + 1;
end

R
T
resultOtherCloud = translateCloud((rotationResult * fullOtherCloud')', translationResult);

end
