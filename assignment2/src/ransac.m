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
        t = 1;
    end
    if nargin < 4,
        N = 10000;
    end
    
    % Size
    n = size(pointsA, 2);
    
    % Best score
    bestScore = 0;
    bestModel = [];

    % Normalize points
    %[nPointsA, TA] = normalise(pointsA);
    %[nPointsB, TB] = normalise(pointsB);
    
    for i=0:N,
        % Select eight random points
        ids = ceil(rand(8, 1) * size(pointsA, 2));
        
        % Find fundamental matrix
        Ft = eightpoint(pointsA(:, ids), pointsB(:, ids));
        
        % Compute errors B' * F * A
        BFtA = zeros(1, size(pointsA, 2));
        for i=1:n,
            BFtA(i) = pointsB(:, i)' * Ft * pointsA(:, i);
        end
        % Compute distances
        FtA = Ft * pointsA;
        FtB = Ft' * pointsB;
        
        distance = BFtA.^2 ./ (FtA(1, :).^2 + FtA(2, :).^2 + FtB(1, :).^2 + FtB(1, :).^2);
        
        % Compute inliers
        inliers = find(abs(distance) < t);
        
        % Check if more inliers
        if length(inliers) > bestScore,
            bestScore = length(inliers);
            bestModel = inliers;
            fprintf('Inliers:  %d\nOutliers: %d\n', bestScore, size(pointsA, 2) - bestScore);
        end
    end
    fprintf('N. Inliers:  %d\n', bestScore);
    fprintf('N. Outliers: %d\n', size(pointsA, 2) - bestScore);

    % Reestimate F based on the inliers of the best model only
    F = eightPoint(pointsA(:, bestModel), pointsB(:, bestModel));
end