function [points3d] = image2world3d( depth_img, K, R, T )
%IMAGE2WORLD3D 
%   Generate a pointcloud on camera coordinates given a depth image, K 
%   camera parameters matrix, R roatation matrix and T traslation matrix.
%   
%   [points3d] = image2world3d( depth_img, K, R, T )
%
%    Parameters:
%    - depth_img: grayscale image with size [with, heigh, 1]
%    - K: 3x3 matrix with the inctrinsic parameters.
%    - R: 3x3 matrix with the rotation matrix.
%    - T: 1x3 matrix with the tralsation vector.
%
%    Return:
%    - points3d: point cloud with size [3, with * heigh]. The frist 3
%    channels are [X Y Z] 3D coordinates. If the image is null or K is not 
%    a 3x3 matrix, it returns [].

    points3d = [];
end

