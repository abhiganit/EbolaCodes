

function f = ErrorFunction(beta, timepoints, datapoints, maxtime)
    
    % calculate model points
    model = EbolaModel(1, beta, timepoints, maxtime);
    partsumf = zeros(size(timepoints,1),1);
    % sum up square diffs for each dataset
    for dataset = 1:size(timepoints,1)
       partsumf(dataset) = sum((datapoints{dataset} - model{dataset}).^2);
    end
    
    % return sum of square differences over all datasets
    f = sum(partsumf);
end