%% Make some phony data
% Make the search window a square within a bigger grid
function [S, G] = GenerateSquare(stencil_dr, stencil_dc)
grid_size = 0.1;
grid_points_x = 21;
grid_points_y = 21;
W = grid_size * grid_points_x;
H = grid_size * grid_points_y;
xx_search = linspace(0, W, grid_points_x);
yy_search = linspace(0, H, grid_points_y);

square_x = W / 2.0;
square_y = H / 2.0;
square_w = grid_size * 2.5;
square_h = grid_size * 2.5;
G = square(square_x, square_y, square_w, square_h, xx_search, yy_search);

% Make the stencil a subgrid of the entire grid
stencil_points = 7;
stencil_W = stencil_points * grid_size;
stencil_H = stencil_W;
stencil_xc = W / 2.0 + stencil_dc * grid_size;
stencil_yc = H / 2.0 + stencil_dr * grid_size;
stencil_xx = linspace(stencil_xc - stencil_W/2, stencil_xc + stencil_W/2, stencil_points);
stencil_yy = linspace(stencil_yc - stencil_H/2, stencil_yc + stencil_H/2, stencil_points);

S = square(square_x, square_y, square_w, square_h, stencil_xx, stencil_yy);

end

function F = square(x0, y0, w, h, xx, yy)
[X, Y] = meshgrid(xx, yy);
F =  (abs(X - x0) <= w).*(abs(Y - y0) <= h);
end
