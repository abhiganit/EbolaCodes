function [new_value]=Tau_leap(old, Parameters)


% Parameters
betaI = Parameters(1); betaW = Parameters(2); omega = Parameters(3);
alpha = Parameters(4);
theta= Parameters(5);
gammaH = Parameters(6); 
gammaD = Parameters(7); gammaR = Parameters(8); 
gammaDH = Parameters(9); gammaRH = Parameters(10); 
gammaF = Parameters(11);
deltaG = Parameters(12); deltaH = Parameters(13);
MF = Parameters(14);  fFG = Parameters(15); 
E = Parameters(16); 
C = Parameters(17);
reportingrateGeneral = Parameters(18); reportingrateHospital = Parameters(19);
phiG = Parameters(20); phiW = Parameters(21);  phiC = Parameters(22);
pG = Parameters(23);  pH = Parameters(24); pQ = Parameters(25);
HospCapacity = Parameters(26);
tau = Parameters(27);

% Compartments
Sg = old(1);  Sf = old(2);  Sw = old(3); % Susceptible people
Eg = old(4);  Ew = old(5);  % Exposed people
Ig = old(6); % People becoming symptomatic
Ige = old(7); Iwe = old(8); % People in Ebola care center 
Fg = old(9); Fge = old(10); Fwe = old(11); % Ebola victim's funeral 
Rg = old(12); Rge = old(13); Rwe = old(14); % Recovered Ebola victims
Dg = old(15); Dge = old(16); Dwe = old(17); % Buried Ebola victims
Eq = old(18); 
Iq = old(19);
Iqe = old(20);
Fqe = old(21); 
Fq  = old(22);
Rqe = old(23);
Rq = old(24);
Dqe = old(25);
Dq = old(26);

% Compartments for fitting
Cincd = old(27);  % cumulative incidences
Cdied = old(28); % cumulative deaths
CHCW = old(29);  % cumulative healthcare workers
CHospAd = old(30); % cumulative admissions to health care centers


Ng = Sg+Sf+Eg+Eq+Ig+Iq+Rg+Rq;
Nw = Sw+Ew+Iwe+Rwe;
Nd = Sg+Sf+Sw+Eg+Eq+Ew+Rg+Rge+Rwe+Rqe+Rq; 
NF = Nd/(gammaF*E);
Ft = Fg+Fge+Fwe+Fqe+Fq;


% initialize arrays
Change = zeros(34,30); %21 rates, X states
Rate = zeros(34,1);


%%%% Transitions
%%% Level 1 (getting infection)
% General: susc -> exposed
Rate(1) = (1-phiG)*betaI*Sg*((Ig+Iq)/Ng);                                              Change(1,1) = -1; Change(1,4) = +1;

% Funeral: susc -> exposed
Rate(2) = omega*betaI*(Ft/(Ft+NF))*Sf;                                            Change(2,2) = -1; Change(2,4) = +1; 

% Worker: susc -> exposed
Rate(3) = (1-phiW)*betaW*Sw*(Iwe+Ige+Iqe)/(Nw+Ige);                                Change(3,3) = -1; Change(3,5) = +1;


%%% Level 2 (becoming symtomatic)
% General: exposed -> inf
Rate(4) = alpha*Eg;                                                               Change(4,4) = -1; Change(4,6) = +1;

%%% Level 3 (moving to Ebola Care)
% General: inf -> ebola care
if (Ige+Iqe) < HospCapacity
    Rate(5) = gammaH*theta*Ig;                                                        Change(5,6) = -1; Change(5,7) = +1;
else
    Rate(5) = 0;                                                        Change(5,6) = 0; Change(5,7) = 0;
end
    
% Worker: exposed -> inf
Rate(6) = alpha*Ew;                                                               Change(6,5) = -1; Change(6,8) = +1;


%%% Level 4 (dying and having funeral)
% General: inf -> funeral
Rate(7) = (1-pG)*(1-theta)*deltaG*gammaD*Ig;                                      Change(7,6) = -1; Change(7,9) = +1;

% General EC: inf -> funeral
Rate(8) = (1-pH)*deltaH*gammaDH*Ige;                                              Change(8,7) = -1; Change(9,10) = +1;

% Worker EC: inf -> buried
Rate(9) = (1-pH)*deltaG*gammaD*Iwe;                                             Change(9,8) = -1; Change(9,11) = +1;


%%% Level 5 (recovering from Ebola)
% General: inf -> recovered
Rate(10) = (1-theta)*(1-deltaG)*gammaR*Ig;                                        Change(10,6) = -1; Change(10,12) = +1;  

% General EC: inf -> recovered
Rate(11) = (1-deltaH)*gammaRH*Ige;                                                Change(11,7) = -1; Change(11,13) = +1;  

% Worker EC: inf -> recovered
Rate(12) = (1-deltaG)*gammaR*Iwe;                                                Change(12,8) = -1; Change(12,14) = +1;  


