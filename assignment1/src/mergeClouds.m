function [ resultOtherCloud ] = mergeClouds(fullBaseCloud, fullOtherCloud, sampleSize)

% Final transformation matrix to conform otherCloud to coordinate system of
% baseCloud
transformResult = eye(size(fullBaseCloud, 2) + 1);

% Sample part of clouds for point matching
%baseCloudIds  = randsample(size(fullBaseCloud,  1), sampleSize);
baseCloud     = fullBaseCloud;
%baseCloud     = fullBaseCloud(baseCloudIds, :);
%otherCloudIds = randsample(size(fullOtherCloud, 1), sampleSize);
otherCloud    = fullOtherCloud;
%otherCloud    = fullOtherCloud(otherCloudIds, :);

% Compute base centroid
baseCentroid = computeCentroid(baseCloud);

% Create base cloud
baseCloudPrime = translateCloud(baseCloud, -baseCentroid);

% Create target cloud
[targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);

counter = 0;

rotations    = [];
translations = [];

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
    
    % Transform to homogeneous coordinates
    rotations = [rotations R]
    translations = [translations; T]
    transform = [R T'; zeros(1, size(transformResult, 2) - 1) 1];
    transformResult = transformResult * transform;
    
    % Compute new distance
    [targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);
    size(translations)
    counter = counter + 1;
end

% Transform result with homogeneous coordinates
%resultOtherCloud = transformResult * [fullOtherCloud'; ones(1, size(fullOtherCloud, 1))];
% Cut off homogeneous coordinates.
%resultOtherCloud = resultOtherCloud(1:size(resultOtherCloud, 1) - 1, :);
%resultOtherCloud = resultOtherCloud';
resultOtherCloud = fullOtherCloud;
total_i = size(rotations, 2)/size(rotations, 1);
for i = 1:total_i,
    R = rotations(:, (i - 1) *3 + 1:i * 3);
    T = translations(i, :);
    resultOtherCloud = translateCloud((R * resultOtherCloud')', T);
end
end