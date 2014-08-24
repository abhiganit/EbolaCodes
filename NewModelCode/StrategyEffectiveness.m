function[B] = StrategyEffectiveness(input)
% input has to be a cell of size s and size of each matrix of cell must be
% m x n.
fig = figure;
set(fig, 'Position', [500, 100, 900, 500])
Adet = input;
load('ExtinctionProbs');  %load stochastic simulation data
Asto = A;
ExtProbs = B;
outputtimes = [30, 91, 183];

for i=1:size(Asto,2)
    cilow{i} = cellfun( @arraySortLow ,Asto{i}, repmat({outputtimes},1,4), repmat({size(Asto{1}{1},1)},1,4), 'UniformOutput', false );
    cihigh{i} = cellfun( @arraySortHigh ,Asto{i}, repmat({outputtimes},1,4), repmat({size(Asto{1}{1},1)},1,4), 'UniformOutput', false );
    cilowmat{i} = cell2mat(cilow{i}')';
    cihighmat{i} = cell2mat(cihigh{i}')';
end


s = length(Adet); % No of strategies
m = length(Adet{1}(:,1)); % No of days after strategies
n = length(Adet{1}(1,:)); % Variation in rates for strategies

Bdet = cell(1,s);
t = 1:m-1;


% figure properties
labelsize = 14;
c = [0 0 1; 0 0.5 0; 1 0 0; 0 0.75 0.75];
h = rgb2hsv(c);
h2 = h; h3 = h;
h2(:,2) = 0.6*h2(:,2);
h3(:,2) = 0.2*h3(:,2);
cmap1 = hsv2rgb(h2);
cmap2 = hsv2rgb(h3);
cmap_all = [cmap1; cmap2];
colormap(cmap_all);
%cmap = {'k', 'b', 'g', 'r', 'c'};

%ColorSet = varycolor(n);
%set(gca, 'ColorOrder', ColorSet);
%hold all
strtitle = {{'a) Hospital Transmission Reduction (100%)'},...
            {'b) Hygienic Burial of Hospital Cases'},...
            {'c) Hospital Case Isolation'},...
            {'d) Hospital Transmission Reduction (90%)'},...
            {'e) Hygienic Burial of Hospital Cases (80%)'},...
            {'f) Hospital Case Isolation (80%)'}};
legendtext = {{'95%', '97%' '99%', '100%'},...
               {'80%', '85%' '90%', '95%'},...
               {'80%', '85%' '90%', '95%'},...
               {'70%', '80%' '90%', '95%'},...
               {'30%', '50%' '70%', '95%'},...
               {'50%', '65%' '80%', '95%'}};
legendtitle = {'Community Transmission Reduction','','', ...
               'Hygienic Burial for Hospital Cases','Hygienic Burial for Community Cases','Hospital Contacts Follow-up/Isolation'};              
        
strategies = 4:9;
for i = 1:s
    for j = 1:n
        Bdet{i}(:,j) = diff(Adet{i}(:,j));
    end
end
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% plotting NEW CASES  %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplotorder = [1,2,3,10,11,12];

a = 365/12;
b = 0:12;
tickmarks = a*b;
ticklabels = {'0','1','2','3','4','5','6','7','8','9','10','11','12'};

for i = strategies   
    subplot(6,3,subplotorder(i-3))    
    for j=2:n
        hold on;
        plot(t,Bdet{i}(:,j), 'Color', cmap1(j-1,:), 'LineWidth', 1.2);
    end
    xlabel('Months After Intervention', 'FontSize', 14, 'FontName', 'Palatino')
    set(gca, 'FontSize',labelsize)
    ylim([0 30])
    xlim([0 366])
    leg = legend(legendtext{i-3}, 'FontName', 'Palatino');
    v = get(leg,'title');
    set(v,'string',legendtitle{i-3}, 'FontName', 'Palatino');
    set(gca, 'XTick', tickmarks, 'XTickLabel', ticklabels);
    set(leg, 'EdgeColor', 'white')
    box off;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% plotting CUMULATIVE CASES  %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xlabstr = {'1 mo', '3 mo', '6 mo'};
Bsumsdet = cellfun(@(a)cumsum(a), Bdet, 'UniformOutput',false);
Boutputsumsdet = cellfun(@(a,times)a(times,:), Bsumsdet, repmat({outputtimes},1,9), 'UniformOutput',false);


%differences
upperdifference = cellfun( @(u,m) u-m(:,2:end), cihighmat, Boutputsumsdet(4:9), 'UniformOutput', false);
lowerdifference = cellfun( @(l,m) m(:,2:end)-l, cilowmat, Boutputsumsdet(4:9), 'UniformOutput', false);
subplotorder = [4,5,6,13,14,15];

%colormap(cmap1)
for i = strategies
    index = i-3;
    subplot(6,3,subplotorder(index))
    bar(Boutputsumsdet{i}(:,2:end), 'LineStyle', 'none')
    caxis([1,8])
    numgroups = size(Boutputsumsdet{i}(:,2:end), 1); 
    numbars = size(Boutputsumsdet{i}(:,2:end), 2); 
    groupwidth = min(0.8, numbars/(numbars+1.5));
    hold on;
    for j = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*j-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, Boutputsumsdet{i}(:,j+1), upperdifference{index}(:,j), 'k', 'linestyle', 'none');
    end
    ylim([0 3.4e3])
    set(gca,'XTickLabel',{'','',''}, 'FontSize', labelsize);
    set(gca, 'YTick', [0, 1000, 2000,3000])
    box off;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% plotting PROBS OF EXTINCTION  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%colormap(cmap2);
subplotorder = [7,8,9,16,17,18];

for i = 1:6
    subplot(6,3,subplotorder(i))
    bar(ExtProbs{i}', 'LineStyle', 'none');
    caxis([-3,4])
    set(gca,'XTickLabel',xlabstr, 'FontSize', labelsize)
    ylim([0,1.05])
   
    box off;
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
        
%% ylabels
annotation('textbox', [0 0.8 0.05 0.1],...,...
            'String','Daily Ebola Cases',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);

annotation('textbox', [0 0.65 0.05 0.1],...,...
            'String','Cumulative Ebola Cases',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);

annotation('textbox', [0 0.5 0.05 0.1],...,...
            'String','Probability $<5$ Cases Daily',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);

annotation('textbox', [0 0.35 0.05 0.1],...,...
            'String','Daily Ebola Cases',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);

annotation('textbox', [0 0.2 0.05 0.1],...,...
            'String','Cumulative Ebola Cases',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);

annotation('textbox', [0 0.05 0.05 0.1],...,...
            'String','Probability $<5$ Cases Daily',...
            'HorizontalAlignment', 'Right',...
           'interpreter', 'latex',...
           'LineStyle', 'none',...
            'FontSize', 16);
        
        
end
   

function ciestlow = arraySortLow(arr, inputcolumns, N)
    loCI = max(floor(N*0.025),1);
    sortedcolumns = sort(arr(:,inputcolumns));
    ciestlow  = sortedcolumns(loCI,:);
end

function ciesthigh = arraySortHigh(arr, inputcolumns, N)

    hiCI = max(ceil(N*0.975),1);
    sortedcolumns = sort(arr(:,inputcolumns));
    ciesthigh  = sortedcolumns(hiCI,:);
end
            
 
