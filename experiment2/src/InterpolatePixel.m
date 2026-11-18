function G = InterpolatePixel(H, r, c)
% Interpolates the image H at the row and columns c, which may be real values
if (r < 1 || r > size(H, 1))
    G = 0;
    fprintf("row %d out of bounds for array H with size %d, %d", r, size(H, 1), size(H, 2));
    return
elseif (c < 1 || c > size(H, 2))
    G = 0;
    fprintf("col %d out of bounds for array H with size %d, %d", c, size(H, 1), size(H, 2));
    return
end

% Compute nearest integer rows and columns (rounding down)
idx = [r, c];
idxNearest = floor(idx);

% Intepolate using lagrange polynomials
N11 = LagrangePolynomial(idx, idxNearest+[0, 0], idxNearest+[1, 1]);
G = N11 * H(idxNearest(1)+0, idxNearest(2)+0);

N12 = LagrangePolynomial(idx, idxNearest+[0, 1], idxNearest+[1, 0]);
G = G + N12 * H(idxNearest(1)+0, idxNearest(2)+1);

N21 = LagrangePolynomial(idx, idxNearest+[1, 0], idxNearest+[0, 1]);
G = G + N21 * H(idxNearest(1)+1, idxNearest(2)+0);

N22 = LagrangePolynomial(idx, idxNearest+[1, 1], idxNearest+[0, 0]);
G = G + N22 * H(idxNearest(1)+1, idxNearest(2)+1);

end

function l = LagrangePolynomial(x, x0, x1)
l = prod((x - x1) ./ (x0 - x1), 2);
end