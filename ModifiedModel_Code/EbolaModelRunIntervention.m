function EbolaModelRunIntervention

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();

% set up parameters
MaxIt = 10;
interventionduration = 365;
preinterventiontime = max(timesets_nointervention{1});
timeset = 0:(preinterventiontime);
timesets_intervention0 = repmat({timeset},1,4);
timesets_intervention = repmat({0:interventionduration},1,4);
control0 = [0,0,0,0,0,0,10000];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% run model with no intervention  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initial_conditions = InitializeNoIntervention(EstimatedParameters());
model_nointervention = EbolaModel(1, EstimatedParameters(), timesets_intervention0, preinterventiontime+interventionduration, initial_conditions,MaxIt,control0);
nointervention_cases = model_nointervention{1}{1};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize intervention runs
%initializemat = zeros(interventionduration+1, frequency);
%intervention_cases = repmat({initializemat}, 1, numberofstrategies);
allruns = model_nointervention{2};
InitialSetUpForEveryIntervention = InitializeIntervention(allruns(:,maxtime+1));
 
% Intervention
i = 1;
hospcap = [314,500,1000,1500,2000];
for x = hospcap
    control1 = [0,0,0.4,0,1,0,x];
    model_intervention = EbolaModel(1, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention',MaxIt,control1);
    intervention_cases = model_intervention{1}{1};
    total_cases = vertcat(nointervention_cases,intervention_cases(2:end,:));
    cumulativecases{i} = total_cases;
    i = i+1;
end

t = linspace(0,length(total_cases)-2,length(total_cases)-1);
plot(t,diff(cumulativecases{1}),t,diff(cumulativecases{2}),t,diff(cumulativecases{3})...
    ,t,diff(cumulativecases{4}),t,diff(cumulativecases{5}))





% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%% COMBINE OUTPUT %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % combined before and after intervention
 
% plotAllInterventions(preintervention_cases, model_total, timeset);

end

function eps = EstimatedParameters()

    load('paramest');
    eps = x;

end

function ic = InitializeNoIntervention(x)
    
 %Initial conditions
    N0 = 4.09e6;           % Initial population size    
    %N0 = 1.14e6;          % Montserrado Co.
    %N0 = 0.27e6;          % Lofa Co.
    Eg0 = 0;  Ew0 = 0;  % Exposed people
    Ig0 = x(4);   % People becoming symptomatic
    Ige0 = 0; Iwe0 = 0; % People in Ebola care center 
    Fg0 = 0;  Fge0 = 0; Fwe0 = 0;% Ebola victim's funeral 
    Rg0 = 0; Rge0 = 0; Rwe0 = 0; % Recovered Ebola victims
    Dg0 = 0; Dge0 = 0; Dwe0 = 0; % Buried Ebola victims
    Eq0 = 0; Iq0=0; Iqe0 =0;
    Fqe0 = 0; Fq0 =0; Rqe0 =0; Rq0 = 0;
    Dqe0 = 0; Dq0 = 0;
    Cincd0 = 0;  % cumulative incidences
    Cdied0 = 0; % cumulative deaths
    CHCW0 = 0;  % cumulative healthcare workers
    CHospAd0 = 0; % cumulative admissions to health care centers
    Sw0 = (2.8/10000)*N0;  Sg0 = N0 - Sw0 - Ig0;  Sf0 = 0 ;   % Susceptible people
    
    ic =  [Sg0,Sf0,Sw0,...  (1-3)
                Eg0,Ew0,... (4-5)
                Ig0,...  (6-7)
                Ige0,Iwe0,... (8-9)
                Fg0,Fge0,Fwe0,...  (10-12)
                Rg0,Rge0,Rwe0,...   (13-15)
                Dg0,Dge0,Dwe0, ...   (16-18)
                Eq0,Iq0,Iqe0,...
                Fqe0,Fq0,Rqe0,Rq0,Dqe0,Dq0,...
                Cincd0,Cdied0,CHCW0,CHospAd0]; % (19-22)
end

function ic = InitializeIntervention(previousoutput)
    ic = previousoutput;
      
end

