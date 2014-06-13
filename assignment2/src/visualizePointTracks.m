function [result] = visualizePointTracks(Z)
% VISUALIZEPOINTTRACKS Shows a 2d black-white image representing point tracks over time.
    result = zeros(size(Z, 3), size(Z, 1));
    for i = 1 : size(Z, 3),
        result(i, :) = ismember(Z(:, :, i), [-1, -1], 'rows');
    end
    imshow(result);
end
