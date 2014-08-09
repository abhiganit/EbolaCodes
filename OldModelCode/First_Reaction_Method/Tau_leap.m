function [new_value]=Tau_leap(old, Parameters);

% Parameters
betaI = Parameters(1); betaH = Parameters(2); betaF = Parameters(3);
alpha = Parameters(4);
theta1= Parameters(5);
gammaH = Parameters(6); gammaI = Parameters(7); gammaD = Parameters(8); gammaDH = Parameters(9); gammaIH = Parameters(10); gammaF = Parameters(11);
delta1 = Parameters(12); delta2 = Parameters(13);
N = Parameters(14);
tau = Parameters(15);

% Compartments
S=old(1); E=old(2); I=old(3); H=old(4); F=old(5); R=old(6);

% Transitions
Rate(1) = (betaI*S*I + betaH*S*H+betaF*S*F)/N ;       Change(1,:)=[-1 +1 0 0 0 0];
Rate(2) =  alpha*E;                                   Change(2,:)=[0 -1 +1 0 0 0];
Rate(3) = gammaH*theta1*I;                            Change(3,:)=[0 0 -1 +1 0 0];
Rate(4) = gammaDH*delta2*H;                           Change(4,:)=[0 0 0 -1 +1 0];
Rate(5) = gammaF*F;                                   Change(5,:)=[0 0 0 0 -1 +1];
Rate(6) = gammaI*(1-theta1)*(1-delta1)*I;             Change(5,:)=[0 0 -1 0 0 +1];
Rate(7) = delta1*(1-theta1)*gammaD*I;                 Change(6,:)=[0 0 -1 0 +1 0];
Rate(8) = gammaIH*(1-delta2)*H;                       Change(8,:)=[0 0 0 -1 0 +1];
%Rate(9) = 1-sum(Rate(1:8));                           Change(9,:)=[0 0 0 0 0 0];
new_value=old;

for i=1:8
    Num=poissrnd(Rate(i)*tau);
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end


