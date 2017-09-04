function [ points3d ] = camera3d2world3d( points, M )
%IMAGE2WORLD3D 
%   Generate a pointcloud on world coordinates given a the camera points 
%   and pose matrix M.
%   
%   [points3d] = image2world3d( points, M )
%
%    Parameters:
%    - points: points in camera coordinates
%    - M: camera pose
%
%    Return:
%    - points3d: point cloud with size [4, with * heigh]. The frist 4
%    channels are [X Y Z 1] 3D coordinates.

    points(4,:) = 1;
    
    points3d = M * points;
    points3d(1,:) = points3d(1,:) ./ points3d(4,:);
    points3d(2,:) = points3d(2,:) ./ points3d(4,:);
    points3d(3,:) = points3d(3,:) ./ points3d(4,:);
    points3d(4,:) = points3d(4,:) ./ points3d(4,:);

end
