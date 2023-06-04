function new_data = performpca(X,T, flag_norm, is2D)
%  PERFORMPCA Perform pca analysis
%           PERFORMPCA(X, T, filename, dir) takes the matrix of data
%           X and the class labels T and performs a principal component analysis
%           based on sprtool. A figure with the scree plot is saved, according to
%           the given filename. PERFORMPCA saves the png files of scree
%           plot in directory dir.
%
%          OUTPUT:
%          pca_data.X: matrix of the projection
%          pca_data.y: matrix of class labels
%          pca_data.filename: name of data
%          pca_data.Kaiser: components to keep according to Kaiser criterion
%          pca_data.eigval = eigenvalues


% Normalize Data: FLAG 1/0

if flag_norm
    X = scalestd(X);
end


in_data = structdata(X,T);
model = pca(in_data.X,3);
out_data = linproj(in_data, model);
% pca_data.eigval = model.eigval;
% pca_data.filename = filename;
% pca_data.X = pca_data.X';
% pca_data.y = pca_data.y';

% ppatterns(out_data);

new_data.X = out_data.X';
new_data.Y = out_data.y';

figure;

if is2D
    gscatter(new_data.X(:,1), new_data.X(:,2) ,new_data.Y, 'rb','ox');
else
    h = gscatter(new_data.X(:,1),new_data.X(:,2), new_data.Y, 'rb','ox');
    z = new_data.X(:,3);
    gu = unique(new_data.Y);
    for k = 1:numel(gu)
        idx = (new_data.Y == gu(k));
        set(h(k), 'ZData', z(idx));
    end
end
