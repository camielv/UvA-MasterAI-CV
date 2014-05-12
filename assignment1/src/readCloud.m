function [cloud, indexes] = readCloud(cloudName, filter)
    cloud = readPcd(['..' filesep 'data' filesep cloudName '.pcd']);
    % Remove 4th dimension
    cloud = cloud(:, 1:3);
    
    if filter == true
        indexes = all(cloud'<2);
        cloud = cloud(indexes,:);
    else
        indexes = 1:size(cloud,1);
    end
end