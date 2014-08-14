function beta = EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets, maxtime] = CleanData();
    
    % minimize error function
    beta = fminsearch( @(beta)ErrorFunction(beta, timesets, datasets, maxtime) , [0.9 0.5]);

    % plot model fit
    plotModelFit(beta, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('Run time: %f minutes', h/60)
end