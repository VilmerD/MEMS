%% Postprocess dic with k-means
dx_sub = GetSubimage(dx, window);
dy_sub = GetSubimage(dy, window);

% Make k-means clustering of dx and dy data
data = [dx_sub(:), dy_sub(:)];
[id, C] = kmeans(data, 4);
mask = reshape(id, size(dx_sub)) ~= 1;

dx_filter = dx_sub;
dx_filter(mask) = 0;
dy_filter = dy_sub;
dy_filter(mask) = 0;

% Plot clustered data
figure;

subplot(1, 3, 1);
imagesc(reshape(id, size(dx_sub)));
title("class");
% colorbar(gca, 'southoutside')

subplot(1, 3, 2);
imagesc(dx_filter);
title("dx(1)");
clim(gca, [-1, 1]*1e-1);

subplot(1, 3, 3);
imagesc(dy_filter);
title("dy(1)")
clim(gca, [-1, 1]*1e-1);


%% 
%% With SVM
dx_train = dx_sub(1:3, :);
dy_train = cell(size(dx_train));

jbad = 182;
dy_train(1, 1:jbad) = {"G"};
dy_train(1, (jbad+1):end) = {"B"};

jbad = 181;
dy_train(2, 1:jbad) = {"G"};
dy_train(2, (jbad+1):end) = {"B"};

jbad = 182;
dy_train(3, 1:jbad) = {"G"};
dy_train(3, (jbad+1):end) = {"B"};
dy_train = resize(dy_train, [1, numel(dx_train)]);
dx_train = dx_train(:);

svmodel = fitcsvm(dx_train, dy_train, 'Standardize', true);