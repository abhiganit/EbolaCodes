function[B] = StrategyEffectiveness(input)
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
strtitle = {'Isolation & Contact Follow-up',...
            'Transmission Reduction (Hospital & Community Cases)',...
            'Hygienic Burial (Hospital + Community Cases)',...
            'Isolation & Contact Follow-up & Hygienic Burial (Hospital Cases)',...
            'Isolation & Contact Follow-up & Hygienic Burial (Hospital Cases)',...
            'Hygienic Burial (Hospital + Community Cases) & Isolation (Hospital Cases)'};
legend = 
        
        
strategies = 4:9;
for i = 1:s
    for j = 1:n
        B{i}(:,j) = diff(A{i}(:,j));
    end
end
        
subplotorder = [1,2,3,7,8,9];
        
for i = strategies   
    subplot(4,3,subplotorder(i-3))    
    for j=2:n
        hold on;
        plot(t,B{i}(:,j), 'Color', cmap(j-1,:), 'LineWidth', 1.2);
    end
    if (i==4 || i==7)
        text(-50, 15,{'New Daily', 'Ebola Cases'},  'FontSize',14, 'Rotation', 0, 'HorizontalAlignment','Right')  
    end
    xlabel('Days After Intervention', 'FontSize', 14)
    ylim([0 25])
    xlim([0 366])
    set(gca, 'FontSize',labelsize)
    box off;
end

% add titles
annotation('textbox', [0.15 0.85 0.2 0.1],...
           'String', strtitle{1},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
           'FontSize', 16);
annotation('textbox', [0.4 0.85 0.2 0.1],...
           'String', strtitle{2},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
            'FontSize', 16);
annotation('textbox', [0.7 0.85 0.2 0.1],...
           'String', strtitle{3},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
            'FontSize', 16);
% add titles
annotation('textbox', [0.15 0.41 0.2 0.1],...
           'String', strtitle{4},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
           'FontSize', 16);
annotation('textbox', [0.4 0.41 0.2 0.1],...
           'String', strtitle{5},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
            'FontSize', 16);
annotation('textbox', [0.7 0.41 0.2 0.1],...
           'String', strtitle{6},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
            'FontSize', 16);

outputtimes = [30, 91, 183];

xlabstr = {'1 mo', '3 mo', '6 mo'};
Bsums = cellfun(@(a)cumsum(a), B, 'UniformOutput',false);
Boutputsums = cellfun(@(a,times)a(times,:), Bsums, repmat({outputtimes},1,9), 'UniformOutput',false);

subplotorder = [4,5,6,10,11,12];

colormap(cmap)
for i = strategies
    subplot(4,3,subplotorder(i-3))
    bar(Boutputsums{i}(:,2:end))
    ylim([0 2.8e3])
    set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize);
    %xlabel('Days After Intervention', 'FontSize', 14)
    if (i==4 || i==7)
        text(0, 1500,{'Cumulative', 'Ebola Cases'},  'FontSize',14, 'Rotation', 0, 'HorizontalAlignment','Right')  
    end
    box off;
end

 
end
   


            
 
