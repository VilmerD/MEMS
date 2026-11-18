function G = InterpolatePixels(H, idx)
% This function is really slow
G = zeros(size(idx, 2));
for rr = 1:size(idx, 2)
    r = idx(1, rr);
    for cc = 1:size(idx, 2)
        c = idx(2, cc);
        G(rr, cc) = InterpolatePixel(H, r, c);
    end
end
end