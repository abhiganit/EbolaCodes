

function f = ErrorFunction(beta, timepoints, datapoints, maxtime, weights, initial, MaxIt,control)
    
    % calculate model points
     model = EbolaModel(1, beta, timepoints, maxtime, initial,MaxIt,control);
%     model = EbolaModel_intervention(1, beta, timepoints, maxtime, initial,MaxIt,control);
    modelfit = model{1};
    partsumf = zeros(size(timepoints,1),1);
    % sum up square diffs for each dataset
    for dataset = 1:size(timepoints,1)
       partsumf(dataset) = sum(weights{dataset}.*(datapoints{dataset} - modelfit{dataset}).^2);
    end
    
    % return sum of square differences over all datasets
    f = sum(partsumf);
end