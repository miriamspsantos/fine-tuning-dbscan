function [] = arff_to_mat(filename_arff, filename_mat)

    dataOut = arff2double(filename_arff);
    
    X = dataOut.X;
    Y = dataOut.Y;
    
    save(filename_mat,'X','Y');
end

