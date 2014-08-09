function [step, new_value]=Iterate(old, Parameters);
% Parameters
betaI = Parameters(1); betaH = Parameters(2); betaF = Parameters(3);
alpha = Parameters(4);
theta1= Parameters(5);
gammaH = Parameters(6); gammaI = Parameters(7); gammaD = Parameters(8); gammaDH = Parameters(9); gammaIH = Parameters(10); gammaF = Parameters(11);
delta1 = Parameters(12); delta2 = Parameters(13);
N = Parameters(14);

% Compartments
S=old(1); E=old(2); I=old(3); H=old(4); F=old(5); R=old(6);

% Transitions
Rate(1) = (betaI*S*I + betaH*S*H+betaF*S*F)/N;       Change(1,:)=[-1 +1 0 0 0 0]; %(S-1,E+1,I,H,F,R)
Rate(2) = alpha*E;                                   Change(2,:)=[0 -1 +1 0 0 0]; %(S,E-1,I+1,H,F,R)
Rate(3) = gammaH*theta1*I;                            Change(3,:)=[0 0 -1 +1 0 0]; %(S,E,I-1,H+1,F,R)
Rate(4) = gammaDH*delta2*H;                           Change(4,:)=[0 0 0 -1 +1 0]; %(S,E,I,H-1,F+1,R)
Rate(5) = gammaF*F;                                   Change(5,:)=[0 0 0 0 -1 +1]; %(S,E,I,H,F-1,R+1)
Rate(6) = gammaI*(1-theta1)*(1-delta1)*I;             Change(5,:)=[0 0 -1 0 0 +1]; %(S,E,I-1,H,F,R+1)
Rate(7) = delta1*(1-theta1)*gammaD*I;                 Change(6,:)=[0 0 -1 0 +1 0]; %(S,E,I-1,H,F+1,R)
Rate(8) = gammaIH*(1-delta2)*H;                       Change(8,:)=[0 0 0 -1 0 +1]; %(S,E,I,H-1,F,R+1)

Change(9,:) =[0 0 0 0 0 0];

R1 =rand(1,1);
R2 =rand(1,1);

step = -log(R2)/(sum(Rate));

% find which event to do
m=min(find(cumsum(Rate)>=R1*sum(Rate)));

nv =old + Change(m,:);
while nv(nv<0) <0
    if m < 9;
        m= m+1;
        nv =old + Change(m,:);
    end
end
new_value=nv;
%old+Change(m,:); 