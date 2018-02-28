function output = PSNR(input_img1, input_img2)
%PSNR calculate the PSNR of the two input images

    % If they are rgb image, use only Y channel
    if (ndims(input_img1) == 3)
        input_img1 = rgb2ycbcr(input_img1);
        input_img1 = input_img1(:, :, 1);
        input_img2 = rgb2ycbcr(input_img2);
        input_img2 = input_img2(:, :, 1);
    end
    
    L = diff(getrangefromclass(input_img1));
    
    intensity_diff = double(input_img1) - double(input_img2);
    mse = mean(intensity_diff(:) .^ 2);
    
    output = 20 * log10(L / sqrt(mse));
    
end

