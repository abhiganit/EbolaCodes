function EbolaModelRunVaccTx
    tic;  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data
    [~, ~, ~, ~] = CleanData();

    % set up parameters
    MaxIt = 1; %2^10;
    duration = 182 + ceil(365/2);  %run up to 1st Dec then another 6 months
    timeset = 0:duration;
    timesets = repmat({timeset},1,4);

    delayuntilintervention = 0;
    delayuntilimmunity = 0;
    
    %intervention immunity
%      delays = [30 14;
%                91 14;
%                183 14];
   %% 1st December, 1st February
    delays = [182 14;
             244 14];
   
   HospitalVisitors = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% run model for 1 year  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% VACCINATION LOOP %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % no intervention
    modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, 0, 0);
    %save outcomes
    cumulativecasesVACC_ni = modelout{1}{1};
    cumulativedeathsVACC_ni = modelout{1}{2};
    cumulativehcwincidenceVACC_ni = modelout{1}{3};
    cumulativehospadmissionVACC_ni = modelout{1}{4};
    currenthcwVACC_ni = modelout{1}{5};
    totalvaccinedosesVACC_ni = modelout{1}{6};
    currenthospitalizationsVACC_ni = modelout{1}{8};
    currentebolahospitalizationsVACC_ni = modelout{1}{9};
    
    cumulativegeneralincidenceVACC_ni = modelout{1}{10};
    cumulativehospincidenceVACC_ni = modelout{1}{11};
    cumulativegeneraldeathsVACC_ni = modelout{1}{12};
    cumulativehospdeathsVACC_ni = modelout{1}{13};
    cumulativehcwdeathsVACC_ni = modelout{1}{14};
    
    allVSuccess = linspace(0,1,11);
    %allVCov = linspace(0,1,6);

   % cumulativecasesVACC = cell(size(allVE, 2), size(allVCov, 2));
    

    for i = 1:size(delays,1)
        delayuntilintervention = delays(i,1);
        delayuntilimmunity = delays(i,2);
        indexVESuccess = 0;
        for VESuccess = allVSuccess
            indexVESuccess = indexVESuccess+1;
                modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, VESuccess, 1, 0, 0);
                %save outcomes
                cumulativecasesVACC{i}{indexVESuccess} = modelout{1}{1};
                cumulativedeathsVACC{i}{indexVESuccess} = modelout{1}{2};
                cumulativehcwincidenceVACC{i}{indexVESuccess} = modelout{1}{3};
                cumulativehospadmissionVACC{i}{indexVESuccess} = modelout{1}{4};
                currenthcwVACC{i}{indexVESuccess} = modelout{1}{5};
                totalvaccinedosesVACC{i}{indexVESuccess} = modelout{1}{6};
                currenthospitalizationsVACC{i}{indexVESuccess} = modelout{1}{8};
                currentebolahospitalizationsVACC{i}{indexVESuccess} = modelout{1}{9};
                
                cumulativegeneralincidenceVACC{i}{indexVESuccess} = modelout{1}{10};
                cumulativehospincidenceVACC{i}{indexVESuccess} = modelout{1}{11};
                cumulativegeneraldeathsVACC{i}{indexVESuccess} = modelout{1}{12};
                cumulativehospdeathsVACC{i}{indexVESuccess} = modelout{1}{13};
                cumulativehcwdeathsVACC{i}{indexVESuccess} = modelout{1}{14};
        end
    end
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% TREATMENT LOOP %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    %cumulativecasesTX = cell(size(allTE, 2), size(allTCov, 2));
   
    %%%% No Intervention
    modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, 0, 0);
    %save outcomes
    cumulativecasesTX_ni = modelout{1}{1};
    cumulativedeathsTX_ni = modelout{1}{2};
    cumulativehcwincidenceTX_ni = modelout{1}{3};
    cumulativehospadmissionTX_ni = modelout{1}{4};
    currenthcwTX_ni = modelout{1}{5};
    totaltreatmentdosesTX_ni = modelout{1}{7};
    currenthospitalizationsTX_ni = modelout{1}{8};
    currentebolahospitalizationsTX_ni = modelout{1}{9};
    
    cumulativegeneralincidenceTX_ni = modelout{1}{10};
    cumulativehospincidenceTX_ni = modelout{1}{11};
    cumulativegeneraldeathsTX_ni = modelout{1}{12};
    cumulativehospdeathsTX_ni = modelout{1}{13};
    cumulativehcwdeathsTX_ni = modelout{1}{14};
    
    
    allTE = linspace(0.1,1,10);
    allTCov = linspace(0.2,1,5);
                
    for i = 1:size(delays,1)
        delayuntilintervention = delays(i,1);
        delayuntilimmunity = 0;
        indexTE = 0;
        for TE = allTE
            indexTE = indexTE+1;
            indexTCov = 0;
            for TCov = allTCov 
                indexTCov = indexTCov+1;
                modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, TE, TCov);
                %save outcomes
                cumulativecasesTX{i}{indexTE, indexTCov} = modelout{1}{1};
                cumulativedeathsTX{i}{indexTE, indexTCov} = modelout{1}{2};
                cumulativehcwincidenceTX{i}{indexTE, indexTCov} = modelout{1}{3};
                cumulativehospadmissionTX{i}{indexTE, indexTCov} = modelout{1}{4};
                currenthcwTX{i}{indexTE, indexTCov} = modelout{1}{5};
                totaltreatmentdosesTX{i}{indexTE, indexTCov} = modelout{1}{7};
                currenthospitalizationsTX{i}{indexTE, indexTCov} = modelout{1}{8};
                currentebolahospitalizationsTX{i}{indexTE, indexTCov} = modelout{1}{9};
               
                cumulativegeneralincidenceTX{i}{indexTE, indexTCov} = modelout{1}{10};
                cumulativehospincidenceTX{i}{indexTE, indexTCov} = modelout{1}{11};
                cumulativegeneraldeathsTX{i}{indexTE, indexTCov} = modelout{1}{12};
                cumulativehospdeathsTX{i}{indexTE, indexTCov} = modelout{1}{13};
                cumulativehcwdeathsTX{i}{indexTE, indexTCov} = modelout{1}{14};
            end
        end
    end
    
    
    save('VaccTreatmentDetResults',... 
        'cumulativecasesVACC','cumulativecasesTX',...
        'cumulativedeathsVACC','cumulativedeathsTX',...
        'cumulativehcwincidenceVACC','cumulativehcwincidenceTX',...
        'cumulativehospadmissionVACC','cumulativehospadmissionTX',...
        'currenthcwVACC','currenthcwTX',...
        'totalvaccinedosesVACC','totaltreatmentdosesTX',...
        'currenthospitalizationsVACC','currenthospitalizationsTX',...
        'currentebolahospitalizationsVACC','currentebolahospitalizationsTX',...
        'cumulativegeneralincidenceVACC', 'cumulativegeneralincidenceTX',...
        'cumulativehospincidenceVACC', 'cumulativehospincidenceTX',...    
        'cumulativegeneraldeathsVACC','cumulativegeneraldeathsTX',...
        'cumulativehospdeathsVACC','cumulativehospdeathsTX',...
        'cumulativehcwdeathsVACC', 'cumulativehcwdeathsTX',... 
        'cumulativecasesVACC_ni','cumulativecasesTX_ni',...
        'cumulativedeathsVACC_ni','cumulativedeathsTX_ni',...
        'cumulativehcwincidenceVACC_ni','cumulativehcwincidenceTX_ni',...
        'cumulativehospadmissionVACC_ni','cumulativehospadmissionTX_ni',...
        'currenthcwVACC_ni','currenthcwTX_ni',...
        'totalvaccinedosesVACC_ni','totaltreatmentdosesTX_ni',...
        'currenthospitalizationsVACC_ni','currenthospitalizationsTX_ni',...
        'currentebolahospitalizationsVACC_ni','currentebolahospitalizationsTX_ni',...
        'cumulativegeneralincidenceVACC_ni', 'cumulativegeneralincidenceTX_ni',...
        'cumulativehospincidenceVACC_ni', 'cumulativehospincidenceTX_ni',...    
        'cumulativegeneraldeathsVACC_ni','cumulativegeneraldeathsTX_ni',...
        'cumulativehospdeathsVACC_ni','cumulativehospdeathsTX_ni',...
        'cumulativehcwdeathsVACC_ni', 'cumulativehcwdeathsTX_ni');

    h= toc;
    sprintf('Run time: %f mins', h/60)
end

function eps = EstimatedParameters()

    load('Fitting/paramest.mat');
    %load('paramest.mat');
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