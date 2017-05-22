function [ points3d ] = image2camera3d( depth_img, frame_number, K )
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

    frame_number_string = sprintf('%06d', frame_number);
    gps   = [file_path '\gps\'   frame_number_string '.txt']
    rgb   = [file_path '\rgb\'   frame_number_string '.png']
    depth = [file_path '\depth\' frame_number_string '.png']

    disp(['image2camera3D: ' file_path]);

    % Read Position Matrices
    M = reshape(load(gps),[4,4]);
    R = M(1:3,1:3);
    T = M(1:3,4);

    % Read rgb image
    img = imread(rgb);
    [h,w,c] = size(img);

    % Read depth image
    wz = double(imread(depth));
    wz = wz(:,:,1);
    [hd,wd,cd] = size(wz);

    if hd~=h || wd~=w
        disp('images have different sizes')
        return
    end

    % Create image positions
    u = double(repmat(1:w,[h,1]));
    v = double(repmat(1:h,[w,1]))';

    % Create points matrix
    image_dimensions = [1,size(u,1)*size(u,2)];
    u = reshape(u,image_dimensions);
    v = reshape(v,image_dimensions);
    wz = reshape(wz,image_dimensions);
    point = [u.*wz;v.*wz;wz];

    % 2d to 3d conversion
    points3d = K \ point;
end

