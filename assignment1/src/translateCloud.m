function [ translatedCloud ] = translateCloud(cloud, translation)
% TRANSLATECLOUD translates a point cloud based on the provided translation vector.
translatedCloud = cloud + repmat(translation, [size(cloud, 1) 1]);
end

