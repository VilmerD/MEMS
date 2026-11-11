% Measurements are in mm and seconds
L1 = 80.6;
L2 = 10.0;
W1 = 25.5;
W2 = 9.7;
t = 3.1;

height_after = 48.0;
total_displacement = 7.25;
height_before = height_after - total_displacement;

displacement_rate = 2; % mm / minute

%% Look at first image

% Get image files
fileform = "../experiment1/data/DIC-%04i_0.tif";
step_init = 288;
step_final = 359;
nfiles = step_final - step_init;
filenames = cell(nfiles, 1);
for i = 1:nfiles
    stepnbr = step_init + i - 1;
    filenames{i} = sprintf(fileform, stepnbr);
end

% Read first image
Img0 = importdata(filenames{1});

% Read image metadata
[ImgH, ImgW] = size(Img0);

% Select operating window
window_big.rows = [1240, 3550];
window_big.cols = [2600, 4040];

% Show first image
figure;
subplot(1, 2, 1);
imagesc(Img0);
title("First image");

Img0_sub = GetSubimage(Img0, window_big);
subplot(1, 2, 2);
imagesc(Img0_sub)
title("First image zoomed to fit specimen");

%% DO DIC
window.rows = [2150, 2350];
window.cols = [3450, 3650];

% Select convolution parameters
LS = 45;      % motif size
LG = 305;     % search window size

m = 1;
dm = 0;
PrevImage = importdata(filenames{m});
CurrImage = importdata(filenames{m+dm});

% Prepare output
dx = zeros(ImgH, ImgW);
dy = zeros(ImgH, ImgW);

% Prepare figure
doplotscan = 0;
doplotdiff = 1;
if (doplotscan)
    figScan = figure();
    
    axs(1) = subplot(3, 2, 1:4);
    imgs(1) = imagesc(axs(1), zeros(LG));
    hold(axs(1), 'on');
    clim(axs(1), [0, 255]);
    lines = plot(axs(1), [0, 1], [0, 1], 'r');
    title(axs(1), "Grid");
    
    axs(2) = subplot(3, 2, 5);
    imgs(2) = imagesc(axs(2), zeros(LS));
    hold(axs(2), 'on');
    clim(axs(2), [0, 255]);
    title(axs(2), "Stencil");
    
    axs(3) = subplot(3, 2, 6);
    imgs(3) = imagesc(axs(3), zeros(LS));
    hold(axs(3), 'on');
    clim(axs(3), [0, 255]);
    title(axs(3), "Best Fit");

    scanplots.axs = axs;
    scanplots.imgs = imgs;
    scanplots.lines = lines;
end

% Plot the row of new data after each row is done
if (doplotdiff)
    figdiff = figure();

    diffplots.ax_img0 = subplot(1, 3, 1);
    diffplots.img_img0 = imagesc(GetSubimage(CurrImage, window));
    hold(gca, 'on');
    title(gca, "Current Image");

    diffplots.ax_dx = subplot(1, 3, 2);
    diffplots.img_dx = imagesc(GetSubimage(dx, window));
    hold(gca, 'on');
    title(gca, "DX");

    diffplots.ax_dy = subplot(1, 3, 3);
    diffplots.img_dy = imagesc(GetSubimage(dy, window));
    hold(gca, 'on');
    title(gca, "DY");
    
end

DC = 1;
DR = 1;
% for each grid point on the operating window of the current image
for r = window.rows(1):DR:window.rows(2)
    fprintf("Row = %06d\n", r)

    for c = window.cols(1):DC:window.cols(2)
        % fprintf("%06d, ", c)
        % Extract stencil of surrounding points
        dr_stens = floor((LS - 1)/2);
        dc_stens = dr_stens;
        S = ExtractWindow(PrevImage, r-dr_stens, c - dc_stens, LS, LS);

        % Extract searching window
        dr_window = floor((LG - 1)/2);
        dc_window = dr_window;
        G = ExtractWindow(CurrImage, r-dr_window, c - dc_window, LG, LG);

        % Find best fit using normalized cross-correlation
        data = ImageInterpolatedCrossCorrelationSearch(S, G);

        % Returns displacement relative bottom corner of search window, 
        % which is centered around the search point
        dx(r:(r+DR-1), c:(c+DC-1)) = data.dc;
        dy(r:(r+DR-1), c:(c+DC-1)) = data.dr;

        % Plot scan
        if (doplotscan)
            plotWindows(scanplots.img, scanplots.lines, S, G, data)
            pause(1e-2);
        end
    end
    
    % Plot row results
    if (doplotdiff)
        diffplots.img_dx.CData = GetSubimage(dx, window);
        diffplots.img_dy.CData = GetSubimage(dy, window);
        drawnow;
        pause(1e-3);
    end
end

%% Plot the displacement fields


function G = ExtractWindow(F, i, j, Li, Lj)
    G = F(i:(i+Li-1), j:(j+Lj-1));
end

