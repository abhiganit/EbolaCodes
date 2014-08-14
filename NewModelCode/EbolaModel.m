function modelout = EbolaModel(model, beta, timepoints, MaxTime)
% model = 0 runs stochastic model where as model = 1 runs the difference
% equation.


    %% extract required data for model fit
    
    %tic;
    % Model Parameters (Liberia where possible)
    
    %% Estimated Parameters
    betaI = beta(1); %.200;    % Transmission coefficient in community
    betaH = beta(2);
    betaW = beta(3);
    delta = beta(4); %51/100;     % case fatality
    theta = beta(5); %67/100;       % Percentage of infectious cases are hospitaized
    %betaH = .200;   % Transmission coefficient for hospital goers/patients
    %betaW = .200;    % Transmission coefficient for hospital/ebola treatment workers
    %betaF = .02;    %/7;% 7.653/7;   % Transmission coefficient during funerals with ebola patient
    
    omega = 3.0;
    alpha = 1/7;        % 1/alpha: mean duration of the incubation period  
    
    gammaH = 1/5;       % 1/gammaH: mean duration from symptom onset to hospitalization
    gammaI = 1/10;      % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/9.6;     % 1/gammaD: mean duration from onset to death
    gammaDH = 1/4.6;     % 1/gammaDH: mean duration from hospitalization to death
    gammaIH = 1/5;     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    
    %delta1 = 80/100;      % delta1 and delta2 calculated such that case fatality rate is delta
    %delta2 = 80/100;
    M =  5;            % average family size (number of chances per person to be at each funeral)
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = 90272 / (67.8e6 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
    epsilon = 90/100;       % percentage Symptomatic illness 
    
    KikwitPrev = 7.81e-6;
    delta1 = delta*gammaI / (delta*gammaI + (1-delta)*gammaD);
    delta2 = delta*gammaIH / (delta*gammaIH + (1-delta)*gammaDH);

    N0 = 4.4e6;         % Initial population size
    
    % Initial conditions
    Eg0 = 0; Ef0 = 0; Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = 5; If0 = 0; Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0; Ff0 = 0; Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0; Rf0 = 0; Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0; Df0 = 0; Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cincf0 = 0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0; Cdiedf0 = 0; Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;
    CHospDis0 = 0;
    
    Sh0 = 5*(2.8/10000)*N0; Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0; 
    
    % Tau and maximum time taken
    tau=1;
    MaxIt = 10;

    initial = [Sg0,Sf0,Sh0,Sw0,Eg0,Ef0,Eh0,Ew0,Ig0,If0,Ih0,Iw0,Fg0,Ff0,Fh0, Fw0,Rg0,Rf0,Rh0,Rw0,Dg0,Df0,Dh0,Dw0, Cincg0,Cincf0,Cinch0,Cincw0, Cdiedg0,Cdiedf0,Cdiedh0,Cdiedw0,CHosp0,CHospDis0];

    params = [betaI,betaH,betaW, omega, alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,M,fFG,fGH,fHG,epsilon,KikwitPrev,tau];
    
    if model== 0
        for i= 1:MaxIt
            % The main iteration 
            [~, pop]=Stoch_Iteration([0 MaxTime],initial,params);
        
            output.Sg(:,i)=pop(:,1); output.Sf(:,i) = pop(:,2); output.Sh(:,i) = pop(:,3); output.Sw(:,i) = pop(:,4); 
            output.Eg(:,i)=pop(:,5); output.Ef(:,i) = pop(:,6); output.Eh(:,i) = pop(:,7); output.Ew(:,i) = pop(:,8);
            output.Ig(:,i)=pop(:,9); output.If(:,i) = pop(:,10); output.Ih(:,i) = pop(:,11); output.Iw(:,i) = pop(:,12);
            output.Fg(:,i)=pop(:,13); output.Ff(:,i) = pop(:,14); output.Fh(:,i) = pop(:,15); output.Fw(:,i)=pop(:,16); 
            output.Rg(:,i) = pop(:,17); output.Rf(:,i)= pop(:,18); output.Rh(:,i) = pop(:,19); output.Rw(:,i)=pop(:,20);
            output.Dg(:,i) = pop(:,21); output.Df(:,i) = pop(:,22); output.Dh(:,i) = pop(:,23); output.Dw(:,i)=pop(:,24);
            output.Cincg(:,i) = pop(:,25); output.Cf(:,i) = pop(:,26); output.Ch(:,i) = pop(:,27); output.Cw(:,i)=pop(:,28);
            output.Cdiedg(:,i) = pop(:,29); output.Cdiedf(:,i) = pop(:,30); output.Cdiedh(:,i) = pop(:,31); output.Cdiedw(:,i) = pop(:,32);
            output.CHosp(:,i) = pop(:,33);
            output.CHospDis(:,i) = pop(:,34);

        end
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
            output.CHospDis = pop(:,34);
            
    end
        
    %plotFigures(t, output, incidence)
    %% OUTPUT
    CumulativeCases = output.Cincg(timepoints{1}+1) + output.Cincf(timepoints{1}+1) + output.Cinch(timepoints{1}+1) + output.Cincw(timepoints{1}+1);
    CumulativeDeaths = output.Cdiedg(timepoints{2}+1) + output.Cdiedf(timepoints{2}+1) + output.Cdiedh(timepoints{2}+1) + output.Cdiedw(timepoints{2}+1);
                        
    CumulativeHealthworkerIncidence = output.Cincw(timepoints{3}+1);
    CumulativeHospitalAdmissions = output.CHosp(timepoints{4}+1);
    CumulativeHospitalDischarges = output.CHospDis(timepoints{5}+1);
    
    modelout{1} = CumulativeCases;
    modelout{2} = CumulativeDeaths;
    modelout{3} = CumulativeHealthworkerIncidence;
    modelout{4} = CumulativeHospitalAdmissions;
    modelout{5} = CumulativeHospitalDischarges;
%    figure;
%    subplot(2,1,1)
%     plot(timepoints{1}, modelout{1})
%        subplot(2,1,2)
%     plot(timepoints{2}, modelout{2})
end
