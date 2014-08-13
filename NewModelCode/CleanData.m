function [t, d] = CleanData

    % clean the data and find times at which model and data are evaluated
    data = ReadData();
    datacell = struct2cell(data);
    
    t = datacell(1:2:(end-1),1);
    d = datacell(2:2:end,1);
        
end