function[B] = StrategyEffectiveness(input)
% input has to be a cell of size s and size of each matrix of cell must be
% m x n.
fig = figure;
set(gcf,'position',...
         get(0,'screensize'));
plotwidth = 0.25;
plotheight = 0.1;
leftmargin = 0.1;
rightmargin = 0.05;
bottommargin = 0.15;
columnspace = 0.05;
rowspace = 0.01;
midspace = 0.09;

labelsize = 18;
ticksize = 18;
titlesize = 20;
legendsize = 15;

%top row
ax(1) = axes('Position',  [leftmargin,                           bottommargin+5*plotheight+11*rowspace+midspace, plotwidth, plotheight]);
ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+5*plotheight+11*rowspace+midspace, plotwidth, plotheight]);
ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+5*plotheight+11*rowspace+midspace, plotwidth, plotheight]); 

%middle row
ax(4) = axes('Position',  [leftmargin,                           bottommargin+4*plotheight+7*rowspace+midspace, plotwidth, plotheight]);
ax(5) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+4*plotheight+7*rowspace+midspace, plotwidth, plotheight]);
ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+4*plotheight+7*rowspace+midspace, plotwidth, plotheight]); 

%bottom row
ax(7) = axes('Position',  [leftmargin,                           bottommargin+3*plotheight+6*rowspace+midspace, plotwidth, plotheight]);
ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+3*plotheight+6*rowspace+midspace, plotwidth, plotheight]);
ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+6*rowspace+midspace, plotwidth, plotheight]);

ax(10) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+5*rowspace,         plotwidth, plotheight]);
ax(11) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+5*rowspace,         plotwidth, plotheight]);
ax(12) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+5*rowspace,         plotwidth, plotheight]); 

ax(13) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace,         plotwidth, plotheight]);
ax(14) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace,         plotwidth, plotheight]);
ax(15) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+1*rowspace,         plotwidth, plotheight]); 

ax(16) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+0*rowspace,         plotwidth, plotheight]);
ax(17) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+0*rowspace,         plotwidth, plotheight]);
ax(18) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+0*rowspace,         plotwidth, plotheight]);



Adet = input;
%load('StochasticRunsData_MontserradoCounty');  %load stochastic simulation data
load('StochasticRunsData')
%B = ProbabilityOfExtinction(A);
Asto = A;
ExtProbs = ProbabilityOfExtinction(Asto);
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
strtitle = {{'a) HCW Transmission Reduction (100%)'},...
            {'b) Hygienic Burial of Hospital Deaths'},...
            {'c) Hospital Case Isolation'},...
            {'d) HCW Transmission Reduction (90%)'},...
            {'e) Hygienic Burial of Hospital Deaths (80%)'},...
            {'f) Hospital Case Isolation (80%)'}};
legendtext = {{'95%', '97%' '99%', '100%'},...
               {'80%', '85%' '90%', '95%'},...
               {'80%', '85%' '90%', '95%'},...
               {'70%', '80%' '90%', '95%'},...
               {'30%', '50%' '70%', '95%'},...
               {'50%', '65%' '80%', '95%'}};
%%% MONTSERRADO COUNTY
% strtitle = {{'a) HCW Transmission Reduction (80%)'},...
%             {'b) Hygienic Burial of Hospital Deaths'},...
%             {'c) Hospital Case Isolation'},...
%             {'d) HCW Transmission Reduction (90%)'},...
%             {'e) Hygienic Burial of Hospital Deaths (80%)'},...
%             {'f) Hospital Case Isolation (80%)'}};
% legendtext = {{'50%', '65%' '80%', '95%'},...
%                {'80%', '85%' '90%', '95%'},...
%                {'80%', '85%' '90%', '95%'},...
%                {'70%', '80%' '90%', '95%'},...
%                {'30%', '50%' '70%', '95%'},...
%                {'50%', '65%' '80%', '95%'}};

legendtitle = {'Community Transmission Reduction','','', ...
               'Hygienic Burial of Hospital Deaths','Hygienic Burial of Community Deaths','Hospital Contact-tracing and Quarantining'};              
        
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
    %subplot(6,3,subplotorder(i-3))    
    axes(ax(subplotorder(i-3)))
    for j=2:n
        hold on;
        plot(t,Bdet{i}(:,j), 'Color', cmap1(j-1,:), 'LineWidth', 1.2);
    end
    xlabel('Months After Intervention', 'FontSize', labelsize, 'FontName', 'Palatino')
    set(gca, 'FontSize',ticksize, 'FontName', 'Palatino')
