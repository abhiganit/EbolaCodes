function [T,P]=Stoch_Iteration(Time,Initial,Parameters)

S=Initial(1); E=Initial(2); I=Initial(3); H = Initial(4); F = Initial(5); R = Initial(6);

tau=Parameters(end);


T=[0:tau:Time(2)]; 
P(1,:)=[S E I H F R];
old=[S E I H F R];


loop=1;
while (T(loop)<Time(2))  
    [new]=Tau_leap(old,Parameters);
    loop=loop+1;
    P(loop,:)=new; old=new;
end