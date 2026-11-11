function [i, j, v] = FindMaxArray(ccvalues)
[H, W] = size(ccvalues);
[v, I] = max(ccvalues, [], 'all');
[i, j] = ind2sub([H, W], I);
end