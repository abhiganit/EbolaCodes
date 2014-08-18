function [T,P]=Diffeqn_Iteration(Time,Initial,Parameters)

tau=Parameters(end);
T=[0:tau:Time(2)]; 
P(1,:)= Initial;
old=Initial;

loop=1;
while (T(loop)<Time(2))  
%     [new]=Tau_step(old,Parameters, T(loop));
    [new]=Tau_step_AbhiSimple(old,Parameters, T(loop));

    if(size(old,2)==33)
        display('problem');
    end
%     [new]=Tau_step_KatieSimple(old,Parameters, T(loop));

    loop=loop+1;
    P(loop,:)=new; old=new;
   
end