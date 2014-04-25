Normal Space Sampling
=====================

With this technique we sample more from "peculiar" spots in the mesh. The idea
is to compute for each point its normal. We then keep a bunch of bins for those
normals (`nBinsX * nBinsY * nBinsZ`) and then we put each normal with its pixel
in its closest bin. Then from each bin we sample the same number of points.

This results in peculiar orientations (which then map to few pixels) to be
sampled in proportion more than common normals.
