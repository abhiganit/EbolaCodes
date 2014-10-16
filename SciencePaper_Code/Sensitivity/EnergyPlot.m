N0 = 4.09e6;  
KikwitGeneralPrev = 0.81*6.4e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
KikwitNonhospPrev = 5.6e-5; %7.81e-6;  %prevalence in previous epidemic to use in weighting of betaF relative to betaI
Sw0 = (2.8/10000)*N0;
alpha = 9.5;        % 1/alpha: mean duration of the incubation period 
gammaD = 7.9;       % 1/gammaD: mean duration from onset to death
gammaI = 9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
gammaH = 4.9;    % 1/Time between hospitalization and death
fGHN = 62131;
fHG = 7;          % 1/average time spent at in hospital with non-ebola disease
M =  5;            % average family size
MH = 1;             % additional family members visiting hospital
omega = ((21*1.2-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev);
epsilon = 100/100;       % percentage Symptomatic illness 


y = [Sw0,alpha,gammaD,gammaI,gammaH,fGHN,fHG,M,MH,omega,epsilon];
x0 = EbolaModelFit(y); % Check if getting same fitted value.

% Control Strategies


% controlparams = zeros(1,6);
% CumCases0 = EbolaModelRunIntervention(x0,y,controlparams);
% iH = 0; phiG = 0; phiW = 0; phiC =0; pG =0; pH =0; 
Strat = [0 0 0 0 0 1; 
         1 0 0 0 0 0;
         0 0 0 0 0.9 0.9;
         0.9 0 0 0.9 0 0;
         0.6 0 0 0.6 0.6 0.6]
for i = 1:5
    controlparams = Strat(i,:);
   [CumCases(i),dailycases{i}] = EbolaModelRunIntervention(x0,y,controlparams);
   DailyCases(i,:) = dailycases{i}(:,1)'
end

CumSum6 = [CumCases(1),0,0,0,0;
           0, CumCases(2),0,0,0;
           0, 0, CumCases(3),0,0;
           0,0,0,CumCases(4),0;
           0,0,0,0,CumCases(5)];
t = linspace(0,length(DailyCases),length(DailyCases));
colorstring = {'b','g','r','c','m'};

subplot(2,1,1);
for i = 1:5
plot(t,DailyCases(i,:),colorstring{i},'linewidth',2);
hold on;
end
hold off;
box off
legend('Hygienic Burial of Hospital Deaths (100%)',...
                 'Hospital Case Isolation (100%)',...
                 'Hygienic Burial of Hospital Deaths (90%) and Community Deaths (60%)',...
                 'Hospital Case Isolation (90%) and Contact-tracing and Quarantining (90%)',...
                 'All Strategies (60%)');
subplot(2,1,2);
for i = 1:5
bar(CumSum6(i,:),colorstring{i});
hold on;
end
box off
hold off



