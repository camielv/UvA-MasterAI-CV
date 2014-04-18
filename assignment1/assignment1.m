%% Read PCD
%pcl1 = readPcd('data/0000000000.pcd');
%pcl2 = readPcd('data/0000000001.pcd');

baseCloud = [1,1;2,2];
otherCloud = [1,1; cosd(40)+1, sind(40)+1]

d = size(baseCloud, 2);

% Compute base centroid
baseCentroid = computeCentroid(baseCloud);

% Create base cloud
baseCloudPrime = translateCloud(baseCloud, -baseCentroid);

% Create target cloud
[targetCloud, minima] = computeClosestCloud(baseCloud, otherCloud)

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

    % Fucking determinants that you did not tell me about (Thanks! <3)
    dsign = sign(det(V*U'));
    
    Matrix = eye(d);
    Matrix(d,d) = dsign;
    R = V * Matrix * U'
    R3 = U * V'
    % Rotation Matrix
    R2 = R * V'

    % Translation Matrix
    T = baseCentroid - targetCentroid * R

    % Move Target Cloud
    otherCloud = translateCloud((R * otherCloud')', T)
    
    % Compute new distance
    [targetCloud, minima] = computeClosestCloud(baseCloud, otherCloud);
    counter = counter + 1;
    pause
end