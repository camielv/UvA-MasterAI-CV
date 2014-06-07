%% Load VLFEAT
run('../vlfeat/toolbox/vl_setup.m');

%% Load images
imageA = imread('../data/TeddyBear/obj02_002.png');
imageB = imread('../data/TeddyBear/obj02_003.png');

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
F = ransac(pointsA, pointsB);

%% Check error
error = sum(sum((pointsB' * F).*pointsA', 2)')

%% Visualize method 1
nScores = scores / max(scores);
ids = nScores < 0.1;
nMatches = matches(:, ids);

result = [imageA imageB];
figure(1); clf;
imshow(result);
hold on;

% Create x and y coordinates for matches a and b.
xa = pointsA(1,:); % FA(1, nMatches(1,:));
xb = pointsB(1,:) + size(IA, 2);% FB(1, nMatches(2,:)) + size(IA,2);
ya = pointsA(2,:);% FA(2, nMatches(1,:));
yb = pointsB(2,:);% FB(2, nMatches(2,:));
scatter(xa, ya);
scatter(xb, yb);

for i=1:size(xa, 2);
    plot([xa(:, i), xb(:, i)], [ya(:, i), yb(:, i)]);
end
