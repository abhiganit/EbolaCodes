function modelout = EbolaModel(model, x, timepoints, MaxTime, initial, HospitalVisitors, MaxIt)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.
    
    % Model Parameters (Liberia where possible)
     % Estimated Parameters
    betaI = x(1);      % Transmission coefficient in community
    betaW = x(2);      % Transmission coefficient between patients-HCWs
    theta = x(3);      % Percentage of infectious cases are hospitaized  
    %delta = x(4);        %x(4);       % case fatality
    delta = 0.6; 
    %gammaDH = x(4); 
    
    %disease progression parameters
    gammaD = 1/7.5;       % 1/gammaD: mean duration from onset to death
    gammaH = 1/3;    % 1/Time between hospitalization and death
    %gammaH = 1/(1/gammaD - 1/gammaDH);
    alpha = 1/8;        % 1/alpha: mean duration of the incubation period 
    gammaI = 1/9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
    
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    epsilon = 100/100;       % percentage Symptomatic illness 
    omega = 1.2;        % overall funeral risk relative to general population
    reportingrateGeneral = 1.0;  %reporting rate of cases and deaths in community
    reportingrateHospital = 1.0; %reporting rate of cases and deaths in hospital
    
    % population parameters
    KikwitGeneralPrev = 0.81*6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    N0 = 4.09e6;          % Initial population size -- Liberia
    %N0 = 1.14e6;   % Montserrado County 
    %N0 = 0.27e6;
    M =  5;            % average family size
    MF = M - 1;         %number of chances to be at a funeral
    MH = 1;             % additional family members visiting hospital
    E = 62*365;          % average life expectancy in Liberia 
    
    %funeral/hospitalization parameters
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = 62131 / (N0 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
    
    % dervied parameters
    gammaDH = 1/(1/gammaD - 1/gammaH);
    gammaIH = 1/(1/gammaI - 1/gammaH);     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    betaH = betaI;      % Transmission coefficient between patients or between HCWs
        
    % Algorithm parameters
    tau=1;
    params = [betaI,betaH,betaW, omega, alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF,delta,...
                MF,MH,fFG,fGH,fHG,epsilon,KikwitGeneralPrev,KikwitNonhospPrev, E, reportingrateGeneral, reportingrateHospital,tau]; 
    
    if model== 0
        clear output;
        %initialize output
        output = nan(28,MaxTime+1,MaxIt);
        parfor i = 1:MaxIt
            % The main iteration 
            [T, pop]=Stoch_Iteration([0 MaxTime],initial,params, HospitalVisitors);
            output(:,:,i)=pop';

        end
            %% SAVE OUTPUT
            CumulativeCases = output(20,(timepoints{1}+1),:) + output(21,(timepoints{1}+1),:) + output(22,(timepoints{1}+1),:);
            CumulativeDeaths = output(23,(timepoints{1}+1),:) + output(24,(timepoints{1}+1),:) + output(25,(timepoints{1}+1),:);
            CumulativeHealthworkerIncidence = output(22,timepoints{3}+1,:);
            CumulativeHospitalAdmissions = output(26,timepoints{4}+1,:);
            
            CumulativeCases = reshape(CumulativeCases, MaxTime+1, MaxIt);
            CumulativeDeaths = reshape(CumulativeDeaths, MaxTime+1, MaxIt);
            CumulativeHealthworkerIncidence = reshape(CumulativeHealthworkerIncidence, MaxTime+1, MaxIt);
            CumulativeHospitalAdmissions = reshape(CumulativeHospitalAdmissions, MaxTime+1, MaxIt);
            
    else
            % The main iteration (note as it is difference equation, we
            % only run it once)
            [T, pop]=Diffeqn_Iteration([0 MaxTime],initial,params, HospitalVisitors);
            output=pop';

           
           %% OUTPUT
           
            %% SAVE OUTPUT
            CumulativeCases = output(20,(timepoints{1}+1)) + output(21,(timepoints{1}+1)) + output(22,(timepoints{1}+1));
            CumulativeDeaths = output(23,(timepoints{1}+1)) + output(24,(timepoints{1}+1)) + output(25,(timepoints{1}+1));
            CumulativeHealthworkerIncidence = output(22,timepoints{3}+1);
            CumulativeHospitalAdmissions = output(26,timepoints{4}+1);

            
    end
        
    % get model output ready to passing
    FittingOut{1} = CumulativeCases';
    FittingOut{2} = CumulativeDeaths';
    FittingOut{3} = CumulativeHealthworkerIncidence';
    FittingOut{4} = CumulativeHospitalAdmissions';
    
    modelout{1} = FittingOut;
    modelout{2} = output;

end
