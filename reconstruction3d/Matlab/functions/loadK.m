function [ K ] = loadK( file )
%LOADK
%   Read the K intrinsic matrix using the synthia format.
%   
%   [K] = loadK(file)
%
%    Parameters:
%    - file: String. Parameters file containing the intrinsic parameters.
%
%    Return:
%    - K: 3x3 matrix used for the camera matrix. If the the file does not
%   exist, it returns an error.

    if exist(file, 'file') == 2
        % Read camera parameters
        camera_param = double(load(file));
        fpixels = camera_param(1);
        cu = camera_param(2);
        cv = camera_param(3);

        % Computation matrices
        K = [fpixels,0,cu;0,fpixels,cv;0,0,1];
        
    else
        error(['Parameters file for K matrix does not exist: ' file])
    end
end
