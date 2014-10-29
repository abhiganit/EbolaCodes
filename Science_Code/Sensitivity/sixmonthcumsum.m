function[controls] = sixmonthcumsum(i,x)
iH = 0; phiG = 0; phiW = 0; phiC =0; pG =0; pH =0; 
controls = zeros(1,6);
 if i == 1
     pG = x; % Community burial
 elseif i == 2 % A
     pH = x; % Hosp burial
 elseif i == 3 % B
     pG = 0.5; pH = x; % Comm+Hosp burial
 elseif i == 4 % C
     iH = x; % HCW isolation
 elseif i == 5 % D
     iH = x; phiC = x; % HCW isol + Contact
 elseif i == 6
     pG =x; iH =x; 
 elseif i == 7
     pG =x; iH =x; phiC = x;
 elseif i == 8 % AC
     pH =x; iH =x; % Hosp burial + Isol
 elseif i == 9 % AD
     pH =x; iH =x; phiC = x; % Hosp burial + Iso+cont
 elseif i ==10 % BC
     pG =0.5; pH=x; iH =x; 
 else % BD
     pG =0.5; pH = x; iH = x; phiC = x;
 end
 
 controls = [iH, phiG, phiW, phiC, pG, pH];