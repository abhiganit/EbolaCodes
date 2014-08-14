function beta = EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets, maxtime] = CleanData();
    
    % minimize error function
    beta = fminsearch( @(beta)ErrorFunction(beta, timesets, datasets, maxtime) , [0.1, 0.1, 0.1, 0.7, 0.5]); %, [0, 0, 0], [50, 50, 1.00]);

    % plot model fit
    plotModelFit(beta, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('Run time: %f secs', h)
end