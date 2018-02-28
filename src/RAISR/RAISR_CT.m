function CT = RAISR_CT(patch)
%RAISR_CT compute the CT descriptor

    width = size(patch, 1);
    half_width = floor(width / 2);
    center = patch(1 + half_width, 1 + half_width);
    CT = (patch > center);
    
end

