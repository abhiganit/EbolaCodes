function [new_value]=Tau_step(old, Parameters, t)

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
Eg = old(5);  Ef = old(6);   Eh = old(7);  Ew = old(8);
Ig = old(9);  If = old(10); Ih = old(11); Iw = old(12);
Fg = old(13); Ff = old(14); Fh = old(15); Fw = old(16);
Rg = old(17); Rf = old(18); Rh = old(19); Rw = old(20);
Dg = old(21); Df = old(22); Dh = old(23); Dw = old(24);
Cincg = old(25); Cincf = old(26); Cinch = old(27); Cincw = old(28);
Cdiedg = old(29); Cdiedf = old(30); Cdiedh = old(31); Cdiedw = old(32);
CHosp = old(33); %CHospDis = old(34);

Ng = Sg+Eg+Ig+Rg;
Nf = Sf+Ef+If+Rf;
Nh = Sh+Eh+Ih+Rh;
Nw = Sw+Ew+Iw+Rw;
Nd = Ng + Nf + Nh + Nw;

% initialize arrays
Change = zeros(33,size(old,1)); %33 states, 40 events
Rate = zeros(33,1);

%prob ebola funeral
 newebolafunerals = (1-theta)*gammaD*(Ig+If) + gammaDH*(Ih+Iw);  %delta1*   delta2*
 newnonebolafunerals = Nd/E;

