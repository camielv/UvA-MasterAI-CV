function [closestCloud, minima] = computeClosestCloud(baseCloud, otherCloud)
baseRep = repmat(baseCloud, [1 1 size(otherCloud, 1)]);
otherRep = permute(repmat(otherCloud, [1 1 size(baseCloud, 1)]), [3 2 1]);

distance = sqrt(sum((baseRep - otherRep).^2, 2));
[minima, ids] = min(distance, [], 3);

closestCloud = otherCloud(ids, :);
end

