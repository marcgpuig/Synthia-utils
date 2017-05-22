function [a] = test( path, name_func, frame_number )
%TEST Summary of this function goes here
%   Detailed explanation goes here
    
    if path(end) ~= '/'
        path(end+1) = '/';
    end
    
    % Paths
    img_dir = [path 'rgb/'];
    depth_dir = [path 'depth/'];
    data_dir = [path 'gps/'];
    out_dir = [path 'out/'];
    if ~isdir(out_dir)
        mkdir(out_dir)
    end

    % Files
    img_files = dir([img_dir '/*.png']);
    depth_files = dir([depth_dir '/*.png']);
    data_files = dir([data_dir '/*.txt']);
    camera_param_file = [path 'intrinsics.txt'];

    % Sanity Checks
    if length(img_files) ~= length(data_files) || length(depth_files) ~= length(data_files)
        disp('ERROR: number of images and data is diferent')
        disp(['Images files: ' num2str(length(img_files))])
        disp(['Depth files: ' num2str(length(depth_files))])
        disp(['Data files: ' num2str(length(data_files))])
        return 
    end

    % Read camera parameters
    K = loadK(camera_param_file);
    
    % Filter images
    if nargin==3
        frame_number_string = sprintf('%06d', frame_number);
        
        for i=1:length(img_files)
            if img_files(i).name(1:end-4)==frame_number_string
                img_files = [img_files(i)];
                break
            end
        end
    end
    
    % Read for each image
    for i=1:length(img_files)
        disp(['converting image ' num2str(i) ': ' img_files(i).name])

        file_out = [out_dir img_files(i).name(1:end-3) 'ply'];
        
        % Read Position Matrices
        M = loadPose([data_dir data_files(i).name]);
        R = M(1:3,1:3);
        T = M(1:3,4);

        % Read rgb image
        img = imread([img_dir img_files(i).name]);

        % Read depth image
        wz = double(imread([depth_dir depth_files(i).name]))/100.;       

        % test conversion function
        switch (name_func)
            case 'image2camera3d'
                [ points3d ] = image2camera3d( wz, K );
            otherwise
                disp(['function not defined: ' name_func]);
                points3d = [];
        end
        
        
        % save file
        saveXYZRGB(points3d, img, file_out);
        
    end
end

