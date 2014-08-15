function EbolaModelFit
 
    tic;
    % get data and clean it
    [timesets, datasets, maxtime] = CleanData();
    
    % generate LatinHyperCube Samples from 5 parameters
%     nsamples = 10;
%     xn = lhsdesign(nsamples, 5);
%     lower = [0.1 0.1 0.1 0.1 0.1];        % lower bound
%     upper = [0.9 0.9 0.9 0.9 0.9];        % upper bound
%     X = bsxfun(@plus,lower,bsxfun(@times,xn,(upper-lower)));
    
    % minimize error function (betaI, betaH, betaW, CaseFatality, ProbHosp)
    %parfor i = 1:nsamples
        [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime) , [0.3318    0.2241    0.0661    0.8047    0.6263]) %, [0, 0, 0, 0, 0, 0], [50, 50, 50, 1.00, 1.00, 50]);
    %end
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime);
    
    h = toc;
%     sprintf('betaI: %.4f, betaH: %.4f, betaW: %.4f, CF: %.2f, propH: %.2f, gammaH: %.2f', beta)
%     sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end