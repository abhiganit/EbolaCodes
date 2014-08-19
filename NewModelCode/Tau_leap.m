function [new_value]=Tau_leap(old, Parameters)
% Parameters
betaI = Parameters(1); betaH = Parameters(2); betaW = Parameters(3); omega = Parameters(4);
alpha = Parameters(5);
theta= Parameters(6);
gammaH = Parameters(7); gammaI = Parameters(8); gammaD = Parameters(9); gammaDH = Parameters(10); gammaIH = Parameters(11); gammaF = Parameters(12);
%delta1 = Parameters(13); delta2 = Parameters(14);
MF = Parameters(13);  MH = Parameters(14);
fFG = Parameters(15); fGH = Parameters(16); fHG = Parameters(17);
epsilon = Parameters(18); KikwitGeneralPrev = Parameters(19); KikwitNonhospPrev = Parameters(20); E = Parameters(21); tau = Parameters(22);


% Compartments
Sg = old(1);  Sf = old(2);   Sh = old(3);  Sw = old(4);
Eg = old(5);  Eh = old(6);  Ew = old(7);
Ig = old(8);  Ih = old(9); Iw = old(10);
Fg = old(11); Fh = old(12); Fw = old(13);
Rg = old(14); Rh = old(15); Rw = old(16);
Dg = old(17); Dh = old(18); Dw = old(19);
Cincg = old(20); Cincf = old(21); Cinch = old(22); Cincw = old(23);
Cdiedg = old(24); Cdiedh = old(25); Cdiedw = old(26);
CHosp = old(27); %CHospDis = old(34);

%F = Fg+Fh+Fw;
%Ng = max(Sg+Eg+Ig+Fg+Rg+Dg,1);
Ng = max(Sg+Sf+Eg+Ig+Rg,1);
Nh = max(Sh+Eh+Ih+Rh,1);
Nw = max(Sw+Ew+Iw+Rw,1);
%N = Sg+Eg+Ig+Fg+Rg+Dg   +   Sf+Ef+If+Ff+Rf+Df   +    Sh+Eh+Ih+Fh+Rh+Dh  + Sw+Ew+Iw+Fw+Rw+Dw;
Nd = Ng + Nh + Nw;

% initialize arrays
Change = zeros(32,size(old,1)); %33 states, 40 events
Rate = zeros(32,1);

%prob ebola funeral
 newebolafunerals = (1-theta)*gammaD*(Ig) + gammaDH*(Ih+Iw);  %delta1*   delta2*
 newnonebolafunerals = Nd/E;

