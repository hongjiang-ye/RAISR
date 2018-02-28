function HR_image = RAISR(LR_image, filters, patch_size, scale, Q_angle, Q_strenth, Q_coherence)
%RAISR compute the upsample image by RAISR

    half_patch_size = floor(patch_size / 2);

    if (ndims(LR_image) == 3)
        LR_image = rgb2ycbcr(LR_image);
        LR_image_y = LR_image(:, :, 1);
    else
        LR_image_y = LR_image;
    end
    
    % convert to [0, 1]
    LR_image_y = im2double(LR_image_y);
    
    bic_HR_image = imresize(LR_image_y, scale, 'bicubic');
    [HR_height, HR_width] = size(bic_HR_image);
    
    % padding
    bic_HR_image_ext = wextend('2d', 'sym', bic_HR_image, half_patch_size);
    
    tmp_HR_image = zeros(HR_height, HR_width);
   
    % compute the result pixel by pixel
    for x = 1 : HR_height
        for y = 1 : HR_width
            
            HR_patch = bic_HR_image_ext(x : x + 2 * half_patch_size, y : y + 2 * half_patch_size);
            
            idx = RAISR_hashFunction(HR_patch, Q_angle, Q_strenth, Q_coherence);
            type = RAISR_computeType(x, y, scale);
            
            HR_patch = HR_patch(:)';
            tmp_HR_image(x,y) = HR_patch * filters(:, type, idx);
        end
    end
    
    tmp_HR_image = im2uint8(tmp_HR_image);
    
    % blending with bicubic image, may bring down the PSNR and SSIM but looks better
    CT_width = 3;
    tmp_HR_image = RAISR_blend(im2uint8(bic_HR_image), tmp_HR_image, CT_width);
    tmp_HR_image = uint8(tmp_HR_image);
    
    % convert back to rgb
    if (ndims(LR_image) == 3)
        HR_image = zeros(HR_height, HR_width, size(LR_image, 3));
        HR_image(:, :, 1) = tmp_HR_image;
        HR_image(:, :, 2 : 3) = imresize(LR_image(:, :, 2 : 3), [HR_height, HR_width]);
        HR_image = ycbcr2rgb(uint8(HR_image));
    else
        HR_image = tmp_HR_image;
    end

end

