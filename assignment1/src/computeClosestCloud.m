function [closestCloud] = computeClosestCloud(choosingCloud, extractedCloud, resetFlann)
% To use this part you need to add flann to your path!!
persistent flannIndex;
if resetFlann
    if ~isempty(flannIndex)
        flann_free_index(flannIndex);
    end
    flannIndex = flann_build_index(extractedCloud', struct('algorithm', 'kdtree', 'trees', 8));
    return
end

% Compute sum of squared distance between all points.

% Perfect solution
[~, ids] = pdist2(extractedCloud, choosingCloud, 'euclidean', 'Smallest', 1);

%[ids, ~] = flann_search(flannIndex, choosingCloud', 1, struct('checks', 128));

ids = ids';

% Create the closest point cloud.
closestCloud = extractedCloud(ids, :);
end

