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
resize = 0;
GetDICFileInfo;

%% Read some metadata
Img0_tiff = Tiff(filenames{1}, 'r');
Imge_tiff = Tiff(filenames{end}, 'r');

% Time span of images
t0 = datetime(dir(Img0_tiff.FileName).date);
te = datetime(dir(Imge_tiff.FileName).date);
dT = seconds(te - t0);

% Read image size
[ImgH, ImgW] = size(read(Img0_tiff));

%% Get key frames
% Time values
key_frames = [28, 70, 82, 144, 202];

% Translate into frame numbers assuming that the image captures and force-displacement
% started at the same time
% and that at time = 0 the first image is taken
% such that we should round up
key_frames_id = ceil(key_frames / 3); 

%% DO DIC with image interpolation
% Select convolution parameters
paramsA.name = "parametersA";
paramsA.LS = 12;
paramsA.LG = 22;
paramsA.skip = 12;

paramsB.name = "parametersB";
paramsB.LS = 20;
paramsB.LG = 30;
paramsB.skip = 12;

paramsC.name = "parametersC";
paramsC.LS = 8;
paramsC.LG = 18;
paramsC.skip = 12;

allParams = {paramsA, paramsB, paramsC};

%% Do image interpolation dic
subpixel.mode = "interpolate_image";
subpixel.params = "disp";
subpixel.order = 3;

for params = allParams
    ProcessParameters(filenames, key_frames_id, window_small, pixel, resize, params{1}, "int_img", subpixel);
end

%% Do loss interpolation
subpixel.mode = "interpolate_loss";
subpixel.order = 3;

% Load images
for params = allParams
    ProcessParameters(filenames, key_frames_id, window_small, pixel, resize, params, "int_loss", subpixel);
end

%% 

function data = ProcessParameters(filenames, frames, window, pixel, resize, DICParams, outform, subpixel)
for frame = frames
    fprintf("Processing frame %i, %s\n", frame, outform);
    PrevImage = ReadDICFile(filenames{frame-1}, resize);
    CurrImage = ReadDICFile(filenames{frame}, resize);

    % Perform dic
    data = DIC(PrevImage, CurrImage, window, pixel, DICParams.LS, DICParams.LG, DICParams.skip, subpixel, 0);
    filename = fullfile("data", DICParams.name, sprintf("%s_%i.mat", outform, frame));
    save(filename, "DICParams", "data", "subpixel", "window");
end
end