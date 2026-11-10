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

displacement_rate = 2; % mm / minute

A0 = W2*t * 1e-6;

%% Plot force-displacement
data = importdata("data/force.txt");

% load time and shift back so that it starts at 0
time = data.data(:, 1) / 1e3;   
time = time - time(1);          % shift to 0
time_minutes = time / 60;
displacement = time_minutes * displacement_rate;

% fix force so that it's zero at the end
force = data.data(:, 2);        % N
force = force - force(end);

fig = figure();
ax = axes(fig);

plot(displacement, force, ...
     'LineWidth', 2);
hold(ax, 'on');

xlabel(ax, "Displacement [mm]");
ylabel(ax, "Force [N]");
title(ax, "Force - Displacement curve for Polycarbonate sample")

% Draw lines at zero force and at final "zero"
f1 = force(1);
tt = [displacement(1), displacement(end)];
ff = [f1, f1];
plot(tt, ff, 'Color', '#080808', 'LineStyle', '--');

fe = force(end);
tt = [displacement(1), displacement(end)];
ff = [fe, fe];
plot(tt, ff, 'Color', '#080808', 'LineStyle', '--');

% Make annotation about discrepancy
delta_f = abs(fe - f1);
tmid = (displacement(end) + displacement(1)) / 2;
fmid = (fe);
text(ax, tmid, fmid, ...
    sprintf('$ |\\Delta F| \\approx %.2f N$', delta_f), ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'Interpreter', 'latex');

% Save figure to file
set(fig, 'Units', 'centimeters');
set(fig, "Position", [0, 0, 14, 10]);

theme(fig, "light")
saveas(fig, "results/force_displacement.png")
close(fig)

% Output data
fprintf("\n")
fprintf("Load\n")
fprintf("Maximum load:      %2.3f\n", max(force));
fprintf("Load at failure:   %2.3f\n", force(332))

fprintf("\n")
fprintf("Stress[kPa]\n")
fprintf("Maximum stress:      %2.3f\n", max(force)/A0*1e-3);
fprintf("Stress at failure:   %2.3f\n", force(332)/A0*1e-3)
