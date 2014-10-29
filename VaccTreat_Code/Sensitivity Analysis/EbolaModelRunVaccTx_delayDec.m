function[RelativeIncidence,MaxHCWRatio] = EbolaModelRunVaccTx_delayDec(x,y)
% x is estimated params
% y is passed params
    tic; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get data
    [~, ~, ~, ~] = CleanData();

    % set up parameters
    MaxIt = 2^10;
    duration = 365;
    timeset = 0:duration;
    timesets = repmat({timeset},1,4);

     delayuntilintervention = 182;
%     delayuntilimmunity = 0;
    
    %intervention immunity
    delays = [182 14];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% run model for 1 year  %%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%% TREATMENT LOOP %%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

    %cumulativecasesTX = cell(size(allTE, 2), size(allTCov, 2));
   
    %%%% No Intervention
    modelout = EbolaModel(1, x,y, timesets, duration, Initial(x,y), 0, MaxIt, 0, 0, 0, 0, 0, 0);
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
    
    
   
    modelout = EbolaModel(1, x,y, timesets, duration, Initial(x,y), 0, MaxIt, delayuntilintervention, 0, 0, 0, 0.5, 0.8);
    %save outcomes
    cumulativecasesTX = modelout{1}{1};
    cumulativedeathsTX = modelout{1}{2};
    cumulativehcwincidenceTX = modelout{1}{3};
    cumulativehospadmissionTX = modelout{1}{4};
    currenthcwTX = modelout{1}{5};
    totaltreatmentdosesTX = modelout{1}{7};
    currenthospitalizationsTX = modelout{1}{8};
    currentebolahospitalizationsTX = modelout{1}{9};

    cumulativegeneralincidenceTX = modelout{1}{10};
    cumulativehospincidenceTX = modelout{1}{11};
    cumulativegeneraldeathsTX = modelout{1}{12};
    cumulativehospdeathsTX = modelout{1}{13};
    cumulativehcwdeathsTX = modelout{1}{14};
           
    RelativeIncidence = cumulativecasesTX(end)./cumulativecasesTX_ni(end);
    MaxHCWRatio = max(currentebolahospitalizationsTX./currenthcwTX);
    h= toc;
    sprintf('Run time: %f mins', h/60)
end

% function eps = EstimatedParameters()
% 
%     load('paramest.mat');
%     eps = x;
% 
% end

function ic = Initial(x,y)
    
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
    Sh0 = 5*y(1);   Sf0 = 0; Sw0 = y(1);  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
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