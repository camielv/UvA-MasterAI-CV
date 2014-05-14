% This function finds the fundamental matrix using the normalized eight
% point algorithm from 8 or more point correspondences.
%
% Arguments:
% pointsA, pointsB - Two sets 3xN of corresponding homogenous points.
%
% Returns:
% F                - Fundamental matrix

function [F] = findFundamentalMatrix(pointsA, pointsB, ransac)
    if nargin < 3,
        ransac = 0;
    end

    % Number of point correspondences
    n = size(pointsA, 2);
    
    % Normalise points
    [pointsA, TA] = normalise(pointsA);
    [pointsB, TB] = normalise(pointsB);
    
    % Seperate x and y coordinates per point set.
    Ax = pointsA(1, :)';
    Bx = pointsB(1, :)';
    Ay = pointsA(2, :)';
    By = pointsB(2, :)';


    if ransac,
        % Apply ransac
    else
        % See Equation 1 in assignment to constructs matrix A.
        A = [Bx .* Ax, Bx .* Ay, Bx, By .* Ax, By .* By, By, Bx, By, ones(n, 1)];
    end

    % Find the SVD of A. Solve Equation 1.
    [U D V] = svd(A, 0);

    % The entries of F are the components of the column of V corresponding to
    % the smallest singular value.
    F = reshape(V(:,9),3,3)';

    % Find the SVD of F.
    [Uf, Df, Vf] = svd(F,0);

    % Set the smallest singular value in the diagonal matrix Df to zero in
    % order to obtain the corrected matrix D f
    Df = diag([Df(1,1) Df(2,2) 0]);

    % Recompute Fundamental Matrix
    F = Uf * Df * Vf';

    F = TB' * F * TA;
end