function filters = RAISR_train(train_img_dir, scale, patch_size, Q_angle, Q_strenth, Q_coherence)
%RAISR_TRAIN train the RAISR filters
    
    half_patch_size = floor(patch_size / 2);
    images_name_list = dir(train_img_dir);
    images_name_list = getFileList(images_name_list);
    images_num = length(images_name_list);
    images_path = cell(images_num, 1);
    
    hash_index_num = Q_angle * Q_strenth * Q_coherence;
    
    % record the ATA result
    Q = zeros(patch_size ^ 2, patch_size ^ 2, scale ^ 2, hash_index_num);
    
    % record the ATb result
    V = zeros(patch_size ^ 2, scale ^ 2, hash_index_num);
    
    for k = 1 : images_num
        fprintf('\nExtracting patches from %d/%d...\n', k, images_num);
    
        image_name = images_name_list(k).name;
        images_path{k} = [train_img_dir, image_name];
        image = imread(images_path{k});
        
        image = rgb2gray(im2double(image));
        [height, width] = size(image);

        LR_image = RAISR_createLRImage(image, scale);
        bicubic_HR_image = imresize(LR_image, [height, width], 'bicubic');
        
        % padding
        bicubic_HR_image_ext = wextend('2d', 'sym', bicubic_HR_image, half_patch_size);
        
        for x = 1 : height
            for y = 1 : width

                origin_LR_patch = ...
                    bicubic_HR_image_ext(x : x + 2 * half_patch_size, ...
                                         y : y + 2 * half_patch_size);
                        
                for i = 1 : 3
                    % rotate 90, filp up down and filp center
                    LR_patch = RAISR_transform(origin_LR_patch, i);
                
                    idx = RAISR_hashFunction(LR_patch, Q_angle, Q_strenth, Q_coherence);
                    type = RAISR_computeType(x, y, scale);
                    
                    LR_patch = LR_patch(:)';
                    
                    % accumulate
                    Q(:, :, type, idx) = Q(:, :, type,idx) + LR_patch' * LR_patch;
                    V(:, type, idx) = V(:, type, idx) + LR_patch' * image(x, y);
                end
            end
        end
    end

    filters = zeros(patch_size ^ 2, scale ^ 2, hash_index_num);

    % may have rank defiency warning, ignore
    warning('off');
    for type = 1 : scale ^ 2
        for idx = 1 : hash_index_num
            % solve the regression approximately
            filters(:, type, idx) = Q(:, :, type, idx) \ V(:, type, idx);
        end
    end

end

