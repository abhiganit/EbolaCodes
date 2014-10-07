
function [T,P]=Stoch_Iteration(Time,Initial,Parameters,HospitalVisitors, interventiondelay, immunitydelay, VE, VCov, TE, TCov)



tau=Parameters(end);


T=0:tau:Time(2); 
P(1,:)= Initial;
old=Initial;

% HospitalVectorA = repmat(1,67,1);
% HospitalVectorB = repmat(0,366-67,1);
% HospitalVector = [HospitalVectorA; HospitalVectorB];


loop=1;
while (T(loop)<Time(2)) 
    %[new]=Tau_leap(old, Parameters, T(loop), HospitalVector(loop),interventiondelay, immunitydelay, VE, VCov, TE, TCov);
    [new]=Tau_leap(old, Parameters, T(loop), HospitalVisitors,interventiondelay, immunitydelay, VE, VCov, TE, TCov);
    loop=loop+1;
    P(loop,:)=new; old=new;
end