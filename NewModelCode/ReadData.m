function data = ReadData
    
    % read in data and headers   
    filename = 'EbolaData';
    dataformat = '%d %d %d %d';
    headerformat = '%s %s %s %s';
    fid = fopen(filename); 
    str = fgets(fid);
    headerlines = textscan(str, headerformat, 'Delimiter', '\t');
    dataout = textscan(fid, dataformat, 'Delimiter', '\t');
    
    fclose(fid);
    
    % save as separate cells
    for i = 1:size(headerlines,2)
        header = headerlines{i};
        header = header{1};
        data.(header) = dataout{i};
    end
end