% Get image files
fileform = "data/DIC-%04i_0.tif";
step_init = 288;
step_final = 359;
nfiles = step_final - step_init;
filenames = cell(nfiles, 1);
for i = 1:nfiles
    stepnbr = step_init + i - 1;
    filenames{i} = sprintf(fileform, stepnbr);
end

% Read images

% Read image metadata

% Prepare output

% Select operating window
window = [2300, 3100, 2400, 3200];
d = importdata(filenames{1});
image(d(window(1):window(3), window(2):window(4)));

% Select convolution parameters
LS = 6;      % stencil size
LG = 20;     % padding size

m = 10;
CurrImage = importdata(filenames{m});
NextImage = importdata(filenames{m+10});

dx = [];
dy = [];

fig = figure();
ax1 = subplot(1, 3, 1);
ax2 = subplot(1, 3, 2);
ax3 = subplot(1, 3, 3);


% for each grid point on the operating window
for i = window(1):window(3)
    fprintf("Row = %+6i\n", i)
    for j = window(2):window(4)
        % Extract stencil to search for
        S = ExtractWindow(CurrImage, i, j, LS);
        image(ax1, S);

        % Convolve over sub-window
        ccgrid = ones(2*LG+1);
        for gi = (i-LG):(i+LG)
            for gj = (j-LG):(j+LG)
                % Extract grid to search within
                G = ExtractWindow(NextImage, gi, gj, LS);

                % Compute correlation
                cc = CrossCorrelation(double(S)/255.0, double(G)/255.0);
                ccgrid(gi-(i-LG)+1, gj-(j-LG)+1) = cc;

                image(ax2, G);
                image(ax3, ccgrid);
                clim(ax3, [0.990,1]);
                pause(1e-2);
            end
        end
        
        % Find best value
        [di, dj] = findBest(ccgrid);
        di = di - (LG - 1);
        dj = dj - (LG - 1);

        % Insert values
        i0 = i-window(1)+1;
        j0 = j-window(2)+1;
        dx(i0, j0) = di;
        dy(i0, j0) = dj;
    end
end

% Extracts a window of F centered around i, j, with size (2K+1)x(2K+1)
function G = ExtractWindow(F, i, j, K)
    x0 = i - K; xe = i + K;
    y0 = j - K; ye = j + K;
    G = F(x0:xe, y0:ye);
end

function loss = CrossCorrelation(F, G)
    loss = sum(F.*G, 'all')/sqrt(sum(F.*F, 'all')*sum(G.*G, 'all'));
end

function [i, j] = findBest(ccvalues)
vmax = max(ccvalues, [], 'all');
[i, j] = find(ccvalues == vmax);
i = i(1);
j = j(1);
end