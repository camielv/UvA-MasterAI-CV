%% Load VLFEAT
run('~/Tools/vlfeat/toolbox/vl_setup.m');

%% Load images
image1 = imread('../data/TeddyBear/obj02_001.png');
image2 = imread('../data/TeddyBear/obj02_002.png');

%% Compute SIFT interest points
% Convert to single precision
I1 = single(rgb2gray(image1));
I2 = single(rgb2gray(image2));

% Find interest points
[F1, D1] = vl_sift(I1);
[F2, D2] = vl_sift(I2);

% Match interest points
[matches, scores] = vl_ubcmatch(D1, D2);

% Compute fundamental matrix

%% Visualize method 1
nScores = scores / max(scores);
ids = nScores < 0.1;
nMatches = matches(:, ids);

result = [image1 image2];
figure(1); clf;
imshow(result);
hold on;

% Create x and y coordinates for matches a and b.
xa = F1(1, nMatches(1,:));
xb = F2(1, nMatches(2,:)) + size(I1,2);
ya = F1(2, nMatches(1,:));
yb = F2(2, nMatches(2,:));
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