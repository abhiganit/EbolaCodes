function[ProbCell] = ProbabilityOfExtinction(input)

A = input;

s = length(A); % Number of strategies
r = length(A{1}); % Number of variations in plot
n = length(A{1}{1}(:,1)); % Number of stochastic runs

prob1 = 0; prob3 = 0; prob6 = 0;

for i = 1:s
    for j = 1:r
         C = A{i}{j}';
         B = diff(C);
         prob1 = sum(B(30,:)<5);
         prob3 = sum(B(91,:)<5);
         prob6 = sum(B(183,:)<5);
%         for k=1:n
%             C = A{i}{j}';
%             B = diff(C(:,k));
%             prb1 = sum(B(30,:
%             prob1 = (B(30)<5) + prob1;
%             prob3 = (B(91)<5) + prob3;
%             prob6 = (B(183)<5) + prob6; 
%         end
        ProbMatrix(j,:) = [prob1,prob3,prob6]./n;
        prob1 = 0; prob3 = 0; prob6 =0;
    end
    ProbCell{i} = ProbMatrix;
end

% figure properties
labelsize = 14;
cmap = [0 0 1;...
        0 0.5 0;...
        1 0 0;...
        0 0.75 0.75];
colormap(cmap);
xlabstr = {'1 mo', '3 mo', '6 mo'};

subplotorder = [1 2 3 4 5 6];
for i = subplotorder
subplot(2,3,i)
bar(ProbCell{i}');
set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize);
ylabel('Prob. of extinction');
end

end