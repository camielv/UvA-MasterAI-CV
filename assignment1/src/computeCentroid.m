function [ centroid ] = computeCentroid(cloud)
centroid = mean(cloud, 1);
end

