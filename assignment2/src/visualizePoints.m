function visualizePoints(imageA, imageB, pointsA, pointsB)
    result = [imageA imageB];
    figure; clf;
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