%     ylim([0 280])
%    ylim([0 150]) % For Monstarrodo county
    xlim([0 366])
    leg = legend(legendtext{i-3}, 'FontName', 'Palatino', 'FontSize', legendsize);
    v = get(leg,'title');
    set(v,'string',legendtitle{i-3}, 'FontName', 'Palatino', 'FontSize', legendsize);
    set(gca, 'XTick', tickmarks, 'XTickLabel', ticklabels);
    set(leg, 'EdgeColor', 'white')
    box off;
    
    if i==4 || i==7
        text(-61,15, {'Daily', 'Ebola Cases'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center'); 
    end
        title(strtitle{i-3}, 'FontSize', titlesize,'FontName', 'Palatino')
  
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
    %subplot(6,3,subplotorder(index))
    axes(ax(subplotorder(i-3)))
    bar(Boutputsumsdet{i}(:,2:end), 'LineStyle', 'none')
    caxis([1,8])
    numgroups = size(Boutputsumsdet{i}(:,2:end), 1); 
    numbars = size(Boutputsumsdet{i}(:,2:end), 2); 
    groupwidth = min(0.8, numbars/(numbars+1.5));
    hold on;
    for j = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*j-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, Boutputsumsdet{i}(:,j+1), lowerdifference{index}(:,j), upperdifference{index}(:,j), 'k', 'linestyle', 'none');
    end
     ylim([0.1 25.0e3])
%     ylim([0.1,5.0e3]) % Monstaroddo county
    set(gca,'XTickLabel',{'','',''}, 'FontSize', labelsize, 'FontName', 'Palatino');
%     set(gca, 'YTick', [0, 1000, 2000,3000, 4000, 5000,6000,7000,8000])
%    set(gca, 'YTick', [0, 1000, 2000,3000, 4000, 5000]) % Monsterrado county
    set(gca, 'FontSize', ticksize, 'TickLength', [0 0])
    box off;
    
    if i==4 || i==7
        text(0,2500, {'Cumulative', 'Ebola Cases'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center'); 
    end  
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% plotting PROBS OF EXTINCTION  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%colormap(cmap2);
subplotorder = [7,8,9,16,17,18];

for i = 1:6
    %subplot(6,3,subplotorder(i))
    axes(ax(subplotorder(i)))
    bar(ExtProbs{i}', 'LineStyle', 'none');
    caxis([-3,4])
    set(gca,'XTickLabel',xlabstr, 'FontSize', ticksize, 'FontName', 'Palatino')
    ylim([0,1.0])
    %set(gca, 'YTick', 0:0.2:0.6);
    if i==1 || i==4
        text(0.005,0.3, {'Probability', '< 1 Case Daily'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center');  
    end
    box off;
end


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% ANNOTATIONS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% add titles
% annotation('textbox', [0.15 0.85 0.2 0.1],...
%            'String', strtitle{1},...
%            'HorizontalAlignment', 'center',...
%            'LineStyle', 'none',...
%            'FontName', 'Palatino',...
%            'FontSize', 16);
% annotation('textbox', [0.4 0.85 0.2 0.1],...
%            'String', strtitle{2},...
%            'HorizontalAlignment', 'center',...  
%            'LineStyle', 'none',...
%             'FontName', 'Palatino',...
%             'FontSize', 16);
% annotation('textbox', [0.7 0.85 0.2 0.1],...
%            'String', strtitle{3},...
%            'HorizontalAlignment', 'center',...
%            'LineStyle', 'none',...
%             'FontName', 'Palatino',...
%             'FontSize', 16);
% % add titles
% annotation('textbox', [0.15 0.43 0.2 0.1],...
%            'String', strtitle{4},...
%            'HorizontalAlignment', 'center',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%            'FontSize', 16);
% annotation('textbox', [0.4 0.43 0.2 0.1],...
%            'String', strtitle{5},...
%            'HorizontalAlignment', 'center',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% annotation('textbox', [0.7 0.43 0.2 0.1],...
%            'String', strtitle{6},...
%            'HorizontalAlignment', 'center',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
%         
%% ylabels
% annotation('textbox', [0 0.8 0.05 0.1],...,...
%             'String','Daily Ebola Cases',...
%             'HorizontalAlignment', 'Right',...
%            'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% 
% annotation('textbox', [0 0.65 0.05 0.1],...,...
%             'String','Cumulative Ebola Cases',...
%             'HorizontalAlignment', 'Right',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% 
% annotation('textbox', [0 0.5 0.05 0.1],...,...
%             'String','Probability $<5$ Cases Daily',...
%             'HorizontalAlignment', 'Right',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% 
% annotation('textbox', [0 0.35 0.05 0.1],...,...
%             'String','Daily Ebola Cases',...
%             'HorizontalAlignment', 'Right',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% 
% annotation('textbox', [0 0.2 0.05 0.1],...,...
%             'String','Cumulative Ebola Cases',...
%             'HorizontalAlignment', 'Right',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
% 
% annotation('textbox', [0 0.05 0.05 0.1],...,...
%             'String','Probability $<5$ Cases Daily',...
%             'HorizontalAlignment', 'Right',...
%             'FontName', 'Palatino',...
%            'LineStyle', 'none',...
%             'FontSize', 16);
%         
        
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
            
 
