function [closestCloud] = computeClosestCloud(choosingCloud, extractedCloud, method, resetFlann)
% COMPUTECLOSESTCLOUD Creates a new point cloud made of the closest elements between two clouds.
%   [closestcloud] = computeClosestCloud(CHOOSING, EXTRACTED, METHOD, RESETFLANN) creates a new
%   cloud made of the elements from EXTRACTED that are closest to cloud CHOOSING. The resulting
%   cloud has the same number of points as CHOOSING, and may contain repeated elements from 
%   EXTRACTED. METHOD indicates which type of method is used to create the cloud: it can be either
%   'flann' or 'brute'. In the former case the flann library is used in order to build the cloud.
%   In this case, the function needs to be called once before with RESETFLANN equal to 1, which
%   lets flann build the index of EXTRACTED. Once this step is done, this function may be called
%   any number of times with the same EXTRACTED. If EXTRACTED needs to be changed, simply call it
%   with RESETFLANN equal to 1 again.

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
