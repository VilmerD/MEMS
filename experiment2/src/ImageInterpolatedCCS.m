function data = ImageInterpolatedCCS(Motif, Image, mode)
% Searches for best fit of S on the subset image NextImage
% Motif             is the motif, must be smaller than NextImageSubset
% Search            is the subset of a following image
% Data              resulting column and row displacements

% Define displacement parameters
% q = dc, dr and measures the displacement from the image center to the

if nargin < 3 || mode == "disp"
    % interpolated window
    q0 = [0; 0];
    interpord = 3;
    func = @(q)  (-1.0) * InterpolatedNCC(Motif, Image, q, interpord);
    options = optimset("TolFun", 1e-9, "TolX", 1e-9, "FunValCheck", "on");

    % Maximize loss using fminsearch
    [qopt, loss, ~] = fminsearch(func, q0, options);

    % Return the displacement
    data.dr = qopt(1);
    data.dc = qopt(2);
    data.loss = loss * (-1.0);

elseif mode == "disp_stretch"
    % interpolated window
    q0 = [0; 0; 1; 1];
    options = optimset("TolFun", 1e-9, "TolX", 1e-9, "FunValCheck", "on");
    interpord = 3;
    func = @(q)  (-1.0) * InterpolatedNCCStretched(Motif, Image, q, interpord);

    % Maximize loss using fminsearch
    [qopt, loss, ~] = fminsearch(@(q)  func, q0, options);

    % Return the displacement
    data.dr = qopt(1);
    data.dc = qopt(2);

    % And stretch
    data.sr = qopt(3);
    data.sc = qopt(4);

    % And loss
    data.loss = loss * (-1.0);
end
end

function loss = InterpolatedNCC(M, H, q, interpord)
% Cut off q to be within boundary
q = reshape(q, [1, 2]);
% dM = (size(M) - 1) / 2;
% centH = (size(H) + 1) / 2;
% dmin = -centH + dM + 2;
% dmax = centH - dM - 3;
% qbox = min(dmax, max(q, dmin));
qbox = q;

% if (sum(q < dmin) > 0 || sum(q > dmax) > 0)
%     loss = inf;
%     return
% end

% First interpolate image using the displacement parameters
G = InterpolateImage(H, M, qbox, interpord);

% Then compute the normalized cross-correlation
loss = NormalizedCrossCorrelation(M, G);

% Add barrier cost for reaching boundaries
% w = max(size(H))/2;
% loss = loss - (1e-1)*sum(BoxBarrierLog(qbox, -centH, centH, centH));
end

function loss = InterpolatedNCCStretched(M, H, q, interpord)
% Cut off q to be within boundary
dM = (size(M) - 1) / 2;
centH = (size(H) + 1) / 2;
dmin = -centH + dM;
dmax = centH - dM - 3;

disp = q(1:2);
stretch = q(3:4);
qbox = min(dmax(:), max(disp, dmin(:)));

% First interpolate image using the displacement parameters
G = InterpolateImage2(H, M, qbox, stretch);

% Then compute the normalized cross-correlation
loss = NormalizedCrossCorrelation(M, G);

% Add barrier cost for reaching boundaries
w = max(size(H))/2;
loss = loss - (1e-2)*sum(BoxBarrierLog(qbox, dmin(:), dmax(:), w(:)));
end

% Computes a two-sided barrier loss, such that
% loss -> inf as x-> x0+ and
% loss -> inf as x-> xe-
function loss = BoxBarrierLog(x, x0, xe, w)
dx0 = abs(x - (x0-1));
dxe = abs((xe+1) - x);
loss = log(dx0./w).^2 + log(dxe./w).^2;
end

% Computes a two-sided barrier loss, such that
% loss -> inf as x-> x0+ and
% loss -> inf as x-> xe-
function loss = BoxBarrierExp(x, x0, xe, w)
dx0 = abs(x - (x0-1));
dxe = abs((xe+1) - x);
loss = exp(dx0./w).^2 + exp(dxe./w).^2;
end

% G is double, so just cast F to double as well
function loss = NormalizedCrossCorrelation(F, G)
CC = sum(F.*G, 'all');
NCC = sqrt(sum(F.*F, 'all') * sum(G.*G, 'all'));
if (NCC == 0)
    loss = inf;
else
    loss = CC / NCC;
end
end