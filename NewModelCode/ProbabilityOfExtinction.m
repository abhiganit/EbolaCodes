function[ProbCell] = ProbabilityOfExtinction(input)

A = input;

s = length(A); % Number of strategies
r = length(A{1}); % Number of variations in plot
n = length(A{1}{1}); % Number of stochastic runs

prob1 = 0; prob3 = 0; prob6 = 0;

for i = 1:s
    for j = 1:r
        for k=1:n
            B = diff{A{i}{j}(:,k)};
            prob1 = (B(30)<5) + prob1;
            prob3 = (B(91)<5) + prob3;
            prob6 = (B(183)<5) + prob6; 
        end
        ProbMatrix(j,:) = [prob1,prob3,prob6]./n;
        prob1 = 0; prob3 = 0; prob6 =0;
    end
    ProbCell{i} = ProbMatrix;
end
         
