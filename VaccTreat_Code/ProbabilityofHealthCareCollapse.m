function[ProbCellHC,HCThresholdEffandCov3months,HCThresholdEffandCov6months] = ProbabilityofHealthCareCollapse(currentallhospcases,currentebolahospcases,burdencoeff,probslice)


A1 = currentallhospcases;  % all current hospitalization cases
A2 = currentebolahospcases; % all current ebola-hospitalization cases
p = length(A1); % Number of delays
q = length(A1{1}(:,1)); % Number of variations in efficacy between 0 and 1
r = length(A1{1}(1,:)); %  Number of variations of coverage between 0 and 1
n = length(A1{1}{1,1}(:,1)); % Number of stochastic runs

months3 = 0; months = 6;

for i = 1:p            % Looping over delays
    A3{i} = cellfun(@(x,y){x-y},A1{i},A2{i}); % all current non-ebola-hospitalization cases
    for j = 1:q        % Looping over efficacies
        for k = 1:r    % Looping over coverage
            B = A1{i}{j,k}';   % Grabbing and transposing the ith delay, jth efficacy and kth coverage matrix for all current cases
            C = A3{i}{j,k}';   % Grabbing and transposing the ith delay, jth efficacy and kth coverage matrix for non-ebola current cases
            month3 = sum(B(91,:)<burdencoeff*C(91,:)); % # stochastic realizations resulting into current ebola hospitalization less than the threshold after 3 months
            month6 = sum(B(183,:)<burdencoeff*C(183,:));  % # stochastic realizations resulting into current ebola hospitalization less than the threshold after 3 months
            ProbIntermediateCell{j,k} = [month3,month6]./n; 
        end
    end
    ProbCellHC{i} = ProbIntermediateCell;
end

eff = linspace(0,1,q);
cov = linspace(0,1,r);

for i = 1:p
    for j = 1:q % Varying over efficacies to find optimal coverage
        X = vertcat(ProbCellHC{i}{j,:});
        Y = X>=probslice;
        ind3 = find(Y(:,1),1,'first');
        ind6 = find(Y(:,2),1,'first');
        EC3(j,:) = [eff(j),cov(ind3)];
        EC6(j,:) = [eff(j),cov(ind6)];
    end
    HCThresholdEffandCov3months{i} = EC3;
    HCThresholdEffandCov6months{i} = EC6;
end