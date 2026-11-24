function G = InterpolateImage(H, M, d, interpord)
dM = (size(M, 1) - 1) / 2;
centH = (size(H, 1) + 1) / 2;

% Compute nearest integer rounded down
q = floor(d);
s = reshape(d - q, [1, 2]);

% Compute rows and cols for upper corner
idx0 = (centH + q) - dM;
idxe = (centH + q) + dM;

if (sum(idx0 - 1 < 1) > 0 || sum(idxe + 2 > size(H, 1)) > 0)
    G = zeros(size(M));
    return;
end

rr = idx0(1):idxe(1);
cc = idx0(2):idxe(2);

if interpord == 1
    Nr(1) = LagrangePolynomial(s(1), 0, 1);
    Nr(2) = LagrangePolynomial(s(1), 1, 0);
    Nc(1) = LagrangePolynomial(s(2), 0, 1);
    Nc(2) = LagrangePolynomial(s(2), 1, 0);
    G = zeros(size(M));
    for i = 0:1
        for j = 0:1
            G = G + Nr(i+1)*Nc(j+1) * H(rr+i, cc+j);
        end
    end
elseif interpord == 2
    Nr(1) = LagrangePolynomial(s(1), -1,  [0,  1]);
    Nr(2) = LagrangePolynomial(s(1),  0,  [1, -1]);
    Nr(3) = LagrangePolynomial(s(1),  1, [-1,  0]);
    Nc(1) = LagrangePolynomial(s(2), -1,  [0,  1]);
    Nc(2) = LagrangePolynomial(s(2),  0,  [1, -1]);
    Nc(3) = LagrangePolynomial(s(2),  1, [-1,  0]);

    % Compute interpolation functions
    G = zeros(size(M));
    for i = -1:1
        for j = -1:1
            G = G + Nr(i+2)*Nc(j+2) * H(rr+i, cc+j);
        end
    end
elseif interpord == 3
    Nr(1) = LagrangePolynomial(s(1), -1,  [ 0, 1, 2]);
    Nr(2) = LagrangePolynomial(s(1),  0,  [-1, 1, 2]);
    Nr(3) = LagrangePolynomial(s(1),  1,  [-1, 0, 2]);
    Nr(4) = LagrangePolynomial(s(1),  2,  [-1, 0, 1]);
    Nc(1) = LagrangePolynomial(s(2), -1,  [ 0, 1, 2]);
    Nc(2) = LagrangePolynomial(s(2),  0,  [-1, 1, 2]);
    Nc(3) = LagrangePolynomial(s(2),  1,  [-1, 0, 2]);
    Nc(4) = LagrangePolynomial(s(2),  2,  [-1, 0, 1]);

    % Compute interpolation functions
    G = zeros(size(M));
    for i = -1:2
        for j = -1:2
            G = G + Nr(i+2)*Nc(j+2) * H(rr+i, cc+j);
        end
    end
end
end

function l = LagrangePolynomial(x, x0, x1)
l = prod((x' - x1) ./ (x0' - x1), 2);
end