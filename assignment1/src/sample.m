function [cloud, sampledCloudIds] = sample(cloudName, method, sampleSize)
    
    cloud = readCloud(cloudName);
    
    if strcmp(method, 'none')
        sampledCloudIds = 1:size(cloud,1);
        return
    elseif strcmp(method, 'random')
        sampledCloudIds = randsample(size(cloud,  1), sampleSize);
        return
    elseif strcmp(method, 'normal')
        sampledCloudIds = normalSampling(cloudName, sampleSize, 100);
        return
    else
        throw('sampling method unknown');
    end
end