function [T,P]=Stoch_Iteration(Time,Initial,Parameters)

S=Initial(1); E=Initial(2); I=Initial(3); H = Initial(4); F = Initial(5); R = Initial(6);

T=0; 
P(1,:)=[S E I H F R];
old=[S E I H F R];


loop=1;
while (T(loop)<Time(2))  
    [step,new]=Iterate(old,Parameters);
    loop=loop+1;
    T(loop)=T(loop-1)+step;
    P(loop,:)=old;
    loop=loop+1;
    T(loop)=T(loop-1);
    P(loop,:)=new; old=new;
    
     if loop>=length(T)
        T(loop*2)=0;
        P(loop*2,:)=0;
    end
end

T=T(1:loop); P=P(1:loop,:);
