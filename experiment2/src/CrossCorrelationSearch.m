function data = CrossCorrelationSearch(Motif, Image)
% Searches for best fit of S on the subset image NextImage
% Motif             is the motif, must be smaller than NextImageSubset
% Search            is the subset of a following image
% Data              resulting column and row displacements
[imgH, imgW] = size(Image);
[motH, motW] = size(Motif);

% Check that the size of the motif is at most 2^32-1
if (motH * motW >= 2^16 - 1) 
    error("Motif window must contain less than 2^16-1 entries!\n")
end

rMin = 1;
rMax = imgH - motH;
H = rMax - rMin + 1;

cMin = 1;
cMax = imgW - motW;
W = cMax - cMin + 1;

% Convolve over sub-window
Grid = ones(H, W);
for r = rMin:rMax
    for c = cMin:cMax
        % Extract grid to search within
        G = ExtractWindow(Image, r, c, motH, motW);

        % Compute correlation
        cc = CrossCorrelation(Motif, G);
        Grid(r, c) = cc;
    end
end

% Find best value
[rbest, cbest, ~] = FindMaxArray(Grid);
d = [cbest; rbest];

% Compute distance from center to rbest and cbest
motC = [(1 + motW)/2; (1 + motH)/2];
imgC = [(1 + imgW)/2; (1 + imgH)/2];
d0 = d + (motC - 1) - imgC;

% Return the displacement
data.dc = d0(1);
data.dr = d0(2);

end

% Assumes that F and G are uint 8.
% Then the largest any product can be is uint16, and so the largest the sum can be 
% assuming no more than 2^16-1 entries in total, is uint32.
function loss = CrossCorrelation(F, G)
    F_32 = uint32(F);
    G_32 = uint32(G);
    CC = sum(F_32.*G_32, 'all');
    NCC = sqrt(sum(F_32.*F_32, 'all')*sum(G_32.*G_32, 'all'));
    loss = CC / NCC;
end


function G = ExtractWindow(F, i, j, Li, Lj)
    G = F(i:(i+Li-1), j:(j+Lj-1));
end