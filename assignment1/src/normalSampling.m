function [sampledIDs] = normalSampling(cloudName, originalIDs, nSamples, nBins)
% NORMALSAMPLING samples a certain number of points using normal data.

    nBinsX = round(nBins^(1/3));
    nBinsY = nBinsX;
    nBinsZ = nBinsX;
    nBins = nBinsX * nBinsY * nBinsZ;

    dx = 2/nBinsX;
    dy = 2/nBinsY;
    dz = 2/nBinsZ;

    normals = readNormals(cloudName, originalIDs);
    
    % Remove invalid normals
    normalIDs = ~any(isnan(normals),2);
    validNormals = normals(normalIDs, :);
    normalIDs = find(normalIDs);

    % Find bin for each normal.
    binsX = floor(validNormals(:, 1) / dx) + 1 + ceil(1/dx); binsX(binsX == nBinsX + 1) = nBinsX;
    binsY = floor(validNormals(:, 2) / dy) + 1 + ceil(1/dy); binsY(binsY == nBinsY + 1) = nBinsY;
    binsZ = floor(validNormals(:, 3) / dz) + 1 + ceil(1/dz); binsZ(binsZ == nBinsZ + 1) = nBinsZ;

    % Find count for each bin
    bins = [binsX, binsY, binsZ];
    [uniqueBins, ~, ids] = unique(bins, 'rows'); 
    counts = accumarray(ids, 1);
    
    % Ascending Sort bins by count
    uniqueBins = sortrows([counts, uniqueBins], 1);
    nUB = size(uniqueBins, 1);

    sampledIDs = [];
    gotSamples = 0;

    % For each bin, extract nSamples / nBins
    for i=1:nUB
        % If you extract less than that, recompute extracting factor by (nSamples - gotSamples)/(nBins - exploredBins)
        desiredSamples = ceil((nSamples - gotSamples)/(nUB - i + 1));
        binsIDs = find(ismember(bins, uniqueBins(i, 2:4), 'rows'));
        if uniqueBins(i, 1) <= desiredSamples
            % If less than desired samples, sample everything.
            gotSamples = gotSamples + uniqueBins(i, 1);
        else
            % If more than desired samples, random sample.
            gotSamples = gotSamples + desiredSamples;
            binsIDs = randsample(binsIDs, desiredSamples);
        end
        realIDs = normalIDs(binsIDs);
        sampledIDs = [sampledIDs; realIDs];
    end
end
