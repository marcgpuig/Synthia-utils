function [ Q,M ] = loadMatrices( file )
%LOADK
%   Read the K intrinsic matrix using the synthia format.
%   
%   [Q, M] = loadPose(file)
%
%    Parameters:
%    - file: String. Parameters file containing the pose.
%
%    Return:
%    - M: 4x4 matrix pose. If the the file does not
%   exist, it returns an error. It follow the format:
%       | R | T |
%       | 0 | 1 |
%    - Q: 4x4 matrix with intrinsic parameters:
%       | 1 | 0 |      0       | -cx (pixels)  |
%       | 0 | 1 |      0       | -cy (pixels)  |
%       | 1 | 0 |      0       | focal(pixels) |
%       | 0 | 1 | 1/b (meters) |        0      |
%
    if exist(file, 'file') == 2
        % Read camera parameters
        fid = fopen(file);
        data = fgetl(fid);
        fclose(fid);
        
        data_json = jsondecode(data);
        
        M = reshape(data_json.extrinsic.matrix,[4,4])';
        Q = reshape(data_json.intrinsic.matrix,[4,4])'
        
        
    else
        error(['File for Pose matrix does not exist: ' file])
    end
end
