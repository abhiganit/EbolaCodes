function plotVacc_det()
%close all

xaxis = 0.1:0.1:1.0;
delays = [7, 30, 91];
colors = {'b','r','g','m','c'};
linestyles = {':', '--', '-'};

fig = figure;
set(fig, 'Position', [100 100 1600 900]);
xlimits = [0.09,1.01];
ss = get(0,'screensize');
set(gcf,'position',...
         [100, 100, ss(3)/3, ss(4)/3]);
plotwidth = 0.26;
plotheight = 0.8;
leftmargin = 0.1;
%rightmargin = 0.05;
bottommargin = 0.05;
columnspace = 0.03;
rowspace = 0.05;
%midspace = 0.09;

labelsize = 18;
ticksize = 18;
titlesize = 20;
legendsize = 15;

% %top row
% ax(1) = axes('Position',  [leftmargin,                           bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]);
% ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]);
% ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+3*plotheight+3*rowspace, plotwidth, plotheight]); 
% 
% %middle row
% ax(4) = axes('Position',  [leftmargin,                           bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
% ax(5) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]);
% ax(6) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+2*plotheight+2*rowspace, plotwidth, plotheight]); 
% 
% %middle row
% ax(7) = axes('Position',  [leftmargin,                           bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
% ax(8) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]);
% ax(9) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+1*plotheight+1*rowspace, plotwidth, plotheight]); 

