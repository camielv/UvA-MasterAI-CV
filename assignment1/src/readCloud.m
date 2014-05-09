function [cloud] = readCloud(cloudName)
    cloud = readPcd(['..' filesep 'data' filesep cloudName '.pcd']);
    % Remove 4th dimension
    cloud1 = cloud(:, 1:3);
    % Filter shit
    cloud = cloud1(all(cloud1'<2),:);
end