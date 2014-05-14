% This function finds the fundamental matrix using the ransac algorithm to
% filter outliers and the eight point algorithm to find the fundamental
% matrix
%
% Arguments:
% pointsA, pointsB - Two sets 3xN of corresponding homogenous points.
% t                - Error threshold
% N                - Number of iterations
%
% Returns:
% F                - Fundamental matrix
% bestModel        - Indices of inliers

function [F, bestModel] = ransac(pointsA, pointsB, t, N)
    if nargin < 3,
        t = 0.001;
    end
    if nargin < 4,
        N = 10000;
    end
    
    % Best score
    bestScore = 0;
    bestModel = [];

    % Normalize points
    [nPointsA, TA] = normalise(pointsA);
    [nPointsB, TB] = normalise(pointsB);
    
    for i=0:N,
        % Select eight random points
        ids = ceil(rand(8, 1) * size(pointsA, 2));
        
        Ft = eightPoint(pointsA, pointsB);
        
        
    end