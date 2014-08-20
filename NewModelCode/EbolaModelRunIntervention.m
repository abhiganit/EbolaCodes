function EbolaModelRunIntervention

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();
% run up until current time with no intervention
model_nointervention = EbolaModel(1, EstimatedParameters(), timesets_nointervention, maxtime, InitializeNoIntervention(EstimatedParameters()));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run from current time with intervention
interventionduration = 300;
timesets_intervention = repmat({0:interventionduration},1,4);
allruns = model_nointervention{2};
initial = InitializeIntervention(allruns(:,end));
controlparams = getControlParams();

model_intervention = EbolaModel_intervention(1, EstimatedParameters(), timesets_intervention, interventionduration, initial', controlparams);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% COMBINE OUTPUT %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% combined before and after intervention
model_total = cellfun( @(o1,o2)[o1; o2], model_nointervention{1}, model_intervention{1}, 'UniformOutput', false);
timesets_total =  cellfun( @(o1,o2)[o1; (o1(end)+o2')], timesets_nointervention, timesets_intervention', 'UniformOutput', false);

plotIntervention(model_total, timesets_total, maxtime)
end

function eps = EstimatedParameters()

    load(paramest);
    eps = x;
end

function ic = InitializeNoIntervention(x)
    
% Initial conditions
    N0 = 4.09e6;          % Initial population size    Ig0 = x(5);  
    Eg0 = 0;    Eh0 = 0; Ew0 = 0;         % exposed
    Ig0 = x(5); Ih0 = 0; Iw0 = 0;         % infected
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

function cp = getControlParams()

cp = [0, 0, 0, 0, 0, 0, 0, 11];

end
