%% Postprocess dic with k-means
% Make k-means clustering of dx and dy data
data = [data.exx(:), data.exy(:), data.eyy(:)];
[id, C] = kmeans(data, 3);
mask = reshape(id, size(data.exx)) == id(sub2ind(size(data.exx), 180, 40));
[CC, RR] = meshgrid(1:size(data.exx, 2), 1:size(data.exx, 1));
mask = or(mask, (1 - (RR > 70) .* (RR < 300)) > 0);

exx_filter = data.exx;
exx_filter(mask) = 0;
eyy_filter = data.eyy;
eyy_filter(mask) = 0;

% Plot clustered data
figure;

subplot(1, 3, 1);
imagesc(reshape(id, size(exx)));
title("class");
% colorbar(gca, 'southoutside')

subplot(1, 3, 2);
imagesc(exx_filter);
title("dx(1)");
clim(gca, [-1, 1]*1e-1);

subplot(1, 3, 3);
imagesc(eyy_filter);
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