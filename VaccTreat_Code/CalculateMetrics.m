load('VaccTreatmentStochResults');
allVE = linspace(0,1,6);
allVCov = linspace(0,1,6);
allTE = linspace(0,1,6);
allTCov = linspace(0,1,6);
% Saving more than 90 % probabilities and corresponding efficacy and
% coverage
l = 1;
for i = 1:p
    for j = 1:q
        for k = 1:r
            if A{j,k}(1,1)>=0.9
                
                