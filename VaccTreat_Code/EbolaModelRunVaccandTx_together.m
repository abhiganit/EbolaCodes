function EbolaModelRunVaccandTx_together
    tic;  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data
    %[~, ~, ~, ~] = CleanData();

    % set up parameters
    MaxIt = 2^10;
    duration = 182 + ceil(365/2);
    timeset = 0:duration;
    timesets = repmat({timeset},1,4);

    delayuntilintervention = 0;
    delayuntilimmunity = 0;
    
    HospitalVisitors = 0;
    %intervention immunity
    delays = [182 14];
%               91 14;
%               183 14];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% run model for 1 year  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% VACCINATION AND TREATMENT LOOP %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% No Intervention
    modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, 0, 0, 0, 0);
    %save outcomes
    cumulativecasesTXVACC_ni = modelout{1}{1};
    cumulativedeathsTXVACC_ni = modelout{1}{2};
    cumulativehcwincidenceTXVACC_ni = modelout{1}{3};
    cumulativehospadmissionTXVACC_ni = modelout{1}{4};
    currenthcwTXVACC_ni = modelout{1}{5};
    totalvaccinedosesTXVACC_ni = modelout{1}{6};
    totaltreatmentdosesTXVACC_ni = modelout{1}{7};
    currenthospitalizationsTXVACC_ni = modelout{1}{8};
    currentebolahospitalizationsTXVACC_ni = modelout{1}{9};
    
    allVESuccess = [0.45,0.90]; %linspace(0,1,11);
    allTE = linspace(0.1,1,10);
    allTCov = linspace(0.2,1,5);
                
    %for i = 1:size(delays,1)
        delayuntilintervention = delays(1,1);
        delayuntilimmunity = delays(1,2);
        indexVESuccess = 0;
        for VESuccess = allVESuccess;
            indexVESuccess = indexVESuccess+1;
            indexTE = 0;
            for TE = allTE
                TE
                indexTE = indexTE+1;
                indexTCov = 0;
                for TCov = allTCov 
                    indexTCov = indexTCov+1;
                    modelout = EbolaModel(1, EstimatedParameters(), timesets, duration, Initial(EstimatedParameters()), HospitalVisitors, MaxIt, delayuntilintervention, delayuntilimmunity, VESuccess, 1, TE, TCov);
                    %save outcomes
                    cumulativecasesTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{1};
                    cumulativedeathsTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{2};
                    cumulativehcwincidenceTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{3};
                    cumulativehospadmissionTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{4};
                    currenthcwTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{5};
                    totalvaccinedosesTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{6};
                    totaltreatmentdosesTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{7};
                    currenthospitalizationsTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{8};
                    currentebolahospitalizationsTXVACC{indexVESuccess}{indexTE, indexTCov} = modelout{1}{9};

                end
            end
        end
   % end
    
    
    save('VaccTreatmentDetResultsTogether_delay182',... 
        'cumulativecasesTXVACC',...
        'cumulativedeathsTXVACC',...
        'cumulativehcwincidenceTXVACC',...
        'cumulativehospadmissionTXVACC',...
        'currenthcwTXVACC',...
        'totalvaccinedosesTXVACC',...
        'totaltreatmentdosesTXVACC',...
        'currenthospitalizationsTXVACC',...
        'currentebolahospitalizationsTXVACC',...
        'cumulativecasesTXVACC_ni',...
        'cumulativedeathsTXVACC_ni',...
        'cumulativehcwincidenceTXVACC_ni',...
        'cumulativehospadmissionTXVACC_ni',...
        'currenthcwTXVACC_ni',...
        'totalvaccinedosesTXVACC_ni',...
        'totaltreatmentdosesTXVACC_ni',...
        'currenthospitalizationsTXVACC_ni',...
        'currentebolahospitalizationsTXVACC_ni')

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