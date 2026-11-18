fileform = "../experiment1/data/DIC-%04i_0.tif";
step_init = 288;
step_final = 359;
nfiles = step_final - step_init;
filenames = cell(nfiles, 1);
for i = 1:nfiles
    stepnbr = step_init + i - 1;
    filenames{i} = sprintf(fileform, stepnbr);
end

% Select operating window
window_big.rows = [1200, 3800];
window_big.cols = [2400, 4200];
% window_small.rows = [2140, 2660];
% window_small.cols = [2940, 3660];

window_small.rows = [2080, 2720];
window_small.cols = [2880, 3720];
if (resize)
    window_big.rows = window_big.rows/4;
    window_big.cols = window_big.cols/4;
    window_small.rows = window_small.rows/4;
    window_small.cols = window_small.cols/4;
end
window_big.H = window_big.rows(2) - window_big.rows(1);
window_big.W = window_big.cols(2) - window_big.cols(1);
window_small.H = window_small.rows(2) - window_small.rows(1);
window_small.W = window_small.cols(2) - window_small.cols(1);