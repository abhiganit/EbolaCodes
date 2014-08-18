function EbolaModelFit
    
    % initialize parallel pool and start timer
%     if parpool('size') == 0 % checking to see if my pool is already open
%         parpool(2);
%     end
    tic;
    
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    % fit model
    [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights) , [0.05 0.1 0.6 20]); % , [0, 0, 0, 1], [10, 10, 1.00, 20]); 
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('%.5f ', x)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end