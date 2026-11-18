function G = InterpolateImage2(H, M, disp, stretch)
dM = (reshape(size(M), [2, 1]) - 1) / 2;
centH = (reshape(size(H), [2, 1]) + 1) / 2;

% Compute pixel indices
idx_deformed = centH + disp + stretch.*(-dM(1):dM(1));

% Interpolate image at indices


end