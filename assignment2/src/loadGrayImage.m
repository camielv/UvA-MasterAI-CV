function [image] = loadGrayImage(filename)
% LOADGRAYIMAGE Loads an image, and, if RGB, makes it greyscale.
    image = imread(filename);
    if size(image, 3) == 3,
        image = rgb2gray(image);
    end
end
