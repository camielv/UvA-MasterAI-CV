% This function normalizes a set of homogeneous points.
%
% Argument:
% Points           - 3xN array of 2D homogeneous coordinates.
%
% Returns:
% normalizedPoints - 3xN array of transformed 3D homogeneous coordinates.
% T                - The 3x3 transformation matrix.

function [normalizedPoints, T] = normalise(points)

    % Input check
    if size(points, 1) ~= 3
        error('Points must be 3xN');
    end
    
    % Find indices of points that have infinite scale
    finiteIDs = find(abs(points(3, :)) > eps);
    
    if length(finiteIDs) ~= size(points, 2)
        warning('Some points are at infinity');
    end

    % Ensure homogeneous coordinates have scale 1
    points(1, finiteIDs) = points(1, finiteIDs) ./ points(3, finiteIDs);
    points(2, finiteIDs) = points(2, finiteIDs) ./ points(3, finiteIDs);
    points(3, finiteIDs) = 1;
    
    % Centroid of finite points
    centroid = mean(points(1:2, finiteIDs)')';
    
    % Shift origin to centroid 
    newPoints(1, finiteIDs) = points(1, finiteIDs) - centroid(1);
    newPoints(2, finiteIDs) = points(2, finiteIDs) - centroid(2);
    
    % Compute distance
    distance = sqrt( newPoints(1, finiteIDs).^2 + newPoints(2, finiteIDs).^2);
    meanDistance = mean(distance(:));
    
    scale = sqrt(2) / meanDistance;
    
    T = [scale   0   -scale*centroid(1);
         0     scale -scale*centroid(2);
         0       0           1];
     
     normalizedPoints = T * points;
end