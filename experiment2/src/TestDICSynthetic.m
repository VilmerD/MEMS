%% Test dic on constructed data
% 1. Make fake data
% 2. Shift frame
% 3. Apply dic
% 4. Check result

%% Make fake data
% Define image size
imgSize = [256, 512];
% Define number of spots
Img = zeros(imgSize, 'uint8');
Img = uint8(rand(imgSize) * (6));

% Add synthetic Gaussian spots to the image
[xGrid, yGrid] = meshgrid(1:imgSize(2), 1:imgSize(1));
nSpots = 800;
for spot = 1:nSpots
    spotX = randi([1, imgSize(2)]);
    spotY = randi([1, imgSize(1)]);
    spotW = randi([1, 3]);
    Img = Img + uint8(255 * exp(-((xGrid - spotX).^2 + (yGrid - spotY).^2) / (2 * spotW)));
end

% imagesc(Img);

%% Shift frame
shift = 2;
shiftdim = 1;
ImgCurr = Img;
ImgPrev = circshift(Img,shift,shiftdim);

% subplot(1, 2, 1);
% imagesc(ImgPrev_dic);
% 
% subplot(1, 2, 2);
% imagesc(ImgCurr_dic);

%% Do DIC
window_shift = 60;
window.rows = [1+window_shift, size(ImgCurr_dic, 1)-window_shift];
window.cols = [1+window_shift, size(ImgCurr_dic, 2)-window_shift];
pixel.w = 1;
pixel.h = 1;

LS = 20;
LG = 40;
skip = 4;
subpixel_mode = "interpolate_loss";
data = DIC(im2double(ImgPrev), im2double(ImgCurr), window, pixel, LS, LG, skip, subpixel_mode, 1);