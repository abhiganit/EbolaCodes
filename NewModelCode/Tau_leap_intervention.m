function [new_value]=Tau_leap_intervention(old, Parameters,HospitalVisitors)
% Parameters
betaI = Parameters(1); betaH = Parameters(2); betaW = Parameters(3); omega = Parameters(4);
alpha = Parameters(5);
theta= Parameters(6);
gammaH = Parameters(7); gammaI = Parameters(8); gammaD = Parameters(9); gammaDH = Parameters(10); gammaIH = Parameters(11); gammaF = Parameters(12);
MF = Parameters(13);  MH = Parameters(14);
fFG = Parameters(15); fGH = Parameters(16); fHG = Parameters(17);
epsilon = Parameters(18); KikwitGeneralPrev = Parameters(19); KikwitNonhospPrev = Parameters(20); E = Parameters(21);
% intervention parameters
iH = Parameters(22);  phiG = Parameters(23); phiW = Parameters(24);
phiC = Parameters(25); pG = Parameters(26); pH = Parameters(27);  C = Parameters(28); tau = Parameters(29);


% Compartments
Sg = old(1);  Sf = old(2);   Sh = old(3);  Sw = old(4);
Eg = old(5);  Eh = old(6);  Ew = old(7);
Ig = old(8);  Ih = old(9); Iw = old(10);
Fg = old(11); Fh = old(12); Fw = old(13);
Rg = old(14); Rh = old(15); Rw = old(16);
Dg = old(17); Dh = old(18); Dw = old(19);
Cincg = old(20); Cinch = old(21); Cincw = old(22);
Cdiedg = old(23); Cdiedh = old(24); Cdiedw = old(25);
CHosp = old(26); 
Iht = old(27); Iwt = old(28);
T = old(29); A = old(30);


Ng = Sg+Sf+Eg+Ig+Rg;
Nh = Sh+Eh+Ih+Iht+Rh;
Nw = Sw+Ew+Iw+Iwt+Rw;
Nd = Ng + Nh + Nw;
F = Fg + Fh + Fw;
NF = Nd/(gammaF*E);
% initialize arrays
Change = zeros(43,size(old,1)); 
Rate = zeros(43,1);

%prob ebola funeral
% newebolafunerals = (1-pG)*((1-theta)*gammaD*(Ig)) +(1-pH)*gammaDH*(Ih+Iw); 
% newnonebolafunerals = Nd/E;

