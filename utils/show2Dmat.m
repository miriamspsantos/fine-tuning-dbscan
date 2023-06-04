function show2Dmat(filename,varargin)
% show2Dmat shows and saves the figures regarding certain configuration
% files (in .mat format). 
% 
% 
%   INPUT:
%   'filename' is a string with the name or filepath (must have ".mat")
%   'varargin' can be defined to save the output image. It is the path
%   where the pictures should be saved (png format).
% 
%         filename includes:
%               -- X: dataset (features)
%               -- Y: classes (1/2,3,4,5...): 1 is the majority class and
%               the remaining are the minority....
% 
% 
%   OUTPUT:
%       This function simply presents the figure regarding the file
%       and may also save it if varargin is defined.
%
% 
%   EXAMPLE:
%       filename = 'twospirals.mat'
%       show2Dmat(filename)
%
%
%   NOTES: There are some important things to know about this function:
%       At this point, the specification is the following:
% 
%           ARFF = {MAJ, MIN/MIN-SAFE, BORDERLINE, RARE, OUTLIER};
%           MAJ(1): 'or'
%           MIN(2): 'xb'
%           DIVISION OF MINORITY EXAMPLES:
%                Safe: 'xb'
%                Borderline: '*m' 
%                Rare: 'dk'
%                Outlier: 'sc'
% 
% IMPORTANT: In this specification, the class coded with '1' will refer to
%            the MAJ class!
% 
% TODO: Adapt classification codes for 1 to be the majority.
% 
% Copyright: Miriam Santos, 2017


load(filename);
% This file has X and Y variables
% X are the coordinates and Y is the class 

classes = unique(Y);
maxClass = max(classes);
allClasses = 1:maxClass;
missingClasses = setdiff(allClasses,classes);

% Original Labels:
Labels = {'MAJ', 'MIN', 'BORDER', 'OUTLIER', 'RARE'}';

if length(classes) > 2
    Labels{2} = 'SAFE';
end


% Original codes and symbols for plotting
% colorCode = 'rbmkc';
symbCode = 'ox*ds';

cRare = [135, 19, 244]./255;
cOutlier = [63, 191, 37]./255;

colorCode = [1 0 0;... % maj
             0 0 1;... % safe
             0 0 0;... % border
             cRare;... % rare
             cOutlier]; % outlier
            

% Remove those that are not used
colorCode(missingClasses,:) = [];
symbCode(missingClasses) = [];


% % % figure;
% % % h = gscatter(X(:,1),X(:,2),Y,colorCode, symbCode);
% % % set(h,'LineWidth',1);
% % % xlabel('X1');
% % % ylabel('X2');
% % % axis equal
% % % filename = erase(filename,'.mat');
% % % title(filename)
% % % % legend(dataOut.Labels{end},'Location', 'northeastoutside');
% % % 
% % % legend(Labels([classes]),'Location', 'northeastoutside');


figure;
h = gscatter(X(:,1),X(:,2),Y,colorCode, symbCode);
if length(h) > 2
    for j = 3:1:length(h)
    h(j).MarkerFaceColor = colorCode(j,:);
    end
end
set(h,'LineWidth',1);
set(h,'MarkerSize', 7);
xlabel('X1');
ylabel('X2');
axis equal
filename = erase(filename,'.mat');
title(filename)
% legend(dataOut.Labels{end},'Location', 'northeastoutside');
legend(Labels(classes),'Location', 'northeastoutside');

if (nargin > 1)
%     filename = strrep(filename,'.mat','.png');
    savePath = varargin{1};
    saveas(gcf, fullfile(savePath, filename), 'png');
end

end


