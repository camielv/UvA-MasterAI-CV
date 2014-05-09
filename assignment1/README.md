Setup
=====

Since we use the kd implementation of the library FLANN, the user needs to setup
that library before using this code. You can download FLANN from [here](http://www.cs.ubc.ca/research/flann/).

Once built, the library needs to be installed with `sudo make install`. Finally,
the path where the installation put the MATLAB files needs to be added to the
MATLAB path. In our case, this directory was

    /usr/local/share/flann/matlab

You can add it in MATLAB with the command `addpath`.

Improvements
============

- Sampling: Use normal sampling instead of random sampling. So that you take more valuable points
- Merging: Use error measure to see whether certain points should be merge.
