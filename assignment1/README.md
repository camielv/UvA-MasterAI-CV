Setup
=====

Since we use the kd implementation of the library FLANN, the user needs to setup
that library before using this code. You MUST use the GitHub version of FLANN!!
You can download it by running:

    git clone git://github.com/mariusmuja/flann.git

Once built, the library needs to be installed with `sudo make install`, or, even
better, `sudo checkinstall`. Note that these steps are not included in our
Makefile since we would like you to understand that this step installs software
on your computer.

Finally, the path where the installation put the MATLAB files needs to be added
to the MATLAB path. In our case, this directory was

    /usr/local/share/flann/matlab

You can add it in MATLAB with the command `addpath`. Calling the script
`assignment1.m` automatically adds this path, so you need this step only if you
installed FLANN somewhere else.