%% Transitions
% General: susc -> exposed
Rate(1) = betaI*Sg*(Ig/Ng);                         Change(1,1) = -1; Change(1,5) = +1;
% Funeral: susc -> exposed
Rate(2) = (omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
                betaI*(newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;               Change(2,2) = -1; Change(2,5) = +1; %betaF*Sf; Ig/Ng
% Hosp: susc -> exposed
Rate(3) = betaH*Sh*(Ih+Iw)/(Nh+Nw);      Change(3,3) = -1; Change(3,6) = +1;  %could we have transmissibility between hospitalized patients be same as in general popn?
% Worker: susc -> exposed
Rate(4) = betaW*Sw*(Ih+Iw)/(Nh+Nw);      Change(4,4) = -1; Change(4,7) = +1;


% General: exposed -> inf
Rate(5) = epsilon*alpha*Eg;                                      Change(5,5) = -1; Change(5,8) = +1;
% Hosp: exposed -> inf
Rate(6) = epsilon*alpha*Eh;                                      Change(6,6) = -1; Change(6,9) = +1;
% Worker: exposed -> inf
Rate(7) = epsilon*alpha*Ew;                                      Change(7,7) = -1; Change(7,10) = +1;

% General: inf -> funeral
Rate(8) = (1-theta)*gammaD*Ig;                    Change(8,8) = -1; Change(8,11) = +1;  %delta1*

% Hosp: inf -> funeral
Rate(9) = gammaDH*Ih;                            Change(9,9) = -1; Change(9,12) = +1;  %delta2*
% Worker: inf -> funeral
Rate(10) = gammaDH*Iw;                            Change(10,10) = -1; Change(10,13) = +1;  %delta2*

% General: inf -> recovered
Rate(11) = gammaI*(1-theta)*Ig;               Change(11,8) = -1; Change(11,14) = +1;  %*(1-delta1)
% Hosp: inf -> recovered
Rate(12) = gammaIH*Ih;                        Change(12,9) = -1; Change(12,15) = +1;  %*(1-delta2)
% Worker: inf -> recovered
Rate(13) = gammaIH*Iw;                        Change(13,10) = -1; Change(13,16) = +1;  %*(1-delta2)

% General: funeral -> dead
Rate(14) = gammaF*Fg;                                    Change(14,11) = -1; Change(14,17) = +1;

% Hosp: funeral -> dead
Rate(15) = gammaF*Fh;                                    Change(15,12) = -1; Change(15,18) = +1;
% Worker: funeral -> dead
Rate(16) = gammaF*Fw;                                    Change(16,13) = -1; Change(16,19) = +1;

% General:susc -> Funeral:susc
Rate(17) = MF*(Nd/E +  (1-theta)*gammaD*Ig+gammaDH*(Ih+Iw))*Sg/(Ng-Sf);           Change(17,1) = -1; Change(17,2) = +1;  %delta1* delta2*    
% Funeral:susc -> General:susc
Rate(18) = fFG*Sf;                                       Change(18,2) = -1; Change(18,1) = +1;
% General:susc -> Hosp:susc
Rate(19) = (MH+1)*fGH*Sg + MH*gammaH*theta*Ig*Sg/Ng;                                     Change(19,1) = -1; Change(19,3) = +1;    % ; (1-t/54)*  family members attending hospital for non-ebola cases + ebola cases   
% Hosp:susc -> General:susc
Rate(20) = fHG*Sh;                                       Change(20,3) = -1; Change(20,1) = +1;
% General:inf -> Hosp:inf
Rate(21) = gammaH*theta*Ig;                              Change(21,8) = -1; Change(21,9) = +1;

% General:exposed -> General:recovered
Rate(22) =(1-epsilon)*alpha*Eg;                                Change(22,5) = -1; Change(22,14) = +1;
% Hosp:exposed -> Hosp:recovered
Rate(23) = (1-epsilon)*alpha*Eh;           Change(23,6) = -1; Change(23,15) = +1;
% Worker:susc -> Worker:recovered
Rate(24) = (1-epsilon)*alpha*Ew;           Change(24,7) = -1; Change(24,16) = +1;

%% Cumulative Incidences (no reductions, only additions)
% General: susc -> exposed
Rate(25) = betaI*Sg*Ig/Ng;                         Change(25,20) = +1;
% Funeral: susc -> exposed
Rate(26) = (omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
                betaI*(newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;     Change(26,21) = +1; %betaF*Sf;
% Hosp: susc -> exposed
Rate(27) = betaH*Sh*(Ih+Iw)/(Nh+Nw);      Change(27,22) = +1;  
% Worker: susc -> exposed
Rate(28) = betaW*Sw*(Ih+Iw)/(Nh+Nw);      Change(28,23) = +1;

%% Cumulative Deaths (no reductions, only additions)
% General: inf -> funeral
Rate(29) = (1-theta)*gammaD*Ig;                   Change(29,24) = +1;  %delta1*
% Hosp: inf -> funeral
Rate(30) = gammaDH*Ih;                            Change(30,25) = +1;  %delta2*
% Worker: inf -> funeral
Rate(31) = gammaDH*Iw;                            Change(31,26) = +1;  %delta2*


%% Cumulative Hospitalizations (including HCW)
Rate(32) = gammaH*theta*Ig + alpha*(Eh+Ew);             Change(32,27) = +1;  %gammaH*Iw  + 
   

%% Cumulative Hospital Discharges (including HCW)
%Rate(40) = gammaIH*(1-delta2)*Ih + gammaIH*(1-delta2)*Iw;       Change(40,34) = +1;


%% run algorithm

new_value=old;

for i=1:size(Rate,1)
    Num=poissrnd(Rate(i)*tau); 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




