function [] = EbolaModel()

    % Model Parameters
    betaI = 0.588/7;   % Transmission coefficient in community
    betaH1 = 0.794/7;   % Transmission coefficient for hospital goers/patients
    betaW = 0.794/7;   % Transmission coefficient for hospital/ebola treatment workers
    betaF = 0.8; %/7;% 7.653/7;   % Transmission coefficient during funerals
    alpha = 1/7;       % 1/alpha: mean duration of the incubation period  
    theta = 0.67;      % Percentage/proportion of infectious cases are hospitaized
    gammaH = 1/5;      % 1/gammaH: mean duration from symptom onset to hospitalization
    gammaI = 1/10;     % 1/gammaI: mean duration of the infectious period for survivors
    gammaD = 1/9.6;    % 1/gammaD: mean duration from onset to death
    gammaDH = 1/10;    % 1/gammaDH: mean duration from hospitalization to death
    gammaIH = 1/10;    % 1/gammaIH: mean duration from hospotalization to end of infectiousness
    gammaF  = 1/2;     % 1/gammaF: mean duration from death to burial
    delta1 = 0.8;      % delta1 and delta2 calculated such that case fatality rate is delta
    delta2 = 0.8;
    fGF =  0.4;          % average number of individuals affected by each funeral
    fFG = 0.6;           % flow rate from Sf to Sg
    fGH = 0.6;           % flow rate from Sg to Sh
    fHG = 0.5;           % flow rate from Sh to Sg
    epslon = 0.1;         % asymptotic illness proportion

    N0 = 200000; % Initial population size
    % Initial conditions
    Sg0 = N0; Sf0 = 0; Sh0 = 0; Sw0 = 10; 
    Eg0 = 0; Ef0 = 0; Eh0 = 0; Ew0 = 0; 
    Ig0 = 3; If0 = 0; Ih0 = 0; Iw0 = 0;
    Fg0 = 0; Ff0 = 0; Fh0 = 0; Fw0 = 0;
    Rg0 = 0; Rf0 = 0; Rh0 = 0; Rw0 = 0;
    Dg0 = 0; Df0 = 0; Dh0 = 0; Dw0 = 0;
    % Tau and maximum time taken
    tau=1;
    MaxTime=1*365;
    MaxIt = 20;

    initial = [Sg0,Sf0,Sh0,Sw0,Eg0,Ef0,Eh0,Ew0,Ig0,If0,Ih0,Iw0,Fg0,Ff0,Fh0, Fw0,Rg0,Rf0,Rh0,Rw0,Dg0,Df0,Dh0,Dw0];

    params = [betaI,betaH1,betaW, betaF,alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,fGF,fFG,fGH,fHG,epslon,tau];

    for i= 1:MaxIt
        % The main iteration 
        [t, pop]=Stoch_Iteration([0 MaxTime],initial,params);
        
        output.Sg(:,i)=pop(:,1); output.Sf(:,i) = pop(:,2); output.Sh(:,i) = pop(:,3); output.Sw(:,i) = pop(:,4); 
        output.Eg(:,i)=pop(:,5); output.Ef(:,i) = pop(:,6); output.Eh(:,i) = pop(:,7); output.Ew(:,i) = pop(:,8);
        output.Ig(:,i)=pop(:,9); output.If(:,i) = pop(:,10); output.Ih(:,i) = pop(:,11); output.Iw(:,i) = pop(:,12);
        output.Fg(:,i)=pop(:,13); output.Ff(:,i) = pop(:,14); output.Fh(:,i) = pop(:,15); output.Fw(:,i)=pop(:,16); 
        output.Rg(:,i) = pop(:,17); output.Rf(:,i)= pop(:,18); output.Rh(:,i) = pop(:,19); output.Rw(:,i)=pop(:,20);
        output.Dg(:,i) = pop(:,21); output.Df(:,i) = pop(:,22); output.Dh(:,i) = pop(:,23); output.Dw(:,i)=pop(:,24);
    end

    plotFigures(t, output)


end
