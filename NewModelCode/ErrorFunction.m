

function f = ErrorFunction(beta, timepoints, datapoints)
    
    % calculate model points
    model = EbolaModel(1, beta, timepoints, datapoints);
    
    % sum up square diffs for each dataset
    index = 0;
    for dataset = 1:size(timepoints,1)
       index = index + 1;
       partsumf(index) = sum((datapoints{dataset} - model{dataset}).^2);
    end
    
    % return sum of square differences over all datasets
    f = sum(partsumf);
end