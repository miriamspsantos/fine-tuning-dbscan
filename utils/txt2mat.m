function [X, Y] = txt2mat(filename, flag)
%
%   INPUT:
%       'filename' is a string with the name or filepath (must have ".txt")
%
%   OUTPUT:
%        X is the matrix of data
%        Y is the class to each point belongs
%
%   EXAMPLE:
%       filename = 'positions.txt'
%       txt2mat(filename)
%
%
% Copyright: Miriam Santos, 2017


% Loads txt files
data = load(filename);

% 0 = red balls (commonly, the MAJORITY class)
% 1 = blue crosses (commonly, the MINORITY)


X = [data(:,1),data(:,2)];
Y = data(:,3)+1;



if flag
    filename = erase(filename, '.txt');
    save([filename '.mat'], 'X', 'Y');
end

end


