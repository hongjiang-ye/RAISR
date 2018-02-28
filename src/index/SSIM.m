function output = SSIM(input_img1, input_img2)
%SSIM calculate the global SSIM of the two input images
    
    % If they are rgb image, use only Y channel
    if (ndims(input_img1) == 3)
        input_img1 = rgb2ycbcr(input_img1);
        input_img1 = input_img1(:, :, 1);
        input_img2 = rgb2ycbcr(input_img2);
        input_img2 = input_img2(:, :, 1);
    end
    
    L = diff(getrangefromclass(input_img1));
    
    input_img1 = double(input_img1);
    input_img2 = double(input_img2);
    
    window = createGaussianKernel(11, 1.5);  % 11x11 window size
    K1 = 0.01;
    K2 = 0.03;

    C1 = (K1 * L) ^ 2;
    C2 = (K2 * L) ^ 2;
    window = window / sum(window(:));  % normalize to 1 
    
    mu1 = filter2d(input_img1, window);
    mu2 = filter2d(input_img2, window);
%     mu1 = filter2(window, input_img1, 'valid');
%     mu2 = filter2(window, input_img2, 'valid');

    % equivalent to filter2(window, input_img2, 'valid'), only use the
    % valid pixels
    mu1 = cropInvalidPixels(mu1, window);
    mu2 = cropInvalidPixels(mu2, window);
    
    mu1_sq = mu1 .^ 2;
    mu2_sq = mu2 .^ 2;
    mu1_mu2 = mu1 .* mu2;

    mu_sq_1 = filter2d(input_img1 .^ 2, window);
    mu_sq_2 = filter2d(input_img2 .^ 2, window);
    mu_12 = filter2d(input_img1 .* input_img2, window);
%     mu_sq_1 = filter2(window, input_img1 .^ 2, 'valid');
%     mu_sq_2 = filter2(window, input_img2 .^ 2, 'valid');
%     mu_12 = filter2(window, input_img1 .* input_img2, 'valid');

    
    mu_sq_1 = cropInvalidPixels(mu_sq_1, window);
    mu_sq_2 = cropInvalidPixels(mu_sq_2, window);
    mu_12 = cropInvalidPixels(mu_12, window);
    
    sigma1_sq = mu_sq_1 - mu1_sq;
    sigma2_sq = mu_sq_2 - mu2_sq;
    sigma12 = mu_12 - mu1_mu2;
    
    ssim_map = ((2*mu1_mu2 + C1) .* (2*sigma12 + C2)) ./ ((mu1_sq + mu2_sq + C1) .* (sigma1_sq + sigma2_sq + C2));

    output = mean2(ssim_map);

end

