% Todo documentation

function [image] = loadGrayImage(filename)
    image = imread(filename);
    if size(image, 3) == 3,
        image = rgb2gray(image);
    end
end