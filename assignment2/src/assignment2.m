%% Load VLFEAT
run('../vlfeat/toolbox/vl_setup.m');

%% Load images
imageA = imread('../data/TeddyBear/obj02_002.png');
imageB = imread('../data/TeddyBear/obj02_003.png');

%% Background removal + Interest Points + Matching + Eightpoint + Ransac
[pointsA, pointsB, F] = findMatches(imageA, imageB, 10, 10000);

%% Background removal
[objectA, objectB] = removeBackground(imageA, imageB);

%% Compute SIFT interest points and match them
% Convert to single precision
IA = single(rgb2gray(objectA));
IB = single(rgb2gray(objectB));

% Find interest points
[FA, DA] = vl_sift(IA);
[FB, DB] = vl_sift(IB);

% Match interest points
[matches, scores] = vl_ubcmatch(DA, DB);

%% Compute fundamental matrix
% Convert scores between 0 and 1.
nScores = scores / max(scores);
% At the moment no filtering at score
ids = nScores < 2;
% Get the filtered matches.
nMatches = matches(:, ids);

% Extract x and y coordinates for the points that match in both images A
% and B.
pointsA = FA(1:3, nMatches(1, :));
pointsB = FB(1:3, nMatches(2, :));

%% Find the fundamental matrix
[F, model] = ransac(pointsA, pointsB);
ransacA = pointsA(:, model);
ransacB = pointsB(:, model);

%% Check error
error = sum(sum((pointsB' * F).*pointsA', 2)')

%% Visualize
visualizePoints(imageA, imageB, pointsA, pointsB);