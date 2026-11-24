function data = ImageInterpolatedCCS(Motif, Image, subpixel)
% Searches for best fit of S on the subset image NextImage
% Motif             is the motif, must be smaller than NextImageSubset
% Search            is the subset of a following image
% Data              resulting column and row displacements

% Define displacement parameters
% q = dc, dr and measures the displacement from the image center to the

if nargin < 3 || subpixel.params == "disp"
    % interpolated window
    q0 = [0; 0];
    func = @(q)  (-1.0) * InterpolateCC(Motif, Image, q, subpixel.order);
    options = optimset("TolFun", 1e-9, "TolX", 1e-9, "FunValCheck", "on");

    % Maximize loss using fminsearch
    [qopt, loss, ~] = fminsearch(func, q0, options);

    % Return the displacement
    data.dr = qopt(1);
    data.dc = qopt(2);
    data.loss = loss * (-1.0);

elseif subpixel.params == "disp_stretch"
    % interpolated window
    q0 = [0; 0; 1; 1];
    options = optimset("TolFun", 1e-9, "TolX", 1e-9, "FunValCheck", "on");
    func = @(q)  (-1.0) * InterpolatedCCStretched(Motif, Image, q, subpixel.order);

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

function loss = InterpolateCC(M, H, q, interpord)
% Cut off q to be within boundary
q = reshape(q, [1, 2]);

% First interpolate image using the displacement parameters
G = InterpolateImage(H, M, q, interpord);

% Then compute the normalized cross-correlation
loss = ZNCC(M, G);
end

function loss = InterpolatedCCStretched(M, H, q, interpord)
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
loss = ZNCC(M, G);

% Add barrier cost for reaching boundaries
w = max(size(H))/2;
loss = loss - (1e-2)*sum(BoxBarrierLog(qbox, dmin(:), dmax(:), w(:)));
end