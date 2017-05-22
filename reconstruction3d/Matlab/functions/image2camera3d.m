function [points3d] = image2camera3d( depth_img, K )
%IMAGE2CAMERA3D 
%   Generate a pointcloud on camera coordinates given a depth image and K 
%   camera parameters matrix.
%   
%   [points3d] = image2camera3d( depth_img, K )
%
%    Parameters:
%    - depth_img: grayscale image with size [with, heigh, 1]
%    - K: 3x3 matrix with the inctrinsic parameters.
%
%    Return:
%    - points3d: point cloud with size [6, with * heigh]. The frist 3
%    channels are [X Y Z] 3D coordinates. If the image is null or K is not 
%    a 3x3 matrix, it returns [].

    points3d = [];
end

