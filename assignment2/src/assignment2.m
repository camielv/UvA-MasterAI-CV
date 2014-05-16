%% Load VLFEAT
run('~/Tools/vlfeat/toolbox/vl_setup.m');

%% Load images
imageA = imread('../data/TeddyBear/obj02_001.png');
imageB = imread('../data/TeddyBear/obj02_002.png');

%% Background removal
backgroundA = imageB - imageA;
backgroundB = imageA - imageB;
G = fspecial('gaussian',[25 25], 25);
blurA = imfilter(backgroundA, G, 'same');
blurB = imfilter(backgroundB, G, 'same');
blurA = sum(blurA, 3);
blurB = sum(blurB, 3);
%blurA = blurA ./ max(max(blurA));
%blurB = blurB ./ max(max(blurB));
%%
threshold = 50;
filterA = blurA > threshold;
filterB = blurB > threshold;
maskA = bwconvhull(filterA);
maskB = bwconvhull(filterB);
imageA = imageA .* repmat(uint8(maskA), [1, 1, 3]);
imageB = imageB .* repmat(uint8(maskB), [1, 1, 3]);
%% Compute SIFT interest points and match them
% Convert to single precision
IA = single(rgb2gray(imageA));
IB = single(rgb2gray(imageB));

% Find interest points
[FA, DA] = vl_sift(IA);
[FB, DB] = vl_sift(IB);

% Match interest points
[matches, scores] = vl_ubcmatch(DA, DB);

% TODO: Filter out background features. Background substraction.

%% Compute fundamental matrix
% Convert scores between 0 and 1.
nScores = scores / max(scores);
% At the moment no filtering at score
ids = nScores < 2;
% Get the filtered matches.
nMatches = matches(:, ids);

% Extract x and y coordinates for the points that match in both images A
% and B.
pointsA = FA(:, nMatches(1, :));
pointsB = FB(:, nMatches(2, :));

%% Find the fundamental matrix
F = ransac(pointsA(1:3, :), pointsB(1:3, :));
%% Visualize method 1
nScores = scores / max(scores);
ids = nScores < 0.1;
nMatches = matches(:, ids);

result = [imageA imageB];
figure(1); clf;
imshow(result);
hold on;

% Create x and y coordinates for matches a and b.
xa = FA(1, nMatches(1,:));
xb = FB(1, nMatches(2,:)) + size(IA,2);
ya = FA(2, nMatches(1,:));
yb = FB(2, nMatches(2,:));
scatter(xa, ya);
scatter(xb, yb);

for i=1:size(xa, 2);
    plot([xa(:, i), xb(:, i)], [ya(:, i), yb(:, i)]);
end

%% Visualize method 2
figure(1); clf;
imagesc(cat(2, I1, I2));
axis image off ;
vl_demo_print('sift_match_1', 1) ;

figure(2); clf;
imagesc(cat(2, I1, I2));

xa = F1(1, matches(1,:)) ;
xb = F2(1, matches(2,:)) + size(I1,2) ;
ya = F1(2, matches(1,:)) ;
yb = F2(2, matches(2,:)) ;

hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;

vl_plotframe(F1(:,matches(1,:)));
fb(1,:) = F2(1,:) + size(I1, 2);
vl_plotframe(F2(:,matches(2,:)));
axis image off;
vl_demo_print('sift_match_2', 1);
