function [T,P]=Stoch_Iteration(Time,Initial,Parameters)


tau=Parameters(end);


T=Time(1):tau:Time(2); 
P(1,:)= Initial;
old=Initial;

loop=1;
while (T(loop)<Time(2)) 
    [new]=Tau_leap(old,Parameters);
    loop=loop+1;
    P(loop,:)=new; old=new;
end