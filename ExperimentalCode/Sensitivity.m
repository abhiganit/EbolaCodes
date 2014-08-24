load sixmonthcumsum
N0 = 4.09e6;  
Sw0 = (2.8/10000)*N0;
alpha = 1/8;        % 1/alpha: mean duration of the incubation period 
gammaD = 1/7.5;       % 1/gammaD: mean duration from onset to death
gammaI = 1/9; %10;      % 1/gammaI: mean duration of the infectious period for survivors
gammaH = 1./5;    % 1/Time between hospitalization and death
fGHN = 62131;
fHG = 1/7;          % 1/average time spent at in hospital with non-ebola disease
M =  5;            % average family size
MH = 1;             % additional family members visiting hospital
omega = 1.2;
epsilon = 100/100;       % percentage Symptomatic illness 


y = [Sw0,alpha,gammaD,gammaI,gammaH,fGHN,fHG,M,MH,omega,epsilon];


for i = 1:length(y)
    if i ==11
        old = y(i);
        y(i) = y(i)-0.1*y(i);
        x = EbolaModelFit(y);
        output1 = EbolaModelRunIntervention(x,y);
        sensitivity(i) = (output1-output0)/(0.1*y(i));
        elasticity(i) = sensitivity(i)*old/output0;
        y(i) = old;
    else
        old = y(i);
        y(i) = y(i)+0.1*y(i);
        x = EbolaModelFit(y);
        output1 = EbolaModelRunIntervention(x,y);
        sensitivity(i) = (output1-output0)/(0.1*y(i));
        elasticity(i) = sensitivity(i)*old/output0;
        y(i) = old;
    end
end
    

data1 = sensitivity;
data2 = elasticity*100;
figure;
subplot(1,2,1)
barh(data1);
subplot(1,2,2)
barh(data2)





    