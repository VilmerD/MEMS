%% Make some phony data
% Make the search window a circle within a bigger grid
grid_size = 0.1;
grid_points_x = 21;
grid_points_y = 21;
W = grid_size * grid_points_x;
H = grid_size * grid_points_y;
xx_search = linspace(0, W, grid_points_x);
yy_search = linspace(0, H, grid_points_y);

circle_x0 = W / 2.0;
circle_y0 = H / 3.0;
ra = grid_size * 2.5;
rb = grid_size * 2.0;
G = circle(circle_x0, circle_y0, ra, rb, xx_search, yy_search);

rand_size = 0.5;
G = G + rand(grid_points_y, grid_points_x) * rand_size;

% Make the stencil a subgrid of the entire grid
stencil_points = 7;
xx_stencil = linspace(circle_x0 - 1.2*ra, circle_x0 + 1.2*ra, stencil_points);
yy_stencil = linspace(circle_y0 - 1.3*rb, circle_y0 + 1.2*rb, stencil_points);

S = circle(circle_x0, circle_y0, ra, rb, xx_stencil, yy_stencil);

function F = circle(x0, y0, ra, rb, xx, yy)
[X, Y] = meshgrid(xx, yy);
F = tanh(((X - x0)/ra).^2 + ((Y - y0)/rb).^2 - 1);
end
