function beta = EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets] = CleanData();
    
    % minimize error function
    beta = fminsearch( @(beta)ErrorFunction(beta, timesets, datasets) , 0.1);

    % plot model fit
    plotModelFit(beta, timesets, datasets);
    
    h = toc;
    sprintf('Run time: %f minutes', h/60)
end