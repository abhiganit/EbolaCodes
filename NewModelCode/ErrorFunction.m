

function f = ErrorFunction(data, model)

    allfields = fieldnames(data);
    fields = allfields(2:2:end,1);
    index = 0;
    for field = fields
       index = index + 1;
       parf(index) = (data.(field) - model.(field)).^2;
    end
    
    f = sum(parf);
end