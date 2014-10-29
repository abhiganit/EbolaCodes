function plotTransmission

xaxis = 0.1:0.1:1.0;
%delays = [30, 91, 183];
colors = {'b','r','g','m','c'};

ylimits = [0, 1.01];
close all
fig = figure;
set(fig, 'Position', [100 100 1600 900]);
xlimits = [0.07,1.03];
ss = get(0,'screensize');
set(gcf,'position',...
         [100, 100, ss(3)/1.5, ss(4)/2]);
plotwidth = 0.4;
plotheight = 0.38;
leftmargin = 0.1;
%rightmargin = 0.05;
bottommargin = 0.1;
columnspace = 0.03;
rowspace = 0.05;
%midspace = 0.09;

labelsize = 18;
ticksize = 18;
titlesize = 20;
legendsize = 15;

%top row
ax(1) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
%ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]); 

%middle row
% ax(4) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
% ax(5) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
%ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]); 

%middle row
% ax(7) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
% ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
% %ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]); 

%bottom row
ax(3) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
ax(4) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
%ax(12) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);




 filename = sprintf('VaccTreatmentStochResults_delayDec');
 load(filename)
%for index = 1:2 %(incidence and mortality)

    % means of no interventions
    nointerventioncasesGENERAL = sort(cumulativegeneralincidenceTX_ni(:,end)); %at the end of year
    nointerventioncasesHOSP = sort(cumulativehospincidenceTX_ni(:,end) + cumulativehcwincidenceTX_ni(:,end)); %at the end of year
    %nointerventioncasesHCW = sort(cumulativehcwincidenceTX_ni(:,end)); %at the end of year
    
    nointerventiondeathsGENERAL =  sort(cumulativegeneraldeathsTX_ni(:,end)); %at the end of year
    nointerventiondeathsHOSP =  sort(cumulativehospdeathsTX_ni(:,end) + cumulativehcwdeathsTX_ni(:,end)); %at the end of year
    %nointerventiondeathsHCW =  sort(cumulativehcwdeathsTX_ni(:,end)); %at the end of year
    

    interventioncasesGENERAL = cellfun( @(a) sort(a(:,end)), cumulativegeneralincidenceTX, 'UniformOutput', false);
    interventioncasesHOSP =  cellfun( @(a,b) sort(a(:,end)+b(:,end)), cumulativehospincidenceTX, cumulativehcwincidenceTX, 'UniformOutput', false);
    %interventioncasesHCW =  cellfun( @(a) sort(a(:,end)), cumulativehcwincidenceTX, 'UniformOutput', false);
    
    interventiondeathsGENERAL = cellfun( @(a) sort(a(:,end)), cumulativegeneraldeathsTX, 'UniformOutput', false);
    interventiondeathsHOSP =  cellfun( @(a,b) sort(a(:,end)+b(:,end)), cumulativehospdeathsTX, cumulativehcwdeathsTX, 'UniformOutput', false);
    %interventiondeathsHCW =  cellfun( @(a) sort(a(:,end)), cumulativehcwdeathsTX, 'UniformOutput', false);
    
     relativeIncidenceGENERAL =  cellfun( @(a,b)(a./b), interventioncasesGENERAL, repmat({nointerventioncasesGENERAL}, size(interventioncasesGENERAL,1), size(interventioncasesGENERAL,2)), 'UniformOutput', false);
     relativeDeathsGENERAL =  cellfun( @(a,b)(a./b), interventiondeathsGENERAL, repmat({nointerventiondeathsGENERAL}, size(interventiondeathsGENERAL,1), size(interventiondeathsGENERAL,2)), 'UniformOutput', false);
     relativeIncidenceHOSP =  cellfun( @(a,b)(a./b), interventioncasesHOSP, repmat({nointerventioncasesHOSP}, size(interventioncasesHOSP,1), size(interventioncasesHOSP,2)), 'UniformOutput', false);
     relativeDeathsHOSP =  cellfun( @(a,b)(a./b), interventiondeathsHOSP, repmat({nointerventiondeathsHOSP}, size(interventiondeathsHOSP,1), size(interventiondeathsHOSP,2)), 'UniformOutput', false);
