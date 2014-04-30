function [closestCloud, minima] = computeForClosestCloud(baseCloud, otherCloud)
baseCloudSize = size(baseCloud, 1);
for i = 1:baseCloudSize
    differences = bsxfun(@minus, baseCloud(i, :), otherCloud);
    distance = sqrt(sum(differences.^2, 2));
    [minimum, id] = min(distance);
    closestCloud(i, :) = otherCloud(id, :);
    minima(i) = minimum;
end
end

