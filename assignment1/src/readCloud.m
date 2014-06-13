function [cloud, indexes] = readCloud(cloudName, filter)
% READCLOUD reads a pcd file and optionally trims it to 3 dimensions.
    cloud = readPcd(['..' filesep 'data' filesep cloudName '.pcd']);
    % Remove 4th dimension
    cloud = cloud(:, 1:3);
    
    if filter == true
        indexes = all(cloud'<1);
        cloud = cloud(indexes,:);
    else
        indexes = 1:size(cloud,1);
    end
end
