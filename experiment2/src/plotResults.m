% visualize_int_img_xx.m
% Get filenames
key_frames_id = [10, 24, 28, 48, 68];
nframes = numel(key_frames_id);
epsmin_perc = 4;
lossmin_rad = pi/4;

form = "int_img";
params = "parametersB";
titles = 'ABCDEFG';

domask = 1;
nclusters = 2;

fig = figure("Color", "w");
theme(fig, "light");
t = tiledlayout(4, nframes + 1, ...
    'Padding', 'tight', ...
    'TileSpacing', 'none');

for i = 1:numel(key_frames_id)
    frame = key_frames_id(i);

    fileName = fullfile('data', params, sprintf("%s_%i.mat", form, frame));
    S = load(fileName).data;

    [e1, e2, th] = Principle(S.exx, S.eyy, S.exy);
    S.e1 = e1;
    S.e2 = e2;
    S.th = th;
    
    % Handle either:
    % 1) fields stored directly in the MAT-file, or
    % 2) one struct variable inside the MAT-file
    if isfield(S, 'exx') && isfield(S, 'eyy') && isfield(S, 'loss')
        data = S;
    else
        fn = fieldnames(S);
        if isscalar(fn) && isstruct(S.(fn{1}))
            data = S.(fn{1});
        else
            error('Could not find exx, eyy, and loss in %s.', fileName);
        end
    end
    
    fields = {'e1', 'e2', 'th', 'loss'};
    fields_names = {"$\Delta \epsilon_{1}$ [\%]", "$\Delta \epsilon_{2}$ [\%]", "$\varphi [rad]$", "$loss$ [rad]"};
    
    if (domask)
        size_img = size(S.exx);

        [id, c] = kmeans([S.loss(:)], nclusters);
        
        ID = reshape(id, size_img);

        rvoid = round(size_img(1)/2);
        cvoid = 1;

        % We know that the middle of column 1 is just void so use
        % it as reference
        mask = (ID == ID(rvoid, cvoid));
    end

    for k = 1:numel(fields)
        nexttile(t, i + (nframes + 1) * (k - 1));

        % Get data and scale/map
        if (k == 1 || k == 2)
            field_data = data.(fields{k})*100;
        elseif (k == 3)
            field_data = data.(fields{k});
        else
            field_data = acos(data.(fields{k}));
        end
    
        % Mask out bad values
        bad = ~isfinite(field_data);
        if domask
            bad = bad | mask;
        end
        
        field_data(bad) = 0;   % placeholder value
        h = imagesc(field_data);
        h.AlphaData = ~bad;
        
        % Fix axis to look nice
        axis("tight")
        xticks({});
        yticks({});
        
        % Set title if at top
        if (k == 1)
            title(titles(i));
        end

        % Colormap and limits
        if (k == 1 || k == 2)
            clim([-1, 1]*epsmin_perc)
            colormap(gca, "parula");
        elseif (k == 3) 
            clim([0, pi]);
            colormap(gca, "copper");
        else
            clim([0, lossmin_rad]);
            colormap(gca, "copper");
        end
    
        % Set colorbar if to the very right
        if (i == nframes) 
            cbar = colorbar("eastoutside");
            cbar.Label.String = fields_names{k};
            cbar.Label.Interpreter = "latex";

            pos = cbar.Position;
            pos(4) = 0.8 * pos(4);              
            pos(2) = pos(2) + 0.5 * (cbar.Position(4) - pos(4));
            cbar.Position = pos;
        end
    end
end

% Save figure
% Fix aspect
% I want the width to be 20 cm, so the height must be 20cm * (rows*imgW/cols*imgH) to match
width = 20;
height = 20 * ((3 * size_img(1)) / ((nframes) * size_img(2)));

set(fig, "Units", "centimeters");
set(fig, "Position", [0, 0, width, height]);
filename = fullfile("results", sprintf("%s_grid.png", form));
exportgraphics(fig, filename, "Resolution", 300);
close(fig);