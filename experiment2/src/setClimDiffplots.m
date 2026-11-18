%% Set clim for all plots of diffplots
function setClimDiffplots(plots, clims)
axs = [plots.ax_exx, plots.ax_exy, plots.ax_eyx, plots.ax_eyy];

for i = 1:numel(axs)
    clim(axs(i), clims)
end

end