function EbolaModelRunVaccTx_delay30   
tic;  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data
    [~, ~, ~, ~] = CleanData();

    % set up parameters
    MaxIt = 2; %2^10;
    duration = 365;
    timeset = 0:duration;
    timesets = repmat({timeset},1,4);

    Delay1 = 30;
    
    delayuntilintervention = Delay1; %intervention delay
    delayuntilimmunity = 14; %immunity delay
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% run model for 1 year  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% VACCINATION LOOP %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % no intervention
    modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), 1, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, 0, 0);
    %save outcomes
    cumulativecasesVACC_ni = modelout{1}{1};
    cumulativedeathsVACC_ni = modelout{1}{2};
    cumulativehcwincidenceVACC_ni = modelout{1}{3};
    cumulativehospadmissionVACC_ni = modelout{1}{4};
    currenthcwVACC_ni = modelout{1}{5};
    totalvaccinedosesVACC_ni = modelout{1}{6};
    currenthospitalizationsVACC_ni = modelout{1}{8};
    currentebolahospitalizationsVACC_ni = modelout{1}{9};
    
    
    allVSuccess = linspace(0,1,11);
    indexVESuccess = 0;
    for VESuccess = allVSuccess
        indexVESuccess = indexVESuccess+1;
            modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), 1, MaxIt, delayuntilintervention, delayuntilimmunity, VESuccess, 1, 0, 0);
            %save outcomes
            cumulativecasesVACC{indexVESuccess} = modelout{1}{1};
            cumulativedeathsVACC{indexVESuccess} = modelout{1}{2};
            cumulativehcwincidenceVACC{indexVESuccess} = modelout{1}{3};
            cumulativehospadmissionVACC{indexVESuccess} = modelout{1}{4};
            currenthcwVACC{indexVESuccess} = modelout{1}{5};
            totalvaccinedosesVACC{indexVESuccess} = modelout{1}{6};
            currenthospitalizationsVACC{indexVESuccess} = modelout{1}{8};
            currentebolahospitalizationsVACC{indexVESuccess} = modelout{1}{9};
    end

    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% TREATMENT LOOP %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
    %%%% No Intervention
    modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), 1, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, 0, 0);
    %save outcomes
    cumulativecasesTX_ni = modelout{1}{1};
    cumulativedeathsTX_ni = modelout{1}{2};
    cumulativehcwincidenceTX_ni = modelout{1}{3};
    cumulativehospadmissionTX_ni = modelout{1}{4};
    currenthcwTX_ni = modelout{1}{5};
    totaltreatmentdosesTX_ni = modelout{1}{7};
    currenthospitalizationsTX_ni = modelout{1}{8};
    currentebolahospitalizationsTX_ni = modelout{1}{9};
        
    allTE = linspace(0.1,1,10);
    allTCov = linspace(0.2,1,5);
                

        delayuntilintervention = Delay1;
        delayuntilimmunity = 0;
        indexTE = 0;
        for TE = allTE
            indexTE = indexTE+1;
            indexTCov = 0;
            for TCov = allTCov 
                indexTCov = indexTCov+1;
                modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), 1, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, TE, TCov);
                %save outcomes
                cumulativecasesTX{indexTE, indexTCov} = modelout{1}{1};
                cumulativedeathsTX{indexTE, indexTCov} = modelout{1}{2};
                cumulativehcwincidenceTX{indexTE, indexTCov} = modelout{1}{3};
                cumulativehospadmissionTX{indexTE, indexTCov} = modelout{1}{4};
                currenthcwTX{indexTE, indexTCov} = modelout{1}{5};
                totaltreatmentdosesTX{indexTE, indexTCov} = modelout{1}{7};
                currenthospitalizationsTX{indexTE, indexTCov} = modelout{1}{8};
                currentebolahospitalizationsTX{indexTE, indexTCov} = modelout{1}{9};
               
            end
        end
    
    
    save('VaccTreatmentStochResults_delay30',... 
        'cumulativecasesVACC','cumulativecasesTX',...
        'cumulativedeathsVACC','cumulativedeathsTX',...
        'cumulativehcwincidenceVACC','cumulativehcwincidenceTX',...
        'cumulativehospadmissionVACC','cumulativehospadmissionTX',...
        'currenthcwVACC','currenthcwTX',...
        'totalvaccinedosesVACC','totaltreatmentdosesTX',...
        'currenthospitalizationsVACC','currenthospitalizationsTX',...
        'currentebolahospitalizationsVACC','currentebolahospitalizationsTX',...
        'cumulativecasesVACC_ni','cumulativecasesTX_ni',...
        'cumulativedeathsVACC_ni','cumulativedeathsTX_ni',...
        'cumulativehcwincidenceVACC_ni','cumulativehcwincidenceTX_ni',...
        'cumulativehospadmissionVACC_ni','cumulativehospadmissionTX_ni',...
        'currenthcwVACC_ni','currenthcwTX_ni',...
        'totalvaccinedosesVACC_ni','totaltreatmentdosesTX_ni',...
        'currenthospitalizationsVACC_ni','currenthospitalizationsTX_ni',...
        'currentebolahospitalizationsVACC_ni','currentebolahospitalizationsTX_ni');

    h= toc;
    sprintf('Run time: %f mins', h/60)
    
end

function eps = EstimatedParameters()

    load('paramest');
    eps = x;

end

function ic = Initial(x)
    
% Initial conditions
    N0 = 4.09e6;           % Initial population size    
    %N0 = 1.14e6;          % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4);    Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;    Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;    Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;    Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0;Iht0 = 0; Iwt0 = 0;
    V0 = 0;
    T0 = 0; Tf0 = 0; Tr0 = 0; Td0 = 0;
    Sh0 = 5*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
    CT0 = 0;
    ic =  [Sg0,Sf0,Sh0,Sw0,...  (1-4)
                Eg0,Eh0,Ew0,... (5-7)
                Ig0,Ih0,Iw0,...  (8-10)
                Fg0,Fh0, Fw0,...  (11-13)
                Rg0,Rh0,Rw0,...   (14-16)
                Dg0,Dh0,Dw0, ...   (17-19)
                Cincg0,Cinch0,Cincw0, ... (20-22)
                Cdiedg0,Cdiedh0,Cdiedw0,... (23-25)
                CHosp0, Iht0, Iwt0,...%26-28
                V0, T0, Tf0, Tr0, Td0,...%29-33
                CT0];            %34
end