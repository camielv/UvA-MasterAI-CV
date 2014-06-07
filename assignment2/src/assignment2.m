%% Load VLFEAT
run('../vlfeat/toolbox/vl_setup.m');

pointTracks = chaining('../data/TeddyBear', 100, 1000);
%pointTracks = chaining('../data/House', 100, 1000);