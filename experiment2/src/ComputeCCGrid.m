function CCVals = ComputeCCGrid(Motif, Image)
% Searches for best fit of S on the subset image NextImage
% Motif             is the motif, must be smaller than NextImageSubset
% Search            is the subset of a following image
% Data              resulting column and row displacements
motH = size(Motif, 1);
imgH = size(Image, 1);

dM = (motH - 1) / 2;

imgRMin = dM + 1;
imgRMax = imgH - dM;

gridH = imgRMax - imgRMin + 1;

% Convolve over sub-window
CCVals = ones(gridH, gridH);
for r = imgRMin:imgRMax
    rout = r - imgRMin + 1;
    for c = imgRMin:imgRMax
        cout = c - imgRMin + 1;

        % Extract window centered around r and c
        G = ExtractWindow(Image, r, c, dM);

        % Compute correlation
        CCVals(rout, cout) = CrossCorrelation(Motif, G);
    end
end

end

function loss = CrossCorrelation(F, G)
CC = sum(F.*G, 'all');
NCC = sqrt(sum(F.*F, 'all')*sum(G.*G, 'all'));
loss = CC / NCC;
end

function G = ExtractWindow(F, i, j, L)
G = F(i + (-L:L), j + (-L:L));
end