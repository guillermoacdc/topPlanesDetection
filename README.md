# topPlanesDetection

This repository contains a top-plane extraction algorithm suitable for packing scenes: cluttered scenes with multiple boxes,
each one with different spatial properties (positions, orientations and scales) and under partial occlusion conditions. The algorithm was designed as a
component of a pipeline that resolves the problems of detection, segmentation and pose estimation of boxes from point clouds.
The performance of the algorithm is assessed in terms of four indicators: (1) existing planes detected -DP, (2) number of existing
planes that were detected multiple times – MD, (3) number of missing planes -MP , (4) number of spurious planes detected -SP.
