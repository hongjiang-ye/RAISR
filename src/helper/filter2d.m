function output_img = filter2d(input_img, filter)
    
    if (size(input_img, 3) > 1)
        output_img = zeros(size(input_img));
        for i = 1 : size(input_img, 3)
            output_img(:, :, i) = filter2d(input_img(:, :, i), filter);
        end
    else
        % padding
        m = size(filter, 1) - 1;
    
        [img_height, img_width] = size(input_img);
        padded_img = zeros(2 * m + img_height, 2 * m + img_width);
        output_img = zeros(size(padded_img));
    
        padded_img(m + 1 : m + img_height, m + 1: m + img_width) = input_img;
    
        padded_img(1 : m, :) = ...
            bsxfun(@plus, zeros(m, 1), padded_img(m + 1, :));
        padded_img(m + img_height + 1 : img_height + m * 2, :) = ...
            bsxfun(@plus, zeros(m, 1), padded_img(m + img_height, :));
    
        padded_img(:, 1 : m) = ...
            bsxfun(@plus, zeros(1, m), padded_img(:, m + 1));
        padded_img(:, m + img_width + 1 : img_width + m * 2) = ...
            bsxfun(@plus, zeros(1, m), padded_img(:, m + img_width));
    
        % corr
        margin = ceil(m / 2);
        for i = m - margin + 1: m + img_height + margin
            for j = m - margin + 1: m + img_width + margin
                img_block = padded_img(i - margin : i + margin, j - margin : j + margin);
                output_img(i, j) = reshape(filter, 1, []) * reshape(img_block, [], 1);
            end
        end
    
        % clip
        output_img = output_img(m + 1 : m + img_height, m + 1 : m + img_width);
    end
end
