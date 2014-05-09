%% Read PCD
clear all

sampleSize = 5000;

[fullBaseCloud,  baseCloudIds]  = sample('../data/0000000000', 'none', 5000);
[fullOtherCloud, otherCloudIds] = sample('../data/0000000001', 'none', 5000);

% Pick less stuff since we can't do all data, too slow
baseCloud     = fullBaseCloud(baseCloudIds, :);
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
[targetCloud, minima] = computeClosestCloud(baseCloud, otherCloud);
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
    fullOtherCloud = translateCloud((R * fullOtherCloud')', T);
    otherCloud = fullOtherCloud(otherCloudIds, :);

    % Compute new distance
    [targetCloud, minima] = computeClosestCloud(baseCloud, otherCloud);
    counter = counter + 1
    drawnow('update');
end

% Save points to file so that we can check and visualize them
% TODO!!
