function [ centroid ] = computeCentroid(cloud)
centroid = sum(cloud, 1) / size(cloud, 1);
end

