% This function removes the background of the two given colour images. The
% function assumes that only the foreground object is moving in the images.
%
% Arguments:
% imageA, imageB   - A image.
%
% Returns:
% imageA, imageB   - A image.

function [imageA] = removeBackground(imageA, imageB, threshold)

    if nargin < 3,
        threshold = 50;
    end
    
    % Subtract images.
    backgroundA = imageB - imageA;
    
    % Blur the result
    G = fspecial('gaussian',[25 25], 25);
    blurA = imfilter(backgroundA, G, 'same');
    
    % Sum all the colours
    blurA = sum(blurA, 3);

    % Threshold the blur
    filterA = blurA > threshold;
    
    % Find the mask
    maskA = bwconvhull(filterA);
    
    % Final image
    imageA = imageA .* repmat(uint8(maskA), [1, 1, 3]);
end