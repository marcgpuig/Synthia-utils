function [ points3d ] = camera3d2world3d( points, M )
%IMAGE2WORLD3D 
%   Generate a pointcloud on camera coordinates given a depth image, K 
%   camera parameters matrix, R roatation matrix and T traslation matrix.
%   
%   [points3d] = image2world3d( points, M )
%
%    Parameters:
%    - points: points in camera coordinates
%    - M: extrinsic matrix
%
%    Return:
%    - points3d: point cloud with size [3, with * heigh]. The frist 3
%    channels are [X Y Z] 3D coordinates. If the image is null or K is not 
%    a 3x3 matrix, it returns [].

    points(4,:) = 1;
    
    % Unity ¿bug? on computing Pose Matrix (It expects Z to be negative)
    M(1:3,3) = -M(1:3,3);
    
    points3d = M * points;
    points3d(1,:) = points3d(1,:) ./ points3d(4,:);
    points3d(2,:) = points3d(2,:) ./ points3d(4,:);
    points3d(3,:) = points3d(3,:) ./ points3d(4,:);
    points3d(4,:) = points3d(4,:) ./ points3d(4,:);

end
