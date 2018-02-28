function output = interplotAlongDim(input, in_length, out_length)
%INTERPLOTALONGDIM perform bicubic interpolation along the column
    
    scale = out_length / in_length;
    
    % Calculate the index in the input column
    u = (1 : out_length)' / scale + 0.5 * (1 - 1 / scale);
    
    % Left-most pixel that involve in the computation
    left = floor(u - 1);
    
    % The indices of the input pixels involved in computing
    indices = bsxfun(@plus, left, 0 : 3);
    
    dist = bsxfun(@minus, u, indices);
    
    % The weights used to compute the k-th output pixel are in row k of the weights matrix.
    weights = bicubicWeights(dist);
    
    % Mirror out-of-bounds indices, equivalent of doing symmetric padding
    aux = [1 : in_length, in_length : -1 : 1];
    indices = aux(mod(indices - 1, length(aux)) + 1);
    
    % Calculate the output pixels
    output = sum(input(indices) .* weights, 2);

end

