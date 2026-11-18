function data = LossInterpolatedCCS(Motif, Image)
% Compute loss grid
CCGrid = ComputeCCGrid(Motif, Image);
gridH = size(CCGrid, 1);
cGrid = (size(CCGrid, 1) + 1) / 2;

% Interpolate loss around the maximum
[SXI, SYI] = meshgrid(1:gridH, 1:gridH);
CCgridInterp = griddedInterpolant(SXI', SYI', CCGrid', 'spline');

% interpolants first coordinate is column
[~, idx] = max(CCGrid(:));
[row0, col0] = ind2sub(size(CCGrid), idx);
x0 = [col0, row0];          

lb = max([1, 1], x0 - 1);
ub = min([size(CCGrid, 2), size(CCGrid, 1)], x0 + 1);

obj = @(xy) -CCgridInterp(xy(1), xy(2));
opts = optimoptions("fmincon", ...
    "OptimalityTolerance", 1e-9, ...
    "StepTolerance", 1e-9, ...
    "Display", "none");
[d, fval] = fmincon(obj, x0, [], [], [], [], lb, ub, [], opts);
data.loss = -fval;

% Compute displacement
d0 = d - cGrid;

% Return the data
data.dc = d0(1);
data.dr = d0(2);
end