%      relativeIncidenceHCW =  cellfun( @(a,b)(a./b), interventioncasesHCW, repmat({nointerventioncasesHCW}, size(interventioncasesHCW,1), size(interventioncasesHCW,2)), 'UniformOutput', false);
%      relativeDeathsHCW =  cellfun( @(a,b)(a./b), interventiondeathsHCW, repmat({nointerventiondeathsHCW}, size(interventiondeathsHCW,1), size(interventiondeathsHCW,2)), 'UniformOutput', false);
    
    %% find means %%
    relativeIncidenceGENERAL_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),  interventioncasesGENERAL, repmat({nointerventioncasesGENERAL}, size(interventioncasesGENERAL,1), size(interventioncasesGENERAL,2)), 'UniformOutput', false));
    relativeDeathsGENERAL_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),  interventiondeathsGENERAL, repmat({nointerventiondeathsGENERAL}, size(interventiondeathsGENERAL,1), size(interventiondeathsGENERAL,2)), 'UniformOutput', false));
    
    relativeIncidenceHOSP_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),  interventioncasesHOSP, repmat({nointerventioncasesHOSP}, size(interventioncasesHOSP,1), size(interventioncasesHOSP,2)), 'UniformOutput', false));
    relativeDeathsHOSP_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),  interventiondeathsHOSP, repmat({nointerventiondeathsHOSP}, size(interventiondeathsHOSP,1), size(interventiondeathsHOSP,2)), 'UniformOutput', false));
    
%     relativeIncidenceHCW_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),  interventioncasesHCW, repmat({nointerventioncasesHCW}, size(interventioncasesHCW,1), size(interventioncasesHCW,2)), 'UniformOutput', false));
%     relativeDeathsHCW_mean = cell2mat(cellfun( @(a,b) calculateMEDCI(a)./calculateMEDCI(b),...
%         interventiondeathsHCW, ...
%         repmat({nointerventiondeathsHCW}, size(interventiondeathsHCW,1), size(interventiondeathsHCW,2)),...
%         'UniformOutput', false));
    

%     relativeIncidenceGENERAL_mean = cell2mat( cellfun(  @calculateMEDCI, relativeIncidenceGENERAL, 'UniformOutput', false));
%     relativeDeathsGENERAL_mean = cell2mat( cellfun(  @calculateMEDCI, relativeDeathsGENERAL, 'UniformOutput', false));
%     relativeIncidenceHOSP_mean = cell2mat( cellfun(  @calculateMEDCI, relativeIncidenceHOSP, 'UniformOutput', false));
%     relativeDeathsHOSP_mean = cell2mat( cellfun(  @calculateMEDCI, relativeDeathsHOSP, 'UniformOutput', false));
%     relativeIncidenceHCW_mean = cell2mat( cellfun(  @calculateMEDCI, relativeIncidenceHCW, 'UniformOutput', false));
%     relativeDeathsHCW_mean = cell2mat( cellfun(  @calculateMEDCI, relativeDeathsHCW, 'UniformOutput', false));
    
    %% find lowCI %%
    relativeIncidenceGENERAL_low = cell2mat( cellfun(  @calculateLOWCI, relativeIncidenceGENERAL, 'UniformOutput', false));
    relativeDeathsGENERAL_low = cell2mat( cellfun(  @calculateLOWCI, relativeDeathsGENERAL, 'UniformOutput', false));
    relativeIncidenceHOSP_low = cell2mat( cellfun(  @calculateLOWCI, relativeIncidenceHOSP, 'UniformOutput', false));
    relativeDeathsHOSP_low = cell2mat( cellfun(  @calculateLOWCI, relativeDeathsHOSP, 'UniformOutput', false));
%     relativeIncidenceHCW_low = cell2mat( cellfun(  @calculateLOWCI, relativeIncidenceHCW, 'UniformOutput', false));
%     relativeDeathsHCW_low = cell2mat( cellfun(  @calculateLOWCI, relativeDeathsHCW, 'UniformOutput', false));

    %% find highCI %%
    relativeIncidenceGENERAL_high = cell2mat( cellfun(  @calculateHIGHCI, relativeIncidenceGENERAL, 'UniformOutput', false));
    relativeDeathsGENERAL_high = cell2mat( cellfun(  @calculateHIGHCI, relativeDeathsGENERAL, 'UniformOutput', false));
    relativeIncidenceHOSP_high = cell2mat( cellfun(  @calculateHIGHCI, relativeIncidenceHOSP, 'UniformOutput', false));
    relativeDeathsHOSP_high = cell2mat( cellfun(  @calculateHIGHCI, relativeDeathsHOSP, 'UniformOutput', false));
