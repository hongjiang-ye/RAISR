function kernel = createGaussianKernel(size, sigma)
%CREATEGAUSSIANKERNEL create gaussian kernel
    
    kernel = zeros(size);
    
    sigma_sq = 1.0 / (2 * sigma ^ 2);
    
    % dist to origin (0, 0)
    dist = floor(size / 2 + 0.5);
    
    for i = 1 : size 
        x = i - dist;
        tmp = sigma_sq /pi * exp(-x ^ 2 * sigma_sq);
        
        for j = 1 : size
            y = j - dist;
            kernel(x + dist, y + dist) = tmp * exp(-y ^ 2 * sigma_sq);
        end
        
    end
    
    kernel_sum = sum(sum(kernel));
    kernel = kernel / kernel_sum;   

end

