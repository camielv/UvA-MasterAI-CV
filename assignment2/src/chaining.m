% This function gives back points that appear in x consecutive frames
%
%
function [Z] = chaining(path, rt, N, bt, noLoop)
    filenames = getFilenames(path);
    nFiles = size(filenames, 2);
    
    Z = zeros(0, 2, 2);
    
    peakTresh = 4;

    imageA = loadGrayImage(filenames{1});
    imageB = loadGrayImage(filenames{2});
    [imageAcut] = removeBackground(imageA, imageB, bt);
    imageAcut = single(imageAcut);
    [FA, DA] = vl_sift(imageAcut, 'PeakThresh', peakTresh);

    for i = 1 : nFiles - noLoop,
        imageB = loadGrayImage(filenames{mod(i, nFiles) + 1});
        
        % Remove background
        [imageBcut] = removeBackground(imageB, imageA, bt);
        imageBcut = single(imageBcut);
    
        % Compute SIFT features
        [FB, DB] = vl_sift(imageBcut, 'PeakThresh', peakTresh);
        
        % Find features
        [pointsA, pointsB] = findMatches(FA, FB, DA, DB, rt, N);
        %visualizePoints(imageA, imageB, pointsA, pointsB)
        allPoints = cat(3, pointsA(1:2, :)', pointsB(1:2, :)');

        % Check if points are already in Z
        if ~isempty(Z),
            sZ = size(Z);
            Z = cat(3, Z, repmat([-1, -1], [sZ(1) 1]));
            [matches, ids] = ismember(Z(:, :, end - 1), allPoints(:, :, 1), 'rows');
            Z(matches, :, end) = allPoints(ids(matches), :, 2);
            
            % Visualization
            [mm, ii] = ismember(allmatch, allPoints(:, :, 1), 'rows');
            visualizePoints(imageA, imageB, allPoints(ii(mm), :, 1), allPoints(ii(mm), :, 2));
            allmatch = allPoints(ii(mm), :, 2);
            
            % Remove points that have a track.
            ids = unique(ids(matches));
            noIds = setdiff(1:size(allPoints, 1), ids);
            allPoints = allPoints(noIds, :, :);
        else
            allmatch = allPoints(:, :, 2);
        end
        % Add leftover points
        sZ = size(Z);
        Z = [Z; cat(3, repmat([-1, -1], [size(allPoints, 1), 1, sZ(3)-2]), allPoints)];
        
        % Prepare next iteration
        imageA = imageB;
        FA = FB;
        DA = DB;
    end
    
end