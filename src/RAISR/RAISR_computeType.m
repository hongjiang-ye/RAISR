function type = RAISR_computeType(x, y, scale)
%RAISR_COMPUTETYPE compute the pixel type in the interploted image

    type = mod(x, scale) * scale + mod(y, scale) + 1;
    
end

