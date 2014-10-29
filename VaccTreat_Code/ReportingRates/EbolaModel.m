function modelout = EbolaModel(model, x, timepoints, MaxTime, initial, ReportingRate, HospitalVisitors, MaxIt, interventiondelay, immunitydelay, VE, VCov, TE, TCov)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.
    
    % Model Parameters (Liberia where possible)
     % Estimated Parameters
    betaI = x(1);      % Transmission coefficient in community
    betaW = x(2);      % Transmission coefficient between patients-HCWs
    theta = x(3);      % Percentage of infectious cases are hospitaized
    gammaH = 1/4.9; %1/3;    % 1/Time between hospitalization and death  -- updated based on NEJM paper
     
    %disease progression parameters
    delta = 0.72; %0.6;    %case fatality -- updated based on NEJM paper
    alpha = 1/9.5; %1/8;        % 1/alpha: mean duration of the incubation period  -- -- updated based on NEJM paper
    gammaI = 1/9; %10;      % 1/gammaI: mean duration of the infectious period for survivors -- didn't update because 1) #'s don't add up, and 2) bad fit
    gammaD = 1/7.9; %1/7.5;       % 1/gammaD: mean duration from onset to death -- updated based on NEJM paper
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    epsilon = 100/100;       % percentage Symptomatic illness 
    omega = 1.2;        % overall funeral risk relative to general population
    reportingrateGeneral = ReportingRate;  %reporting rate of cases and deaths in community
    reportingrateHospital = ReportingRate; %reporting rate of cases and deaths in hospital
    
    % population parameters
    KikwitGeneralPrev = 0.81*6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    N0 = 4.09e6;          % Initial population size
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
    
    deltaG = delta*gammaI / ...
                ((1-delta)*gammaD  + delta*gammaI); 
    
    deltaH = delta*gammaIH /...
                ( (1-delta)*gammaDH + delta*gammaIH );
   
%     % Initial conditions
%     Ig0 = x(5);  
%     Eg0 = 0;  Eh0 = 0; Ew0 = 0;         % exposed
%               Ih0 = 0; Iw0 = 0;         % infected
%     Fg0 = 0;  Fh0 = 0; Fw0 = 0;         % died:funeral
%     Rg0 = 0;  Rh0 = 0; Rw0 = 0;         % recovered
%     Dg0 = 0;  Dh0 = 0; Dw0 = 0;         % died:buried
%     Cincg0 = Ig0; Cincf0 = 0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
%     Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
%     CHosp0 = 0;
%     Sh0 = 20*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
    
    % Algorithm parameters
    tau=1;
    %MaxIt = 100;
