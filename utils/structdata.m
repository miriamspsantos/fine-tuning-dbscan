function data = structdata(X, T)
% STRUCTDATA Build data according to sprtool toolbox
%
% STRUCTDATA transforms data X [samples x features] and vector
% T [classes x 1] into structure data.X [features x classes]
% and data.y [1 x classes]. This is the format required to work 
% with sprtool.


data = struct('X', X', 'y', T', 'name', 'Data according to SPRTOOL');

end