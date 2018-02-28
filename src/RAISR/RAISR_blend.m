function blend_result = RAISR_blend(bicubic_HR, RAISR_HR, CT_width)
%RAISR_BLEND blend the bicubic result and RAISR result with weights
%computed by Census Transform.

    bicubic_HR = double(bicubic_HR);
    RAISR_HR = double(RAISR_HR);

    half_CT_width = floor(CT_width / 2);
    [height, width] = size(bicubic_HR);
    
    weights = zeros(height, width);
    for i = 1 + half_CT_width : height - half_CT_width
        for j = 1 + half_CT_width : width - half_CT_width
            patch_x = bicubic_HR(i - 1 : i + 1, j - 1 : j + 1);
            CT_x = RAISR_CT(patch_x);
            
            % larger the change in structure, larger the weight
            weights(i, j) = sum(CT_x(:));
        end
    end
    
    weights = weights / (CT_width ^ 2 - 1) / 2 + 0.5;  % wights in [0.5, 1]

    % larger the change in structure, larger the weights of RAISR
    blend_result = weights .* RAISR_HR + (1 - weights) .* bicubic_HR;
            
end

