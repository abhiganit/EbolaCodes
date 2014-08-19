% estimated 18th August 8.51 pm EST
    betaI = 0.10260; 
    betaW = 0.21548;
    theta=0.43483;
    gammaDH=0.21986;
    Sg0=14.71689; 

%disease progression parameters
    alpha = 1/7;        % 1/alpha: mean duration of the incubation period 
    gammaI = 1/10;      % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/7;       % 1/gammaD: mean duration from onset to death
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    epsilon = 100/100;       % percentage Symptomatic illness 
    omega = 3.0;        % odds ratio of funeral risk relative to general population
    
% population parameters
    KikwitGeneralPrev = 6.4e-5;   %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 5.6e-5;   %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    N0 = 4.09e6;          % Initial population size
    M =  5;            % average family size
    MF = M - 1;         %number of chances to be at a funeral
    MH = 1;             % additional family members visiting hospital
    E = 62*365;          % average life expectancy in Liberia 
    
%funeral/hospitalization parameters
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = 62131 / (N0 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
    
% dervied parameters
    gammaH = 1/(1/gammaD - 1/gammaDH);
    gammaIH = 1/(1/gammaI - 1/gammaH);     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    betaH = betaI;      % Transmission coefficient between patients or between HCWs

% Initial conditions
    Eg0 = 0;  Eh0 = 0; Ew0 = 0;         % exposed
              Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;  Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;  Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;  Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cincf0 = 0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;
    Sh0 = 20*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible