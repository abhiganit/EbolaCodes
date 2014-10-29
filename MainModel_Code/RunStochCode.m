function RunStochCode

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% NO INTERVENTION %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get data
[timesets_nointervention, datasets, maxtime, weights] = CleanData();
maxtime = 104;
% set up parameters
numberofstrategies = 9;
interventionduration = 365;
frequency = 4;
preinterventiontime = 104; %max(timesets_nointervention{1});
timeset = 0:(preinterventiontime+interventionduration);
timesets_intervention0 = repmat({timeset},1,4);
timesets_intervention = repmat({0:interventionduration},1,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% run model with no intervention  %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MaxIt = 1000;
initial_conditions = InitializeNoIntervention(EstimatedParameters());
model_nointervention = EbolaModel(0, EstimatedParameters(), timesets_intervention0, preinterventiontime+interventionduration, initial_conditions, 1,MaxIt);
% Adding Non-HCW and HCW cases
% model_nointervention{1}{1} = model_nointervention{1}{1}+model_nointervention{1}{3};
% A = model_nointervention{1}{1};
% P = diff(A');
% X1 = quantile(A(:,104+72),[0.025,0.975])
% T1 = quantile(P(104+72,:),[0.025,0.975])
% X2 = quantile(A(:,104+72+15),[0.025,0.975])
% T2 = quantile(P(104+72+15,:),[0.025,0.975])
% X3 = quantile(A(:,104+72+31),[0.025,0.975])
% T3 = quantile(P(104+72+31,:),[0.025,0.975])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% INTERVENTION %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initializemat = zeros(interventionduration+1, frequency);
intervention_cases = repmat({initializemat}, 1, numberofstrategies);
allruns = model_nointervention{2};
InitialSetUpForEveryIntervention = InitializeIntervention(allruns(:,maxtime+1));
controlparams = [0.6,0,0,0.6,0.6,0.6]; %[iH, phiG, phiW, phiC, pG, pH]
model_intervention = EbolaModel_intervention(0, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams, 0,MaxIt);
B = model_intervention{1}{1};
P = diff(B');
Y1 = quantile(B(:,72),[0.025,0.975])
Q1 = quantile(P(72,:),[0.025,0.975])
Y2 = quantile(B(:,178),[0.025,0.975])
Q2 = quantile(P(178,:),[0.025,0.975])



controlparams = [0.95,0,0,0,0,0]; %[iH, phiG, phiW, phiC, pG, pH]
model_intervention = EbolaModel_intervention(0, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams, 0,MaxIt);
B = model_intervention{1}{1};
P = diff(B');
YY1 = quantile(B(:,72),[0.025,0.975])
QY1 = quantile(P(72,:),[0.025,0.975])


controlparams = [0.9,0,0,0.9,0,0]; %[iH, phiG, phiW, phiC, pG, pH]
model_intervention = EbolaModel_intervention(0, EstimatedParameters(), timesets_intervention, interventionduration, InitialSetUpForEveryIntervention', controlparams, 0,MaxIt);
B = model_intervention{1}{1};
P = diff(B');
YX1 = quantile(B(:,72),[0.025,0.975])
QX1 = quantile(P(72,:),[0.025,0.975])


end

function eps = EstimatedParameters()

    load('paramest');
    eps = x;
end

function ic = InitializeNoIntervention(x)
    
% Initial conditions
    N0 = 4.09e6;          % Initial population size    Ig0 = x(5);  
    %N0 = 1.14e6;           % Montserrado Co.
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
