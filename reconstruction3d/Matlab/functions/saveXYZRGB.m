function [saved] = saveXYZRGB( points3d, rgb_image, file_out )
%SAVEXYZRGB 
%   Write a file following the format [X Y Z R G B]
%   
%   [saved] = saveXYZRGB( points3d, rgb_image, file_out )
%
%    Parameters:
%    - rgb_image: rgb image with size [weight, height, channels]
%    - points3d: 3xN matrix with N = weight*height
%    - file_out: string. filename to write the points.
%
%    Return:
%    - saved: bool. Return True if the file is saved succesfuly.

    saved = False
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

    points3d_rgb = points3d
end
