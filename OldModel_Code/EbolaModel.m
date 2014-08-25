function [t,S,E,I,H,F,R] = EbolaModel()

% Model Parameters for Congo
% betaI = 0.88*0.588/7;   % Transmission coefficient in community
% betaH = 0.794/7;   % Transmission coefficient in hospital
% betaF = 7.653/7;   % Transmission coefficient during funerals
% alpha = 1/7;       % 1/alpha: mean duration of the incubation period  
% theta1 = 0.67;      % Percentage/proportion of infectious cases are hospitaized
% gammaH = 1/5;      % 1/gammaH: mean duration from symptom onset to hospitalization
% gammaI = 1/10;     % 1/gammaI: mean duration of the infectious period for survivors
% gammaD = 1/9.6;    % 1/gammaD: mean duration from onset to death
% gammaDH = 1/4.6; % 1/((1/gammaD)-(1/gammaH));    % 1/gammaDH: mean duration from hospitalization to death
% gammaIH = 1/5; % 1/((1/gammaI)-(1/gammaH));    % 1/gammaIH: mean duration from hospotalization to end of infectiousness
% gammaF  = 1/2;     % 1/gammaF: mean duration from death to burial
% delta1 = 0.8;      % delta1 and delta2 calculated such that case fatality rate is delta
% delta2 = 0.8;


% Model Parameters for Uganda
betaI = 4.532/7;   % Transmission coefficient in community
betaH =  0.012/7;   % Transmission coefficient in hospital
betaF = 0.462/7;   % Transmission coefficient during funerals
alpha = 1/8; %1/12;       % 1/alpha: mean duration of the incubation period  
theta1 = 0.65;      % Percentage/proportion of infectious cases are hospitaized
gammaH = 1/4.2;      % 1/gammaH: mean duration from symptom onset to hospitalization
gammaI = 1/10;     % 1/gammaI: mean duration of the infectious period for survivors
gammaD = 1/8;    % 1/gammaD: mean duration from onset to death
gammaDH = 1/3.8; % 1/((1/gammaD)-(1/gammaH));    % 1/gammaDH: mean duration from hospitalization to death
gammaIH = 1/5.8; % 1/((1/gammaI)-(1/gammaH));    % 1/gammaIH: mean duration from hospotalization to end of infectiousness
gammaF  = 1/2;     % 1/gammaF: mean duration from death to burial
delta1 = 0.47;      % delta1 and delta2 calculated such that case fatality rate is delta
delta2 = 0.42;


N0 = 470000; % Initial population size

% Initial conditions
S0 = N0-9;  E0 = 0; I0 = 9; H0 = 0; F0 = 0; R0 = 0;
% Tau and maximum time taken
tau=1;
MaxTime=20*7; %365; %365;
MaxIt = 100;

for i= 1: MaxIt
% The main iteration 
[t, pop]=Stoch_Iteration([0 MaxTime],[S0,E0,I0,H0,F0,R0],[betaI,betaH, betaF,alpha, theta1, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,N0,tau]);
T=t/7; S(:,i)=pop(:,1); E(:,i)=pop(:,2); I(:,i)=pop(:,3); H(:,i)= pop(:,4); F(:,i) = pop(:,5); R(:,i) = pop(:,6);
end

% plots the graphs with scaled colours
subplot(2,3,1)
h=plot(T,S,'-g','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Susceptible'

subplot(2,3,2)
h=plot(T,E,'-r','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Exposed'

subplot(2,3,3)
h=plot(T,I,'-k','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Infectious'

subplot(2,3,4)
h=plot(T,H,'-b','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Hospitalized'

subplot(2,3,5)
h=plot(T,F,'-c','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Funeral'

subplot(2,3,6)
h=plot(T,R,'-m','linewidth',1.5);
xlabel 'Time (Weeks)';
ylabel 'Removed'