%     initial = [Sg0,Sf0,Sh0,Sw0,...  (1-4)
%                 Eg0,Eh0,Ew0,... (5-7)
%                 Ig0,Ih0,Iw0,...  (8-10)
%                 Fg0,Fh0, Fw0,...  (11-13)
%                 Rg0,Rh0,Rw0,...   (14-16)
%                 Dg0,Dh0,Dw0, ...   (17-19)
%                 Cincg0,Cincf0,Cinch0,Cincw0, ... (20-23)
%                 Cdiedg0,Cdiedh0,Cdiedw0,... (24-26)
%                 CHosp0];            %27
    params = [betaI,betaH,betaW, omega, alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF,deltaG, deltaH,...
                MF,MH,fFG,fGH,fHG,epsilon,KikwitGeneralPrev,KikwitNonhospPrev, E, reportingrateGeneral, reportingrateHospital,tau]; 
    
    if model== 0
        clear output;
        %initialize output
        %output = nan(28,MaxTime+1,MaxIt);
        parfor i = 1:MaxIt
            % The main iteration 
            [T, pop]=Stoch_Iteration([0 MaxTime],initial,params, HospitalVisitors, interventiondelay, immunitydelay, VE, VCov, TE, TCov);
            output(:,:,i)=pop';

        end
            %% SAVE OUTPUT
            CumulativeCases = output(20,(timepoints{1}+1),:) + output(21,(timepoints{1}+1),:) + output(22,(timepoints{1}+1),:);
            CumulativeDeaths = output(23,(timepoints{1}+1),:) + output(24,(timepoints{1}+1),:) + output(25,(timepoints{1}+1),:);
            CumulativeGeneralIncidence = output(20,(timepoints{1}+1),:);
            CumulativeHospitalIncidence = output(21,(timepoints{1}+1),:);
            CumulativeHealthworkerIncidence = output(22,timepoints{3}+1,:);
            CumulativeGeneralDeaths = output(23,(timepoints{1}+1),:);
            CumulativeHospitalDeaths = output(24,(timepoints{1}+1),:);
            CumulativeHealthworkerDeaths = output(25,(timepoints{1}+1),:);
            CumulativeHospitalAdmissions = output(26,timepoints{4}+1,:);
            
            CurrentHospitalWorkers = output(4,(timepoints{1}+1),:)+output(7,(timepoints{1}+1),:) + output(29,(timepoints{1}+1),:);
            
            TotalVaccineDoses = output(29,(timepoints{1}+1),:);
            
            TotalTreatmentDoses = output(34,(timepoints{1}+1),:);
            
            CurrentHospitalizations = output(3,(timepoints{1}+1),:)+output(6,(timepoints{1}+1),:)+...
                output(9,(timepoints{1}+1),:)+output(10,(timepoints{1}+1),:)+output(27,(timepoints{1}+1),:)+...
                output(28,(timepoints{1}+1),:)+output(30,(timepoints{1}+1),:);
            
            CurrentEbolaHospitalizations = output(9,(timepoints{1}+1),:)+output(10,(timepoints{1}+1),:)+output(27,(timepoints{1}+1),:)+...
                output(28,(timepoints{1}+1),:)+output(30,(timepoints{1}+1),:);
            
            CumulativeCases = reshape(CumulativeCases, MaxTime+1, MaxIt);
            CumulativeDeaths = reshape(CumulativeDeaths, MaxTime+1, MaxIt);
            CumulativeGeneralIncidence = reshape(CumulativeGeneralIncidence, MaxTime+1, MaxIt);
            CumulativeHospitalIncidence = reshape(CumulativeHospitalIncidence, MaxTime+1, MaxIt);
            CumulativeHealthworkerIncidence = reshape(CumulativeHealthworkerIncidence, MaxTime+1, MaxIt);  
            CumulativeGeneralDeaths = reshape(CumulativeGeneralDeaths, MaxTime+1, MaxIt);
            CumulativeHospitalDeaths = reshape(CumulativeHospitalDeaths, MaxTime+1, MaxIt);
            CumulativeHealthworkerDeaths = reshape(CumulativeHealthworkerDeaths, MaxTime+1, MaxIt); 
            
            CumulativeHospitalAdmissions = reshape(CumulativeHospitalAdmissions, MaxTime+1, MaxIt);
            CurrentHospitalWorkers = reshape(CurrentHospitalWorkers, MaxTime+1, MaxIt);
            TotalVaccineDoses = reshape(TotalVaccineDoses, MaxTime+1, MaxIt);
            TotalTreatmentDoses = reshape(TotalTreatmentDoses,MaxTime+1, MaxIt);
            CurrentHospitalizations = reshape(CurrentHospitalizations,MaxTime+1, MaxIt);
            CurrentEbolaHospitalizations = reshape(CurrentEbolaHospitalizations,MaxTime+1, MaxIt);
    else
            % The main iteration (note as it is difference equation, we
            % only run it once)
            [T, pop]=Diffeqn_Iteration([0 MaxTime],initial,params, HospitalVisitors, interventiondelay, immunitydelay, VE, VCov, TE, TCov);
            output=pop';

           
           %% OUTPUT
           
            %% SAVE OUTPUT
            CumulativeCases = output(20,(timepoints{1}+1)) + output(21,(timepoints{1}+1)) + output(22,(timepoints{1}+1));
            CumulativeDeaths = output(23,(timepoints{1}+1)) + output(24,(timepoints{1}+1)) + output(25,(timepoints{1}+1));
            CumulativeGeneralIncidence = output(20,timepoints{3}+1);
            CumulativeHospitalIncidence = output(21,timepoints{3}+1);
            CumulativeHealthworkerIncidence = output(22,timepoints{3}+1);
            CumulativeGeneralDeaths = output(23,(timepoints{1}+1));
            CumulativeHospitalDeaths = output(24,(timepoints{1}+1));
            CumulativeHealthworkerDeaths = output(25,(timepoints{1}+1));
            
            CumulativeHospitalAdmissions = output(26,timepoints{4}+1);
            
            CurrentHospitalWorkers = output(4,(timepoints{1}+1))+output(7,(timepoints{1}+1)) + output(29,(timepoints{1}+1));

            TotalVaccineDoses = output(29,(timepoints{1}+1));
            TotalTreatmentDoses = output(34,(timepoints{1}+1));
            CurrentHospitalizations = output(3,(timepoints{1}+1))+output(6,(timepoints{1}+1))+...
                output(9,(timepoints{1}+1))+output(10,(timepoints{1}+1))+output(27,(timepoints{1}+1))+...
                output(28,(timepoints{1}+1))+output(30,(timepoints{1}+1));
            CurrentEbolaHospitalizations =  output(9,(timepoints{1}+1))+output(10,(timepoints{1}+1))+output(27,(timepoints{1}+1))+...
                output(28,(timepoints{1}+1))+output(30,(timepoints{1}+1));
            
            
            
    end
        
    % get model output ready to passing
    FittingOut{1} = CumulativeCases';
    FittingOut{2} = CumulativeDeaths';
    FittingOut{3} = CumulativeHealthworkerIncidence';
    FittingOut{4} = CumulativeHospitalAdmissions';
    FittingOut{5} = CurrentHospitalWorkers';
    FittingOut{6} = TotalVaccineDoses';
    FittingOut{7} = TotalTreatmentDoses';
    FittingOut{8} = CurrentHospitalizations';
    FittingOut{9} = CurrentEbolaHospitalizations';
    
    FittingOut{10} = CumulativeGeneralIncidence';
    FittingOut{11} = CumulativeHospitalIncidence';
    FittingOut{12} = CumulativeGeneralDeaths';
    FittingOut{13} = CumulativeHospitalDeaths';
    FittingOut{14} = CumulativeHealthworkerDeaths';
    
    modelout{1} = FittingOut;
    modelout{2} = output;

end
