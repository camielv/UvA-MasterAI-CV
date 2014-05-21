% This function finds the fundamental matrix using the normalized eight
% point algorithm from 8 or more point correspondences.
%
% Arguments:
% pointsA, pointsB - Two sets 3xN of corresponding homogenous points.
%
% Returns:
% F                - Fundamental matrix

function [F] = eightPoint(pointsA, pointsB)
    % Number of point correspondences.
    n = size(pointsA, 2);
    
    % Normalise points.
    [pointsA, TA] = normalise(pointsA);
    [pointsB, TB] = normalise(pointsB);
    
    % Seperate x and y coordinates per point set.
    Ax = pointsA(1, :)';
    Bx = pointsB(1, :)';
    Ay = pointsA(2, :)';
    By = pointsB(2, :)';
    
    % Construct matrix A.
    %A = [Ax .* Bx, Ax .* By, Ax, Ay .* Bx, Ay .* By, Ay, Bx, By, ones(n, 1)];
    A = [Ax.*Bx, Ay.*Bx, Bx, Ax.*By, Ay.*By, By, Ax, Ay, ones(n, 1)];
    
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

    % Denormalise Fundamental Matrix
    F = TB' * F * TA;
end