function [headerline, data] = ReadData
    
    filename = 'EbolaData';
    dataformat = '%d %d %d';
    headerformat = '%s %s %s';
    fid = fopen(filename); 
    str = fgetl(fid);
    headerlines = textscan(str, headerformat, 'Delimiter', '\t');
    data = textscan(fid, dataformat, 'HeaderLines', 1, 'Delimiter', '\t');
    
end