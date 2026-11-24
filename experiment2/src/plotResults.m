% visualize_int_img_xx.m
% Get filenames
key_frames_id = [10, 24, 28, 48, 68];
nframes = numel(key_frames_id);
epsmin_perc = 4;
lossmin_deg = 30;

form = "int_img";
params = "parametersB";
titles = 'ABCDEFG';

domask = 1;

fig = figure("Color", "w");
theme(fig, "light");
t = tiledlayout(3, nframes + 1, ...
    'Padding', 'tight', ...
    'TileSpacing', 'none');

for i = 1:numel(key_frames_id)
    frame = key_frames_id(i);

    fileName = fullfile('data', params, sprintf("%s_%i.mat", form, frame));
    S = load(fileName).data;
    
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
    
    fields = {'exx', 'eyy', 'loss'};
    fields_names = {"$\Delta \epsilon_{xx}$ [\%]", "$\Delta \epsilon_{yy}$ [\%]", "$loss$ [deg]"};
    
    if (domask)
        size_img = size(S.exx);
        if (form == "int_loss")
            NCLUST = 2;
            [id, c] = kmeans([S.loss(:)], NCLUST);
        else
            NCLUST = 2;
            [id, c] = kmeans([S.exx(:), S.eyy(:), S.loss(:)], NCLUST);
        end
        ID = reshape(id, size(S.exx));

        rvoid = round(size_img(1)/2);
        cvoid = 1;
        mask = (ID == ID(rvoid, cvoid));
    end

    for k = 1:numel(fields)
        nexttile(t, i + (nframes + 1) * (k - 1));

        % Get data and scale/map
        if (k < 3)
            field_data = data.(fields{k})*100;
        else
            field_data = acosd(data.(fields{k}));
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
        if (k == 3) 
            clim([0, lossmin_deg]);
            colormap(gca, "gray");
        else
            clim([-1, 1]*epsmin_perc)
            colormap(gca, "spring");
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