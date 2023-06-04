% TOY DATASET

load example-2-clust

figure; h = gscatter(X(:,1), X(:,2) , Y, 'rb','ox');

plot_data(X,Y)
[SDs, X_n, Y_n] = findSD(X,Y,2,1);
[SDs, X_n, Y_n] = findSD(X,Y,1,1);

