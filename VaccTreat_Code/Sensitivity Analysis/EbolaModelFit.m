function[x] =  EbolaModelFit(y)
    
    tic;
    interventiondelay = 0;  immunitydelay = 0; VE =0; VCov = 0; TE = 0; TCov = 0;
    
    % get data and clean it
    [timesets, datasets, maxtime, weights] = CleanData();
     % remove HCWs from total incidence to get rid of overfitting
    datasets{1} = datasets{1}-datasets{3}; % Cumulative Cases - Cumulative HCW cases
    
    % accounting for reporting delay (6 days for Cases, 2 Days for Deaths,
    % 0 Days for Hosp admins)
    
    timesets{1} = timesets{1};
    timesets{2} = timesets{2} + 4;
    timesets{3} = timesets{3} + 0;
    timesets{4} = timesets{4} + 6;
    maxtime = maxtime + 6;
    
    %specify run parameters
    HospitalVisitors = 0;
    MaxIt = 32;

    % fit model    
    startingconditions = [0.06873 0.16598 0.22978 17.98054] ;

    [x, fval] = fminsearch( @(x)ErrorFunction(x,y, timesets, datasets, maxtime, weights, Initial(x,y),MaxIt, HospitalVisitors,interventiondelay, immunitydelay, VE, VCov, TE, TCov) , startingconditions); %, [0, 0, 0, 1/5.5, 1], [10, 10, 1, 1, 50]); 
    h = toc;
    
    sprintf('Run time: %f mins', h/60)
end

function ic = Initial(x,y)
    
% Initial conditions
    N0 = 4.09e6;           % Initial population size    
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4); Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;    Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;    Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;    Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;Iht0 = 0; Iwt0 = 0;
    Sh0 = 5*y(1);   Sf0 = 0; Sw0 = y(1);  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
    V0 = 0; T0 =0; Tf0=0; Tr0=0;Td0=0; CT0=0;
    
    ic =  [Sg0,Sf0,Sh0,Sw0,...  (1-4)
                Eg0,Eh0,Ew0,... (5-7)
                Ig0,Ih0,Iw0,...  (8-10)
                Fg0,Fh0, Fw0,...  (11-13)
                Rg0,Rh0,Rw0,...   (14-16)
                Dg0,Dh0,Dw0, ...   (17-19)
                Cincg0,Cinch0,Cincw0, ... (20-22)
                Cdiedg0,Cdiedh0,Cdiedw0,... (23-25)
                CHosp0, Iht0, Iwt0,...  %26-28
                V0,T0,Tf0,Tr0,Td0,CT0];       % 29-34     
end