addpath(genpath('assignment2/'));

%% Load VLFEAT
run('assignment2/vlfeat/toolbox/vl_setup.m');

Z = chaining('assignment2/data/House', 0.1, 1000, 0.5, 1);

%% Select full tracks
result = zeros(size(Z, 3), size(Z, 1));
for i = 1 : size(Z, 3),
    result(i, :) = ismember(Z(:, :, i), [-1, -1], 'rows');
end

ids = sum(result, 1) == 0;
Z = Z(ids, :, :);

%% Normalize each timestep
for i=1:size(Z,1)
    % Compute centroid
    centroid = mean(Z(i, :, :), 3);
    Z(i, :, :) = bsxfun(@minus, Z(i, :, :), centroid);
end

%% Convert to slide representation
sizeZ = size(Z);

% Append all slices
Z = reshape(Z, sizeZ(1), 2 * sizeZ(3), 1);
Z = permute(Z, [2,1,3]);

%% Do 3d reconstruction
[S, M] = denseSFM(Z);
scatter3(S(1, :), S(2, :), S(3, :));