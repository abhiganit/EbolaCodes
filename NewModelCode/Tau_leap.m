function [new_value]=Tau_leap(old, Parameters)

% Parameters
betaI = Parameters(1); betaH1 = Parameters(2); betaW = Parameters(3); betaF = Parameters(4);
alpha = Parameters(5);
theta= Parameters(6);
gammaH = Parameters(7); gammaI = Parameters(8); gammaD = Parameters(9); gammaDH = Parameters(10); gammaIH = Parameters(11); gammaF = Parameters(12);
delta1 = Parameters(13); delta2 = Parameters(14);
fGF = Parameters(15); fFG = Parameters(16); fGH = Parameters(17); fHG = Parameters(18);
epsilon = Parameters(19); tau = Parameters(20);


% Compartments
Sg=old(1); Sf=old(2); Sh=old(3); Sw = old(4);
Eg = old(5); Ef= old(6); Eh = old(7); Ew = old(8);
Ig = old(9); If = old(10); Ih = old(11); Iw = old(12);
Fg = old(12); Ff = old(13); Fh = old(14); Fw = old(16);
Rg = old(17); Rf = old(18); Rh = old(19); Rw = old(20);
Dg = old(21); Df = old(22); Dh = old(23); Dw = old(24);

F = Fg+Ff+Fh+Fw;
Ng = Sg+Eg+Ig+Fg+Rg+Dg;
Nf = Sf+Ef+If+Ff+Rf+Df;
Nh = Sh+Eh+Ih+Fh+Rh+Dh;
Nw = Sw+Ew+Iw+Fw+Rw+Dw;
N = Ng+Nf+Nh+Nw;
Change = zeros(30,24); % 30 is no of events and 24 is no of compartments
Rate = zeros(30,1);
%% Transitions
% General: susc -> exposed
Rate(1) =epsilon*betaI*Sg*Ig/Ng;                          Change(1,1) = -1; Change(1,5) = +1;
% Funeral: susc -> exposed
Rate(2) = epsilon*betaF*Sf;                               Change(2,2) = -1; Change(2,6) = +1;
% Hosp: susc -> exposed
Rate(3) = epsilon*(betaH1*Sh*Ih/Nh + betaW*Sh*Iw/Nw);     Change(3,3) = -1; Change(3,7) = +1;  %could we have transmissibility between hospitalized patients be same as in general popn?
% Worker: susc -> exposed
Rate(4) = epsilon*(betaW*Sw*Ih/Nh + betaI*Sw*Ih/Nh);      Change(4,4) = -1; Change(4,8) = +1;


% General: exposed -> inf
Rate(5) = alpha*Eg;                                      Change(5,5) = -1; Change(5,9) = +1;
% Funeral: exposed -> inf
Rate(6) = alpha*Ef;                                      Change(6,6) = -1; Change(6,10) = +1;
% Hosp: exposed -> inf
Rate(7) = alpha*Eh;                                      Change(7,7) = -1; Change(7,11) = +1;
% Worker: exposed -> inf
Rate(8) = alpha*Ew;                                      Change(8,8) = -1; Change(8,12) = +1;

% General: inf -> funeral
Rate(9) = delta1*(1-theta)*gammaD*Ig;                    Change(9,9) = -1; Change(9,13) = +1;
% Funeral: inf -> funeral
Rate(10) = delta1*(1-theta)*gammaD*If;                   Change(10,10) = -1; Change(10,14) = +1;
% Hosp: inf -> funeral
Rate(11) = delta2*gammaDH*Ih;                            Change(11,11) = -1; Change(11,15) = +1;
% Worker: inf -> funeral
Rate(12) = delta2*gammaDH*Iw;                            Change(12,12) = -1; Change(12,16) = +1;

% General: inf -> recovered
Rate(13) = gammaI*(1-theta)*(1-delta1)*Ig;               Change(13,9) = -1; Change(13,17) = +1;
% Funeral: inf -> recovered
Rate(14) = gammaI*(1-theta)*(1-delta1)*If;               Change(14,10) = -1; Change(14,18) = +1;
% Hosp: inf -> recovered
Rate(15) = gammaIH*(1-delta2)*Ih;                        Change(15,11) = -1; Change(15,19) = +1;
% Worker: inf -> recovered
Rate(16) = gammaIH*(1-delta2)*Iw;                        Change(16,12) = -1; Change(16,20) = +1;

% General: funeral -> dead
Rate(17) = gammaF*Fg;                                    Change(17,13) = -1; Change(17,21) = +1;
% Funeral: funeral -> dead
Rate(18) = gammaF*Ff;                                    Change(18,14) = -1; Change(18,22) = +1;
% Hosp: funeral -> dead
Rate(19) = gammaF*Fh;                                    Change(19,15) = -1; Change(19,23) = +1;
% Worker: funeral -> dead
Rate(20) = gammaF*Fw;                                    Change(20,16) = -1; Change(20,24) = +1;

% General:susc -> Funeral:susc
Rate(21) = fGF*F/N;                                      Change(21,1) = -1; Change(21,2) = +1;
% Funeral:susc -> General:susc
Rate(22) = fFG*Sf;                                       Change(22,2) = -1; Change(22,1) = +1;
% General:susc -> Hosp:susc
Rate(23) = fGH*Sg;                                       Change(23,1) = -1; Change(23,3) = +1;      
% Hosp:susc -> General:susc
Rate(24) = fHG*Sh;                                       Change(24,3) = -1; Change(24,1) = +1;

% General:inf -> Hosp:inf
Rate(25) = gammaH*theta*Ig;                              Change(25,9) = -1; Change(25,11) = +1;
% Funeral:inf -> Hosp:inf
Rate(26) = gammaH*theta*If;                              Change(26,10) = -1; Change(26,11) = +1;
% General:susc -> General:recovered
Rate(27) =(1-epsilon)*betaI*Sg*Ig/Ng;                     Change(27,1) = -1; Change(27,17) = +1;
% Funeral:susc -> Funeral:recovered
Rate(28) = (1-epsilon)*epsilon*betaF*Sf;                   Change(28,2) = -1; Change(28,18) = +1;
% Hosp:susc -> Hosp:recovered
Rate(29) = (1-epsilon)*betaH1*Sh*(Ih/Nh+Iw/Nw);           Change(29,3) = -1; Change(29,19) = +1;
% Worker:susc -> Worker:recovered
Rate(30) = (1-epsilon)*betaW*Sw*(Ih/Nh+Iw/Nw);            Change(30,4) = -1; Change(30,20) = +1;


new_value=old;

for i=1:size(Rate,1)
    Num=poissrnd(Rate(i)*tau);
%     if i==4
%         
%     end
    %% Make sure things don't go negative
    Use=min([Num new_value(find(Change(i,:)<0))]);
    new_value=new_value+Change(i,:)*Use;
end


