function EbolaModelFit
 
    tic;
    
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    % fit model
    [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights) , [0.10260 0.21548 0.43483 0.21987 14.71682]); % , [0, 0, 0, 1], [10, 10, 1.00, 20]); 
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('%.5f ', x)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end