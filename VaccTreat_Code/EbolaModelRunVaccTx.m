function EbolaModelRunVaccTx
    tic;  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data
    [~, ~, ~, ~] = CleanData();

    % set up parameters
    MaxIt = 32;
    duration = 365;
    timeset = 0:duration;
    timesets = repmat({timeset},1,4);

    delayuntilintervention = 0;
    delayuntilimmunity = 0;
    
    %intervention immunity
    delays = [0 0;
              0 28;
              14 28;
              28 28;
              42 28];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% run model for 1 year  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% VACCINATION LOOP %%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     allVE = 0:0.1:1;
%     allVCov = 0:0.1:1;
    allVE = linspace(0,1,6);
    allVCov = linspace(0,1,6);

   % cumulativecasesVACC = cell(size(allVE, 2), size(allVCov, 2));
    

    for i = 1:size(delays,1)
        delayuntilintervention = delays(i,1);
        delayuntilimmunity = delays(i,2);
        indexVE = 0;
        for VE = allVE
            indexVE = indexVE+1;
            indexVCov = 0;
            for VCov = allVCov 
                indexVCov = indexVCov+1;
                modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(), 1, MaxIt, delayuntilintervention, delayuntilimmunity, VE, VCov, 0, 0);
                %save outcomes
                cumulativecasesVACC{i}{indexVE, indexVCov} = modelout{1}{1};
                cumulativedeathsVACC{i}{indexVE, indexVCov} = modelout{1}{2};
                cumulativehcwincidenceVACC{i}{indexVE, indexVCov} = modelout{1}{3};
                cumulativehospadmissionVACC{i}{indexVE, indexVCov} = modelout{1}{4};
                currenthcwVACC{i}{indexVE, indexVCov} = modelout{1}{5};
                totalvaccinedosesVACC{i}{indexVE, indexVCov} = modelout{1}{6};
                currenthospitalizationsVACC{i}{indexVE, indexVCov} = modelout{1}{8};
                currentebolahospitalizationsVACC{i}{indexVE, indexVCov} = modelout{1}{9};
               
            end
        end
    end
    
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% TREATMENT LOOP %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     allTE = 0:0.1:1;
%     allTCov = 0:0.1:1;
    allTE = linspace(0,1,6);
   allTCov = linspace(0,1,6);

    %cumulativecasesTX = cell(size(allTE, 2), size(allTCov, 2));
   
    for i = 2:size(delays,1)
        delayuntilintervention = delays(i,1);
        delayuntilimmunity = 0;
        indexTE = 0;
        for TE = allTE
            indexTE = indexTE+1;
            indexTCov = 0;
            for TCov = allTCov 
                indexTCov = indexTCov+1;
                modelout = EbolaModel(0, EstimatedParameters(), timesets, duration, Initial(), 1, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, TE, TCov);
                %save outcomes
                cumulativecasesTX{i-1}{indexTE, indexTCov} = modelout{1}{1};
                cumulativedeathsTX{i-1}{indexTE, indexTCov} = modelout{1}{2};
                cumulativehcwincidenceTX{i-1}{indexTE, indexTCov} = modelout{1}{3};
                cumulativehospadmissionTX{i-1}{indexTE, indexTCov} = modelout{1}{4};
                currenthcwTX{i-1}{indexTE, indexTCov} = modelout{1}{5};
                totaltreatmentdosesTX{i-1}{indexTE, indexTCov} = modelout{1}{7};
                currenthospitalizationsTX{i-1}{indexTE, indexTCov} = modelout{1}{8};
                currentebolahospitalizationsTX{i-1}{indexTE, indexTCov} = modelout{1}{9};
               
            end
        end
    end
    
    
    save('VaccTreatmentStochResults', 'cumulativecasesVACC','cumulativecasesTX',...
        'cumulativedeathsVACC','cumulativedeathsTX','cumulativehcwincidenceVACC','cumulativehcwincidenceTX'...
        ,'cumulativehospadmissionVACC','cumulativehospadmissionTX','currenthcwVACC','currenthcwTX',...
        'totalvaccinedosesVACC','totaltreatmentdosesTX','currenthospitalizationsVACC',...
        'currenthospitalizationsTX','currentebolahospitalizationsVACC','currentebolahospitalizationsTX')
    h= toc;
    sprintf('Run time: %f mins', h/60)
end

function eps = EstimatedParameters()

    load('paramest');
    eps = x;

end

function ic = Initial
    
% Initial conditions
    N0 = 4.09e6;           % Initial population size    
    %N0 = 1.14e6;          % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = 1;    Ih0 = 0; Iw0 = 0;         % infected
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