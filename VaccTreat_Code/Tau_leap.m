function [new_value]=Tau_leap(old, Parameters, t, HospitalVisitors, interventiondelay, immunitydelay, VE, VCov, TE, TCov)

% Parameters
betaI = Parameters(1); betaH = Parameters(2); betaW = Parameters(3); omega = Parameters(4);
alpha = Parameters(5);
theta= Parameters(6);
gammaH = Parameters(7); gammaI = Parameters(8); gammaD = Parameters(9); gammaDH = Parameters(10); gammaIH = Parameters(11); gammaF = Parameters(12);
deltaG = Parameters(13); deltaH = Parameters(14);
MF = Parameters(15);  MH = Parameters(16);
fFG = Parameters(17); fGH = Parameters(18); fHG = Parameters(19);
epsilon = Parameters(20); KikwitGeneralPrev = Parameters(21); KikwitNonhospPrev = Parameters(22); E = Parameters(23); 
reportingrateGeneral = Parameters(24); reportingrateHospital = Parameters(25);
tau = Parameters(26);


% Compartments
Sg = old(1);  Sf = old(2);   Sh = old(3);  Sw = old(4);
Eg = old(5);  Eh = old(6);  Ew = old(7);
Ig = old(8);  Ih = old(9); Iw = old(10);
Fg = old(11); Fh = old(12); Fw = old(13);
Rg = old(14); Rh = old(15); Rw = old(16);
Dg = old(17); Dh = old(18); Dw = old(19);
%cumulative incidences
Cincg = old(20); Cinch = old(21); Cincw = old(22);
Cdiedg = old(23); Cdiedh = old(24); Cdiedw = old(25);
CHosp = old(26); 
Iht = old(27);  Iwt = old(28);
% vacc/treatment classes
V = old(29); 
T = old(30); Tf = old(31); Tr = old(32); Td = old(33);
CT = old(34);


%% Move vaccination workers into holding-vaccinated compartment instantaneously%%
if(round(t)>round(interventiondelay+immunitydelay))
    Nw = Sw+Ew+Iw+Iwt+Rw + (VE*VCov*Sw);
    %Nw = Sw+Ew+Iw+Iwt+Rw + (VE*V);
else
    Nw = Sw+Ew+Iw+Iwt+Rw;
end

% if(round(t)==round(interventiondelay))
%     % do something with densities
%    V = VCov*Sw;  % count number of vaccine doses
%    old(29) = V; %set an immediate number of vaccinated individuals
% elseif(round(t)==round(interventiondelay+immunitydelay))
%    Sw = Sw - VE*VCov*Sw;  %move a proportion of successfully vaccinated people from the Sw class
%    old(4) = Sw;
% end
if(round(t)==round(interventiondelay+immunitydelay))
    % do something with densities
   V = VCov*Sw;  % count number of vaccine doses
   old(29) = V; %set an immediate number of vaccinated individuals
   Sw = Sw - VE*VCov*Sw;  %move a proportion of successfully vaccinated people from the Sw class
   old(4) = Sw;
end


Ng = Sg+Sf+Eg+Ig+Rg;
Nh = Sh+Eh+Ih+Iht+Rh + T+Tr;
F = Fg + Fh + Fw + Tf;
% account fornumber of vaccinated people in total alive people


Nd = Ng + Nh + Nw;
NF = Nd/(gammaF*E);

% Starting intervention after a delay
if(round(t) < round(interventiondelay))
    TE = 0; 
    TCov = 0;
end

% initialize arrays
Change = zeros(40,size(old,2)); %40 rates, X states
Rate = zeros(40,1);


