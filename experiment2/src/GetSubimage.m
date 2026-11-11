function F = GetSubimage(I, window)
F = I(window.rows(1):window.rows(2), window.cols(1):window.cols(2));
end