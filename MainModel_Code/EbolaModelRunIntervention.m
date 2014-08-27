function EbolaModelRunIntervention

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();

% set up parameters
MaxIt = 10;
numberofstrategies = 9;
interventionduration = 365;
frequency = 4;
preinterventiontime = max(timesets_nointervention{1});
timeset = 0:(preinterventiontime+interventionduration);
timesets_intervention0 = repmat({timeset},1,4);
timesets_intervention = repmat({0:interventionduration},1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% run model with no intervention  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initial_conditions = InitializeNoIntervention(EstimatedParameters());
model_nointervention = EbolaModel(1, EstimatedParameters(), timesets_intervention0, preinterventiontime+interventionduration, initial_conditions, 1, MaxIt);
nointervention_cases = repmat({model_nointervention{1}{1}}, 1, numberofstrategies);
preintervention_cases = cellfun( @(a)a(1:(maxtime+1),:), nointervention_cases, 'UniformOutput', false);
postintervention_cases = cellfun( @(a)a((maxtime+1):(maxtime+interventionduration+1),:), nointervention_cases, 'UniformOutput', false);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize intervention runs
initializemat = zeros(interventionduration+1, frequency);
intervention_cases = repmat({initializemat}, 1, numberofstrategies);
allruns = model_nointervention{2};
InitialSetUpForEveryIntervention = InitializeIntervention(allruns(:,maxtime+1));

% loop around the interventions
for intervention_type = 1:numberofstrategies
    
    for intervention_level = 1:frequency
        % phiW and phiG
        if intervention_type == 4 %5
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(3) = 0.8; %1.0;    %phiW
            %startingpoint = 0.7;  %phiG
            variables = [0.50, 0.65, 0.80, 0.95]; %[0.95 0.97 0.99 1];
            controlparams(2) = variables(intervention_level); %min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %phiG
        % pH and phG
        elseif intervention_type == 5 %6
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            %controlparams(6) = 0.9;    %pH
            %startingpoint = 0.0;        %pG
            variables = [0.8, 0.85, 0.90, 0.95];
            controlparams(6) = variables(intervention_level); %min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %pH
        % iH 
        elseif intervention_type == 6 %4
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            %controlparams(1) = 0.9;  %iH
            %startingpoint = 0.5;    %phiC
            variables = [0.8 0.85 0.90 0.95];
            controlparams(1) = variables(intervention_level); %min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %iH
        elseif intervention_type == 7 %8
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(3) = 0.9;    %phiW
            controlparams(2) = 0; %0.7;    %phiG
            %startingpoint = 0.2;  %pH
            variables = [0.7 0.8 0.9 0.95]; %[0.5 0.65 0.80 0.95];
            controlparams(6) = variables(intervention_level); %  min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %pH
        elseif intervention_type == 8 %9
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(6) = 0.8;    %pH
            %controlparams(5) = 0.5;    %pG
            %startingpoint = 0.0;        %iH
            variables = [0.3, 0.5, 0.7, 0.95];
            controlparams(5) = variables(intervention_level); %min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %pG
        elseif intervention_type == 9 %7
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(1) = 0.8;  %iH
            %controlparams(4) = 0.5;  %phiC
            %startingpoint = 0.5;    %pH
            variables = [0.5 0.65 0.8 0.95];
            controlparams(4) = variables(intervention_level);%   min(0.95, startingpoint  + (intervention_level-1)*(1-startingpoint)/(frequency-1));  %phiC    
        else
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
        end
        model_intervention = EbolaModel_intervention(1, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams, 0);
        intervention_cases{intervention_type}(:,intervention_level) = model_intervention{1}{1};
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% COMBINE OUTPUT %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combined before and after intervention
model_total = cellfun( @(o1, o2) [o1, o2], postintervention_cases, intervention_cases, 'UniformOutput', false);
plotAllInterventions(preintervention_cases, model_total, timeset);

end

function eps = EstimatedParameters()

    load('paramest_MontserradoCounty');
    eps = x;
end

function ic = InitializeNoIntervention(x)
    
% Initial conditions
    %N0 = 4.09e6;          % Initial population size    Ig0 = x(5);  
    N0 = 1.14e6;           % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4); Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;    Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;    Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;    Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0; Iht0 = 0; Iwt0 = 0;
    Sh0 = 5*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
%      T0 = 0;
%      A0 = 0;
    
    ic =  [Sg0,Sf0,Sh0,Sw0,...  (1-4)
                Eg0,Eh0,Ew0,... (5-7)
                Ig0,Ih0,Iw0,...  (8-10)
                Fg0,Fh0, Fw0,...  (11-13)
                Rg0,Rh0,Rw0,...   (14-16)
                Dg0,Dh0,Dw0, ...   (17-19)
                Cincg0,Cinch0,Cincw0, ... (20-22)
                Cdiedg0,Cdiedh0,Cdiedw0,... (23-25)
                CHosp0,Iht0, Iwt0]; %,... %26-28 
                %T0,A0];             %29-30 
end

function ic = InitializeIntervention(previousoutput)
    
T0 = 0;
A0 = 0;

ic = [previousoutput; T0; A0];
      
end

function cp_out = getControlParams(index)
    % iH, phiG, phiW, phiC, pG, pH
    index = index+1;

    cp(0+1,:) = [0, 0, 0, 0, 0, 0];
    
    % unused strategies
    cp(1+1,:) = [0, 0, 1, 0, 0, 0];  %transmission reduction (hospital)
    cp(2+1,:) = [1, 0, 0, 0, 1, 1];  %hygeinic burial (hospital+community) + isolation (hospital cases)
    cp(3+1,:) = [1, 0, 0, 1, 0, 1];  %isolation (hospital cases) + contact follow-up + hygienic burial (hospital cases)
    
    
    cp(4+1,:) = [0, 1, 1, 0, 0, 0];  %transmission reduction (hospital+community)
    cp(5+1,:) = [0, 0, 0, 0, 0, 1];  %hygienic burial (hospital)
    cp(6+1,:) = [1, 0, 0, 0, 0, 0];  %isolation (hospital cases)
    
    
    
    cp(7+1,:) = [0, 1, 1, 0, 0, 1];  %transmission reduction (hospital+community) + hygienic burial (hospital cases) 
    cp(8+1,:) = [0, 0, 0, 0, 1, 1];  %hygeinic burial (hospital+community cases)
    cp(9+1,:) = [1, 0, 0, 1, 0, 0];  %isolation (hospital cases) + contact follow-up
    


    cp_out = cp(index,:);

end

function cl_out = getControlLevel(index, freq)
    cl_out = 0.5 + min(0.45,index / (2*freq));
end

