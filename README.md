# Synthia-utils
Useful scripts for synthia datase. You can found the following sections:
- **reconstruction3d**: Utils scrips and functions to generate pointclouds and views respect to the camera and world.
  
### reconstruction3d
- **functions/image2camera3d**: Generate a pointcloud on camera coordinates given a RGB image, depth image and K camera parameters matrix.
- **functions/image2world3d**: Generate a pointcloud on world coordinates given a RGB image, depth image, K camera parameters matrix, R rotation matrix and T translation matrix.
- **functions/loadK**: Return the K camera parameters matrix given a synthia intrinsic parameters file.
- **functions/saveXYZRGB**: Save the pointcloud on a txt file to be represented on Meshlab 3D visor.
- **scripts/createCameraPointCloud**: Create a file for each image with the pointcloud wiuth respect to the camera. The file follow the format for being used on the Meshlab 3D visor.
- **scripts/createWorldPointCloud**: Create a file for each image with the pointcloud wiuth respect to the world. The file follow the format for being used on the Meshlab 3D visor.
- **scripts/create4ViewsPointCloud**: Create a file for each image with the pointcloud wiuth respect to the camera with the four views available on Synthia. The file follow the format for being used on the Meshlab 3D visor.


# Dependencies
Each file is done on the following programming languages:
- Python (.py)
- Matlab (.m)  

Each language has its own dependencies.

### Python dependencies 
- Python 2.7

### Matlab dependencies
- Matlab
