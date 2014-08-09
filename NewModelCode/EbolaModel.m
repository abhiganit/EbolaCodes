function [t,Sg,Sf,Sh,Sw,Eg,Ef,Eh,Ew,Ig,If,Ih,Iw,Fg,Ff,Fh,Fw, Rg,Rf,Rh,Rw,Dg,Df,Dh, Dw] = EbolaModel()

% Model Parameters
betaI = 0.588/7;   % Transmission coefficient in community
betaH1 = 0.794/7;   % Transmission coefficient for hospital goers/patients
betaH2 = 0.794/7;   % Transmission coefficient for hospital/ebola treatment workers
betaF = 0.8; %/7;% 7.653/7;   % Transmission coefficient during funerals
alpha = 1/7;       % 1/alpha: mean duration of the incubation period  
theta = 0.67;      % Percentage/proportion of infectious cases are hospitaized
gammaH = 1/5;      % 1/gammaH: mean duration from symptom onset to hospitalization
gammaI = 1/10;     % 1/gammaI: mean duration of the infectious period for survivors
gammaD = 1/9.6;    % 1/gammaD: mean duration from onset to death
gammaDH = 1/10;    % 1/gammaDH: mean duration from hospitalization to death
gammaIH = 1/10;    % 1/gammaIH: mean duration from hospotalization to end of infectiousness
gammaF  = 1/2;     % 1/gammaF: mean duration from death to burial
delta1 = 0.8;      % delta1 and delta2 calculated such that case fatality rate is delta
delta2 = 0.8;
fGF =  0.4;          % average number of individuals affected by each funeral
fFG = 0.6;           % flow rate from Sf to Sg
fGH = 0.6;           % flow rate from Sg to Sh
fHG = 0.5;           % flow rate from Sh to Sg
epslon = 0.1;         % asymptotic illness proportion

N0 = 200000; % Initial population size
% Initial conditions
Sg0 = N0; Sf0 = 0; Sh0 = 0; Sw0 = 10; 
Eg0 = 0; Ef0 = 0; Eh0 = 0; Ew0 = 0; 
Ig0 = 3; If0 = 0; Ih0 = 0; Iw0 = 0;
Fg0 = 0; Ff0 = 0; Fh0 = 0; Fw0 = 0;
Rg0 = 0; Rf0 = 0; Rh0 = 0; Rw0 = 0;
Dg0 = 0; Df0 = 0; Dh0 = 0; Dw0 = 0;
% Tau and maximum time taken
tau=1;
MaxTime=2*365;
MaxIt = 10;

initial = [Sg0,Sf0,Sh0,Sw0,Eg0,Ef0,Eh0,Ew0,Ig0,If0,Ih0,Iw0,Fg0,Ff0,Fh0, Fw0,Rg0,Rf0,Rh0,Rw0,Dg0,Df0,Dh0,Dw0];

params = [betaI,betaH1,betaH2, betaF,alpha, theta, gammaH, gammaI, gammaD,gammaDH, gammaIH,gammaF, delta1,delta2,fGF,fFG,fGH,fHG,epslon,tau];
for i= 1: MaxIt
% The main iteration 
[t, pop]=Stoch_Iteration([0 MaxTime],initial,params);
T=t; 
Sg(:,i)=pop(:,1); Sf(:,i) = pop(:,2); Sh(:,i) = pop(:,3); Sw(:,i) = pop(:,4); 
Eg(:,i)=pop(:,5); Ef(:,i) = pop(:,6); Eh(:,i) = pop(:,7); Ew(:,i) = pop(:,8);
Ig(:,i)=pop(:,9); If(:,i) = pop(:,10); Ih(:,i) = pop(:,11); Iw(:,i) = pop(:,12);
Fg(:,i)=pop(:,13); Ff(:,i) = pop(:,14); Fh(:,i) = pop(:,15); Fw(:,i)=pop(:,16); 
Rg(:,i) = pop(:,17); Rf(:,i)= pop(:,18);, Rh(:,i) = pop(:,19); Rw(:,i)=pop(:,20);
Dg(:,i) = pop(:,21); Df(:,i) = pop(:,22); Dh(:,i) = pop(:,23); Dw(:,i)=pop(:,24);

end

% plots of each compartments (S,E,I,F,R,D)
figure(1)
subplot(2,2,1)
h=plot(T,Sg,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'S_G'

subplot(2,2,2)
h=plot(T,Sf,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'S_F'

subplot(2,2,3)
h=plot(T,Sh,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'S_H'

subplot(2,2,4)
h=plot(T,Sw,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'S_W'

figure(2)
subplot(2,2,1)
h=plot(T,Eg,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'E_G'

subplot(2,2,2)
h=plot(T,Ef,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'E_F'

subplot(2,2,3)
h=plot(T,Eh,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'E_H'

subplot(2,2,4)
h=plot(T,Ew,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'E_W'

figure(3)
subplot(2,2,1)
h=plot(T,Ig,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'I_G'

subplot(2,2,2)
h=plot(T,If,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'I_F'

subplot(2,2,3)
h=plot(T,Ih,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'I_H'

subplot(2,2,4)
h=plot(T,Iw,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'I_W'

figure(4)
subplot(2,2,1)
h=plot(T,Fg,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'F_G'

subplot(2,2,2)
h=plot(T,Ff,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'F_F'

subplot(2,2,3)
h=plot(T,Fh,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'F_H'

subplot(2,2,4)
h=plot(T,Fw,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'F_W'

figure(5)
subplot(2,2,1)
h=plot(T,Rg,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'R_G'

subplot(2,2,2)
h=plot(T,Rf,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'R_f'

subplot(2,2,3)
h=plot(T,Rh,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'R_H'

subplot(2,2,4)
h=plot(T,Rw,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'R_W'


figure(6)
subplot(2,2,1)
h=plot(T,Dg,'-g','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'D_G'

subplot(2,2,2)
h=plot(T,Df,'-r','linewidth',1.5);
xlabel 'Time (days)';
ylabel 'D_F'

subplot(2,2,3)
h=plot(T,Dh,'-k','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'D_H'

subplot(2,2,4)
h=plot(T,Dw,'-b','linewidth',1.5);
xlabel 'Time (years)';
ylabel 'D_W'



