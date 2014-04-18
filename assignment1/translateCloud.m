function [ translatedCloud ] = translateCloud(cloud, translation)
translatedCloud = cloud + repmat(translation, [size(cloud, 1) 1]);
end

