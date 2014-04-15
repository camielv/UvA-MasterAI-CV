%% Read PCD
%pcl1 = readPcd('data/0000000000.pcd');
%pcl2 = readPcd('data/0000000001.pcd');

% Test data
pcl2 = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12];
pcl1 = [1, 1, 1, 1; 2, 2, 2, 2; 3, 3, 3, 3; 4, 4, 4, 4; 5, 5, 5, 5];

% Data dimension
d = 4
% Rotation Matrix
R = eye(d);
% Translation Vector

% We need to minimize the sum of the squares between our initial points and
% their respective closes points in the second vector. We can only rotate
% the first points or translate them. Thus:
%
% min sum || Ra - t - phi(a) ||
%
%
%
t = zeros(1,d);
Mold = ones(4);
M = eye(4);
distance = 10;
while sum(sum(M-Mold)) ~= 0,
    Mold = M;
    pcl1rep = repmat(pcl1, [1 1 size(pcl2, 1)]);
    pcl2rep = permute(repmat(pcl2, [1 1 size(pcl1, 1)]), [3 2 1]);

    distance = sqrt(sum((pcl1rep - pcl2rep).^2, 2));
    [minimum, id] = min(distance, [], 3)

    M = pcl1\pcl2(id,:)
    pcl1 = pcl1 * M;
end