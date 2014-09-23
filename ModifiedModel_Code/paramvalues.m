function[params] = paramvalues(x,y);

   % Model Parameters (Liberia where possible)
    %1 
    betaI = x(1);      % Transmission coefficient in community
    
    %2
    betaW = x(2);      % Transmission coefficient between patients-HCWs
    
    oddofinf = 1.2;
    KikwitGeneralPrev = 0.81*6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    
    %3
    omega = ((21*oddofinf-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev);
    
    %4
    alpha = 1/8;        % 1/alpha: mean duration of the incubation period 
    
    %5 
    theta = x(3);      % Percentage of infectious cases are hospitaized
    
    %6
    gammaH = 1/3;    % 1/Time between hospitalization and death
    
    %7
    gammaD = 1/7.5;       % 1/gammaD: mean duration from onset to death
    
    %8
    gammaR = 1/9; %10;      % 1/gammaR: mean duration of the infectious period for survivors
    
    %9
    gammaDH = 1/(1/gammaD - 1/gammaH);
    
    %10
    gammaRH = 1/(1/gammaR - 1/gammaH);     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    
    %11
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    
    
    delta = 0.6;    %case fatality
    
    %12
    deltaG = delta*gammaR / ...
                ((1-delta)*gammaD  + delta*gammaR); 
   
    %13
    deltaH = delta*gammaRH /...
                ( (1-delta)*gammaDH + delta*gammaRH );
            
   
    %14
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    
    M =  5;            % average family size
    
    %15
    MF = M - 1;         %number of chances to be at a funeral
  
    %16
    E = 62*365;          % average life expectancy in Liberia 

    %17
    reportingrateGeneral = 1.0;  %reporting rate of cases and deaths in community
    
    %18
    reportingrateHospital = 1.0; %reporting rate of cases and deaths in hospital
    
    %19
    phiG = y(1); % reduction in infectiousness of general community
    
    %20
    phiW = y(2); % reduction in infectiousness of health care workers
    
    %21
    pG  = y(3);  % proportion of hygienic funerals in general community
    
    %22
    pH = y(4); % proportion of hygienic funerals at Ebola Center
    
    %23 Algorithm parameter
    tau=1;

    params = [betaI, betaW, omega, alpha, theta, gammaH, gammaD, gammaR,gammaDH, gammaRH,gammaF,deltaG, deltaH,...
                fFG,MF, E, reportingrateGeneral, reportingrateHospital, phiG, phiW, pG, pH, tau]; 