%% Initialization
addpath('./pcd');
addpath('/usr/local/share/flann/matlab');

mergeCloudSet('allClouds.pcd', 'normal', 4000, 'flann', 0, 1, 90);
% cumulativeMergeCloudSet('cumulAllClouds.pcd', 'random', 6000, 'flann', 0, 1, 90);

% mergeCloudSet('everyTwo.pcd', 'normal', 8000, 'flann', 0, 2, 30);
% mergeCloudSet('everyFour.pcd', 'normal', 8000, 'flann', 0, 4, 30);
% mergeCloudSet('everyTen.pcd', 'normal', 8000, 'flann', 0, 10, 60);