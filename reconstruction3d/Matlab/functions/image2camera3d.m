function [ points3d ] = image2camera3d( depth_img, mask, K )
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
%    a 3x3 matrix, it returns an error.

    % Read depth image
    wz = depth_img(:,:,1);
    [hd,wd,cd] = size(wz);

    % Sanity checks
    if hd<=0 || wd<=0
        error(['Depth image has incorrect size: [' num2str(hd) ', ' 
            num2str(wd) ', ' num2str(cd) ']'])
    end
    
    if size(K,1)<3 || size(K,2)<3
        error('K is not a 3x3 matrix')
    end

    % Create image positions
    [u, v] = createPixelMatrices( hd, wd );

%     % Create points matrix
%     image_dimensions = [1,size(u,1)*size(u,2)];
%     u = reshape(u,image_dimensions);
%     v = reshape(v,image_dimensions);
%     wz = reshape(wz,image_dimensions);
%     point = [u(mask).*wz(mask);v(mask).*wz(mask);wz(mask)];
% 
%     % 2d to 3d conversion
%     points3d = K \ point;
    
    % Create points matrix
    image_dimensions = [1,size(u,1)*size(u,2)];
    u = reshape(u,image_dimensions);
    v = reshape(v,image_dimensions);
    wz = reshape(wz,image_dimensions);
    b = -1.0/K(4,3);
    f = K(3,4);
%     point = [u(mask).*wz(mask);v(mask).*wz(mask);wz(mask)];
    point = [u(mask);v(mask);(f*b)./wz(mask);ones(size(wz(mask)))];

    % 2d to 3d conversion
    
    points3d = K * point;
    points3d(1,:) = points3d(1,:)./points3d(4,:);
    points3d(2,:) = points3d(2,:)./points3d(4,:);
    points3d(3,:) = points3d(3,:)./points3d(4,:);
    points3d(4,:) = points3d(4,:)./points3d(4,:);
end

function [ u, v ] = createPixelMatrices( h, w )
%CREATEPIXELMATRICES
%   Generate u, v matrix pair to know the x-pixel and y-pixel coordinate
%   for each position.
%
%   [ u, v ] = createPixelMatrices( h, w )
%
%    Parameters:
%    - h: height value
%    - w: weight value.
%
%    Return:
%    - u: hxw Matrix. It contains the x-coordinate value
%    - v: hxw Matrix. It contains the y-coordinate value

%     u = double(repmat(0:w-1,[h,1]));
    u = double(repmat(w-1:-1:0,[h,1]));
    v = double(repmat(0:h-1,[w,1]))';
%     v = double(repmat(h-1:-1:0,[w,1]))';
end
