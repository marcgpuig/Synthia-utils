function [ M ] = loadPose( file )
%LOADK
%   Read the K intrinsic matrix using the synthia format.
%   
%   [M] = loadPose(file)
%
%    Parameters:
%    - file: String. Parameters file containing the pose.
%
%    Return:
%    - M: 4x4 matrix pose. If the the file does not
%   exist, it returns an error. It follow the format:
%       | R | T |
%       | 0 | 1 |

    if exist(file, 'file') == 2
        % Read camera parameters
        M = reshape(load(file),[4,4]);
    else
        error(['File for Pose matrix does not exist: ' file])
    end
end
