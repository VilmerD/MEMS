function UpdateDICResults(plots, data)
plots.img_exx.CData = data.exx;
plots.img_exy.CData = data.exy;
plots.img_eyy.CData = data.eyy;
plots.img_loss.CData = data.loss;
drawnow;
end