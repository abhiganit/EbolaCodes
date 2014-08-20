function[B] = StrategyEffectiveness(input)
% input has to be a cell of size s and size of each matrix of cell must be
% m x n.

A = input;
s = length(A); % No of strategies
m = length(A{1}(:,1)); % No of days after strategies
n = length(A{1}(1,:)); % Variation in rates for strategies

B = cell(1,s);
t = 1:m-1; 
%ColorSet = varycolor(n);
%set(gca, 'ColorOrder', ColorSet);
%hold all

for i = 1:s
    for j = 1:n
        B{i}(:,j) = diff(A{i}(:,j));
    end
    figure;
    plot(t,B{i},'linewidth',2');
    set(gca,'Xtick',1:1:m-1)
    xlabel('Days after intervention')
    ylabel('New ebola cases')   
%  set(gca,'XtickLabel',1:1:m-1)

end
   


            
 
