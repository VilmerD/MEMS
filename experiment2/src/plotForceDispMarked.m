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

%% Plot
figure();
theme(gcf, "light");
labels = 'ABCDEFG';

% Plot force over time
plot(times, force, 'k--', 'Marker', '^', 'Markersize', 2, "Displayname", "Measured Data");
xlabel("Time [s]");
ylabel("Force [N]");
grid("on");

% Mark times in which snapshots are taken
key_frames_id = [10, 24, 28, 48, 68];
key_frames_time = [];
for frame = key_frames_id
    time = datetime(dir(filenames{frame}).date);
    frame_dur = time - t0;
    key_frames_time = [key_frames_time, seconds(frame_dur)];
end

hold(gca, "on");
force_interp = interp1(times, force, key_frames_time);
plot(key_frames_time, force_interp, 'ro', "Displayname", "Key Frames");

for i = 1:numel(key_frames_time)
    x = key_frames_time(i);
    y = force_interp(i) - 150;
    text(gca, x, y, labels(i), "color", "red", "FontSize", 12)
end

legend("Location", "best");

%% Save figure
set(gcf, "Units", "centimeters");
set(gcf, "Position", [0, 0, 10, 8]);
filename = fullfile("results", "force_disp.png");
exportgraphics(gcf, filename, "Resolution", 300);
close(fig);

