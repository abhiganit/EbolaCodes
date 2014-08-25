function [T,P]=Stoch_Iteration(Time,Initial,Parameters,HospitalVisitors)


tau=Parameters(end);


T=0:tau:Time(2); 
P(1,:)= Initial;
old=Initial;

loop=1;
while (T(loop)<Time(2)) 
    [new]=Tau_leap(old,Parameters,HospitalVisitors);
    loop=loop+1;
    P(loop,:)=new; old=new;
end