%% Transitions
% General: susc -> exposed
Rate(1) = betaI*Sg*(Ig/Ng);                         Change(1,1) = -1; Change(1,5) = +1;
% Funeral: susc -> exposed
Rate(2) = ((21*omega-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
                 betaI*(F/(F+NF))*Sf;               Change(2,2) = -1; Change(2,5) = +1; 
% Hosp: susc -> exposed
Rate(3) = betaH*Sh*(Ih+Iht+Iw+Iwt+T)/(Nh+Nw);      Change(3,3) = -1; Change(3,6) = +1;  %could we have transmissibility between hospitalized patients be same as in general popn?
% Worker: susc -> exposed
Rate(4) = betaW*Sw*(Ih+Iht+Iw+Iwt+T)/(Nh+Nw);      Change(4,4) = -1; Change(4,7) = +1;


% General: exposed -> inf
Rate(5) = epsilon*alpha*Eg;                                      Change(5,5) = -1; Change(5,8) = +1;
% Hosp: exposed -> inf
Rate(6) = epsilon*alpha*Eh;                                      Change(6,6) = -1; Change(6,27) = +1;
% Worker: exposed -> inf
Rate(7) = epsilon*alpha*Ew;                                      Change(7,7) = -1; Change(7,28) = +1;

% General: inf -> funeral
Rate(8) = deltaG*(1-theta)*gammaD*Ig;                    Change(8,8) = -1; Change(8,11) = +1;  %delta1*

% Hosp: inf -> funeral
Rate(9) = deltaH*gammaDH*Ih;                            Change(9,9) = -1; Change(9,12) = +1;  %delta2*
% Worker: inf -> funeral
Rate(10) = deltaH*gammaDH*Iw;                            Change(10,10) = -1; Change(10,13) = +1;  %delta2*

% General: inf -> recovered
Rate(11) = (1-deltaG)*gammaI*(1-theta)*Ig;               Change(11,8) = -1; Change(11,14) = +1;  %*(1-delta1)
% Hosp: inf -> recovered
Rate(12) = (1-deltaH)*gammaIH*Ih;                        Change(12,9) = -1; Change(12,15) = +1;  %*(1-delta2)
% Worker: inf -> recovered
Rate(13) = (1-deltaH)*gammaIH*Iw;                        Change(13,10) = -1; Change(13,16) = +1;  %*(1-delta2)

% General: funeral -> dead
Rate(14) = gammaF*Fg;                                    Change(14,11) = -1; Change(14,17) = +1;

% Hosp: funeral -> dead
Rate(15) = gammaF*Fh;                                    Change(15,12) = -1; Change(15,18) = +1;
% Worker: funeral -> dead
Rate(16) = gammaF*Fw;                                    Change(16,13) = -1; Change(16,19) = +1;

% General:susc -> Funeral:susc
Rate(17) = MF*(Nd/E +  (1-theta)*deltaG*gammaD*Ig + deltaH*gammaDH*(Ih+Iw))*Sg/(Ng-Sf);           Change(17,1) = -1; Change(17,2) = +1;  %delta1* delta2*    
% Funeral:susc -> General:susc
Rate(18) = fFG*Sf;                                       Change(18,2) = -1; Change(18,1) = +1;
% General:susc -> Hosp:susc
Rate(19) = HospitalVisitors*((MH+1)*fGH*Sg + MH*gammaH*theta*Ig*Sg/Ng);                                     Change(19,1) = -1; Change(19,3) = +1;    % ; (1-t/54)*  family members attending hospital for non-ebola cases + ebola cases   
% Hosp:susc -> General:susc
Rate(20) = fHG*Sh;                                       Change(20,3) = -1; Change(20,1) = +1;
% General:inf -> Hosp:inf
Rate(21) = (1-TCov)*gammaH*theta*Ig;                              Change(21,8) = -1; Change(21,9) = +1;

% General:exposed -> General:recovered
Rate(22) =(1-epsilon)*alpha*Eg;            Change(22,5) = -1; Change(22,14) = +1;
% Hosp:exposed -> Hosp:recovered
Rate(23) = (1-epsilon)*alpha*Eh;           Change(23,6) = -1; Change(23,15) = +1;
% Worker:susc -> Worker:recovered
Rate(24) = (1-epsilon)*alpha*Ew;           Change(24,7) = -1; Change(24,16) = +1;

%% Cumulative Incidences (no reductions, only additions)
% General: susc -> exposed
Rate(25) = reportingrateGeneral*(epsilon*alpha*Eg);                        Change(25,20) = +1;
% Hosp: susc -> exposed 
Rate(26) = reportingrateHospital*(epsilon*alpha*Eh);       					Change(26,21) = +1;  
% Worker: susc -> exposed
Rate(27) = reportingrateHospital*(epsilon*alpha*Ew);      					Change(27,22) = +1;

%% Cumulative Deaths (no reductions, only additions) -- reporting rate applies to all deaths equally
% General: inf -> funeral
Rate(28) = deltaG*reportingrateGeneral*((1-theta)*gammaD*Ig);                   Change(28,23) = +1; 
% Hosp: inf -> funeral
Rate(29) = deltaH*reportingrateHospital*(gammaDH*Ih);                            Change(29,24) = +1; 
% Worker: inf -> funeral
Rate(30) = deltaH*reportingrateHospital*(gammaDH*Iw);                            Change(30,25) = +1; 


%% Cumulative Hospitalizations (including HCW)
%Rate(31) = reportingrateHospital*(gammaH*theta*Ig + epsilon*alpha*(Eh+Ew));             Change(31,26) = +1; 
Rate(31) = reportingrateHospital*(gammaH*theta*Ig + gammaH*Iht + gammaH*Iwt);             Change(31,26) = +1; 
   

%% Delay for infections at hospital
Rate(32) = (1-TCov)*gammaH*Iht;                               Change(32,27) = -1;    Change(32,9) = +1;
Rate(33) = (1-TCov)*gammaH*Iwt;                               Change(33,28) = -1;    Change(33,10) = +1;

%% Treatment Rates
Rate(34) = TCov*gammaH*theta*Ig;                     Change(34,8) = -1; Change(34,30) = +1;
Rate(35) = TCov*gammaH*Iht;                          Change(35,27) = -1;  Change(35,30) = +1;
Rate(36) = TCov*gammaH*Iwt;                          Change(36,28) = -1;  Change(36,30) = +1;
Rate(37) = (1-TE)*deltaH*gammaDH*T;                      Change(37,30) = -1; Change(37,31) = +1;
Rate(38) = (1-(1-TE)*deltaH)*gammaIH*T;                  Change(38,30) = -1; Change(38,32) = +1;
Rate(39) = gammaF*Tf;                                   Change(39,31) = -1; Change(39,33) = +1;

%% Total cumulative treatment doses
Rate(40) = TCov*gammaH*theta*Ig+TCov*gammaH*Iht+TCov*gammaH*Iwt;  Change(40,34) = +1; 


%% run algorithm
new_value=old;
for i=1:size(Rate,1)
    Num=poissrnd(Rate(i)*tau); 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




