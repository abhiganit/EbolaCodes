function [T,P]=Stoch_Iteration_intervention(Time,Initial,Parameters,HospitalVisitors)


tau=Parameters(end);


T=Time(1):tau:Time(2); 
P(1,:)= Initial;
old=Initial;

loop=1;
while (T(loop)<Time(2)) 
    [new]=Tau_leap_intervention(old,Parameters,HospitalVisitors);
    loop=loop+1;
    P(loop,:)=new; old=new;
end