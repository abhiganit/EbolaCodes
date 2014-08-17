function modelout = EbolaModel(model, x, timepoints, MaxTime)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.
    
    % Model Parameters (Liberia where possible)
    
    % Estimated Parameters
    betaI = x(1);      % Transmission coefficient in community
    betaH = x(1);      % Transmission coefficient between patients or between HCWs
    betaW = x(2);      % Transmission coefficient between patients-HCWs
   % delta = x(4);      % Case fatality
    theta = x(3);      % Percentage of infectious cases are hospitaized
  
    %disease progression parameters
    alpha = 1/7;        % 1/alpha: mean duration of the incubation period 
    gammaI = 1/10;      % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/7;       % 1/gammaD: mean duration from onset to death
    
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    gammaH = 1/5;       % 1/gammaH: mean duration from symptom onset to hospitalization
    epsilon = 100/100;       % percentage Symptomatic illness 
    omega = 3.0;        % odds ratio of funeral risk relative to general population
    
    % population parameters
    KikwitGeneralPrev = 7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    KikwitNonhospPrev = 7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
    N0 = 4.09e6; %4.4e6;         % Initial population size
    M =  5 - 1;            % average family size (number of chances per person to be at each funeral)
    E = 62*365;          % average life expectancy in Liberia 
    
    %funeral/hospitalization parameters
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = 0; %62131 / (N0 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
    
    % dervied parameters
    gammaIH = 1/(1/gammaI - 1/gammaH);     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    gammaDH = 1/(1/gammaD - 1/gammaH);     % 1/gammaDH: mean duration from hospitalization to death
   % delta1 = delta*gammaI / (delta*gammaI + (1-delta)*gammaD);
   % delta2 = delta*gammaIH / (delta*gammaIH + (1-delta)*gammaDH);

    % Initial conditions
    Eg0 = 0; Ef0 = 0; Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4); If0 = 0; Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0; Ff0 = 0; Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0; Rf0 = 0; Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0; Df0 = 0; Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cincf0 = 0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0; Cdiedf0 = 0; Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;
    %CHospDis0 = 0;
    
    Sh0 = 20*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %
    
    % Algorithm parameters
    tau=1;
    MaxIt = 500;
    
    initial = [Sg0,Sf0,Sh0,Sw0,...  (1-4)
                Eg0,Ef0,Eh0,Ew0,... (5-8)
                Ig0,If0,Ih0,Iw0,...  (9-12)
                Fg0,Ff0,Fh0, Fw0,...  (13-16)
                Rg0,Rf0,Rh0,Rw0,...   (17-20)
                Dg0,Df0,Dh0,Dw0, ...   (21-24)
                Cincg0,Cincf0,Cinch0,Cincw0, ... (25-28)
                Cdiedg0,Cdiedf0,Cdiedh0,Cdiedw0,... (29-32)
                CHosp0];            %33
    params = [betaI,betaH,betaW, omega, alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, M,fFG,fGH,fHG,epsilon,KikwitGeneralPrev,KikwitNonhospPrev, E, tau]; %delta1,delta2,
    
    if model== 0
        clear output;
        %initialize output
        output = nan(33,65,10);
        parfor i = 1:MaxIt
            %display(i)
            % The main iteration 
            [~, pop]=Stoch_Iteration([0 MaxTime],initial,params);
            %% susceptible
            output(:,:,i)=pop';

        end
        
            
            %% SAVE OUTPUT
            CumulativeCases = output(25,(timepoints{1}+1),:) + output(26,(timepoints{1}+1),:) + output(27,(timepoints{1}+1),:) + output(28,(timepoints{1}+1),:);
            CumulativeDeaths = output(29,(timepoints{1}+1),:) + output(30,(timepoints{1}+1),:) + output(31,(timepoints{1}+1),:) + output(32,(timepoints{1}+1),:);
            CumulativeHealthworkerIncidence = output(28,timepoints{3}+1,:);
            CumulativeHospitalAdmissions = output(33,timepoints{4}+1,:);
            
            CumulativeCases = reshape(CumulativeCases, 65, MaxIt);
            CumulativeDeaths = reshape(CumulativeDeaths, 65, MaxIt);
            CumulativeHealthworkerIncidence = reshape(CumulativeHealthworkerIncidence, 65, MaxIt);
            CumulativeHospitalAdmissions = reshape(CumulativeHospitalAdmissions, 65, MaxIt);
            
    else
            % The main iteration (note as it is difference equation, we
            % only run it once)
            [~, pop]=Diffeqn_Iteration([0 MaxTime],initial,params);
        
            output.Sg=pop(:,1); output.Sf = pop(:,2); output.Sh = pop(:,3); output.Sw = pop(:,4); 
            output.Eg=pop(:,5); output.Ef = pop(:,6); output.Eh = pop(:,7); output.Ew = pop(:,8);
            output.Ig=pop(:,9); output.If = pop(:,10); output.Ih = pop(:,11); output.Iw = pop(:,12);
            output.Fg=pop(:,13); output.Ff = pop(:,14); output.Fh = pop(:,15); output.Fw=pop(:,16); 
            output.Rg = pop(:,17); output.Rf= pop(:,18); output.Rh = pop(:,19); output.Rw=pop(:,20);
            output.Dg = pop(:,21); output.Df = pop(:,22); output.Dh = pop(:,23); output.Dw=pop(:,24);
            output.Cincg = pop(:,25); output.Cincf = pop(:,26); output.Cinch = pop(:,27); output.Cincw=pop(:,28);
            output.Cdiedg = pop(:,29); output.Cdiedf = pop(:,30); output.Cdiedh = pop(:,31); output.Cdiedw = pop(:,32);
            output.CHosp = pop(:,33);
           % output.CHospDis = pop(:,34);
           
           %% OUTPUT
            CumulativeCases = output.Cincg(timepoints{1}+1) + output.Cincf(timepoints{1}+1) + output.Cinch(timepoints{1}+1) + output.Cincw(timepoints{1}+1);
            CumulativeDeaths = output.Cdiedg(timepoints{2}+1) + output.Cdiedf(timepoints{2}+1) + output.Cdiedh(timepoints{2}+1) + output.Cdiedw(timepoints{2}+1);

            CumulativeHealthworkerIncidence = output.Cincw(timepoints{3}+1);
            CumulativeHospitalAdmissions = output.CHosp(timepoints{4}+1);
            %CumulativeHospitalDischarges = output.CHospDis(timepoints{5}+1);
            
    end
        
    % get model output ready to passing
    modelout{1} = CumulativeCases;
    modelout{2} = CumulativeDeaths;
    modelout{3} = CumulativeHealthworkerIncidence;
    modelout{4} = CumulativeHospitalAdmissions;
    %modelout{5} = CumulativeHospitalDischarges;
    

end
