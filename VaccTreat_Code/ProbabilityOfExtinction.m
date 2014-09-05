function[ProbCell] = ProbabilityOfExtinction(input)
%INPUT:
% input is a cell of size 1 x p where p is number of delays
% each element of input is a cell of side q x r where q is the variation
% in efficacy and r is variation is coverage.
% each element of the q x r cells is a matrix of size n x 366 whose
% each row is a stochastic realization of the simulation

%OUTPUT:
% output will be a cell of size 1 x p where p is number of delays
% each elecment of outpul is a cell of size q x r where q is the variation 
% in the efficacy and r is the variation in coverage.
% each element of the q x r cells is a matrix of size 1 x 2 whose elements
% are probabilities of < 1 daily cases after 3 and 6 months repectively.
A = input;
p = length(A); % Number of delays
q = length(A{1}(:,1)); % Number of variations in efficacy between 0 and 1
r = length(A{1}(1,:)); %  Number of variations of coverage between 0 and 1
n = length(A{1}{1,1}(:,1)); % Number of stochastic runs

month3 = 0; month6 = 0;

for i = 1:p            % Looping over delays
    for j = 1:q        % Looping over efficacies
        for k = 1:r    % Looping over coverage
            C = A{i}{j,k}';   % Grabbing and transposing the ith delay, jth efficacy and kth coverage matrix
            B = diff(C);      % Calculating daily new cases
            month3 = sum(B(91,:)<1); % # stochastic realizations resulting into < 1 daily ebola cases after 3 months
            month6 = sum(B(183,:)<1);  % # stochastic realizations resulting into < 1 daily ebola cases after 3 months
            ProbIntermediateCell{j,k} = [month3,month6]./n; 
        end
    end
    ProbCell{i} = ProbIntermediateCell;
end

end