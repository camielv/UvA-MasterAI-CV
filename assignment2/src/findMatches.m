% This functions removes the background of the object, compute SIFT
% features and matches these descriptor to finally perform RANSAC on the
% normalized eight point algorithm and gives the points that have the best
% model.
%
% Arguments:
% imageA, imageB   - Two images.
% t                - Threshold for ransac.
% N                - Number of iterations for ransac.
%
% Returns:
% pointsA, pointsB - Two sets 3xN of corresponding homogeneous points.
% F                - Fundamental matrix

function [pointsA pointsB, F] = findMatches(FA, FB, DA, DB, t, N)
    if nargin < 5,
        t = 10;
    end
    if nargin < 6,
        N = 10000;
    end
    
    % Match features
    matches = vl_ubcmatch(DA, DB);
    
    pointsA = FA(1:3, matches(1, :));
    pointsB = FB(1:3, matches(2, :));
    
    % RANSAC normalized eight point.
    [F, model] = ransac(pointsA, pointsB, t, N);
    
    pointsA = pointsA(:, model);
    pointsB = pointsB(:, model);
end