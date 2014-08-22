function[B] = StrategyEffectiveness(input,subplotorder1, subplotorder2)
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


% figure properties
labelsize = 14;
cmap = [0 0 1;...
        0 0.5 0;...
        1 0 0;...
        0 0.75 0.75];
colormap(cmap);
%cmap = {'k', 'b', 'g', 'r', 'c'};

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
    subplot(4,3,subplotorder1(i))    
    for j=2:n
        hold on;
        plot(t,B{i}(:,j), 'Color', cmap(j-1,:), 'LineWidth', 1.2);
    end
   % set(gca,'Xtick',1:1:m-1)
    xlabel('Days after intervention', 'FontSize', 14)
    ylabel('New ebola cases',  'FontSize',14)  
%  set(gca,'XtickLabel',1:1:m-1)
    title(strtitle{i}, 'FontSize', 12)
    set(gca, 'FontSize',labelsize)
    switch i
        case {1, 3, 5} 
            ylim([0 200])
        case {2, 4, 6}
            ylim([0 30])
    end
    xlim([0 366])
end

outputtimes = [30, 91, 183];

xlabstr = {'1 mo', '3 mo', '6 mo'};
Bsums = cellfun(@(a)cumsum(a), B, 'UniformOutput',false);
Boutputsums = cellfun(@(a,times)a(times,:), Bsums, repmat({outputtimes},1,6), 'UniformOutput',false);

colormap(cmap)
for i = 1:s
    subplot(4,3,subplotorder2(i))
    bar(Boutputsums{i}(:,2:end))
    switch i
        case {1, 3, 5} 
            ylim([0 1e4])
        case {2, 4, 6}
            ylim([0 3e3])
    end
    set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize);
end

 
end
   


            
 
