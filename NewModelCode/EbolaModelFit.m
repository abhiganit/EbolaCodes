function EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets, maxtime] = CleanData();
    
    % minimize error function
    [beta, fval] = fminsearch( @(beta)ErrorFunction(beta, timesets, datasets, maxtime) , [0.3, 0.3, 0.1, 0.5, 0.5]); %, [0, 0, 0, 0, 0, 0], [50, 50, 50, 1.00, 1.00, 50]);

    % plot model fit
    plotModelFit(beta, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('betaI: %.4f, betaH: %.4f, betaW: %.4f, CF: %.2f, propH: %.2f', beta)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f secs', h)
end