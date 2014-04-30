function [closestCloud, minima] = computeClosestCloud(baseCloud, otherCloud)
% Compute sum of squared distance between all points.
distance = pdist2(baseCloud, otherCloud);
% Find the closest points.
[minima, ids] = min(distance, [], 2);

% Create the closest point cloud.
closestCloud = otherCloud(ids, :);
end

