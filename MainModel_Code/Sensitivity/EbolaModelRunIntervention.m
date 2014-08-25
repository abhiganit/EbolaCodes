function[sixmonthcumsum] = EbolaModelRunIntervention(x,y);

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
initial_conditions = InitializeNoIntervention(x,y);
model_nointervention = EbolaModel(1, x, timesets_intervention0, preinterventiontime+interventionduration, initial_conditions, 1, MaxIt,y);
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
controlparams = [0, 0, 0.9, 0, 0, 0.7];
model_intervention = EbolaModel_intervention(1, x, timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams, 0,10,y);
model_total = cumsum(diff(model_intervention{1}{1}));
sixmonthcumsum = model_total(183);
end

function ic = InitializeNoIntervention(x,y)
    
% Initial conditions
    N0 = 4.09e6;          % Initial population size    Ig0 = x(5);  
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(4); Ih0 = 0; Iw0 = 0;         % infected
    Fg0 = 0;    Fh0 = 0; Fw0 = 0;         % died:funeral
    Rg0 = 0;    Rh0 = 0; Rw0 = 0;         % recovered
    Dg0 = 0;    Dh0 = 0; Dw0 = 0;         % died:buried
    Cincg0 = Ig0; Cinch0 = 0; Cincw0 = 0;       % cumulative incidence
    Cdiedg0 = 0;  Cdiedh0 = 0; Cdiedw0 = 0;       % cumulative died
    CHosp0 = 0; Iht0 = 0; Iwt0 = 0;
    Sh0 = 5*(2.8/10000)*N0;   Sf0 = 0; Sw0 = y(1);  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
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

