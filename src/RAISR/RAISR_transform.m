function transformed_patch = RAISR_transform(patch, type)
%RAISR_TRANSFORM rotate or filp the patch
    
    width = size(patch, 1);
    x = (1 : width);
    y = x;
    
    if (type == 1)  % filp up down
        transformed_patch = patch(width - x + 1, y);
    elseif (type == 2)  % rotate 90 degree
        patch = patch';
        transformed_patch = patch(width - x + 1, y);
    elseif (type == 3)  % filp center
        transformed_patch = patch';
    end
    
end

