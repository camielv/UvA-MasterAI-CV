%% Read PCD
%pcl1 = readPcd('data/0000000000.pcd');
%pcl2 = readPcd('data/0000000001.pcd');

% Test data
%pcl1 = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12];
%pcl2 = [1, 1, 1, 1; 2, 2, 2, 2; 3, 3, 3, 3; 4, 4, 4, 4; 5, 5, 5, 5];

pcl1 = [1,1;2,2];
pcl2 = [1,-1;2, -2]

pcl1rep = repmat(pcl1, [1 1 size(pcl2, 1)]);
pcl2rep = permute(repmat(pcl2, [1 1 size(pcl1, 1)]), [3 2 1]);

% Compute centroid
centroid1 = sum(pcl1, 1) / size(pcl1, 1);
% Create base cloud
base   = pcl1 - repmat(centroid1, [size(pcl1, 1) 1]);


% Data dimension
d = 4;
% Rotation Matrix
R = eye(d);
% Translation Vector
t = zeros(1,d);

counter = 0;
newdistance = 1;
while mean(newdistance) > 0.0012 & counter < 20
    % Compute Euclidean distance
    distance = sqrt(sum((pcl1rep - pcl2rep).^2, 2));
    [minima, ids] = min(distance, [], 3);

    % Target cloud
    target = pcl2(ids, :);

    % Compute centroid
    centroid2 = sum(target, 1) / size(target, 1);
    % Create target cloud
    target = target - repmat(centroid2, [size(target, 1) 1]);

    % Compute A matrix
    A = base' * target;

    % SVD decomposition
    [U, S, V] = svd(A);

    % Rotation Matrix
    R = U * V';

    % Translation Matrix
    T = centroid1 - centroid2 * R;

    % Move Target Cloud
    pcl2 = R * pcl2' + repmat(T', [1 size(pcl2,1)]);
    pcl2 = pcl2'
    pcl1
    % Compute new distance
    pcl2rep = permute(repmat(pcl2, [1 1 size(pcl1, 1)]), [3 2 1]);

    newdistance = sqrt(sum((pcl1rep - pcl2rep).^2, 2))
    counter = counter + 1
end

%if newdistance < 0.0012
%    return
%end
