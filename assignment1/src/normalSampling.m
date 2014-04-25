function [samples] = normalSampling(cloudName, nSamples, nBins)
    nBinsX = nBins^(1/3);
    nBinsY = nBinsX;
    nBinsZ = nBinsZ;

    normals = readNormals(cloudName);
    
    % TODO: Check if this works correctly
    normalsIDs = ~any(isnan(normals),2);
    validNormals = normals(normalIDs);

    % Find bin for each normal.
    % Find count for each bin
    % Ascending Sort bins by count
    % For each bin, extract nSamples / nBins
    % If you extract less than that, recompute extracting factor by (nSamples - gotSamples)/(nBins - exploredBins)

end
