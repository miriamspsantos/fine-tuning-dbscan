function new_data = performpca(X,T, flag_norm)
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
model = pca(in_data.X,2);
out_data = linproj(in_data, model);
% pca_data.eigval = model.eigval;
% pca_data.filename = filename;
% pca_data.X = pca_data.X';
% pca_data.y = pca_data.y';


figure;
% h = gscatter(pca_data.X(:,1), pca_data.X(:,2) ,pca_data.y, 'rb','ox');
ppatterns(out_data);
 
new_data.X = out_data.X';
new_data.Y = out_data.y';
% set(h,'LineWidth',1.5);


% figure; 
% plot(pca_data.eigval,'-or');
% xlabel('Principal Components');
% ylabel('Eigenvalues');title('Scree Plot');
% saveas(gca, fullfile(dir, ['Scree_plot_' filename]), 'png');
% close; 

% if(isempty(find(pca_data.eigval >=1)))
%     pca_data.Kaiser = NaN;
% else
%     pca_data.Kaiser = find(pca_data.eigval >=1);
% end

% save(fullfile(dir, ['pca_' filename '.mat']), 'pca_data');
