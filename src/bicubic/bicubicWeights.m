function weights = bicubicWeights(dis)
%BICUBICWEIGHTS calculate the weights matrix given the distance

    dis = abs(dis);
    dis2 = dis .^ 2;
    dis3 = dis .^ 3;

    weights = (1.5 * dis3 - 2.5 * dis2 + 1) .* (dis <= 1) + ...
                (-0.5 * dis3 + 2.5 * dis2 - 4 * dis + 2) .* ((1 < dis) & (dis <= 2));
            
end

