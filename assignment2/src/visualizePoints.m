function visualizePoints(imageA, imageB, pointsA, pointsB)
% VISUALIZEPOINTS Shows matching points between two images.
    result = [imageA imageB];
    figure(2); clf;
    imshow(result);
    hold on;

    % Create x and y coordinates for matches a and b.
    xa = pointsA(:,1)';
    xb = pointsB(:,1)' + size(imageA, 2);
    ya = pointsA(:,2)';
    yb = pointsB(:,2)';
    scatter(xa, ya);
    scatter(xb, yb);

    plot([xa;xb], [ya;yb]);
end
