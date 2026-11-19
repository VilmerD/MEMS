% Measurements are in mm and seconds
clearvars;
L1 = 80.6;
L2 = 10.0;
W1 = 25.5;
W2 = 9.7;
t = 3.1;

height_after = 48.0;
total_displacement = 7.25;
height_before = height_after - total_displacement;

displacement_rate = 2; % mm / minute

%% Compute the relationship between pixel and length by using measured distances
pix_y0 = 860; pix_ye = 1418;
pix_dy = pix_ye - pix_y0;
pixel.h = L2 * 1e-3 / pix_dy * (-1.0);

pix_x0 = 453; pix_xe = 965;
pix_dx = pix_xe - pix_x0;
pixel.w = W2 * 1e-3 / pix_dx;

%% Get Files
resize = 1;
GetDICFileInfo;

% Read first image
Img0 = ReadDICFile(filenames{1}, resize);

% Read image metadata
[ImgH, ImgW] = size(Img0);

%% DO DIC with image interpolation
% Select convolution parameters
LS = 11;      % motif size
LG = 23;      % search window size
skip = 3;

% Load images
m = 22;
dm = 2;
PrevImage = ReadDICFile(filenames{m}, resize);
CurrImage = ReadDICFile(filenames{m+dm}, resize);

% Perform dic
subpixel_mode = "interpolate_image";
data = DIC(PrevImage, CurrImage, window_small, pixel, LS, LG, skip, subpixel_mode, 1);
plots = PlotDICResults(CurrImage, PrevImage, window_small, data, 2e-2, "jet");

%% DO with loss interpolation
% Select convolution parameters
LS = 6;      % motif size
LG = 13;      % search window size
skip = 6;

% Load images
m = 23;
dm = 1;
PrevImage = ReadDICFile(filenames{m}, resize);
CurrImage = ReadDICFile(filenames{m+dm}, resize);

% Perform dic
subpixel_mode = "interpolate_loss";
data = DIC(PrevImage, CurrImage, window_big, pixel, LS, LG, skip, subpixel_mode, 1);
plots = PlotDICResults(CurrImage, PrevImage, window_big, data, 2e-2, "jet");

%% Plot the displacement fields