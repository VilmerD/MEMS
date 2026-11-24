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
window_big.rows = [1240, 3760];
window_big.cols = [2440, 4160];
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

% Read force-displacement data
force_data = importdata("../experiment1/data/force.txt");
times = force_data.data(:, 1) * 1e-3;
times = times - times(1);

force_scaling = 26.07;
force = force_data.data(:, 2);        % N
force = force - force(end);
force = force * force_scaling;

sample_rate_force = mean(times(2:end) - times(1:end-1));