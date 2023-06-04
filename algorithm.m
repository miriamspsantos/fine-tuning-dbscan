function [SDs, X_n, Y_n] = algorithm(X, Y, L, T, V)
    
    tic;

    SDs = [];
    X_n = X;
    Y_n = Y;
    
    currmfile = mfilename('fullpath');
    curr_path = currmfile(1 : end-length(mfilename()));
    addpath([curr_path 'DBSCAN']);

    X_2 = X(Y == L, :);       
           
    min_pts = 3;

    d_X_2 = size(X_2, 2);
    n_X_2 = size(X_2, 1);
    k = nthroot(min_pts / n_X_2, d_X_2);
    
    if V
        fprintf('\nDimensions = %d\n', d_X_2);
        fprintf('Observations = %d\n', n_X_2);
    end

    epsilon = k;

    values = [];
    clusters = [];
    silhouettes = {};
    cardinalities = {};
    number_clusters = [];
    epsilons = [];

    it = 0;

    while 1

        it = it + 1;

        idx = DBSCAN(X_2, epsilon, min_pts);
           
        number_of_clusters = max(idx);

        if number_of_clusters == 0
            epsilon = epsilon + k;
            continue;
        end

        s = silhouette(X_2, idx, 'Euclidean');

        if sum(isnan(s)) > 0
            
            if size(clusters, 1) == 0
                values = n_X_2.^2;
                clusters = idx;
                silhouettes{1} = 1;
                cardinalities{1} = n_X_2;
                number_clusters = 1;
            end
            
            break;
        end

        silhouette_by_cluster = zeros(number_of_clusters, 1);
        count_by_cluster = zeros(number_of_clusters, 1);

        for c = 1 : number_of_clusters
            s_c = s(idx == c);
            silhouette_by_cluster(c) = mean(s_c);
            count_by_cluster(c) = sum(idx == c);
        end
        
        global_weighted_silhouette = mean(silhouette_by_cluster .* (count_by_cluster.^2));
        
        new_value = 0;

        if size(values) == 0 | values(end) ~= global_weighted_silhouette

            if V
                fprintf('\nIteration = %d\n', it);
                fprintf('Epsilon = %f\n', epsilon);
                fprintf('Weighted Silhouette = %f\n', global_weighted_silhouette);
                fprintf('Number of Clusters = %d\n', number_of_clusters);
            end
            
            new_value = 1;
        end
        
        values = [values global_weighted_silhouette];
        clusters = [clusters idx];
        silhouettes{size(values, 2)} = silhouette_by_cluster;
        cardinalities{size(values, 2)} = count_by_cluster;
        number_clusters = [number_clusters number_of_clusters];
        epsilons = [epsilons epsilon];
            
        sf = 0;

        count_combin = 0;

        for c_1 = 1 : number_of_clusters

            points_c_1 = X_2(idx == c_1, :);
            intra_c_1 = mean(pdist(points_c_1));

            for c_2 = (c_1 + 1) : number_of_clusters

                points_c_2 = X_2(idx == c_2, :);
                intra_c_2 = mean(pdist(points_c_2));

                inter_c_1_2 = pdist2(points_c_1, points_c_2);
                n_c_1_2 = numel(inter_c_1_2);
                inter_c_1_2 = sum(sum(inter_c_1_2)) / n_c_1_2;

                sf = sf + ((intra_c_1 + intra_c_2) / (inter_c_1_2));

                count_combin = count_combin + 1;
            end
        end

        sf = sf / count_combin;

        if isnan(sf) || sf <=0
            sf = 1;
        end

        if V && new_value
            fprintf('Combinations %d choose 2 = %d | SF = %d\n', number_of_clusters, count_combin, sf);
        end

        epsilon = epsilon + sf * k; 

    end
          
    uniq_clusters = unique(number_clusters);
    max_count_cluster_vals = -1;
    max_count_cluster = -1;
    start_count_cluster = -1;

    for i = 1:numel(uniq_clusters)
        
        c = uniq_clusters(i);
        
        idx_c = (number_clusters == c);

        f = find(diff([false, idx_c==1, false]) ~= 0);
        [m, ix] = max(f(2:2:end) - f(1:2:end-1));
        
        if m > max_count_cluster_vals
           
            max_count_cluster_vals = m;
            max_count_cluster = c;
            start_count_cluster = f(2 * ix - 1);
        end
        
    end
    
    end_c = start_count_cluster + max_count_cluster_vals - 1;
    
    if start_count_cluster > 1
        values(1:start_count_cluster-1) = n_X_2*n_X_2*-1;
    end
    
    if end_c < numel(values)  
        values(end_c+1:end) = n_X_2*n_X_2*-1;
    end

    [cr_max, i_max] = max(values);
    max_clusters = clusters(:, i_max);
    
    if V
        fprintf('\nNumber of Clusters = %d\n', max_count_cluster);
        fprintf('Longest Sequence = %d\n', max_count_cluster_vals);
        fprintf('Max CR Cluster = %f\n', cr_max);
    end 
    
    max_cardinalities = cardinalities{i_max};
    
    max_cardinality = max(max_cardinalities);
        
    clusters_importance = max_cardinalities ./ max_cardinality;
    
    if V
        fprintf('\nRI by cluster: ');

        for i=1:numel(clusters_importance)
            fprintf('C%d = %f; ', i, clusters_importance(i));
        end
    end 
        
    SDs = zeros(size(X_2, 1), 1);
    
    sds_indexes = (clusters_importance <= T);
    
    count_sds = 1;
    
    for i=1:size(sds_indexes, 1)

        cluster_indexes = (max_clusters == i);
        points = X_2(cluster_indexes, :);
            
        rows = ismember(X_2, points, 'rows');
            
        if sds_indexes(i) == 1
            
            SDs(rows) = count_sds;
            count_sds = count_sds + 1;
        else
            
            SDs(rows) = -1;
        end
    end
        
    X_1 = X(Y ~= L, :);
    Y_1 = Y(Y ~= L, :);
    
    Y_2 = Y(Y == L, :);
    
    X_n = [X_2; X_1];
    Y_n = [Y_2; Y_1];
    
    other_classes = ones(size(X_1, 1), 1) .* -2;
    
    SDs = [SDs; other_classes];
    
    t = toc;
    
    if V
        fprintf('\n Execution Time = %f\n', t);
    end
    
%     figure
%     
%     plot(epsilons,number_clusters,...
%         'LineWidth',1,...
%         'Color','r')
%     
%     xticks(0:20:max(epsilons))
%     
%     xlabel('Epsilon (\epsilon)', 'FontSize', 14)
%     ylabel('N. Clusters', 'FontSize', 14)
%     xt = get(gca, 'XTick');
%     set(gca, 'FontSize', 14)
%     
%     ax = gca;
%     outerpos = ax.OuterPosition;
%     ti = ax.TightInset; 
%     left = outerpos(1) + ti(1);
%     bottom = outerpos(2) + ti(2);
%     ax_width = outerpos(3) - ti(1) - ti(3);
%     ax_height = outerpos(4) - ti(2) - ti(4);
%     ax.Position = [left bottom ax_width ax_height];
%     
%     fig = gcf;
%     fig.PaperPositionMode = 'auto';
%     fig_pos = fig.PaperPosition;
%     fig.PaperSize = [fig_pos(3) fig_pos(4)];

%     PlotClusteringResult(X_n, max_clusters); 
end
