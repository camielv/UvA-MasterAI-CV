function [ centroid ] = computeCentroid(cloud)
% COMPUTECENTROID computes the centroid of a point cloud
centroid = mean(cloud, 1);
end