%%% Level 5 (burials of Ebola Victims)
% General: inf -> buried
Rate(13) = pG*(1-theta)*deltaG*gammaD*Ig;                                         Change(13,6) = -1; Change(13,15) = +1;

% General EC: inf -> buried
Rate(14) = pH*deltaH*gammaDH*Ige;                                                 Change(14,7) = -1; Change(14,16) = +1;

% Worker EC: inf -> buried
Rate(15) = pH*deltaG*gammaD*Iwe;                                                 Change(15,8) = -1; Change(15,17) = +1;


%%% Level 5 (normal burial)
Rate(16) = gammaF*Fg;                                                             Change(16,9) = -1; Change(16,15) = +1;

Rate(17) = gammaF*Fge;                                                            Change(17,10) = -1; Change(17,16) = +1;

Rate(18) = gammaF*Fwe;                                                            Change(18,11) = -1; Change(18,17) = +1;


%%% Level 6 (flow between general communitya and funerals)
% General:susc -> Funeral:susc
Rate(19) = MF*(Nd/E + (1-pG)*deltaG*(1-theta)*gammaD*Ig...
    +(1-pH)*deltaH*gammaDH*Ige+...
     (1-pH)*deltaG*gammaD*(Iwe+Iqe)...
     +(1-pQ)*deltaG*(1-theta)*gammaD*Iq)*Sg/(Ng-Sf);                                 Change(19,1) = -1; Change(19,2) = +1;  

% Funeral:susc -> General:susc
Rate(20) = fFG*Sf;                                                                Change(20,2) = -1; Change(20,1) = +1;


%%% Contact tracing rates
%Rate(21) = Cr*Eg;   
if (Ige+Iqe) >= HospCapacity
    Rate(21) = (C*(1-(1-betaI/C)^(1/gammaH)))*phiC*(gammaH*theta*Ig...
    +gammaH*theta*Iq + alpha*Ew);    
else
    Rate(21) = (C*(1-(1-betaI/C)^(1/gammaH)))*phiC*(gammaH*theta*Ig...
    +gammaH*theta*Iq + alpha*(Ew+Eq)); 
end
Change(21,4) = -1; Change(21,18)=+1;

Rate(22) = alpha*Eq ;
if (Ige+Iqe) >=  HospCapacity
    Change(22,18) = -1; Change(22,19)=+1;
else
    Change(22,18) = -1; Change(22,20)=+1;
end

% Iqe -> Fqe
Rate(23) = (1-pH)*deltaG*gammaD*Iqe;
Change(23,20) = -1; Change(23,21) = +1;
% Iq -> Fq
Rate(24) = (1-pQ)*(1-theta)*deltaG*gammaD*Iq;
Change(24,19) = -1; Change(24,22) = +1;

% Iqe -> Rqe
Rate(25) = (1-deltaG)*gammaR*Iqe;
Change(25,20) = -1; Change(25,23) = +1;

% Iq -> Rq
Rate(26) = (1-theta)*(1-deltaG)*gammaR*Iq;
Change(26,19) = -1; Change(26,24) = +1;

% Iqe -> Dqe 
Rate(27) = pH*deltaG*gammaD*Iqe;
Change(27,20) = -1; Change(27,25) = +1;
% Iq -> Dq
Rate(28) = pQ*(1-theta)*deltaG*gammaD*Iq;
Change(28,19) = -1; Change(28,26) = +1;
% Fqe -> Dqe
Rate(29) = gammaF*Iqe;
Change(29,21) = -1; Change(29,25) = +1;
% Fq -> Dq
Rate(30) = gammaF*Iq;
Change(30,22) = -1; Change(30,26) = +1;

%%% For fitting (no reductions, only additions)
% Cumulative Cases
Rate(31) = reportingrateGeneral*alpha*Eg + reportingrateHospital*alpha*Ew + ...
           reportingrateGeneral*alpha*Eq;        Change(31,27) = +1;

% Cumulative Deaths 
Rate(32) =  deltaG*reportingrateGeneral*((1-theta)*gammaD*Ig)...
           + deltaH*reportingrateHospital*(gammaDH*Ige)... 
           + deltaG*reportingrateHospital*(gammaD*Iwe)...
           + deltaG*reportingrateHospital*gammaD*Iqe...
           + deltaG*reportingrateGeneral*(1-theta)*gammaD*Iq;                           Change(32,28) = +1;

% Cumulative HCW cases
Rate(33) = reportingrateHospital*alpha*Ew;                                        Change(33,29) = +1;

% Cumulative Hospital Admissions
if (Ige+Iqe) >= HospCapacity
    Rate(34) = gammaH*theta*Ig +alpha*Ew+gammaH*theta*Iq;                                            Change(34,30) = +1;
%   May be this should be zero.
else
    Rate(34) = gammaH*theta*Ig +alpha*Ew+gammaH*theta*Iq+alpha*Eq;                                   Change(34,30) = +1;
end

%% run algorithm
new_value=old;
for i=1:size(Rate,1)
    Num=poissrnd(Rate(i)*tau); 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