%bottom row
% ax(1) = axes('Position',  [leftmargin,                           bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
% ax(2) = axes('Position',  [leftmargin+plotwidth+columnspace,     bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);
% ax(3) = axes('Position',  [leftmargin+2*plotwidth+2*columnspace, bottommargin+0*plotheight+0*rowspace, plotwidth, plotheight]);



%filename = sprintf('VaccTreatmentDetResults');
filename = sprintf('VaccTreatmentDetResultsTogether');
load(filename);

for index = 1:size(delays,2)
%     clear nointerventioncases nointerventiondeaths nointerventionmaxhcwratio ...
%            interventioncases interventiondeaths interventiontxdoses interventionmaxhcwratio;
%     filename = sprintf('VaccTreatmentStochResults_delay%g', delays(index));
%     load(filename);
    
    % means of no interventions
%     nointerventioncases = cumulativecasesTX_ni(:,end); %at the end of year
%     nointerventiondeaths =  cumulativedeathsTX_ni(:,end); %at the end of year
    nointerventionmaxhcwratio = max((currentebolahospitalizationsVACC_ni./currenthcwVACC_ni)')'; 

%     interventioncases = cellfun( @(a) a(:,end), cumulativecasesTX, 'UniformOutput', false);
%     interventiondeaths = cellfun( @(a) a(:,end), cumulativedeathsTX, 'UniformOutput', false);
%     interventiontxdoses = cellfun( @(a) a(:,end), totaltreatmentdosesTX, 'UniformOutput', false);
     interventionmaxhcwratio =  cell2mat(cellfun( @(a,b) max((a./b)')', currentebolahospitalizationsVACC{index}, currenthcwVACC{index}, 'UniformOutput', false));
%     relativeIncidence = cellfun( @(a,b) a./b,  interventioncases, repmat({nointerventioncases}, size(interventioncases,1), size(interventioncases,2)), 'UniformOutput', false);
%     relativeDeaths = cellfun( @(a,b) a./b,  interventiondeaths, repmat({nointerventiondeaths}, size(interventiondeaths,1), size(interventiondeaths,2)), 'UniformOutput', false);
    interventionhcw = currenthcwVACC;

    %% find means %%
%     relativeIncidence_mean = cell2mat( cellfun( @(a) mean(a), relativeIncidence, 'UniformOutput', false));
%     relativeDeaths_mean = cell2mat( cellfun( @(a) mean(a), relativeDeaths, 'UniformOutput', false));
%     interventiontxdoses_mean = cell2mat( cellfun( @(a) mean(a), interventiontxdoses, 'UniformOutput', false));
%     interventionmaxhcwratio_mean = cell2mat( cellfun( @calculateMEDCI, interventionmaxhcwratio, 'UniformOutput', false));
%     interventionhcw_mean = cell2mat( cellfun( @calculateMEDCI, interventionhcw, 'UniformOutput', false));
    
    %% find lowCI %%
%     relativeIncidence_low = cell2mat( cellfun( @calculateLOWCI, relativeIncidence, 'UniformOutput', false));
%     relativeDeaths_low = cell2mat( cellfun( @calculateLOWCI, relativeDeaths, 'UniformOutput', false));
%     interventiontxdoses_low = cell2mat( cellfun( @calculateLOWCI, interventiontxdoses, 'UniformOutput', false));
    %interventionmaxhcwratio_low = cell2mat( cellfun( @calculateLOWCI, interventionmaxhcwratio, 'UniformOutput', false));
    
    %% find highCI %%
%     relativeIncidence_high = cell2mat( cellfun( @calculateHIGHCI, relativeIncidence, 'UniformOutput', false));
%     relativeDeaths_high = cell2mat( cellfun( @calculateHIGHCI, relativeDeaths, 'UniformOutput', false));
%     interventiontxdoses_high = cell2mat( cellfun( @calculateHIGHCI, interventiontxdoses, 'UniformOutput', false));
    %interventionmaxhcwratio_high = cell2mat( cellfun( @calculateHIGHCI, interventionmaxhcwratio, 'UniformOutput', false));
    
       
    %% 1st ROW
%     axes(ax(0*size(delays,2) + index));
%     %h1 = subplot(4,3,0*size(delays,2) + index);
%     set(gca, 'XLim', xlimits, 'YLim', [0 1], 'Box', 'off')
%     set(gca, 'FontSize', 14, 'FontName', 'Palatino')
%     xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
%     hold on;
%     for i=1:5
%         ha = errorbar(xaxis, relativeIncidence_mean(:,i), ...
%                 relativeIncidence_mean(:,i)-relativeIncidence_low(:,i), relativeIncidence_high(:,i)-relativeIncidence_mean(:,i),...
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
%     if index==1 
%         text(-0.05,0.5, {'Relative', 'incidence'}, ...
%             'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
%             'HorizontalAlignment', 'Center'); 
%         leg = legend('20%', '40%', '60%', '80%', '100%');
%         set(leg, 'FontSize', legendsize, 'FontName', 'Palatino')
%         v = get(leg,'title');
%         set(v,'string','Treatment coverage', 'FontName', 'Palatino', 'FontSize', legendsize);
%         set(leg, 'EdgeColor', 'white')
%     end
%     
%     switch index
%         case 1
%             title('1 Week delay', 'FontSize', titlesize, 'FontName', 'Palatino')
%         case 2
%             title('1 Month delay', 'FontSize', titlesize, 'FontName', 'Palatino')
%         case 3
%             title('3 Months delay', 'FontSize', titlesize, 'FontName', 'Palatino')
%     end
%     
%     
%     %% 2nd ROW
%     axes(ax(1*size(delays,2) + index));
%     xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
%     %h2 = subplot(4,3,1*size(delays,2) + index);
%    % plot(h2, xaxis, relativeDeaths_mean);
%     set(gca, 'XLim', xlimits, 'YLim', [0 1], 'Box', 'off')
%     set(gca, 'FontSize', 14, 'FontName', 'Palatino')
%     hold on;
%     for i=1:5
%         ha = errorbar(xaxis, relativeDeaths_mean(:,i), ...
%                 relativeDeaths_mean(:,i)-relativeDeaths_low(:,i), relativeDeaths_high(:,i)-relativeDeaths_mean(:,i),...
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
%     if index==1 
%         text(-0.05,0.5, {'Relative', 'mortality'}, ...
%             'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
%             'HorizontalAlignment', 'Center'); 
%     end
%     
%     %% 3rd ROW
%     axes(ax(2*size(delays,2) + index));
%     xlabel('Treatment efficacy, \epsilon_T', 'FontSize', labelsize, 'FontName', 'Palatino')
%     %h3 = subplot(4,3,2*size(delays,2) + index);
%     set(gca, 'XLim', xlimits, 'Box', 'off')
%     set(gca, 'FontSize', 14, 'FontName', 'Palatino')
%     hold on;
%     for i=1:5
%         ha = errorbar(xaxis, interventiontxdoses_mean(:,i), ...
%                 interventiontxdoses_mean(:,i)-interventiontxdoses_low(:,i), interventiontxdoses_high(:,i)-interventiontxdoses_mean(:,i),...
%                'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
%     end
%     if index==1 
%         text(-0.05,7.5e4, {'Treatment', 'doses'}, ...
%             'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
%             'HorizontalAlignment', 'Center'); 
%     end
    
    %% 4th ROW
    %axes(ax(index));
    %axes(ax(3*size(delays,2) + index));
    xlabel('Successfully vaccinated (%), \epsilon_V', 'FontSize', labelsize, 'FontName', 'Palatino')
    %h4 = subplot(4,3,3*size(delays,2) + index);
   % plot(h4, xaxis, interventionmaxhcwratio_mean);
    set(gca, 'XLim', [0 1], 'Box', 'off')
    set(gca, 'FontSize', 14, 'FontName', 'Palatino')
     hold on;
     ylim([0 150])
    %for i=1:3
        plot([0,xaxis], interventionmaxhcwratio, 'LineStyle', linestyles{index});
%         ha = errorbar(xaxis, interventionmaxhcwratio_mean(:,i), ...
%                 interventionmaxhcwratio_mean(:,i)-interventionmaxhcwratio_low(:,i), interventionmaxhcwratio_high(:,i)-interventionmaxhcwratio_mean(:,i),...
%                 'o','Color', colors{i}, 'MarkerFaceColor', colors{i});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
    if index==1 
        text(-0.12,150/2, {'Maximum Ebola', 'patients per HCW'}, ...
            'Rotation', 90, 'FontName', 'Palatino', 'FontSize', labelsize,...
            'HorizontalAlignment', 'Center'); 
    end
%         ha = errorbar(xaxis, interventionmaxhcwratio_mean(2:end), ...
%                 interventionmaxhcwratio_mean(2:end)-interventionmaxhcwratio_low(2:end), interventionmaxhcwratio_high(2:end)-interventionmaxhcwratio_mean(2:end),...
%                 'o','Color', colors{1}, 'MarkerFaceColor', colors{1});
%         hb = get(ha,'children');  
%         Xdata = get(hb(2),'Xdata');
%         temp = 4:3:length(Xdata);
%         temp(3:3:end) = [];
%         xleft = temp; xright = temp+1; 
%         Xdata(xleft) = 0; %Xdata(xleft) - .1;
%         Xdata(xright) = 0; %Xdata(xright) + .1;
%         set(hb(2),'Xdata',Xdata)
    %end
%     if index==1 
%         text(-0.05,3000, {'Maximum Ebola', 'patients per HCW'}, ...
%             'Rotation', 90, 'FontName', 'Palatino', 'FontSize', titlesize,...
%             'HorizontalAlignment', 'Center'); 
%     end
    
%     if index==1
%        set( get(h1, 'YLabel'), 'String', 'Relative incidence', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h2, 'YLabel'), 'String', 'Relative mortality', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h3, 'YLabel'), 'String', 'Number of Tx doses', 'FontSize', 16, 'FontName', 'Palatino')
%        set( get(h4, 'YLabel'), 'String', 'Maximum Ebola patients/HCW', 'FontSize', 16, 'FontName', 'Palatino')
%     end
end
end

function out = calculateMEDCI(a)
    B = sort(a);
    out =  B(ceil(0.50*size(a,1)));
end

function out = calculateLOWCI(a)
    B = sort(a);
    out =  B(ceil(0.10*size(a,1)));
end

function out = calculateHIGHCI(a)
    B = sort(a);
    out =  B(ceil(0.90*size(a,1)));
end