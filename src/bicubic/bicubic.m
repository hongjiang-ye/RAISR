function output_img = bicubic(input_img, height, width)
%BICUBIC cubic convolution interpolation
%   CAUTION: No antialiasing, so looks bad.

    input_img = double(input_img);
    origin_height = size(input_img, 1);
    origin_width = size(input_img, 2);
    channels = size(input_img, 3);

    output_img = zeros(height, width, channels);
    
    for c = 1 : channels
        tmp_output = zeros(height, width);
        % interplot at col
        for y = 1 : origin_width
            tmp_output(:, y) = interplotAlongDim(input_img(:, y, c), origin_height, height);
        end
        tmp_output = tmp_output';
        
        % interplot at row
        tmp_output_transpose = zeros(width,height);
        for x = 1 : height
            tmp_output_transpose(:, x) = interplotAlongDim(tmp_output(:, x), origin_width, width);
        end
        
        % copy the result to output
        output_img(:, :, c) = tmp_output_transpose';
    end
    
end

