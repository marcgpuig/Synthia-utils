function [ saved ] = saveXYZRGB( points3d, rgb_image, file_out, separator )
%SAVEXYZRGB 
%   Write a file following the format [X Y Z R G B]
%   
%   [saved] = saveXYZRGB( points3d, rgb_image, file_out )
%
%    Parameters:
%    - rgb_image: rgb image with size [weight, height, channels]
%    - points3d: 3xN matrix with N = weight*height
%    - file_out: string. filename to write the points.
%    - separator: char. delimiter character. ', ' is used by default
%
%    Return:
%    - saved: bool. Return True if the file is saved succesfuly.

    if nargin < 4
        separator = ',';
    end
    
    M = fuseRGB(points3d,rgb_image);
    
    dlmwrite(file_out, M', 'delimiter', separator)
    
    %TODO: check if it is saved correclty
    % gvillalonga: I do not see how to do it...
    
    saved = True
end

function [points3d_rgb] = fuseRGB( points3d, rgb_image )
%FUSERGB 
%   Auxiliar function. It fuses the 3d points with its RGB color.
%   
%   [points3d_rgb] = fuseRGB( points3d, rgb_image )
%
%    Parameters:
%    - points3d: 3xN matrix with N = weight*height
%    - rgb_image: rgb image with size [weight, height, channels]
%
%    Return:
%    - points3d_rgb: 6xN matrix with N = weight*height. The first 3
%    channels are the 3d coordinates [X Y Z] and the last 3 channels are
%    the RGB color [R G B]. Retruns points3d if rgb_image is void.
    
    points3d_rgb = points3d;
    
    if size(rgb_image,1)>0 && size(rgb_image,2)>0 && size(rgb_image,3)>2
        points3d_rgb(4,:) = reshape(rgb_image(:,:,1),[1,size(rgb_image,1)*size(rgb_image,2)]);
        points3d_rgb(5,:) = reshape(rgb_image(:,:,2),[1,size(rgb_image,1)*size(rgb_image,2)]);
        points3d_rgb(6,:) = reshape(rgb_image(:,:,3),[1,size(rgb_image,1)*size(rgb_image,2)]);
    else
        disp(['WARNING: RGB image has not the correct size: [' 
            num2str(size(rgb_image,1)) ', ' num2str(size(rgb_image,2)) ', '
            num2str(size(rgb_image,3)) ']'])
    end
end
