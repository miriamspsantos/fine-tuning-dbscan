function [SDs, X_n, Y_n] = findSD(X,Y,CLASS, flagPlot)

currmfile = mfilename('fullpath');
curr_path = currmfile(1 : end-length(mfilename()));
addpath([curr_path 'arff-to-mat']);
addpath([curr_path 'data']);
addpath([curr_path 'DBSCAN']);


THRESHOLD = 0.3;

VERBOSE = 1;

is2D = 1; % CHANGE, BY DEFAULT THIS IS 2D

[SDs, X_n, Y_n] = algorithm(X, Y, CLASS, THRESHOLD, VERBOSE);

if flagPlot
    PlotClusteringResult(X_n, SDs, is2D);
end

end

