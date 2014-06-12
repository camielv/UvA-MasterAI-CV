function [S,M] = SFM(D)

% Find dense matrices in D, and do bundle adjustment


% Create point cloud


% Triangulate points to create surface mesh
mesh = DelaunayTri(points)


% Map textures on surface mesh


% Plot result
plot3(result)