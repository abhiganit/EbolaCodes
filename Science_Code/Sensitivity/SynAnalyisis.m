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
x = 0.9;

controlparams = zeros(1,6);
CumCases0 = EbolaModelRunIntervention(x0,y,controlparams);

for i = 1:11
    controlparams = sixmonthcumsum(i,x);
    CumCases(i) = EbolaModelRunIntervention(x0,y,controlparams);
    CasesAverted(i) = CumCases0 - CumCases(i);
end

A = CumCases(2);
B = CumCases(3);
C = CumCases(4);
D = CumCases(5);
AC = CumCases(8);
AD = CumCases(9);
BC = CumCases(10);
BD = CumCases(11);

SynMatrix = [A,C,AC;...
             A,D,AD;...
             B,C,BC;...
             B,D,BD];

bar(SynMatrix)

figure;

StupidMatrix = zeros(18,18);

StupidMatrix(1,1) = A;
StupidMatrix(1,6) = A;
StupidMatrix(2,2) = C;
StupidMatrix(2,12) = C;
StupidMatrix(3,11) = B;
StupidMatrix(3,16) = B;
StupidMatrix(4,7) = D;
StupidMatrix(4,17) = D;
StupidMatrix(5,3) = AC;
StupidMatrix(6,8) = AD;
StupidMatrix(7,13) = BC;
StupidMatrix(8,18) = BD;


for i = 1:18
    bar(StupidMatrix(i,:));
    hold on
end

hold off

% Syn(1) = CasesAverted(3)-CasesAverted(1)-CasesAverted(2);
% Syn(2) = CasesAverted(6)-CasesAverted(1)-CasesAverted(4);
% Syn(3) = CasesAverted(7)-CasesAverted(1)-CasesAverted(5);
% Syn(4) = CasesAverted(8)-CasesAverted(2)-CasesAverted(4);
% Syn(5) = CasesAverted(9)-CasesAverted(2)-CasesAverted(5);
% Syn(6) = CasesAverted(10)-CasesAverted(3)-CasesAverted(4);
% Syn(7) = CasesAverted(11)-CasesAverted(3)-CasesAverted(5);
% 
% bar(Syn);