function [done] = test( path, name_func, views, frame_number)
%TEST Summary of this function goes here
%   TODO: Detailed explanation goes here

    if path(end) ~= '/'
        path(end+1) = '/';
    end
    
    % Read camera parameters
    camera_param_file = [path 'CameraParams/intrinsics.txt'];
    K = loadK(camera_param_file);
    Q = loadQ(camera_param_file);
    
    for v=1:length(views)
        % Paths
        disp(['Running path ' views{v}])
        img_dir = [path 'RGB/' views{v} '/'];
        depth_dir = [path 'Depth/' views{v} '/'];
        data_dir = [path 'CameraParams/' views{v} '/'];
        gt_dir = [path 'GT/LABELS/' views{v} '/']; 
        out_dir = [path 'out/' views{v} '/'];
        if ~isdir(out_dir)
            mkdir(out_dir)
        end
            
        % Files
        img_files = dir([img_dir '*.png']);
        depth_files = dir([depth_dir '*.png']);
        data_files = dir([data_dir '*.txt']);
        gt_files = dir([gt_dir '*.png']);

        % Sanity Checks
        if length(img_files) ~= length(data_files) || length(depth_files) ~= length(data_files)
            disp('ERROR: number of images and data is diferent')
            disp(['Images files: ' num2str(length(img_files))])
            disp(['Depth files: ' num2str(length(depth_files))])
            disp(['Data files: ' num2str(length(data_files))])
            done = false;
            return 
        end

        % Filter images
        if nargin==4
            img_files_tmp = struct('name',{},'folder',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
            depth_files_tmp = struct('name',{},'folder',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
            data_files_tmp = struct('name',{},'folder',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
            gt_files_tmp = struct('name',{},'folder',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
            for n=1:length(frame_number)
                frame_number_string = sprintf('%06d', frame_number(n));

                for i=1:length(img_files)
                    if img_files(i).name(1:end-4)==frame_number_string
                        img_files_tmp(end+1) = img_files(i);
                        depth_files_tmp(end+1) = depth_files(i);
                        data_files_tmp(end+1) = data_files(i);
                        gt_files_tmp(end+1) = gt_files(i);
                        break;
                    end
                end            
            end
            img_files = img_files_tmp;
            depth_files = depth_files_tmp;
            data_files = data_files_tmp;
            gt_files = gt_files_tmp;
        end

        % Read for each image
        for i=1:length(img_files)
            disp(['converting image ' num2str(i) ': ' img_files(i).name])
            file_out = [out_dir img_files(i).name(1:end-3) 'ply'];

            % Read Position Matrices
            M = loadPose([data_dir data_files(i).name]);

            % Read rgb image
            img = imread([img_dir img_files(i).name]);

            % Read gt image
            gt = imread([gt_dir gt_files(i).name]);
            gt_mask = findDinamicObjects(gt(:,:,1));

            % Read depth image
            wz = double(imread([depth_dir depth_files(i).name]))/100.0;   
            wz = wz(:,:,1);

            % Undefined depth mask
            mask = wz < 100.0;
            mask = logical(mask .* (1-gt_mask));

            % test conversion function
            save = true; % change to save
            switch (name_func)
                case 'image2camera3d'
                    [ points3d ] = image2camera3d( wz, mask, Q );
                case 'image2world3d'
                    [ points3d ] = image2camera3d( wz, mask, Q );
                    [ points3d ] = camera3d2world3d( points3d, M );
                otherwise
                    disp(['function not defined: ' name_func]);
                    save = false;
                    points3d = [];
            end

            if save == true
                % save file
                saveXYZRGB(points3d, img(repmat(mask,[1,1,3])), file_out);
            end

            done = true;
        end
    end
end

