function LR_image = RAISR_createLRImage(HR_image, scale)
%CREATELRIMAGE downsample by bicubic
    
    [HR_height, HR_width, c] = size(HR_image);
    
    % You have to trim the HR_image, getting rid of out of bound error of
    % the LR patch and HR patch mapping
    height_trim = HR_height - mod(HR_height, scale);
    width_trim = HR_width - mod(HR_width, scale);
    HR_image_trim = HR_image(1 : height_trim, 1 : width_trim, :);
    
    % Downsample
    LR_image = imresize(HR_image_trim, [height_trim / scale, width_trim / scale]);
    
end

