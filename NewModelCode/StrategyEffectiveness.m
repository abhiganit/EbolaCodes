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
strtitle = {{'Isolation (90\%) \& Contact Follow-up'},...
            {'Transmission Reduction (Hospital (100\%) \& Community Cases)'},...
            {'Hygienic Burial (Hospital (90\%) + Community Cases)'},...
            {'Isolation (90\%) \& Contact Follow-up (50\%) \& Hygienic Burial (Hospital Cases)'},...
            {'Transmission Reduction (Hospital (90\%) \& Community Cases (70\%)) \& Hygienic Burial (Hospital Cases)'},...
            {'Hygienic Burial (Hospital Cases (90\%) \& Community Cases (50\%)) \& Isolation (Hospital Cases)'}};
legendtext = {{'70\%', '80\%' '90\%', '95\%'},...
               {'95\%', '97\%' '99\%', '100\%'},...
               {'0\%', '30\%' '60\%', '95\%'},...
               {'50\%', '65\%' '80\%', '95\%'},...
               {'20\%', '45\%' '70\%', '95\%'},...
               {'0\%', '30\%' '60\%', '95\%'}};
              
        
strategies = 4:9;
for i = 1:s
    for j = 1:n
        B{i}(:,j) = diff(A{i}(:,j));
    end
end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% plotting NEW CASES  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplotorder = [1,2,3,10,11,12];
for i = strategies   
    subplot(6,3,subplotorder(i-3))    
    for j=2:n
        hold on;
        plot(t,B{i}(:,j), 'Color', cmap(j-1,:), 'LineWidth', 1.2);
    end
    xlabel('Days After Intervention', 'FontSize', 14)
    set(gca, 'FontSize',labelsize)
    ylim([0 30])
    xlim([0 366])
    if (i==4 || i==7)
        text(-50, 15,{'New Daily', 'Ebola Cases'},  'FontSize',14, 'Rotation', 0, 'HorizontalAlignment','Right')  
    end
    leg = legend(legendtext{i-3}, 'interpreter', 'latex');
    legend('boxoff');
    box off;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% plotting CUMULATIVE CASES  %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
outputtimes = [30, 91, 183];

xlabstr = {'1 mo', '3 mo', '6 mo'};
Bsums = cellfun(@(a)cumsum(a), B, 'UniformOutput',false);
Boutputsums = cellfun(@(a,times)a(times,:), Bsums, repmat({outputtimes},1,9), 'UniformOutput',false);

subplotorder = [4,5,6,13,14,15];

colormap(cmap)
for i = strategies
    subplot(6,3,subplotorder(i-3))
    bar(Boutputsums{i}(:,2:end))
    ylim([0 2.8e3])
    set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize);
    
    if (i==4 || i==7)
        text(0, 1500,{'Cumulative', 'Ebola Cases'},  'FontSize',14, 'Rotation', 0, 'HorizontalAlignment','Right')  
    end
    box off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% plotting PROBS OF EXTINCTION  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplotorder = [7,8,9,16,17,18];
load('ExtinctionProbs');
for i = 1:6
    subplot(6,3,subplotorder(i))
    bar(B{i}');
    set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize);
    ylabel('Prob. of extinction');
end


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% ANNOTATIONS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% add titles
annotation('textbox', [0.15 0.85 0.2 0.1],...
           'String', strtitle{1},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
           'interpreter', 'latex',...
           'FontSize', 16);
annotation('textbox', [0.4 0.85 0.2 0.1],...
           'String', strtitle{2},...
           'HorizontalAlignment', 'center',...  
           'LineStyle', 'none',...
           'interpreter', 'latex',...
            'FontSize', 16);
annotation('textbox', [0.7 0.85 0.2 0.1],...
           'String', strtitle{3},...
           'HorizontalAlignment', 'center',...
           'LineStyle', 'none',...
           'interpreter', 'latex',...
            'FontSize', 16);
% add titles
annotation('textbox', [0.15 0.43 0.2 0.1],...
           'String', strtitle{4},...
           'HorizontalAlignment', 'center',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
           'FontSize', 16);
annotation('textbox', [0.4 0.43 0.2 0.1],...
           'String', strtitle{5},...
           'HorizontalAlignment', 'center',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);
annotation('textbox', [0.7 0.43 0.2 0.1],...
           'String', strtitle{6},...
           'HorizontalAlignment', 'center',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);
end
   


            
 
