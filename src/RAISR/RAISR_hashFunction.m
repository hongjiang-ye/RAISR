function idx = RAISR_hashFunction(patch, Q_angle, Q_strength, Q_coherence)
%RAISR_HASHFUNCTION compute the hash index of the patch. Q_angle, Q_strength and
%Q_coherence are quantization factor for them.

    [gx, gy] = gradient(patch);
    gx = gx(:);
    gy = gy(:);
    G = [gx, gy];

    GTG=G'*G;
    
    % if apply the gaussian weighting, the result is worse?
    % W = fspecial('gaussian', size(patch, 1), 2);
    % W = diag(W(:));
    % GTG=G'*W*G;

    [eig_vectors, eig_values] = eig(GTG);
    eig_values = diag(eig_values);
    
    % angle
    angle = atan2(eig_vectors(1, 1), eig_vectors(2, 1));
    if (angle < 0)
        angle = angle + pi;
    end
    
    % strength
    strength = max(eig_values) / (sum(eig_values) + eps);
    
    % coherence
    lambda1 = sqrt(max(eig_values));
    lambda2 = sqrt(min(eig_values));
    coherence = abs((lambda1 - lambda2) / (lambda1 + lambda2 + eps));
    
    % quantization
    angle = floor(angle / ((pi + eps) / Q_angle));  % 0-23
    strength = floor(strength / (1 / Q_strength));  % 0-2
    coherence = floor(coherence / (1 / Q_coherence));  % 0-2

    % bound the result
    if (angle >= 24)
        angle = 23;
    end
    if (strength >= 3)
        strength = 2;
    end
    if (coherence >= 3)
        coherence = 2;
    end
    
    idx = angle * (Q_strength * Q_coherence) + strength * Q_coherence + coherence + 1;
    
end