%% Transitions
% General: susc -> exposed
Rate(1) = epsilon*betaI*Sg*((Ig+If)/(Nf+Ng));                         Change(1,1) = -1; Change(1,5) = +1;
% Funeral: susc -> exposed
%Rate(2) = epsilon*Sf*(omega-1)*betaI*KikwitNonhospPrev;               Change(2,2) = -1; Change(2,6) = +1; %betaF*Sf; Ig/Ng
%Rate(2) = epsilon*(omega-1)*betaI*Sf*F/N;               Change(2,2) = -1; Change(2,6) = +1; %betaF*Sf; Ig/Ng
Rate(2) = epsilon*(omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
                betaI*(newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;               Change(2,2) = -1; Change(2,6) = +1; %betaF*Sf; Ig/Ng
% Hosp: susc -> exposed
Rate(3) = epsilon*betaH*Sh*(Ih/Nh + Iw/Nw);      Change(3,3) = -1; Change(3,7) = +1;  %could we have transmissibility between hospitalized patients be same as in general popn?
% Worker: susc -> exposed
Rate(4) = epsilon*betaW*Sw*(Ih/Nh + Iw/Nw);      Change(4,4) = -1; Change(4,8) = +1;


% General: exposed -> inf
Rate(5) = alpha*Eg;                                      Change(5,5) = -1; Change(5,9) = +1;
% Funeral: exposed -> inf
Rate(6) = alpha*Ef;                                      Change(6,6) = -1; Change(6,10) = +1;
% Hosp: exposed -> inf
Rate(7) = alpha*Eh;                                      Change(7,7) = -1; Change(7,11) = +1;
% Worker: exposed -> inf
Rate(8) = alpha*Ew;                                      Change(8,8) = -1; Change(8,12) = +1;

% General: inf -> funeral
Rate(9) = (1-theta)*gammaD*Ig;                    Change(9,9) = -1; Change(9,13) = +1;  %delta1*
% Funeral: inf -> funeral
Rate(10) = (1-theta)*gammaD*If;                   Change(10,10) = -1; Change(10,14) = +1;  %delta1*
% Hosp: inf -> funeral
Rate(11) = gammaDH*Ih;                            Change(11,11) = -1; Change(11,15) = +1;  %delta2*
% Worker: inf -> funeral
Rate(12) = gammaDH*Iw;                            Change(12,12) = -1; Change(12,16) = +1;  %delta2*

% General: inf -> recovered
Rate(13) = gammaI*(1-theta)*Ig;               Change(13,9) = -1; Change(13,17) = +1;  %*(1-delta1)
% Funeral: inf -> recovered
Rate(14) = gammaI*(1-theta)*If;               Change(14,10) = -1; Change(14,18) = +1;  %*(1-delta1)
% Hosp: inf -> recovered
Rate(15) = gammaIH*Ih;                        Change(15,11) = -1; Change(15,19) = +1;  %*(1-delta2)
% Worker: inf -> recovered
Rate(16) = gammaIH*Iw;                        Change(16,12) = -1; Change(16,20) = +1;  %*(1-delta2)

% General: funeral -> dead
Rate(17) = gammaF*Fg;                                    Change(17,13) = -1; Change(17,21) = +1;
% Funeral: funeral -> dead
Rate(18) = gammaF*Ff;                                    Change(18,14) = -1; Change(18,22) = +1;
% Hosp: funeral -> dead
Rate(19) = gammaF*Fh;                                    Change(19,15) = -1; Change(19,23) = +1;
% Worker: funeral -> dead
Rate(20) = gammaF*Fw;                                    Change(20,16) = -1; Change(20,24) = +1;

% General:susc -> Funeral:susc
Rate(21) = MF*(Nd/E +  (1-theta)*gammaD*(Ig+If)+gammaDH*(Ih+Iw));           Change(21,1) = -1; Change(21,2) = +1;  %delta1* delta2*    
% Funeral:susc -> General:susc
Rate(22) = fFG*Sf;                                       Change(22,2) = -1; Change(22,1) = +1;
% General:susc -> Hosp:susc
Rate(23) = (MH+1)*fGH*Sg + MH*gammaH*theta*Ig;                                     Change(23,1) = -1; Change(23,3) = +1;    % ; (1-t/54)*  family members attending hospital for non-ebola cases + ebola cases   
% Hosp:susc -> General:susc
Rate(24) = fHG*Sh;                                       Change(24,3) = -1; Change(24,1) = +1;
% General:exp -> Hosp:exp
% Rate(25) = 0;                                     Change(25,5) = -1; Change(25,7) = +1;    % ; (1-t/54)* %(MH+1)*fGH*Eg + MH*gammaH*theta*Ig*(Eg/(Sg+Eg));
% % Hosp:exp -> General:exp
% Rate(26) = 0;                                       Change(26,7) = -1; Change(26,5) = +1;  %fHG*Eh;

% General:inf -> Hosp:inf
Rate(25) = gammaH*theta*Ig;                              Change(25,9) = -1; Change(25,11) = +1;
% Funeral:inf -> Hosp:inf
Rate(26) = gammaH*theta*If;                              Change(26,10) = -1; Change(26,11) = +1;

% General:susc -> General:recovered
%<<<<<<< HEAD
Rate(27) =(1-epsilon)*betaI*Sg*(Ig+If)/(Ng+Nf);                               Change(27,1) = -1; Change(27,17) = +1;
% =======
% Rate(29) =(1-epsilon)*betaI*Sg*(Ig+If)/(Ng+Nf);                               Change(29,1) = -1; Change(29,17) = +1;
% >>>>>>> RecoverRates
% Funeral:susc -> Funeral:recovered
%Rate(28) = (1-epsilon)*Sf*(omega-1)*betaI*KikwitNonhospPrev;                    Change(28,2) = -1; Change(28,18) = +1; %betaF*Sf;
Rate(28) = (1-epsilon)*(omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*betaI*...
            (newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;       Change(28,2) = -1; Change(28,18) = +1; %betaF*Sf;
%Rate(28) = (1-epsilon)*(omega-1)*betaI*Sf*F/N;                    Change(28,2) = -1; Change(28,18) = +1; %betaF*Sf;
% Hosp:susc -> Hosp:recovered
Rate(29) = (1-epsilon)*betaH*Sh*(Ih/Nh + Iw/Nw);           Change(29,3) = -1; Change(29,19) = +1;
% Worker:susc -> Worker:recovered
Rate(30) = (1-epsilon)*betaW*Sw*(Ih/Nh + Iw/Nw);           Change(30,4) = -1; Change(30,20) = +1;

%% Cumulative Incidences (no reductions, only additions)
% General: susc -> exposed
% <<<<<<< HEAD
Rate(31) = epsilon*betaI*Sg*(Ig+If)/(Ng+Nf);                         Change(31,25) = +1;
% =======
% Rate(33) = epsilon*betaI*Sg*(Ig+If)/(Ng +Nf);                         Change(33,25) = +1;
% >>>>>>> RecoverRates
% Funeral: susc -> exposed
%Rate(32) = epsilon*Sf*(omega-1)*betaI*KikwitNonhospPrev;          Change(32,26) = +1; %betaF*Sf; 
Rate(32) = epsilon*(omega-1)*(KikwitNonhospPrev/KikwitGeneralPrev)*...
                betaI*(newebolafunerals/(newebolafunerals+newnonebolafunerals))*Sf;     Change(32,26) = +1; %betaF*Sf;
%Rate(32) = epsilon*(omega-1)*betaI*Sf*F/N;          Change(32,26) = +1; %betaF*Sf; 
% Hosp: susc -> exposed
Rate(33) = epsilon*betaH*Sh*(Ih/Nh + Iw/Nw);      Change(33,27) = +1;  
% Worker: susc -> exposed
Rate(34) = epsilon*betaW*Sw*(Ih/Nh + Iw/Nw);      Change(34,28) = +1;

%% Cumulative Deaths (no reductions, only additions)
% General: inf -> funeral
Rate(35) = (1-theta)*gammaD*Ig;                   Change(35,29) = +1;  %delta1*
% Funeral: inf -> funeral
Rate(36) = (1-theta)*gammaD*If;                   Change(36,30) = +1;  %delta1*
% Hosp: inf -> funeral
Rate(37) = gammaDH*Ih;                            Change(37,31) = +1;  %delta2*
% Worker: inf -> funeral
Rate(38) = gammaDH*Iw;                            Change(38,32) = +1;  %delta2*


%% Cumulative Hospitalizations (including HCW)
Rate(39) = gammaH*theta*(Ig+If) + alpha*(Eh+Ew);             Change(39,33) = +1;  %gammaH*Iw  + 
   

%% Cumulative Hospital Discharges (including HCW)
%Rate(40) = gammaIH*(1-delta2)*Ih + gammaIH*(1-delta2)*Iw;       Change(40,34) = +1;


%% run algorithm
new_value=old;
for i=1:size(Rate,1)
    Num=Rate(i)*tau; 
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end




