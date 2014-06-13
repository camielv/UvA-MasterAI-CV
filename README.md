Computer Vision Assignments
===========================

University: University of Amsterdam
Master: Artificial Intelligence
Course: Computer Vision
Year: 2013-2014

This repository contains the implementations for the Computer Vision course
assignment. Each assignment can be run with default parameters by simply going
into the `src/` directory of each assignment and run the appropriate script,
`assignment{1,2,3}.m`. Before doing this each assignment's requirements should
be fullfilled.

Each folder contains a `Makefile` that should do most of the work for you,
downloading the data and if possible code. If any additional work needs to be
done, it is going to be described in each assignment's `README.txt` file.

In addition, we include the code for a point cloud visualizer and a mesh
builder, both implemented using C++ and the Point Cloud Library. Both projects
can be build using cmake. From each project directory, run the following
commands:

    mkdir build
    cd build
    cmake ..
    make -j

This will create the executables.
