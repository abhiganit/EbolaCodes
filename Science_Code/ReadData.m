function [data, weights] = ReadData
    
    % read in data and headers   
   filename = 'EbolaData';
   %  filename = 'EbolaData_MontserradoCounty';
    %filename = 'EbolaData_LofaCounty_asreported';
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
        notnans = ~isnan(data.(nanfield));
        data.(nanfield) = data.(nanfield)(notnans);
        data.(timefield) = data.(timefield)(notnans);
    end
    
    % read in data and headers   
  %  filename = 'weights';
     filename = 'weights_MontserradoCounty';
    %filename = 'weights_LofaCounty_asreported';
    dataformat = '%f %f %f %f';
    fid = fopen(filename);
    weights = textscan(fid, dataformat, 'Delimiter', '\t');
    %weights = cell2mat(weightscell);
end