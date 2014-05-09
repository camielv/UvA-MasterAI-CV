%% Load VLFEAT
run('~/Tools/vlfeat/toolbox/vl_setup.m');

%% Load images
imageA = imread('../data/TeddyBear/obj02_001.png');
imageB = imread('../data/TeddyBear/obj02_002.png');

%% Compute SIFT interest points
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
% TODO: Normalisation function.
% TODO: Denormalisation function.
% TODO: RANSAC.

% Convert scores between 0 and 1.
nScores = scores / max(scores);
% At the moment no filtering at score
ids = nScores < 2;
% Get the filtered matches.
nMatches = matches(:, ids);

% Extract x and y coordinates for the points that match in both images A
% and B.
ptsA = FA(:, nMatches(1, :));
ptsB = FB(:, nMatches(2, :));

% TODO: Write a normalise function
% [ptsB, T1] = normalise2dpts(ptsB);
% [ptsA, T2] = normalise2dpts(ptsA);

ptsAx = ptsA(1, :)';
ptsBx = ptsB(1, :)';
ptsAy = ptsA(2, :)';
ptsBy = ptsB(2, :)';

% See Equation 1 in assignment to constructs matrix A.
A = [ptsBx .* ptsAx, ptsBx .* ptsAy, ptsBx, ptsBy .* ptsAx, ptsBy .* ptsBy, ptsBy, ptsBx, ptsBy, ones(size(nMatches, 2), 1)];

% Find the SVD of A. Solve Equation 1.
[U D V] = svd(A, 0);

% The entries of F are the components of the column of V corresponding to
% the smallest singular value.
F = reshape(V(:,9),3,3)';

% Find the SVD of F.
[Uf, Df, Vf] = svd(F,0);

% Set the smallest singular value in the diagonal matrix Df to zero in
% order to obtain the corrected matrix D f
Df = diag([D(1,1) D(2,2) 0]);

% Recompute Fundamental Matrix
F = Uf * Df * Vf';

% TODO: Denormalise
%F = T2'*F*T1;
    
% Solve epipoles?
%[U,D,V] = svd(F,0);
%e1 = hnormalise(V(:,3));
%e2 = hnormalise(U(:,3));
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
