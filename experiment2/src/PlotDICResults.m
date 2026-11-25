function diffplots = PlotDICResults(CurrImage, PrevImage, window, data, emax, mmap)
clims = [-1, 1] * emax;

figdiff = figure();

diffplots.t = tiledlayout(figdiff, 2, 4, TileSpacing="tight", Padding="loose");

diffplots.ax_img0 = nexttile(diffplots.t, 1);
diffplots.img_img0 = imagesc(diffplots.ax_img0, GetSubimage(CurrImage, window));
title(diffplots.ax_img0, "Current Image");
xticks(diffplots.ax_img0, []);
yticks(diffplots.ax_img0, []);

diffplots.ax_loss = nexttile(diffplots.t, 2);
loss_deg = acosd(min(ones(size(data.loss)), data.loss));
diffplots.img_loss = imagesc(diffplots.ax_loss, loss_deg);
% title(diffplots.ax_loss, "loss");
clim(diffplots.ax_loss, [0, 30]);
colormap(diffplots.ax_loss, mmap);
xticks(diffplots.ax_loss, []);
yticks(diffplots.ax_loss, []);

diffplots.ax_dx = nexttile(diffplots.t, 3);
diffplots.img_dx = imagesc(diffplots.ax_dx, data.ux);
title(diffplots.ax_dx, "$u_y$", "Interpreter", "latex");
colormap(diffplots.ax_dx, mmap);
xticks(diffplots.ax_dx, []);
yticks(diffplots.ax_dx, []);

diffplots.ax_dy = nexttile(diffplots.t, 4);
diffplots.img_dy = imagesc(diffplots.ax_dy, data.uy);
title(diffplots.ax_dy, "$u_x$", "Interpreter", "latex");
colormap(diffplots.ax_dy, mmap);
xticks(diffplots.ax_dy, []);
yticks(diffplots.ax_dy, []);

diffplots.ax_imge = nexttile(diffplots.t, 5);
diffplots.img_imge = imagesc(diffplots.ax_imge, GetSubimage(PrevImage, window));
title(diffplots.ax_imge, "Previous Image");
xticks(diffplots.ax_imge, []);
yticks(diffplots.ax_imge, []);

diffplots.ax_exx = nexttile(diffplots.t, 6);
diffplots.img_exx = imagesc(diffplots.ax_exx, data.exx);
title(diffplots.ax_exx, "$\epsilon_{xx}$", "Interpreter", "latex");
clim(diffplots.ax_exx, clims);
colormap(diffplots.ax_exx, mmap);
xticks(diffplots.ax_exx, []);
yticks(diffplots.ax_exx, []);

diffplots.ax_exy = nexttile(diffplots.t, 7);
diffplots.img_exy = imagesc(diffplots.ax_exy, data.exy);
title(diffplots.ax_exy, "$\epsilon_{xy}$", "Interpreter", "latex");
clim(diffplots.ax_exy, clims);
colormap(diffplots.ax_exy, mmap);
xticks(diffplots.ax_exy, []);
yticks(diffplots.ax_exy, []);

diffplots.ax_eyy = nexttile(diffplots.t, 8);
diffplots.img_eyy = imagesc(diffplots.ax_eyy, data.eyy);
title(diffplots.ax_eyy, "$\epsilon_{yy}$", "Interpreter", "latex");
clim(diffplots.ax_eyy, clims);
colormap(diffplots.ax_eyy, mmap);
xticks(diffplots.ax_eyy, []);
yticks(diffplots.ax_eyy, []);

% Fix colorbars
% -------------------------------------------------------------------------
colormap(diffplots.ax_img0, "hot");
colormap(diffplots.ax_imge, "hot");

% -------------------------------------------------------------------------
% Strain
c = colorbar(diffplots.ax_eyy, "southoutside");
c.Label.String = "Strain [%]";
c.Ticks = [-emax, -emax/2, 0, emax/2, emax];
c.TickLabels = [sprintf("-%d", round(emax*100)), sprintf("-%d", round(emax*50)), "0", ...
    sprintf("%d", round(emax*50)), sprintf("%d", round(emax*100))];

drawnow  % Let tiledlayout finish positioning the axes

p1 = diffplots.ax_exx.Position;
p3 = diffplots.ax_eyy.Position;

c.Units = "normalized";
c.Position = [p1(1), p1(2) - 0.045, ...
             (p3(1) + p3(3)) - p1(1), 0.02];

% -------------------------------------------------------------------------
% loss
colormap(diffplots.ax_loss, "parula");
c2 = colorbar(diffplots.ax_loss, 'northoutside');
colormap(c2, "parula");
c2.Label.String = "ZNCC [deg]";
% c2.Label.VerticalAlignment = "middle";
% c2.Label.HorizontalAlignment = "left";
c2.Label.Position(2) = 1.2;
c2.Ticks = [0, 10];
c2.Position(2) = c2.Position(2)+0.04;

drawnow
end