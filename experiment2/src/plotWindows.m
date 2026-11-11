function plotWindows(imgs, lines, M, H, data)
% Update motif and window
imgs(1).CData = H;
imgs(2).CData = M;

% Interpolate best fit from data
d = [data.dr, data.dc];
imgs(3).CData = InterpolateImage(H, size(M), d);

% Draw rectangle on-top of search window G
midM = (size(M) - 1) / 2;
centH = (size(H) + 1) / 2;
idx0 = centH + d - midM; 
idxe = centH + d + midM;
DrawRectangle(lines, idx0, idxe);
end

function lines = DrawRectangle(lines, idx0, idxe)
r0 = idx0(1) - 0.5;
re = idxe(1) + 0.5;
c0 = idx0(2) - 0.5;
ce = idxe(2) + 0.5;
lines.XData = [c0, ce, ce, c0, c0];
lines.YData = [r0, r0, re, re, r0];
end