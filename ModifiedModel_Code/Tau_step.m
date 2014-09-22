function [new_value]=Tau_step(old, Parameters, t)

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
reportingrateGeneral = Parameters(17); reportingrateHospital = Parameters(18);
phiG = Parameters(19); phiW = Parameters(20); 
pG = Parameters(21);  pH = Parameters(22);
tau = Parameters(23);

% Compartments
Sg = old(1);  Sf = old(2);  Sw = old(3); % Susceptible people
Eg = old(4);  Ew = old(5);  % Exposed people
Ig = old(6);  Iw = old(7); % People becoming symptomatic
Ige = old(8); Iwe = old(9); % People in Ebola care center 
Fg = old(10); Fge = old(11); Fwe = old(12); % Ebola victim's funeral 
Rg = old(13); Rge = old(14); Rwe = old(15); % Recovered Ebola victims
Dg = old(16); Dge = old(17); Dwe = old(18); % Buried Ebola victims
% Compartments for fitting
Cincd = old(19);  % cumulative incidences
Cdied = old(20); % cumulative deaths
CHCW = old(21);  % cumulative healthcare workers
CHospAd = old(22); % cumulative admissions to health care centers


Ng = Sg+Sf+Eg+Ig+Rg;
Nw = Sw+Ew+Iw+Iwe+Rwe;
Nd = Sg+Sf+Sw+Eg+Ew+Rg+Rge+Rwe; 
NF = Nd/(gammaF*E);
Ft = Fg+Fge+Fwe;
% initialize arrays
Change = zeros(25,size(old,1)); %21 rates, X states
Rate = zeros(25,1);


%%%% Transitions
%%% Level 1 (getting infection)
% General: susc -> exposed
Rate(1) = (1-phiG)*betaI*Sg*(Ig/Ng);                                              Change(1,1) = -1; Change(1,4) = +1;

% Funeral: susc -> exposed
Rate(2) = omega*betaI*(Ft/(Ft+NF))*Sf;                                            Change(2,2) = -1; Change(2,4) = +1; 

% Worker: susc -> exposed
Rate(3) = (1-phiW)*betaW*Sw*(Iw+Iwe+Ige)/(Nw+Ige);                                Change(3,3) = -1; Change(3,5) = +1;


%%% Level 2 (becoming symtomatic)
% General: exposed -> inf
Rate(4) = alpha*Eg;                                                               Change(4,4) = -1; Change(4,6) = +1;

% Worker: exposed -> inf
Rate(5) = alpha*Ew;                                                               Change(5,5) = -1; Change(5,7) = +1;



%%% Level 3 (moving to Ebola Care)
% General: inf -> ebola care
Rate(6) = gammaH*theta*Ig;                                                        Change(6,6) = -1; Change(6,8) = +1;

% Hosp: inf -> ebola care
Rate(7) = gammaH*Iw;                                                              Change(7,7) = -1; Change(7,9) = +1;


%%% Level 4 (dying and having funeral)
% General: inf -> funeral
Rate(8) = (1-pG)*(1-theta)*deltaG*gammaD*Ig;                                      Change(8,6) = -1; Change(8,10) = +1;

% General EC: inf -> funeral
Rate(9) = (1-pH)*deltaH*gammaDH*Ige;                                              Change(9,8) = -1; Change(9,11) = +1;

% Worker EC: inf -> buried
Rate(10) = (1-pH)*deltaH*gammaDH*Iwe;                                             Change(10,9) = -1; Change(10,12) = +1;


%%% Level 5 (recovering from Ebola)
% General: inf -> recovered
Rate(11) = (1-theta)*(1-deltaG)*gammaR*Ig;                                        Change(11,6) = -1; Change(11,13) = +1;  

% General EC: inf -> recovered
Rate(12) = (1-deltaH)*gammaRH*Ige;                                                Change(12,8) = -1; Change(12,14) = +1;  

% Worker EC: inf -> recovered
Rate(13) = (1-deltaH)*gammaRH*Iwe;                                                Change(13,9) = -1; Change(11,15) = +1;  


%%% Level 5 (burials of Ebola Victims)
% General: inf -> buried
Rate(14) = pG*(1-theta)*deltaG*gammaD*Ig;                                         Change(14,6) = -1; Change(14,16) = +1;

% General EC: inf -> buried
Rate(15) = pH*deltaH*gammaDH*Ige;                                                 Change(15,8) = -1; Change(15,17) = +1;

% Worker EC: inf -> buried
Rate(16) = pH*deltaH*gammaDH*Iwe;                                                 Change(16,9) = -1; Change(16,18) = +1;


%%% Level 5 (normal burial)
Rate(17) = gammaF*Fg;                                                             Change(17,10) = -1; Change(17,16) = +1;

Rate(18) = gammaF*Fge;                                                            Change(18,11) = -1; Change(18,17) = +1;

Rate(19) = gammaF*Fwe;                                                            Change(19,12) = -1; Change(19,18) = +1;


%%% Level 6 (flow between general communitya and funerals)
% General:susc -> Funeral:susc
Rate(20) = MF*(Nd/E +  (1-pG)*deltaG*(1-theta)*gammaD*Ig...
    +(1-pH)*deltaH*gammaDH*(Ige+Iwe))*Sg/(Ng-Sf);                                 Change(20,1) = -1; Change(20,2) = +1;  

% Funeral:susc -> General:susc
Rate(21) = fFG*Sf;                                                                Change(21,2) = -1; Change(21,1) = +1;


%%% For fitting (no reductions, only additions)
% Cumulative Cases
Rate(22) = reportingrateGeneral*alpha*Eg + reportingrateHospital*alpha*Ew;        Change(22,19) = +1;

% Cumulative Deaths 
Rate(23) =  deltaG*reportingrateGeneral*((1-theta)*gammaD*Ig)...
           + deltaH*reportingrateHospital*(gammaDH*Ige)... 
           + deltaH*reportingrateHospital*(gammaDH*Iwe);                          Change(23,20) = +1;

% Cumulative HCW cases
Rate(24) = reportingrateHospital*alpha*Ew;                                        Change(24,21) = +1;

% Cumulative Hospital Admissions
Rate(25) = gammaH*theta*Ig +gammaH*Iw;                                            Change(25,22) = +1;

%% run algorithm
new_value=old;
for i=1:size(Rate,1)
    Num=Rate(i)*tau; 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