%     relativeIncidenceHCW_high = cell2mat( cellfun(  @calculateHIGHCI, relativeIncidenceHCW, 'UniformOutput', false));
%     relativeDeathsHCW_high = cell2mat( cellfun(  @calculateHIGHCI, relativeDeathsHCW, 'UniformOutput', false));
       
    %% 1st ROW 1st COlumn
    axes(ax(1));
    %h1 = subplot(4,3,0*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'YLim', ylimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    %xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeIncidenceGENERAL_mean(:,i), ...
                relativeIncidenceGENERAL_mean(:,i)-relativeIncidenceGENERAL_low(:,i), relativeIncidenceGENERAL_high(:,i)-relativeIncidenceGENERAL_mean(:,i),...
                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    text(-0.03,1.01/2, {'Community'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    title('Relative Incidence', 'FontSize', titlesize)
 
    
    %% 1st ROW 2nd COlumn
    axes(ax(2));
    %h1 = subplot(4,3,0*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'YLim', ylimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    %xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeDeathsGENERAL_mean(:,i), ...
                relativeDeathsGENERAL_mean(:,i)-relativeDeathsGENERAL_low(:,i), relativeDeathsGENERAL_high(:,i)-relativeDeathsGENERAL_mean(:,i),...
                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    title('Relative Mortality', 'FontSize', titlesize)
    
    %% 2nd ROW 1st COlumn
    axes(ax(3));
    %h1 = subplot(4,3,0*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'YLim', ylimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeIncidenceHOSP_mean(:,i), ...
                relativeIncidenceHOSP_mean(:,i)-relativeIncidenceHOSP_low(:,i), relativeIncidenceHOSP_high(:,i)-relativeIncidenceHOSP_mean(:,i),...
                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    text(-0.03,1.01/2, {'Nosocomial'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
            'HorizontalAlignment', 'Center'); 
    leg = legend('20%', '40%', '60%', '80%', '100%');
        set(leg, 'FontSize', legendsize, 'FontName', 'Palatino')
        v = get(leg,'title');
        set(v,'string','Treatment coverage', 'FontName', 'Palatino', 'FontSize', legendsize);
        set(leg, 'EdgeColor', 'white') 
%% 2nd ROW 2nd COlumn
    axes(ax(4));
    %h1 = subplot(4,3,0*size(delays,2) + index);
    set(gca, 'XLim', xlimits, 'YLim', ylimits, 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
    xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
    hold on;
    for i=1:5
        ha = errorbar(xaxis, relativeDeathsHOSP_mean(:,i), ...
                relativeDeathsHOSP_mean(:,i)-relativeDeathsHOSP_low(:,i), relativeDeathsHOSP_high(:,i)-relativeDeathsHOSP_mean(:,i),...
                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
        hb = get(ha,'children');  
        Xdata = get(hb(2),'Xdata');
        temp = 4:3:length(Xdata);
        temp(3:3:end) = [];
        xleft = temp; xright = temp+1; 
        Xdata(xleft) = 0; %Xdata(xleft) - .1;
        Xdata(xright) = 0; %Xdata(xright) + .1;
        set(hb(2),'Xdata',Xdata)
    end
    
%     %% 3rd ROW 1st COlumn
%     axes(ax(5));
%     %h1 = subplot(4,3,0*size(delays,2) + index);
%     set(gca, 'XLim', xlimits, 'YLim', [0 1.3], 'Box', 'off')
%     set(gca, 'FontSize', 14, 'FontName', 'Palatino')
%     xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
%     hold on;
%     for i=1:5
%         ha = errorbar(xaxis, relativeIncidenceHCW_mean(:,i), ...
%                 relativeIncidenceHCW_mean(:,i)-relativeIncidenceHCW_low(:,i), relativeIncidenceHCW_high(:,i)-relativeIncidenceHCW_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
%     end
%     text(-0.03,1.3/2, {'HCW'}, ...
%             'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
%             'HorizontalAlignment', 'Center'); 
%     
% %% 3rd ROW 2nd COlumn
%     axes(ax(6));
%     %h1 = subplot(4,3,0*size(delays,2) + index);
%     set(gca, 'XLim', xlimits, 'YLim', [0 1.3], 'Box', 'off')
%     set(gca, 'FontSize', 14, 'FontName', 'Palatino')
%     xlabel('Treatment efficacy', 'FontSize', labelsize, 'FontName', 'Palatino')
%     hold on;
%     for i=1:5
%         ha = errorbar(xaxis, relativeDeathsHCW_mean(:,i), ...
%                 relativeDeathsHCW_mean(:,i)-relativeDeathsHCW_low(:,i), relativeDeathsHCW_high(:,i)-relativeDeathsHCW_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
%     end
    
%end
end

function out = calculateLOWCI(a)
    B = sort(a);
    out =  B(ceil(0.025*size(a,1)));
end

function out = calculateMEDCI(a)
    B = sort(a);
    out =  B(ceil(0.50*size(a,1)));
end


function out = calculateHIGHCI(a)
    B = sort(a);
    out =  B(ceil(0.975*size(a,1)));
end

