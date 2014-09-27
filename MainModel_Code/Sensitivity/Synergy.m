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
% Strat = [iH, phiG, phiW, phiC, pG, pH];
A = []; B = []; C = []; D = [];AC = [];AD = []; BC = []; BD = []; 
% A
iH = 0; phiG = 0; phiW = 0; phiC = 0; pG =0;  pH = x;
A = [iH, phiG, phiW, phiC, pG, pH];

% B
iH = 0; phiG = 0; phiW = 0; phiC = 0; pG = 0.5;  pH = x;
B = [iH, phiG, phiW, phiC, pG, pH];

% C
iH = x; phiG = 0; phiW = 0; phiC = 0; pG =0;  pH = 0;
C = [iH, phiG, phiW, phiC, pG, pH];

% D
iH = x; phiG = 0; phiW = 0; phiC = x; pG =0;  pH = 0;
D = [iH, phiG, phiW, phiC, pG, pH];

% AC
iH = x; phiG = 0; phiW = 0; phiC = 0; pG =0;  pH = x;
AC = [iH, phiG, phiW, phiC, pG, pH];

% AD
iH = x; phiG = 0; phiW = 0; phiC = x; pG =0;  pH = x;
AD = [iH, phiG, phiW, phiC, pG, pH];

% BC
iH = x; phiG = 0; phiW = 0; phiC = 0; pG =0.5;  pH = x;
BC = [iH, phiG, phiW, phiC, pG, pH];

% BD
iH = x; phiG = 0; phiW = 0; phiC = x; pG =0.5;  pH = x;
BD = [iH, phiG, phiW, phiC, pG, pH];



Strat = [A;B;C;D;AC;AD;BC;BD];

for i = 1: length(Strat)
    controlparams = Strat(i,:);
    CumCases{i} = EbolaModelRunIntervention(x0,y,controlparams);
end

[A,B,C,D,AB,AC,AD,BC,BD,ABC,ABD] = CumCases{:};

SynMatrix = [A,0,C,0,AC;...
             A,0,0,D,AD;...
             0,B,C,0,BC;...
             0,B,0,D,BD];

bar(SynMatrix)


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







