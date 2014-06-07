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
        t = 10;
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
    x = 0;

    for i=0:N,
        % Select eight random points
        ids = randsample(n, 8);

        % Find fundamental matrix
        Ft = eightPoint(pointsA(:, ids), pointsB(:, ids));

        % Compute errors B' * F * A
        BFtA = sum((pointsB' * Ft).*pointsA', 2)';

        % Compute distances
        FtA = Ft * pointsA;
        FtB = Ft' * pointsB;

        distance = BFtA.^2 ./ (FtA(1, :).^2 + FtA(2, :).^2 + FtB(1, :).^2 + FtB(1, :).^2);

        % Compute inliers
        inliers = find(distance < t);

        % Check if more inliers
        if length(inliers) > bestScore,
            bestScore = length(inliers);
            bestModel = inliers;
            %fprintf('Inliers:  %d\nOutliers: %d\n', bestScore, n - bestScore);
        end
    end
    fprintf('N. Inliers:  %d\n', bestScore);
    fprintf('N. Outliers: %d\n', n - bestScore);

    % Reestimate F based on the inliers of the best model only
    F = eightPoint(pointsA(:, bestModel), pointsB(:, bestModel));
end
