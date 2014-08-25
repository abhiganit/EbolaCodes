function [t,X,Y,Z] = Program_6_4(beta,gamma,mu,X0,Y0,N0,MaxTime)
%
% 
% Program_6_4( beta, gamma, mu, X0, Y0, N0, MaxTime)
%      This is the MATLAB version of program 6.4 from page 203 of 
% "Modeling Infectious Disease in humans and animals" 
% by Keeling & Rohani.
% 
% It is the SIR model (including births and deaths) with full 
% (event-driven) demographic stochasticity.
%
% This is a more complex stochastic model as 6 events are
% possible: infection, recovery, birth, death of susceptible, death of
% infected, death of recovered.
%
% Note: by default we are using a very small population size to highlight
% the stochasticity.

% Sets up default parameters if necessary.
if nargin == 0
   beta=1;
   gamma=1/10.0;
   mu=5e-4;
   N0=5000;
   
   Y0=ceil(mu*N0/gamma);
   X0=floor(gamma*N0/beta);
   
   MaxTime=2*365;
end

% Checks all the parameters are valid
if X0<=0 
    error('Initial number of susceptibles (%g) is less than or equal to zero',X0);
end

if Y0<=0 
    error('Initial number of infecteds (%g) is less than or equal to zero',Y0);
end

if N0<=0 
    error('Initial population size (%g) is less than or equal to zero',N0);
end

if beta<=0 
    error('Transmission rate beta0 (%g) is less than or equal to zero',beta0);
end

if gamma<=0 
    error('Recovery rate gamma (%g) is less than or equal to zero',gamma);
end

if mu<=0 
    error('Brith and Death rate mu (%g) is less than or equal to zero',mu);
end
  
if MaxTime<=0 
    error('Maximum run time (%g) is less than or equal to zero',MaxTime);
end

if X0+Y0>N0
    warning('Initial level of suceptibles + infecteds (%g + %g = %g) is greater than population size (%g)',X0,Y0,X0+Y0,N0);
end


Z0=N0-X0-Y0;

% The main iteration 

[t, pop]=Stoch_Iteration([0 MaxTime],[X0 Y0 Z0],[beta gamma mu N0]);

T=t/365; X=pop(:,1); Y=pop(:,2); Z=pop(:,3);

% plots the graphs with scaled colours
subplot(3,1,1)
h=plot(T,X,'-g');
xlabel 'Time (years)';
ylabel 'Susceptible'

subplot(3,1,2)
h=plot(T,Y,'-r');
xlabel 'Time (years)';
ylabel 'Infectious'

subplot(3,1,3)
h=plot(T,Z,'-k');
xlabel 'Time (years)';
ylabel 'Recovereds'




% Do the iterations using the full event driven stochastic methodology
% This is a relatively general version of the event-driven methodology know
% as Gillespie's Direct Algorithm
function [T,P]=Stoch_Iteration(Time,Initial,Parameters)

X=Initial(1); Y=Initial(2); Z=Initial(3);
T=0; P(1,:)=[X Y Z];
old=[X Y Z];

loop=1;
while (T(loop)<Time(2))  
    [step,new]=Iterate(old,Parameters);
    loop=loop+1;
    T(loop)=T(loop-1)+step;
    P(loop,:)=old;
    loop=loop+1;
    T(loop)=T(loop-1);
    P(loop,:)=new; old=new;
    
     if loop>=length(T)
        T(loop*2)=0;
        P(loop*2,:)=0;
    end
end

T=T(1:loop); P=P(1:loop,:);


% Do the actual iteration step
function [step, new_value]=Iterate(old, Parameters);

beta=Parameters(1); gamma=Parameters(2); mu=Parameters(3); N=Parameters(4);
X=old(1); Y=old(2); Z=old(3);

Rate(1) = beta*X*Y/N;  Change(1,:)=[-1 +1 0];
Rate(2) = gamma*Y;  Change(2,:)=[0 -1 +1];
Rate(3) = mu*N;  Change(3,:)=[+1 0 0];
Rate(4) = mu*X;  Change(4,:)=[-1 0 0];
Rate(5) = mu*Y;  Change(5,:)=[0 -1 0];
Rate(6) = mu*Z;  Change(6,:)=[0 0 -1];

R1=rand(1,1);
R2=rand(1,1);

step = -log(R2)/(sum(Rate));

% find which event to do
m=min(find(cumsum(Rate)>=R1*sum(Rate)));

new_value=old+Change(m,:);







