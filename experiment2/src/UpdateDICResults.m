function UpdateDICResults(plots, data)
plots.img_exx.CData = data.exx;
plots.img_exy.CData = data.exy;
plots.img_eyy.CData = data.eyy;

loss_deg = acosd(min(ones(size(data.loss)), data.loss));
plots.img_loss.CData = loss_deg;
plots.img_dx.CData = data.ux;
plots.img_dy.CData = data.uy;
drawnow;
end