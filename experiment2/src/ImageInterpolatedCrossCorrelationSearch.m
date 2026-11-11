function data = ImageInterpolatedCrossCorrelationSearch(Motif, Image)
% Searches for best fit of S on the subset image NextImage
% Motif             is the motif, must be smaller than NextImageSubset
% Search            is the subset of a following image
% Data              resulting column and row displacements

% Define displacement parameters
% q = dc, dr and measures the displacement from the image center to the
% interpolated window
q0 = [0; 0];

% Maximize loss using fminsearch
qopt = fminsearch(@(q)  (-1.0) * InterpolatedNCC(Motif, Image, q), q0);

% Return the displacement
data.dc = qopt(2);
data.dr = qopt(1);

end


function loss = InterpolatedNCC(M, H, q)
% Cut off q to be within boundary
dM = (size(M) - 1) / 2;
centH = (size(H) + 1) / 2;
dmin = -centH + dM + 1;
dmax = centH - dM - 3;
qbox = min(dmax(:), max(q, dmin(:)));

% First interpolate image using the displacement parameters
G = InterpolateImage(H, M, qbox);

% Then compute the normalized cross-correlation
loss = NormalizedCrossCorrelation(M, G);

% Add barrier cost for reaching boundaries
w = max(size(H))/2;
loss = loss + 1e-1*sum(BoxBarrierLog(qbox, dmin(:), dmax(:), w(:)));
end

% Computes a two-sided barrier loss, such that 
% loss -> inf as x-> x0+ and 
% loss -> inf as x-> xe- 
function loss = BoxBarrierLog(x, x0, xe, w)
dx0 = abs(x - (x0-1));
dxe = abs((xe+1) - x);
loss = log(dx0./w).^2 + log(dxe./w).^2;
end

% G is double, so just cast F to double as well
function loss = NormalizedCrossCorrelation(F, G)
F_DBL = double(F);
G_DBL = double(G);
CC = sum(F_DBL.*G_DBL, 'all');
NCC = sqrt(sum(F_DBL.*F_DBL, 'all')*sum(G_DBL.*G_DBL, 'all'));
loss = CC / NCC;

end