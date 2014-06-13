function [cloud, sampledCloudIds] = sample(cloudName, method, sampleSize)
% SAMPLE samples points from a point cloud based on the requested method.
    
    % The original IDs are kept for normal sampling because we need to 
    % discard the normals for the points we have discarded already.
    [cloud originalIDs] = readCloud(cloudName, true);
    
    if strcmp(method, 'none')
        sampledCloudIds = 1:size(cloud,1);
        return
    elseif strcmp(method, 'random')
        sampledCloudIds = randsample(size(cloud,  1), sampleSize);
        return
    elseif strcmp(method, 'normal')
        sampledCloudIds = normalSampling(cloudName, originalIDs, sampleSize, 100);
        return
    else
        throw('sampling method unknown');
    end
end
