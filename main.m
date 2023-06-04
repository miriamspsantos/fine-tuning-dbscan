function [] = main()

    MODE = 2; % 1 -  Convert datasets; 2 - Run algorithm
    
    currmfile = mfilename('fullpath');
    curr_path = currmfile(1 : end-length(mfilename()));
    addpath([curr_path 'arff-to-mat']);
    addpath([curr_path 'data']);
    addpath([curr_path 'DBSCAN']);

    if MODE == 1
        
        filename_arff = 'example-4.arff';
        filename_mat = 'example-4.mat';

        arff_to_mat(filename_arff, filename_mat);

        load example-4.mat

        plot_data(X,Y);
        
    elseif MODE == 2    
                
        load example-4.mat
        
        THRESHOLD = 0.3;
        
        VERBOSE = 1;

        [SDs, X_n, Y_n] = algorithm(X, Y, 2, THRESHOLD, VERBOSE);
        
        PlotClusteringResult(X_n, SDs);
        
        ax = gca;
        outerpos = ax.OuterPosition;
        ti = ax.TightInset; 
        left = outerpos(1) + ti(1);
        bottom = outerpos(2) + ti(2);
        ax_width = outerpos(3) - ti(1) - ti(3);
        ax_height = outerpos(4) - ti(2) - ti(4);
        ax.Position = [left bottom ax_width ax_height];

        fig = gcf;
        fig.PaperPositionMode = 'auto';
        fig_pos = fig.PaperPosition;
        fig.PaperSize = [fig_pos(3) fig_pos(4)];
    end
end

