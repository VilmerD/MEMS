%% Plot the width?
%% Get measurements
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

%% Get Files
resize = 0;
GetDICFileInfo;

%% Plot some rows
Img0_tiff = Tiff(filenames{1}, 'r');
img0 = read(Img0_tiff);
midrow = 2350;

figure();
ax = axes();
hold(ax, 'on');

w = zeros(size(img0, 1));

dmin = 20;
for k = 1:size(img0, 1)
    diff = conv2([-1, 0, 1], imgk);
    diff = diff(1000:end-1000);
    [id, c] = kmeans(reshape(abs(diff), [], 1), 2);
    c_outside = id(1);
    k1 = find(id ~= c_outside, 1, "first");
    k2 = find(id ~= c_outside, 1, "last");
    % plot([k1, k2], [k, k], "Marker", "o");
    w(k) = k2 - k1;
end

wmean = conv2(ones(1, 7), w);
plot(w);