%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function PlotClusteringResult(X, IDX, is2D)

k=max(IDX);

Colors=hsv(double(k));

Legends = {};
for i=-2:k
    Xi=X(IDX==i,:);
    if i>0
        Style = 'o';
        MarkerSize = 8;
        Color = [0 0 0];
        MarkerFaceColor = Colors(i,:);
        Legends{end+1} = ['SD #' num2str(i)];
    elseif i==-2
        Style = 'o';
        MarkerSize = 8;
        Color = [0 0 0];
        MarkerFaceColor = [0.9 0.9 0.9];
        if ~isempty(Xi)
            Legends{end+1} = 'Majority Classes';
        end
    elseif i==-1
        Style = 'o';
        MarkerSize = 8;
        Color = [0 0 0];
        MarkerFaceColor = [0.35 0.35 0.35];
        if ~isempty(Xi)
            Legends{end+1} = 'Minority Class';
        end
    else
        Style = 'p';
        MarkerSize = 12;
        Color = [0 0 0];
        MarkerFaceColor = [0 0 0];
        if ~isempty(Xi)
            Legends{end+1} = 'Noise';
        end
    end
    if ~isempty(Xi)
        
        if is2D
            plot(Xi(:,1),Xi(:,2),Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',MarkerFaceColor);
        else
            plot3(Xi(:,1),Xi(:,2), Xi(:,3), Style,'MarkerSize',MarkerSize,'Color',Color,'MarkerFaceColor',MarkerFaceColor);
        end
    end
    hold on;
end
hold off;
%     axis equal;
%     grid on;
    ax = gca;
    ax.Visible = 'off';
    legend(Legends, 'FontSize', 14);
    legend('Location', 'NorthEastOutside');

end