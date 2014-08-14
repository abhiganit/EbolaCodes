function data = ReadData
    
    % read in data and headers   
    filename = 'EbolaData';
    dataformat = '%f %f %f %f %f %f %f %f';
    headerformat = '%s %s %s %s %s %s %s %s';
%     dataformat = '%f %f %f %f %f %f %f %f';
%     headerformat = '%s %s %s %s %s %s %s %s';
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
    
    allfields = fieldnames(data);
    datafields = allfields(2:2:end,1);
    timefields = allfields(1:2:(end-1),1);
    
    % strip out all the NaNs separately for each dataset
   
    for i = 1:size(datafields,1)
        nanfield = datafields{i};
        timefield = timefields{i};
        data.(nanfield) = data.(nanfield)(~isnan(data.(nanfield)));
        data.(timefield) = data.(timefield)(~isnan(data.(nanfield)));
    end
end