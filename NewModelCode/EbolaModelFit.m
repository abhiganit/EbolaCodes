function EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    
    % generate LatinHyperCube Samples from 5 parameters
%     nsamples = 10;
%     xn = lhsdesign(nsamples, 5);
%     lower = [0.1 0.1 0.1 0.1 0.1];        % lower bound
%     upper = [0.9 0.9 0.9 0.9 0.9];        % upper bound
%     X = bsxfun(@plus,lower,bsxfun(@times,xn,(upper-lower)));
    
    % minimize error function (betaI, betaH, betaW, ProbHosp)
    %parfor i = 1:nsamples
        [x, fval] = fminsearchbnd( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights) , [0.23524 1.06453 0.2 0.2] , [0, 0, 0, 0], [10, 10, 10, 1.00]);
    %end    
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime);
    
    h = toc;
     sprintf('%.5f ', x)
     sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end