

function f = ErrorFunction(beta)
    
    % get model and data
    data = ReadData();
    model = EbolaModel(1, beta);
    
    % clean the data and scroll through actual incidences at given times
    allfields = fieldnames(data);
    fields = allfields(2:2:end,1);
    index = 0;
    for field = fields
       field = field{1};
       index = index + 1;
       partsumf(index) = sum((data.(field) - model.(field)).^2);
    end
    
    % return sum of square differences
    f = sum(partsumf);
end