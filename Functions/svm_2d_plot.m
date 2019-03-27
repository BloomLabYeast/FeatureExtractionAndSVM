function svm_2d_plot(mdl,X,group)
d = 0.01;
[x1Grid,x2Grid] = meshgrid(min(X(:,1)):d:max(X(:,1)),...
    min(X(:,2)):d:max(X(:,2)));
xGrid = [x1Grid(:),x2Grid(:)];
[~,scores] = predict(mdl,xGrid);

figure;
h(1:2) = gscatter(X(:,1),X(:,2),group,'rb','.');
hold on
contour(x1Grid,x2Grid,reshape(scores(:,2),size(x1Grid)),[0 0],'k');