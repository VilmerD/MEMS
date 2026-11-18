function Img = ReadDICFile(filename, resize)
Img = im2double(importdata(filename));
if (resize)
    Img = imresize(Img, 0.25, "bicubic");
end
end