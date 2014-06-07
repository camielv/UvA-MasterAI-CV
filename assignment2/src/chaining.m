% This function gives back points that appear in x consecutive frames
%
%
function [Z] = chaining(path, t, N)
    filenames = getFilenames(path);
    nFiles = size(filenames, 2);
    
    Z = zeros(0, 2, 2);

    imageA = imread(filenames{1});
    imageB = imread(filenames{2});
    [imageAcut] = removeBackground(imageA, imageB);
    imageAcut = single(rgb2gray(imageAcut));
    [FA, DA] = vl_sift(imageAcut);
    
    for i = 1 : nFiles,
        imageB = imread(filenames{mod(i, nFiles) + 1});
        
        % Remove background
        [imageBcut] = removeBackground(imageB, imageA);
        imageBcut = single(rgb2gray(imageBcut));
    
        % Compute SIFT features
        [FB, DB] = vl_sift(imageBcut);
        
        % Find features
        [pointsA, pointsB] = findMatches(FA, FB, DA, DB, t, N);
        %visualizePoints(imageA, imageB, pointsA, pointsB)
        allPoints = cat(3, pointsA(1:2, :)', pointsB(1:2, :)');
        % Save the points. Rows 4 Columns ..
        % if B1 == B2
        %   append C
        % otherwise
        %   create new line (empty, B2, C)
        % end
        if ~isempty(Z),
            sZ = size(Z);
            Z = cat(3, Z, repmat([-1, -1], [sZ(1) 1]));
            [matches, ids] = ismember(Z(:, :, end - 1), allPoints(:, :, 1), 'rows');
            Z(matches, :, end) = allPoints(ids(matches), :, 2);
          
            visualizePoints(imageA, imageB, allPoints(ids(matches), :, 1), allPoints(ids(matches), :, 2));
            ids = unique(ids(matches));
            noIds = setdiff(1:size(allPoints, 1), ids);
            allPoints = allPoints(noIds, :, :);
        end
        sZ = size(Z);
        Z = [Z; cat(3, repmat([-1, -1], [size(allPoints, 1), 1, sZ(3)-2]), allPoints)];
        
        % Prepare next iteration
        imageA = imageB;
        FA = FB;
        DA = DB;
    end
    
end