%% Transitions
% General: susc -> exposed
Rate(1) = (1-phiG)*betaI*Sg*(Ig/Ng);                         Change(1,1) = -1; Change(1,5) = +1;
% Funeral: susc -> exposed
%Rate(2) = gammaF*(omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
%                 betaI*(newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;               Change(2,2) = -1; Change(2,5) = +1;

Rate(2) = ((21*omega-19)/2)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
               betaI*(F/(F+NF))*Sf;               Change(2,2) = -1; Change(2,5) = +1; 
% Hosp: susc -> exposed
Rate(3) = betaH*Sh*(Ih+Iht+Iw+Iwt)/(Nh+Nw);      					Change(3,3) = -1; Change(3,6) = +1; 
% Worker: susc -> exposed
Rate(4) = (1-phiW)*betaW*Sw*(Ih+Iht+Iw+Iwt)/(Nh+Nw);      				Change(4,4) = -1; Change(4,7) = +1;


% General: exposed -> inf
Rate(5) = epsilon*alpha*Eg;                                      Change(5,5) = -1; Change(5,8) = +1;
% Hosp: exposed -> inf
Rate(6) = epsilon*alpha*Eh;                                      Change(6,6) = -1; Change(6,27) = +1;
% Worker: exposed -> inf
Rate(7) = epsilon*alpha*Ew;                                      Change(7,7) = -1; Change(7,28) = +1;

% General: inf -> funeral
Rate(8) = (1-pG)*(1-theta)*gammaD*Ig;                    		Change(8,8) = -1; Change(8,11) = +1;  
% Hosp: inf -> funeral
Rate(9) = (1-pH)*gammaDH*Ih;                            		Change(9,9) = -1; Change(9,12) = +1;  
% Worker: inf -> funeral
Rate(10) = (1-pH)*gammaDH*Iw;                            		Change(10,10) = -1; Change(10,13) = +1;

% General: inf -> recovered
Rate(11) = gammaI*(1-theta)*Ig;               					Change(11,8) = -1; Change(11,14) = +1;  
% Hosp: inf -> recovered
Rate(12) = gammaIH*Ih;                        					Change(12,9) = -1; Change(12,15) = +1; 
% Worker: inf -> recovered
Rate(13) = gammaIH*Iw;                        					Change(13,10) = -1; Change(13,16) = +1;

% General: funeral -> dead
Rate(14) = gammaF*Fg;                                    		Change(14,11) = -1; Change(14,17) = +1;
% Hosp: funeral -> dead
Rate(15) = gammaF*Fh;                                    		Change(15,12) = -1; Change(15,18) = +1;
% Worker: funeral -> dead
Rate(16) = gammaF*Fw;                                    		Change(16,13) = -1; Change(16,19) = +1;

% General:susc -> Funeral:susc
Rate(17) = MF*(Nd/E +  (1-pG)*(1-theta)*gammaD*Ig+(1-pH)*gammaDH*(Ih+Iw))*Sg/(Ng-Sf);           Change(17,1) = -1; Change(17,2) = +1;     
% Funeral:susc -> General:susc
Rate(18) = fFG*Sf;                                       		Change(18,2) = -1; Change(18,1) = +1;
% General:susc -> Hosp:susc
Rate(19) = HospitalVisitors*((MH+1)*fGH*Sg + MH*gammaH*theta*Ig*Sg/Ng);            Change(19,1) = -1; Change(19,3) = +1;    
%Rate(19) = 0;                                                    Change(19,1) = -1; Change(19,3) = +1;    

% Hosp:susc -> General:susc
Rate(20) = fHG*Sh;                                       		Change(20,3) = -1; Change(20,1) = +1;
% General:inf -> Hosp:inf
Rate(21) = gammaH*theta*Ig;                              		Change(21,8) = -1; Change(21,9) = +1;

% General:exposed -> General:recovered
Rate(22) =(1-epsilon)*alpha*Eg;                                Change(22,5) = -1; Change(22,14) = +1;
% Hosp:exposed -> Hosp:recovered
Rate(23) = (1-epsilon)*alpha*Eh;           					   Change(23,6) = -1; Change(23,15) = +1;
% Worker:susc -> Worker:recovered
Rate(24) = (1-epsilon)*alpha*Ew;           					   Change(24,7) = -1; Change(24,16) = +1;

%% Cumulative Incidences (no reductions, only additions)
% General: susc -> exposed
Rate(25) = epsilon*alpha*Eg;                          			Change(25,20) = +1;
% Hosp: susc -> exposed  
Rate(26) = epsilon*alpha*Eh;      								Change(26,21) = +1;  
% Worker: susc -> exposed
Rate(27) = epsilon*alpha*Ew; 								    Change(27,22) = +1;


%% Cumulative Deaths (no reductions, only additions)
% General: inf -> funeral
Rate(28) = (1-theta)*gammaD*Ig;                   Change(28,23) = +1;  
% Hosp: inf -> funeral
Rate(29) = gammaDH*Ih;                            Change(29,24) = +1;  
% Worker: inf -> funeral
Rate(30) = gammaDH*Iw;                            Change(30,25) = +1; 


%% Cumulative Hospitalizations (including HCW)
Rate(31) = gammaH*theta*Ig + alpha*(Eh+Ew);             Change(31,26) = +1;  


%% Delay for infections at hospital
Rate(32) = gammaH*Iht;                               Change(32,27) = -1;    Change(32,9) = +1;
Rate(33) = gammaH*Iwt;                               Change(33,28) = -1;    Change(33,10) = +1;


%% Intervention Rates
%Rate(34) = iG*Ig;                                  Change(34,8) = -1;   Change(34,29) = +1;
%Rate(35) = iH*Iht;                                 Change(35,27) = -1;  Change(35,29) = +1;
%Rate(36) = iH*Iwt;                                 Change(36,28) = -1;  Change(36,29) = +1;
Rate(34) = 0;                                  Change(34,8) = -1;   Change(34,29) = +1;
Rate(35) = 0;                                 Change(35,27) = -1;  Change(35,29) = +1;
Rate(36) = 0;                                 Change(36,28) = -1;  Change(36,29) = +1;
Rate(37) = iH*Ih;                                  Change(37,9) = -1;   Change(37,29) = +1;
Rate(38) = iH*Iw;                                  Change(38,10) = -1;   Change(38,29) = +1;
% Rate(39) = (C*epsilon*alpha*Eg/(Sg+Eg))*(phiCG*Eg + phiCH*(Eh+Ew));   Change(39,5) = -1;   Change(39,30) = +1;
Rate(39) = (C*(1-(1-betaI/C)^(1/gammaH)))*phiC*gammaH*(Iht+Iwt+theta*Ig);   Change(39,5) = -1;   Change(39,30) = +1;
Rate(40) = alpha*epsilon*A;                        Change(40,30) = -1;  Change(40,29) = +1;
Rate(41) = pG*(1-theta)*gammaD*Ig;                 Change(41,8) = -1;   Change(41,17) = +1;
Rate(42) = pH*gammaDH*Ih;                          Change(42,9) = -1;   Change(42,18) = +1;
Rate(43) = pH*gammaDH*Iw;                          Change(43,10) = -1;  Change(43,19) = +1;


%% run algorithm

new_value=old;

for i=1:size(Rate,1)
    Num=poissrnd(Rate(i)*tau); 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




