%% Testing normal ncc search
tol = 1e-16; % For integer jumps we expect zero error
for dr = -3:1:3
    for dc = -3:1:3
        % This generates a stencil S and a grid G in which S exists
        [S, G] = GenerateSquare(dr, dc);

        % Search for a best fit of S in G
        data = CrossCorrelationSearch(S, G);

        if (abs(data.dr - dr) > tol || abs(data.dc -dc) > tol)
            fprintf("Error! Expected (%+1d, %+1d) got (%+1.3f, %+1.3f)\n", dr, dc, data.dr, data.dc)
        else
            fprintf("Ok! Expected (%+1d, %+1d) got (%+1.3f, %+1.3f)\n", dr, dc, data.dr, data.dc);
        end
    end
end

%% Test interpolated ncc search
tol = 1e-4; % Since we're interpolating the images we allow some room for error
for dr = -3:1:3
    for dc = -3:1:3
        % This generates a stencil S and a grid G in which S exists
        [S, G] = GenerateSquare(dr, dc);

        % Search for a best fit of S in G
        data = ImageInterpolatedCrossCorrelationSearch(S, G);

        if (abs(data.dr - dr) > tol || abs(data.dc -dc) > tol)
            fprintf("Error! Expected (%+1d, %+1d) got (%+1.6f, %+1.6f)\n", dr, dc, data.dr, data.dc)
        else
            fprintf("Ok! Expected (%+1d, %+1d) got (%+1.6f, %+1.6f)\n", dr, dc, data.dr, data.dc);
        end
    end
end


% 
% % Extract the best fit example
% [GR, GC] = size(G);
% [SR, SC] = size(S);
% window.rows = [(GR + 1)/2 + data.dr - (SR - 1)/2, (GR + 1)/2 + data.dr + (SR - 1)/2];
% window.cols = [(GC + 1)/2 + data.dc - (SC - 1)/2, (GC + 1)/2 + data.dc + (SC - 1)/2];
% best_fit_window = G(window.rows(1):window.rows(2), window.cols(1):window.cols(2));
% 
% % Plot side-by-side
% fig = figure();
% ax = subplot(1, 3, 1);
% imagesc(ax, G);
% title("Window");
% clim(ax, [-1, 1]);
% 
% ax = subplot(1, 3, 2);
% imagesc(ax, S);
% title("Stencil");
% clim(ax, [-1, 1]);
% 
% ax = subplot(1, 3, 3);
% imagesc(ax, best_fit_window);
% title("Best fit");
% clim(ax, [-1, 1]);