function EbolaModelFit
    
    tic;
    
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    % fit model
    startingconditions = [0.07355 0.17778 0.37443 24.39939];
    HospitalVisitors = 1;

    MaxIt = 1; %2^11;

    %[x, fval, ~, ~, ~, Hessian] = fminunc( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights, Initial(x), HospitalVisitors) , startingconditions); % , [0, 0, 0, 1], [10, 10, 1.00, 20]); 
    [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights, Initial(x), HospitalVisitors) , startingconditions); %, [0, 0, 0, 1/5.5, 1], [10, 10, 1, 1, 50]); 
    
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime, Initial(x), HospitalVisitors, MaxIt);
    h = toc;
    
%     save('paramest','x');
    save('paramest','x');
    sprintf('%.5f ', x)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end

function ic = Initial(x)
    
% Initial conditions
    N0 = 4.09e6;           % Initial population size    
    %N0 = 1.14e6;          % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4); Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;    Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;    Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;    Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;Iht0 = 0; Iwt0 = 0;
    Sh0 = 5*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
    
    ic =  [Sg0,Sf0,Sh0,Sw0,...  (1-4)
                Eg0,Eh0,Ew0,... (5-7)
                Ig0,Ih0,Iw0,...  (8-10)
                Fg0,Fh0, Fw0,...  (11-13)
                Rg0,Rh0,Rw0,...   (14-16)
                Dg0,Dh0,Dw0, ...   (17-19)
                Cincg0,Cinch0,Cincw0, ... (20-22)
                Cdiedg0,Cdiedh0,Cdiedw0,... (23-25)
                CHosp0, Iht0, Iwt0];            %26-28
end