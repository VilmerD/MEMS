function data = CCS(Motif, Image)
% Compute loss grid
CCGrid = ComputeCCGrid(Motif, Image);
cGrid = (size(CCGrid, 1) + 1) / 2;

[rbest, cbest, loss] = FindMaxArray(CCGrid);

% Return the data
data.dc = cbest - cGrid;
data.dr = rbest - cGrid;
data.loss = loss;
end

function [i, j, v] = FindMaxArray(ccvalues)
[v, I] = max(ccvalues, [], 'all');
[i, j] = ind2sub(size(ccvalues), I);
end