function G = InterpolateImage(H, M, d)
dM = (reshape(size(M), [2, 1]) - 1) / 2;
centH = (reshape(size(H), [2, 1]) + 1) / 2;

% Compute nearest integer rounded down
q = floor(d);
s = d - q; 

% Compute rows and cols for upper corner
idx0 = (centH + q) - dM;
idxe = (centH + q) + dM;

rr = idx0(1):idxe(1);
cc = idx0(2):idxe(2);

% Compute interpolation functions
N11 = Lagrange2(s, [0, 0], [1, 1]);
H11 = H(rr, cc);

N12 = Lagrange2(s, [1, 0], [0, 1]);
H12 = H(rr+1, cc);

N21 = Lagrange2(s, [0, 1], [1, 0]);
H21 = H(rr, cc+1);

N22 = Lagrange2(s, [1, 1], [0, 0]);
H22 = H(rr+1, cc+1);

% Interpolate image
G = N11 * double(H11) + N12 * double(H12) + N21 * double(H21) + N22 * double(H22);
end

function l2 = Lagrange2(x, x0, x1)
l2 = (x(1) - x1(1)) / (x0(1) - x1(1)) * (x(2) - x1(2)) / (x0(2) - x1(2));
end