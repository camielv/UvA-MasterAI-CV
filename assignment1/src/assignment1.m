%% Read PCD
clear all

sampleSize = 5000;

fullBaseCloud = readPcd('../data/0000000000.pcd');
fullOtherCloud = readPcd('../data/0000000001.pcd');

% Cut hopefully useless 4th dimension
fullBaseCloud = fullBaseCloud(:, 1:3);
fullOtherCloud = fullOtherCloud(:, 1:3);

baseCloudIds  = randsample(size(fullBaseCloud,  1), sampleSize);
baseCloud     = fullBaseCloud(baseCloudIds, :);
otherCloudIds = randsample(size(fullOtherCloud, 1), sampleSize);
otherCloud    = fullOtherCloud(otherCloudIds, :);

%baseCloud = [0,0;cosd(45),sind(45)]
%otherCloud = [0,0; cosd(40), sind(40)];

d = size(baseCloud, 2);

% Compute base centroid
baseCentroid = computeCentroid(baseCloud);

% Create base cloud
baseCloudPrime = translateCloud(baseCloud, -baseCentroid);

% Create target cloud
tic
[targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);
toc
counter = 0;
while ( mean(minima) > 0.0012 && counter < 20 )
    % Compute centroid
    targetCentroid = computeCentroid(targetCloud);
    % Create target cloud
    targetCloudPrime = translateCloud(targetCloud, -targetCentroid);

    % Compute A matrix
    A = baseCloudPrime' * targetCloudPrime;

    % SVD decomposition
    [U, S, V] = svd(A);

    % Rotation Matrix
    R = U * V'

    % Translation Matrix
    T = baseCentroid - targetCentroid * R

    % Move Target Cloud
    fullOtherCloud = translateCloud((R * otherCloud')', T);
    otherCloud = fullOtherCloud(otherCloudIds);

    % Compute new distance
    [targetCloud, minima] = computeForClosestCloud(baseCloud, otherCloud);
    counter = counter + 1
    drawnow('update');
end

% Save points to file so that we can check and visualize them
% TODO!!
