function [closestCloud] = computeClosestCloud(choosingCloud, extractedCloud, method, resetFlann)

persistent flannIndex;
if resetFlann
    if strcmp(method,'flann')
        if ~isempty(flannIndex)
            flann_free_index(flannIndex);
        end
        flannIndex = flann_build_index(extractedCloud', struct('algorithm', 'kdtree', 'trees', 8));
    end
    return
end

% Compute ids of closest points
if strcmp(method, 'flann')
    [ids, ~] = flann_search(flannIndex, choosingCloud', 1, struct('checks', 128));
else
    [~, ids] = pdist2(extractedCloud, choosingCloud, 'euclidean', 'Smallest', 1);
end

ids = ids';

% Create the closest point cloud.
closestCloud = extractedCloud(ids, :);
end

