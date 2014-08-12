

function f = ErrorFunction(beta)
    
    % clean the data and scroll through actual incidences at given times
    data = ReadData();
    allfields = fieldnames(data);
    fields = allfields(2:2:end,1);
    timefields = allfields(1:2:(end-1),1);
    
    for i = 1:size(timefields,1)    
        strfield = timefields{i};
        timepoints.(strfield) = data.(strfield);
    end
    % get model
    model = EbolaModel(1, beta, timepoints);
    
    
    index = 0;
    for field = fields
       field = field{1};
       index = index + 1;
       partsumf(index) = sum((data.(field) - model.(field)).^2);
    end
    
    % return sum of square differences
    f = sum(partsumf);
end