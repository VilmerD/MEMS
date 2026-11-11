%% Do k-means on original image not the displacement data
img_sub = GetSubimage(CurrImage, window_big);
[XX, YY] = meshgrid(1:size(img_sub, 1), 1:size(img_sub, 2));
% [id, c] = kmeans([XX(:), YY(:), double(img_sub(:))], 3);
% [id, c] = kmeans([XX(:), double(img_sub(:))], 4);
% [id, c] = kmeans([double(img_sub(:))], 3);

figure;
imagesc(reshape(id, size(img_sub)));
title("k-means classification");
colorbar();

%% Edge detection
window_big.rows = [1220, 3650];
window_big.cols = [2540, 4040];

img_sub = GetSubimage(CurrImage, window_big);
xdiff = kron([-1, 0, 1], ones(3, 1));
ydiff = kron(ones(1, 3), [-1; 0; 1]);
rr = conv2(img_sub, xdiff) + conv2(img_sub, ydiff);

figure;

subplot(1, 3, 1);
imagesc(img_sub);
title("Sub image");

subplot(1, 3, 2);
imagesc(rr);
title("Edge filtered");

[ic, c] = kmeans(rr(:), 3);
subplot(1, 3, 3);
imagesc(reshape(ic, size(rr)));

%% Try to train an svm
[XX, YY] = meshgrid(1:size(img_sub, 1), 1:size(img_sub, 2));

good.rows = [500, 600];
good.cols = [600, 700];
good_data = GetTrainingData(rr, XX, YY, good);

bad.rows = [1000, 1100];
bad.cols = [150, 250];
bad_data = GetTrainingData(rr, XX, YY, bad);

training_data = [good_data; bad_data];
training_values = [ones(size(good_data, 1), 1); zeros(size(bad_data, 1), 1)];

svmodel = fitcsvm(training_data, training_values, 'Standardize', true);

%% Predict
subidx.rows = [1000, 1200];
subidx.cols = [400, 600];
predict_data = GetTrainingData(rr, XX, YY, subidx);
[label, score] = predict(svmodel, predict_data);

%% Plot results
figure;

subplot(1, 3, 1);
imagesc(img_sub);
title("Sub image");

subplot(1, 3, 2);
imagesc(rr);
title("Edge filtered");

subplot(1, 3, 3);
imagesc(reshape(label, [201, 201]));

%% Funcs

function data = GetTrainingData(R, X, Y, window)
vals = reshape(GetSubimage(R, window), [], 1);
x = reshape(GetSubimage(X, window), [], 1);
y = reshape(GetSubimage(Y, window), [], 1);

data = [vals, x, y];
end