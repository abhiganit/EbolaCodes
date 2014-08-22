function[B] = StrategyEffectiveness(input,subplotorder)
% input has to be a cell of size s and size of each matrix of cell must be
% m x n.
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])
A = input;
s = length(A); % No of strategies
m = length(A{1}(:,1)); % No of days after strategies
n = length(A{1}(1,:)); % Variation in rates for strategies

B = cell(1,s);
t = 1:m-1; 
%ColorSet = varycolor(n);
%set(gca, 'ColorOrder', ColorSet);
%hold all
strtitle = {'Passive isolation', 'Passive isolation + contact tracing',...
            'Transmission reduction (hospital)', 'Transmission reduction (hospital+community)',...
            'Hygienic burial (hospital)', 'Hygeinic burial (hospital+community)'};
for i = 1:s
    for j = 1:n
        B{i}(:,j) = diff(A{i}(:,j));
    end
    subplot(2,3,subplotorder(i))
    
    plot(t,B{i}(:,2:end));
   % set(gca,'Xtick',1:1:m-1)
    xlabel('Days after intervention', 'FontSize', 14)
    ylabel('New ebola cases',  'FontSize',14)  
%  set(gca,'XtickLabel',1:1:m-1)
    title(strtitle{i}, 'FontSize', 12)
end
   


            
 
