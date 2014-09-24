  function EbolaModelFit
    
     tic;
    
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
    % fit model
    startingconditions = [0.21009 0.04163 0.24764 27.64122];
    %[0.06052 0.13838 0.26851 23.51531];
    MaxIt = 10;
    phiG = 0; phiW = 0; phiC = 0; 
    pG = 0; pH =0; pQ =0; HospCapacity = 314;
    control = [phiG,phiW,phiC,pG,pH,pQ,HospCapacity];
%     control = [0,0,0,0,0,0,10000]; % phiG,phiW,phiC,pG,pH,pQ,HospCapacity

    %[x, fval, ~, ~, ~, Hessian] = fminunc( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights, Initial(x), HospitalVisitors) , startingconditions); % , [0, 0, 0, 1], [10, 10, 1.00, 20]); 
    [x, fval] = fminsearch( @(x)ErrorFunction(x, timesets, datasets, maxtime, weights, Initial(x), MaxIt,control) , startingconditions); % , [0, 0, 0, 1], [10, 10, 1.00, 20]); 
    
    % plot model fit
    plotModelFit(x, timesets, datasets, maxtime, Initial(x), MaxIt,control);
    h = toc;
    
    save('paramest','x');
%     save('paramest','x');
    sprintf('%.5f ', x)
    sprintf('Fval: %.3f', fval)
    sprintf('Run time: %f mins', h/60)
end

function ic = Initial(x)
    
% Initial conditions
    N0 = 4.09e6;           % Initial population size    
    %N0 = 1.14e6;          % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;  Ew0 = 0;  % Exposed people
    Ig0 = x(4);   % People becoming symptomatic
    Ige0 = 0; Iwe0 = 0; % People in Ebola care center 
    Fg0 = 0;  Fge0 = 0; Fwe0 = 0;% Ebola victim's funeral 
    Rg0 = 0; Rge0 = 0; Rwe0 = 0; % Recovered Ebola victims
    Dg0 = 0; Dge0 = 0; Dwe0 = 0; % Buried Ebola victims
    Eq0 = 0; Iq0=0; Iqe0 =0;
    Fqe0 = 0; Fq0 =0; Rqe0 =0; Rq0 = 0;
    Dqe0 = 0; Dq0 = 0;
    Cincd0 = 0;  % cumulative incidences
    Cdied0 = 0; % cumulative deaths
    CHCW0 = 0;  % cumulative healthcare workers
    CHospAd0 = 0; % cumulative admissions to health care centers
    Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sw0 - Ig0;  Sf0 = 0 ;   % Susceptible people
    
    ic =  [Sg0,Sf0,Sw0,...  (1-3)
                Eg0,Ew0,... (4-5)
                Ig0,...  (6-7)
                Ige0,Iwe0,... (8-9)
                Fg0,Fge0,Fwe0,...  (10-12)
                Rg0,Rge0,Rwe0,...   (13-15)
                Dg0,Dge0,Dwe0, ...   (16-18)
                Eq0,Iq0,Iqe0,...
                Fqe0,Fq0,Rqe0,Rq0,Dqe0,Dq0,...
                Cincd0,Cdied0,CHCW0,CHospAd0]; % (19-22)
                
                
end