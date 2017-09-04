function [done] = generate_pointcloud( path, name_func, views, frame_number, filter_objects)
%TEST Summary of this function goes here
%   Generate ply file with the real world pointcloud and RGB colors
%   Usage:
%       - Basic: generate_pointcloud(root_path,'image2camera2world3d',{''})
%       - Generate specific files indexs: generate_pointcloud(root_path,
%                       'image2camera2world3d',{''},{1,5,7,10})
%       - Filter dynamic objects: generate_pointcloud(root_path,
%                       'image2camera2world3d',{''},{1,5,7,10},True)
%   Note: 'views' parameter is only used for the published Synthia format.
%   On case of having only the images/json files inside the RGB, GroundTruth,
%   Depth and Information folder, you can use views={''}. On other case set
%   the subfolders to compute (i.e: views={'OmniF/Left','OmniF/Right'})
    if nargin<5
        filter_objects = false;
    end

    if path(end) ~= '/'
        path(end+1) = '/';
    end
    
    for v=1:length(views)
        % Paths
        disp(['Running path ' views{v}])
        img_dir = [path 'RGB/' views{v} '/'];
        depth_dir = [path 'Depth/' views{v} '/'];
        data_dir = [path 'Information/' views{v} '/'];
        if filter_objects
            gt_dir = [path 'GroundTruth/' views{v} '/']; 
        end
        out_dir = [path 'out/' views{v} '/'];
        if ~isdir(out_dir)
            mkdir(out_dir)
        end
            
        % Files
        img_files = dir([img_dir '*.png']);
        depth_files = dir([depth_dir '*.png']);
        data_files = dir([data_dir '*.json']);
        if filter_objects
            gt_files = dir([gt_dir '*.png']);
        end

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
            if filter_objects
                gt_files_tmp = struct('name',{},'folder',{},'date',{},'bytes',{},'isdir',{},'datenum',{});
            end
            for n=1:length(frame_number)
                frame_number_string = sprintf('%06d', frame_number(n));

                for i=1:length(img_files)
                    if img_files(i).name(1:end-4)==frame_number_string
                        img_files_tmp(end+1) = img_files(i);
                        depth_files_tmp(end+1) = depth_files(i);
                        data_files_tmp(end+1) = data_files(i);
                        if filter_objects
                            gt_files_tmp(end+1) = gt_files(i);
                        end
                        break;
                    end
                end            
            end
            img_files = img_files_tmp;
            depth_files = depth_files_tmp;
            data_files = data_files_tmp;
            if filter_objects
                gt_files = gt_files_tmp;
            end
        end

        % Read for each image
        for i=1:length(img_files)
            disp(['converting image ' num2str(i) ': ' img_files(i).name])
            file_out = [out_dir img_files(i).name(1:end-3) 'ply'];

            % Read Position Matrices
            [Q,M] = loadMatrices([data_dir data_files(i).name]);

            % Read rgb image
            img = imread([img_dir img_files(i).name]);

            % Read gt image
            if filter_objects
                gt = imread([gt_dir gt_files(i).name]);
                gt_mask = findDinamicObjects(gt(:,:,1));
            end

            % Read depth image
            im = double(imread([depth_dir depth_files(i).name]));  
            wz = double( im(:,:,1) + (im(:,:,2) * 256) + (im(:,:,3) * 256 * 256) ) / double((256 * 256 * 256) - 1) * 1000;

            % Undefined depth mask (use only less than 100m for precision)
            mask = wz < 100.0;
            
            if filter_objects
                % Remove dynamic objects from RGB image
                mask = logical(mask .* (1-gt_mask));
            end

            % test conversion function
            save = true; % change to save
            switch (name_func)
                case 'image2camera3d'
                    [ points3d ] = image2camera3d( wz, mask, Q );
                case 'image2camera2world3d'
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

