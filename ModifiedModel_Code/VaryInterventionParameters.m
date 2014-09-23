function VaryInterventionParameters
iH = 0;
phiG = 0;
phiW = 0;
phiC = 0;
pG = 0;
pH = 0;
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();
% run up until current time with no intervention
model_nointervention = EbolaModel(1, EstimatedParameters(), timesets_nointervention, maxtime, InitializeNoIntervention(EstimatedParameters()));

 preinterventiontime = max(timesets_nointervention{1});
 preinterventiontimes = 0:preinterventiontime;
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % initialize intervention runs
% numberofstrategies = 7;
 interventionduration = 365;
% frequency = 4;
 timeset = 0:(preinterventiontime+interventionduration);
 timesets_intervention0 = cell(1);
 timesets_intervention = cell(1);
 timesets_intervention0{1} = timeset;
 timesets_intervention{1} = 0:interventionduration;
 allruns = model_nointervention{2};
 InitializeSetUpForNoIntervention = InitializeIntervention(InitializeNoIntervention(EstimatedParameters())');
 InitialSetUpForEveryIntervention = InitializeIntervention(allruns(:,end));
% initializemat = zeros(interventionduration+1, frequency);
% intervention_cases = repmat({initializemat}, 1, numberofstrategies);
% 
% % run no intervention for pre- and post-intervention time period
controlparams = zeros(1,6); % Varying 6 variables
model_nointervention = EbolaModelVaryingParams(1, EstimatedParameters(), timesets_intervention0, preinterventiontime+interventionduration, InitializeSetUpForNoIntervention', controlparams);
time = timesets_intervention{1};
varycolor(20);
% Startlooping through the varying rates
% Change the parameters to be varied 
% Rates are varying incremently by 5 % right now (can be changed)
j = 1;
for pH = 0:0.05:1
     i = 1;
     for pG = 0:0.05:1
         controlparams = [iH,phiG,phiW,phiC,pG,pH];   
         model_intervention = EbolaModelVaryingParams(1, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams);
        A(:,i) = model_intervention;
     %     plot(time,model_intervention,'Color',ColorSet(i,:));
         i = i+1;
     end
     B{j} = A;
     j = j+1;    
end
 
save('pH_pG','B');
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

