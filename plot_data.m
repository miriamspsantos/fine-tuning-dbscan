function [] = plot_data(X, Y)
    
    data_label_0 = X(Y == 1, :);
    data_label_1 = X(Y == 2, :);

    plot(data_label_0(:, 1), data_label_0(:, 2), '.', 'markersize', 20, 'color', 'black');
    
    hold on
    
    plot(data_label_1(:, 1), data_label_1(:, 2), '.', 'markersize', 20, 'color', 'red');

    legend('Class 1', 'Class 2');
    
    hold off
end

