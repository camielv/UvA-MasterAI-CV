function [cloud] = readCloud(cloudName)
    cloud = readPcd(['../data/' cloudName '.pcd']);
    % Remove 4th dimension
    cloud = cloud(:, 1:3);
end
