function EbolaModelFit
    
    % initialize parallel pool and start timer
%     if parpool('size') == 0 % checking to see if my pool is already open
%         parpool(2);
%     end
    tic;
    
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    
    % generate LatinHyperCube Samples from 5 parameters
%     nsamples = 10;
%     xn = lhsdesign(nsamples, 5);
%     lower = [0.1 0.1 0.1 0.1 0.1];        % lower bound
%     upper = [0.9 0.9 0.9 0.9 0.9];        % upper bound
%     X = bsxfun(@plus,lower,bsxfun(@times,xn,(upper-lower)));
    
    % minimize error function (betaI, betaW, ProbHosp, indexcases)
    %parfor i = 1:nsamples
        [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights) , [0.5 0.1 0.8 10]); % , [0, 0, 0, 1], [10, 10, 1.00, 20]);
    %end    
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime);
    
    h = toc;
    sprintf('%.5f ', x)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end