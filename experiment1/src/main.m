%% Polycarbonate
% Measurements are in mm and seconds
L1 = 80.6;
L2 = 10.0;
W1 = 25.5;
W2 = 9.7;
t = 3.1;

height_after = 48.0;
total_displacement = 7.25;
height_before = height_after - total_displacement;

displacement_rate = 2/60;

%% Plot force-displacement
data = importdata("data/force.txt");

% load time and shift back so that it starts at 0
time = data.data(:, 1) / 1e-3;  % time is in seconds
time = time - time(1);          % shift to 0
displacement = time * displacement_rate;

force = data.data(:, 2);        % N

fig = figure();
ax = axes(fig);

plot(displacement, force);

xlabel(ax, "Displacement");
ylabel(ax, "Force");
title(ax, "Force - Displacement curve for Polycarbonate sample")

set(fig, 'Units', 'centimeters');
set(fig, "Position", [0, 0, 14, 10]);

theme(fig, "light")
saveas(fig, "results/force_displacement.png")
close(fig)