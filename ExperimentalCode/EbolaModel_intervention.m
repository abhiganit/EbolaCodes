function modelout = EbolaModel_intervention(model, x, timepoints, MaxTime, initial, ControlParams, HospitalVisitors, MaxIt,y)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.
    
    % Model Parameters (Liberia where possible)
    
     % Estimated Parameters
    betaI = x(1);      % Transmission coefficient in community
    betaW = x(2);      % Transmission coefficient between patients-HCWs
    theta = x(3);      % Percentage of infectious cases are hospitaized
    gammaH = 1/y(5);    % 1/Time between hospitalization and death
    %Ig0 = x(5);  
    
    %disease progression parameters
    alpha = 1/y(2);        % 1/alpha: mean duration of the incubation period 
    gammaI = 1/y(4); %10;      % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/y(3);       % 1/gammaD: mean duration from onset to death
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    epsilon = y(11);       % percentage Symptomatic illness 
    omega = y(10);        % overall funeral risk relative to general population
    
    % population parameters
    KikwitGeneralPrev = 6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    N0 = 4.09e6;          % Initial population size
    M =  y(8);            % average family size
    MF = M - 1;         %number of chances to be at a funeral
    MH = y(9);             % additional family members visiting hospital
    E = 62*365;          % average life expectancy in Liberia 
    
    %funeral/hospitalization parameters
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = y(6) / (N0 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/y(7);          % 1/average time spent at in hospital with non-ebola disease
    
    % dervied parameters
    gammaDH = 1/(1/gammaD - 1/gammaH);
    gammaIH = 1/(1/gammaI - 1/gammaH);     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    betaH = betaI;      % Transmission coefficient between patients or between HCWs


    % intervention parameters
%     iH = ControlParams(1);
%     phiG = ControlParams(2);
%     phiW = ControlParams(3);
%     phiC = ControlParams(4);
%     pG = ControlParams(5);
%     pH = ControlParams(6);
    C = 11;  %not varying
    
    
    
    % Algorithm parameters
    tau=1;
    %MaxIt = 10;
%     initial = [Sg0,Sf0,Sh0,Sw0,...  (1-4)
%                 Eg0,Eh0,Ew0,... (5-7)
%                 Ig0,Ih0,Iw0,...  (8-10)
%                 Fg0,Fh0, Fw0,...  (11-13)
%                 Rg0,Rh0,Rw0,...   (14-16)
%                 Dg0,Dh0,Dw0, ...   (17-19)
%                 Cincg0,Cincf0,Cinch0,Cincw0, ... (20-23)
%                 Cdiedg0,Cdiedh0,Cdiedw0,... (24-26)
%                 CHosp0];            %27
    params = [betaI,betaH,betaW, ... (1-3)
            omega, alpha, theta, ...   (4-6)
            gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, ... (7-12)
            MF,MH,fFG,fGH,fHG,...       (13-17)
            epsilon,KikwitGeneralPrev,KikwitNonhospPrev, E,... (18-21)
                    ControlParams, C,... (22-30)
                    tau];  %(31)
    
    if model== 0
        clear output;
        %initialize output
        %output = nan(29,MaxTime+1,MaxIt);
        parfor i = 1:MaxIt
            %display(i)
            % The main iteration 
            [T, pop]=Stoch_Iteration_intervention([0 MaxTime],initial,params, HospitalVisitors);
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
            [T, pop]=Diffeqn_Iteration_intervention([0 MaxTime],initial,params, HospitalVisitors);
            output=pop';
%             output.Sg=pop(:,1); output.Sf = pop(:,2); output.Sh = pop(:,3); output.Sw = pop(:,4); 
%             output.Eg=pop(:,5); output.Eh = pop(:,6); output.Ew = pop(:,7); 
%             output.Ig=pop(:,8); output.Ih = pop(:,9); output.Iw = pop(:,10);
%             output.Fg=pop(:,11);  output.Fh = pop(:,12); output.Fw=pop(:,13); 
%             output.Rg = pop(:,14); output.Rh = pop(:,15); output.Rw=pop(:,16);
%             output.Dg = pop(:,17); output.Dh = pop(:,18); output.Dw=pop(:,19);
%             output.Cincg = pop(:,20); output.Cincf = pop(:,21); output.Cinch = pop(:,22); output.Cincw=pop(:,23);
%             output.Cdiedg = pop(:,24); output.Cdiedh = pop(:,25); output.Cdiedw = pop(:,26);
%             output.CHosp = pop(:,27);
           % output.CHospDis = pop(:,34);
           
           %% OUTPUT
           
            %% SAVE OUTPUT
            CumulativeCases = output(20,(timepoints{1}+1)) + output(21,(timepoints{1}+1)) + output(22,(timepoints{1}+1));
            CumulativeDeaths = output(23,(timepoints{1}+1)) + output(24,(timepoints{1}+1)) + output(25,(timepoints{1}+1));
            CumulativeHealthworkerIncidence = output(22,timepoints{3}+1);
            CumulativeHospitalAdmissions = output(26,timepoints{4}+1);
            
%             CumulativeCases = reshape(CumulativeCases, 65, MaxIt);
%             CumulativeDeaths = reshape(CumulativeDeaths, 65, MaxIt);
%             CumulativeHealthworkerIncidence = reshape(CumulativeHealthworkerIncidence, 65, MaxIt);
%             CumulativeHospitalAdmissions = reshape(CumulativeHospitalAdmissions, 65, MaxIt);
            
%             CumulativeCases = output.Cincg(timepoints{1}+1) + output.Cincf(timepoints{1}+1) + output.Cinch(timepoints{1}+1) + output.Cincw(timepoints{1}+1);
%             CumulativeDeaths = output.Cdiedg(timepoints{2}+1) + output.Cdiedh(timepoints{2}+1) + output.Cdiedw(timepoints{2}+1);
% 
%             CumulativeHealthworkerIncidence = output.Cincw(timepoints{3}+1);
%             CumulativeHospitalAdmissions = output.CHosp(timepoints{4}+1);
            %CumulativeHospitalDischarges = output.CHospDis(timepoints{5}+1);
            
    end
        
    % get model output ready to passing
    FittingOut{1} = CumulativeCases';
    FittingOut{2} = CumulativeDeaths';
    FittingOut{3} = CumulativeHealthworkerIncidence';
    FittingOut{4} = CumulativeHospitalAdmissions';
    %modelout{5} = CumulativeHospitalDischarges;
    
    modelout{1} = FittingOut;
    modelout{2} = output;

end
