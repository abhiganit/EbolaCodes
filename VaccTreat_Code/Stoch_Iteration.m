function [T,P]=Stoch_Iteration(Time,Initial,Parameters,HospitalVisitors, interventiondelay, immunitydelay, VE, VCov, TE, TCov)


tau=Parameters(end);


T=0:tau:Time(2); 
P(1,:)= Initial;
old=Initial;

loop=1;
while (T(loop)<Time(2)) 
    [new]=Tau_leap(old, Parameters, T(loop), HospitalVisitors,interventiondelay, immunitydelay, VE, VCov, TE, TCov);
    loop=loop+1;
    P(loop,:)=new; old=new;
end