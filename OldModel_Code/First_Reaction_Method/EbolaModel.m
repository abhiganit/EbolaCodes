function [t,S,E,I,H,F,R] = EbolaModel()

% Model Parameters
betaI = 0.88*0.588/7;   % Transmission coefficient in community
betaH = 0.794/7;   % Transmission coefficient in hospital
betaF = 7.653/7;% 7.653/7;   % Transmission coefficient during funerals
alpha = 1/7;       % 1/alpha: mean duration of the incubation period  
theta1 = 0.67;      % Percentage/proportion of infectious cases are hospitaized
gammaH = 1/5;      % 1/gammaH: mean duration from symptom onset to hospitalization
gammaI = 1/10;     % 1/gammaI: mean duration of the infectious period for survivors
gammaD = 1/9.6;    % 1/gammaD: mean duration from onset to death
gammaDH = 1/((1/gammaD)-(1/gammaH));    % 1/gammaDH: mean duration from hospitalization to death
gammaIH = 1/((1/gammaI)-(1/gammaH));    % 1/gammaIH: mean duration from hospotalization to end of infectiousness
gammaF  = 1/2;     % 1/gammaF: mean duration from death to burial
delta1 = 0.8;      % delta1 and delta2 calculated such that case fatality rate is delta
delta2 = 0.8;
N0 = 200000; % Initial population size

% Initial conditions
% S0 = 0.99*N0; E0 = 0.005*N0; I0 = 0.005*N0; H0 = 0; F0 = 0; R0 = 0;
S0 = N0-3;  E0 = 0; I0 = 3; H0 = 0; F0 = 0; R0 = 0;
% Tau and maximum time taken

MaxTime=1*365;
MaxIt = 1 ;
T = cell(MaxIt,1); S = cell(MaxIt,1); 
E = cell(MaxIt,1); I = cell(MaxIt,1); 
H = cell(MaxIt,1); F = cell(MaxIt,1); 
R = cell(MaxIt,1); 

for i= 1: MaxIt
% The main iteration 
[t, pop]=Stoch_Iteration([0 MaxTime],[S0,E0,I0,H0,F0,R0],[betaI,betaH, betaF,alpha, theta1, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,N0]);
T{i}=t; S{i}=pop(:,1); E{i}=pop(:,2); I{i}=pop(:,3); H{i}= pop(:,4); F{i} = pop(:,5); R{i} = pop(:,6);
end

% plots the graphs with scaled colours
subplot(2,3,1)
for i = 1:MaxIt
h=plot(T{i},S{i},'-g','linewidth',1.5);
hold on;
end
xlabel 'Time (days)';
ylabel 'Susceptible'
hold off
subplot(2,3,2)

for i = 1:MaxIt
h=plot(T{i},E{i},'-r','linewidth',1.5);
hold on;
end
xlabel 'Time (days)';
ylabel 'Exposed'
hold off
subplot(2,3,3)
for i = 1:MaxIt
h=plot(T{i},I{i},'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'Infectious'
hold on;
end
hold off
subplot(2,3,4)
for i = 1:MaxIt
h=plot(T{i},H{i},'-b','linewidth',1.5);
hold on;
end
xlabel 'Time (years)';
ylabel 'Hospitalized'
hold off

subplot(2,3,5)
for i = 1:MaxIt
h=plot(T{i},F{i},'-c','linewidth',1.5);
hold on;
end
xlabel 'Time (years)';
ylabel 'Funeral'
hold off

subplot(2,3,6)
for i = 1:MaxIt
h=plot(T{i},R{i},'-m','linewidth',1.5);
hold on;
end
xlabel 'Time (years)';
ylabel 'Removed'
hold off








