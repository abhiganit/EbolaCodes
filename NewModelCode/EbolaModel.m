function [] = EbolaModel()

    % Model Parameters (Liberia where possible)
    betaI = 1.000;    % Transmission coefficient in community
    betaH = 1.000;   % Transmission coefficient for hospital goers/patients
    betaW = 1.000;    % Transmission coefficient for hospital/ebola treatment workers
    betaF = 1.000;    %/7;% 7.653/7;   % Transmission coefficient during funerals with ebola patient
    alpha = 1/7;        % 1/alpha: mean duration of the incubation period  
    theta = 67/100;       % Percentage of infectious cases are hospitaized
    gammaH = 1/5;       % 1/gammaH: mean duration from symptom onset to hospitalization
    gammaI = 1/10;      % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/9.6;     % 1/gammaD: mean duration from onset to death
    gammaDH = 1/4.6;     % 1/gammaDH: mean duration from hospitalization to death
    gammaIH = 1/5;     % 1/gammaIH: mean duration from hospitalization to end of infectiousness
    gammaF  = 1/2;      % 1/gammaF: mean duration from death to burial
    delta1 = 80/100;      % delta1 and delta2 calculated such that case fatality rate is delta
    delta2 = 80/100;
    fGF =  5;            % average family size (number of chances per person to be at each funeral)
    fFG = 1/2;          % 1/average time spent at close quarters with body at funeral
    fGH = 90272 / (67.8e6 * 365);  % rate of hospitalization per person per day (DRC 2012 estimates)
    fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
    epsilon = 10/100;       % percentage Symptotic illness 

    N0 = 4.4e6;         % Initial population size
    
    % Initial conditions
    Eg0 = 0; Ef0 = 0; Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = 1; If0 = 0; Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0; Ff0 = 0; Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0; Rf0 = 0; Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0; Df0 = 0; Dh0 = 0; Dw0 = 0;         % died:buried
    Cg0 = Ig0; Cf0 = 0; Ch0 = 0; Cw0 = 0;       % cumulative incidence
    
    Sh0 = 3*(0.1/10000)*N0; Sf0 = 0; Sw0 = (0.1/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0; 
    
    % Tau and maximum time taken
    tau=1;
    MaxTime=1*365;
    MaxIt = 10;

    initial = [Sg0,Sf0,Sh0,Sw0,Eg0,Ef0,Eh0,Ew0,Ig0,If0,Ih0,Iw0,Fg0,Ff0,Fh0, Fw0,Rg0,Rf0,Rh0,Rw0,Dg0,Df0,Dh0,Dw0, Cg0,Cf0,Ch0,Cw0];

    params = [betaI,betaH,betaW, betaF,alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,fGF,fFG,fGH,fHG,epsilon,tau];

    for i= 1:MaxIt
        % The main iteration 
        [t, pop]=Stoch_Iteration([0 MaxTime],initial,params);
        
        output.Sg(:,i)=pop(:,1); output.Sf(:,i) = pop(:,2); output.Sh(:,i) = pop(:,3); output.Sw(:,i) = pop(:,4); 
        output.Eg(:,i)=pop(:,5); output.Ef(:,i) = pop(:,6); output.Eh(:,i) = pop(:,7); output.Ew(:,i) = pop(:,8);
        output.Ig(:,i)=pop(:,9); output.If(:,i) = pop(:,10); output.Ih(:,i) = pop(:,11); output.Iw(:,i) = pop(:,12);
        output.Fg(:,i)=pop(:,13); output.Ff(:,i) = pop(:,14); output.Fh(:,i) = pop(:,15); output.Fw(:,i)=pop(:,16); 
        output.Rg(:,i) = pop(:,17); output.Rf(:,i)= pop(:,18); output.Rh(:,i) = pop(:,19); output.Rw(:,i)=pop(:,20);
        output.Dg(:,i) = pop(:,21); output.Df(:,i) = pop(:,22); output.Dh(:,i) = pop(:,23); output.Dw(:,i)=pop(:,24);
        output.Cg(:,i) = pop(:,25); output.Cf(:,i) = pop(:,26); output.Ch(:,i) = pop(:,27); output.Cw(:,i)=pop(:,28);
    end

    % Output Incidence
    Incidence.Cg = diff(output.Cg);
    Incidence.Cf = diff(output.Cf);
    Incidence.Ch = diff(output.Ch);
    Incidence.Cw = diff(output.Cw);
    
    % Plotting
    plotFigures(t, output)
    

end
