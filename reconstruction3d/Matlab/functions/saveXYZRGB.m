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
        separator = ' ';
    end
    
    M = fuseRGB(points3d,rgb_image);
    
    % (Polygon File Format) PLY header
    vertex_count = size(M,2);
    header = ['ply\nformat ascii 1.0\nelement vertex ' num2str(vertex_count) '\nproperty float32 x\nproperty float32 y\nproperty float32 z\nproperty uchar red\nproperty uchar green\nproperty uchar blue\nend_header\n'];
    file_id = fopen(file_out,'wt');
    fprintf(file_id, header);
    fclose(file_id);
    
    % Write PLY data
    dlmwrite(file_out, M', 'delimiter', separator, '-append');
    
    %TODO: check if it is saved correclty
    % gvillalonga: I do not see how to do it...
    
    saved = true;
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
    
    if size(rgb_image,1)==size(points3d,2)*3
        points3d_rgb(4,:) = rgb_image(1:size(points3d_rgb,2),1);
        points3d_rgb(5,:) = rgb_image(size(points3d_rgb,2)+1:2*size(points3d_rgb,2),1);
        points3d_rgb(6,:) = rgb_image(2*size(points3d_rgb,2)+1:end,1);
    else
        size(rgb_image)
        size(points3d)
        disp(['WARNING: RGB image has not the correct size: [' 
            num2str(size(rgb_image,1)) ', '
            num2str(size(rgb_image,2)) ']'])
    end
end
