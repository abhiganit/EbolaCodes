function EbolaModelRunIntervention

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();
% run up until current time with no intervention
model_nointervention = EbolaModel(1, EstimatedParameters(), timesets_nointervention, maxtime, InitializeNoIntervention(EstimatedParameters()));

preinterventiontime = max(timesets_nointervention{1});
preinterventiontimes = 0:preinterventiontime;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize intervention runs
numberofstrategies = 7;
interventionduration = 365;
frequency = 4;
timeset = 0:(preinterventiontime+interventionduration);
timesets_intervention0 = repmat({timeset},1,4);
timesets_intervention = repmat({0:interventionduration},1,4);
allruns = model_nointervention{2};
InitializeSetUpForNoIntervention = InitializeIntervention(InitializeNoIntervention(EstimatedParameters())');
InitialSetUpForEveryIntervention = InitializeIntervention(allruns(:,end));
initializemat = zeros(interventionduration+1, frequency);
intervention_cases = repmat({initializemat}, 1, numberofstrategies);

% run no intervention for pre- and post-intervention time period
controlparams = getControlParams(0);
model_nointervention = EbolaModel_intervention(1, EstimatedParameters(), timesets_intervention0, preinterventiontime+interventionduration, InitializeSetUpForNoIntervention', controlparams);
% grab just the cases
nointervention_cases = repmat({model_nointervention{1}{1}}, 1, numberofstrategies);
preintervention_cases = cellfun( @(a)a(1:(maxtime+1),:), nointervention_cases, 'UniformOutput', false);
postintervention_cases = cellfun( @(a)a((maxtime+1):(maxtime+interventionduration+1),:), nointervention_cases, 'UniformOutput', false);

% loop around the interventions
for intervention_type = 1:numberofstrategies
    for intervention_level = 1:frequency
        if intervention_type == 7
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(6) = 0.95;
        elseif intervention_type == 2
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(1) = 0.95;
        elseif intervention_type == 5
            controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
            controlparams(3) = 0.95;
        else
        controlparams = getControlLevel(intervention_level,frequency) * getControlParams(intervention_type);
         end
        model_intervention = EbolaModel_intervention(1, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams);
        intervention_cases{intervention_type}(:,intervention_level) = model_intervention{1}{1};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% COMBINE OUTPUT %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combined before and after intervention
% model_total = cellfun( @(o1,o2)[o1; o2], model_nointervention{1}, model_intervention{1}, 'UniformOutput', false);
% timesets_total =  cellfun( @(o1,o2)[o1; (o1(end)+o2')], timesets_nointervention, timesets_intervention', 'UniformOutput', false);

% combined before and after intervention
model_total = cellfun( @(o1, o2) [o1, o2], postintervention_cases, intervention_cases, 'UniformOutput', false);

plotAllInterventions(preintervention_cases, model_total, timeset);
%timesets_total =  cellfun( @(o1,o2)[o1; (o1(end)+o2')], timesets_nointervention, timesets_intervention', 'UniformOutput', false);
%model_total = cellfun( @(o1, o2) [o1, o2], nointervention_cases, intervention_cases, 'UniformOutput', false);

% plotIntervention(model_total, timesets_total, maxtime)
end

function eps = EstimatedParameters()

    load('paramest');
    eps = x;
end

function ic = InitializeNoIntervention(x)
    
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
    Sh0 = 20*(2.8/10000)*N0;   Sf0 = 0; Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sh0 - Sw0 - Ig0;   %susceptible
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
    cp(1+1,:) = [1, 0, 0, 0, 0, 0];  %passive isolation
    cp(2+1,:) = [1, 0, 0, 1, 0, 0];  %passive isolation + contact tracing/follow-up
    cp(3+1,:) = [0, 0, 1, 0, 0, 0];  %transmission reduction (hospital)
    cp(4+1,:) = [0, 1, 0, 0, 0, 0];  %transmission reduction (community)
    cp(5+1,:) = [0, 1, 1, 0, 0, 0];  %transmission reduction (hospital+community)
    cp(6+1,:) = [0, 0, 0, 0, 0, 1];  %hygienic burial (hospital)
    cp(7+1,:) = [0, 0, 0, 0, 1, 1];  %hygeinic burial (hospital+community)


    cp_out = cp(index,:);

end

function cl_out = getControlLevel(index, freq)
    cl_out = min(0.95,index / freq);
end

