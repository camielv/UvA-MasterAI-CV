% This function gives back points that appear in x consecutive frames
%
%
function [points] = chaining(path)
    frames = dir(path);
    frames = frames(3:end);
    
    nameA = [path frames(1).name];
    for i = 2 : size(frames),
        nameB = [path frames(i).name];
        
        % Read image
        imageA = imread(nameA);
        imageB = imread(nameB);
        
        % Find features
        [pointsA, pointsB] = findMatches(imageA, imageB);
    end
end